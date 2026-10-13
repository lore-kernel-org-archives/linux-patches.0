Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64162566F7;
	Tue, 13 Oct 2026 12:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895857; cv=none; b=vGRLwIUsrw5UV//0X3kALod7zsVzvkyzGlXQ1SDR01apMVFejm4fhqJaeGOWnRbESwN0LwY0pLx2A2G5zfyr39NfbDupPD7RLZtXOB0gEUPvcXJVtHP/VftT/hUAMjkKxvkjm/55DVusVGT7trANMyepGbEGr6afveEIR0tm+KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895857; c=relaxed/simple;
	bh=40EIc5kIGcOKUXSHqlN7/qrWJgKPfPddiNK6uBz+6V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlkbCIhveLMHZjmQlp8uIUm9sQ6CGruLeBarOZ4q1w3tm3YN0W66wlXkM+pBTqdJr2RRgQpbfZHtrrjTJceA7JiJmZFJI8gqijVVJc14R6UyJlnndRAI+xAOMBib68XG4RdHlXFxBj+DGctw5bA/hUfP3JPrFgRSRbdtS8wjCjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zZJdGOa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zZJdGOa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BDAF1F000FF;
	Tue, 13 Oct 2026 12:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895856;
	bh=iTu1Hoa/OcaT0//JX/OaZtXXp1SRLGOFy6Nc56MWTNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1zZJdGOasMQMEB3E6GNGI98NFRs4/MhAFCOF6ZYoAi/gVrFuPBAne+Oiq2DJEiv7b
	 DCC/ou/AwXL4OOjVm/hi4OqojoT29pIKUdiiVnzMOa8VYQ2+4Nho6QuTZeXtTVqO2o
	 cWMPYtk72PKy5wqraBgZwZjY7buPIDObbNvOU3XQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 372/497] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Tue, 13 Oct 2026 13:38:59 +0200
Message-ID: <20261013112916.728417907@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1345,8 +1345,10 @@ err:
 		skb->data_len = rx->status;
 		skb->len += rx->status;
 
-		if (unlikely(xennet_fill_frags(queue, skb, &tmpq)))
+		if (unlikely(xennet_fill_frags(queue, skb, &tmpq))) {
+			__skb_queue_head(&tmpq, skb);
 			goto err;
+		}
 
 		if (rx->flags & XEN_NETRXF_csum_blank)
 			skb->ip_summed = CHECKSUM_PARTIAL;


