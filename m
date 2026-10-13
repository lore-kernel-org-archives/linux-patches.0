Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C6944F403E;
	Tue, 13 Oct 2026 12:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892890; cv=none; b=fINJdIoaN0GYVgsSvRnO9PyJzrhqJ5FR1e0RJADJrya54cmPlkIICRM5B7zdAA9gumIdTvpAqUDFpYqHgwBlTaqp7uSvtK1eNxwN2luFG5EyOAh+l+cs+0lJG+qssqCm/t+4aSj/JZGxnaai9KZARp8Y+ieRt7UO5UvPyQGqe4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892890; c=relaxed/simple;
	bh=N3snurcEuIwOruWsXDRH8LCxjHsUBrJ1bqumuuZvbMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abudFAObo+E7KS0GOcfIph5LzKJezTo5sAYe8yeY/HzfVHMNXp1TrxzBCUls48Fo4wIUXNJ/2fItd9xNz46nGemceF0oA9JWN/GCZwV7Ke7bKb7hQFYTleKZkxPMWh20NTSfZp8vUSedfTRqpjwoDklBp68f9p+yicBFri+dFDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OloM9VNi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OloM9VNi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C741F000FF;
	Tue, 13 Oct 2026 12:01:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892888;
	bh=013GemWDig6wOpQqPi9iUiRZjwwyLCRmYWg2iAIlCHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OloM9VNiWzE8Z8v2TtVk8uUTQvMjQeTnBsvSY2FyViZF+O1k/lFPDplWbzBkzE0lk
	 vDOD+EaAdxu5no56OGtXwyoo8Ie/DpYCsS15vWs33+jw2FCjPD7ITPdcB8S1IS7kTD
	 dgVuQR8hlhk5diMxsLRfXh7l1PjBupd6hCmjI2K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 042/621] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Tue, 13 Oct 2026 13:30:37 +0200
Message-ID: <20261013112921.861968860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


