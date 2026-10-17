Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B67513BB9E1;
	Sat, 17 Oct 2026 17:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257343; cv=none; b=Vad2/Td507V0xmC9W3nqKBieHtbyzlOXxpifYHh2HCdHP3D15abEsuYqjLrB4h3d5MSAaQLxyTod3UlyMYBRJGtSD0g/Xg0yNnFJ+LVAcRDcVWyWPIHSusHVxlOX20ieRjdfCwFwe3WWRffOUJD0Y79CXCYoVw0bXdKhXPP0Wng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257343; c=relaxed/simple;
	bh=PT6ZAk7vG7S83IOMjYnSOOtJ3rP7vI1SS8cVbx3rwm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dkHmthM7PUOrVeekLB8oCdotwuCJlI9F/hgVeqgZN129//XiGlmQJsj/g4nIfdGHFjBZm/gnsG4ByVezmDrKgDUlq654JKY+zvL/Ar2XUuWIFYM1D/3CZ7kOGlUY7+ufJGDlh8Q6hi7TbK+scsm9+k4btKqf8nFYPVYnxpImPPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPoSzgmw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPoSzgmw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B25F1F000C4;
	Sat, 17 Oct 2026 17:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257342;
	bh=Cppv7npUaBXPu/IVFgYuk4VbX2VxUa3dfRbbtKguEX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SPoSzgmwemMGzO4oXw4yq8SlTds8PIOwnyFRYCfnPpgkDNkZEvSNhneCN+Ctc8JNB
	 hP0Ws+1LrMFY2x/w0dsoM4PE1DKFVBeuuWQRoKIu4CpRkiRjg7fjM43HIFcbXqYwLj
	 728Upd3hRMqesYUyGWOKoXxRHTx8v5nzynvVw1ek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Juergen Gross <jgross@suse.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0477/1674] xen/netfront: dont leak the skb when xennet_fill_frags() fails
Date: Sat, 17 Oct 2026 17:45:49 +0200
Message-ID: <20261017160443.357918720@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


