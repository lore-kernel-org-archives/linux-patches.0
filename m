Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8F5F4F30D7;
	Tue, 13 Oct 2026 11:47:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892040; cv=none; b=awf3ePFqgI7zwWFCEMI4/45dawyAD9Yr47UlLvpo2VaRnoNVKpeDqAKW/R6H5ojpAp+/EUXQvJeEE0st5ukJNjBnqxgxMTR0/Pk7HAxOlWGIZW87rIzrRGrMzJoA/SqbDfzJA2yvdLT73eaha5JpGeszZtQam2G3IhZo0kMROWk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892040; c=relaxed/simple;
	bh=XzoAG+iJpPYQV2ADxhjqU8kdmVkHh5tUgshAyrIgkqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnKQ6KCR8+WZtdr7O/hP7RacTEYfcf35487ES6sXTk8vdsH1wARruJq+6TAQxlNsy1eGGHp949piaj117iOzJFmxMiSQ1Yy/xYzJmXj6WC1A6h/6qZxIwy9UtTTICpDR6y/V6gJAJ5DcMYYG4q7/XrM3lRf/4oDTbeNbqzkieW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwuCZYpA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwuCZYpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23A01F000FF;
	Tue, 13 Oct 2026 11:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892030;
	bh=ToP+JvDR6hlbacpaHpB3YC8eE6Qx0kjAETgywC5n4iQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwuCZYpADVhTLlQxE55kjhot0faPg5dtuicoub7ohF83/OsvThoCcdochjgK+SEU/
	 qG8ZECL0x8Qusse+xwUkRdCxOru/LAXYveB75xxT+vKcf4YcL5JkZTevjhcrfiP/rI
	 dISCPRWNZiViSjpdKnj7xRMNchJ8eOWdswgfzcfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 038/281] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Tue, 13 Oct 2026 13:35:54 +0200
Message-ID: <20261013112855.976899932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

commit 93ccaf1c26e2133396173b76a071e59024daa622 upstream.

When a response chain has more slots than fit in the skb's frags,
xennet_fill_frags() returns an error and xennet_poll() jumps to its
error path.  That path moves what's left on tmpq to errq to be freed,
but the skb being filled was already dequeued from tmpq, so it's never
freed.  Each chain that overflows leaks the skb and the pages attached
to it as frags, and the backend decides how many slots it sends.

Put the skb back on tmpq before taking the error path, like the
xennet_set_skb_gso() failure just above it does.

Fixes: ad4f15dc2c70 ("xen/netfront: don't bug in case of too many frags")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Juergen Gross <jgross@suse.com>
Link: https://patch.msgid.link/20261007-b4-xen-netfront-fill-frags-leak-v1-1-a8a01ff9cd52@toxicpanda.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -1346,8 +1346,10 @@ err:
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq))) {
+			__skb_queue_head(&tmpq, skb);
 			goto err;
+		}
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;


