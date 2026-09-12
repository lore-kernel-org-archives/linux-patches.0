Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FA936A36A;
	Sat, 12 Sep 2026 09:56:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206974; cv=none; b=n9lPaU4G2tyIU94LD8E/IER0r+3yKIA8kxxOqNUrtfw34/itWUbb8GhVAK+h1DFDRKseTTiXQ8u69ttjvtXaAVc5U6aI4zhvT6AXbpMt/0LTDskIEU+NQsjyOyRodDo7t9v9eZsS7kLe2Lsy39uUKw7ezD1iqGzXdUmW72lmB2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206974; c=relaxed/simple;
	bh=cmL+xWBnj83TFTIHmOUVtzyy8VpQ9c9dySpb1tDhnW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y2kwYGM4qEX3bslvJd81qKu4XiIF4yqb57kDaDTtD27DD4oPycCrWosDhQutIr5xt5Cx/cHwYBem930jUrgwF3dVMQ9w3hrXuqFK9CBEMDFPJOcBu+bX2XTHRf9wVhdBvYe6/j/aDZpVTjZPkIvnxgAjDAPvHX5bWDNx/Y5jw04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qiuS41bb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qiuS41bb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016F51F000FF;
	Sat, 12 Sep 2026 09:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206972;
	bh=JySP6er3Zv3v/0ZuBMBQPCM22Wk7/bTcinUCxpby7vE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qiuS41bbvsIhNtFCKB0/8UeOcr9OVjwI7GIL29xEfk1tDn7GONmpvbrgzaHBuLP0m
	 UqOYLz/y3zS9rsKHXQK5+qoweW75yqYsPGhjCWTswDm8aGsei2gRubaDew6JxIlZFZ
	 l8T3TY5SNS8mmyilRCGY3hfZP9hfGn7TGdR+1Hcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0315/1518] usb: gadget: f_fs: Fix fence cleanup in ffs_dmabuf_transfer() error paths
Date: Sat, 12 Sep 2026 08:41:24 +0200
Message-ID: <20260912065630.606006126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

[ Upstream commit 621707dc67c9846fd876d7579ec951d92aa033f1 ]

The error paths for endpoint-disabled (ESHUTDOWN) and request-allocation
failure (ENOMEM) in ffs_dmabuf_transfer() jump to err_fence_put which
calls dma_fence_put() on the fence. However, at that point the fence has
only been kmalloc'd — dma_fence_init() has not been called yet, so the
refcount and the fence ops are uninitialized. Calling dma_fence_put() on
such an object leads to undefined behavior.

Use kfree() instead, since the fence is just a plain allocation at this
stage, and rename the label to err_fence_free to reflect the actual
cleanup action.

Fixes: 7b07a2a7ca02 ("usb: gadget: functionfs: Add DMABUF import interface")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Reviewed-by: Paul Cercueil <paul@crapouillou.net>
Link: https://patch.msgid.link/20260612-fix-f_fs-fence-cleanup-v1-1-79f489b0efe9@analog.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_fs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/function/f_fs.c b/drivers/usb/gadget/function/f_fs.c
index 09d6872ad38b7..d73b082d5d835 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1683,13 +1683,13 @@ static int ffs_dmabuf_transfer(struct file *file,
 	/* In the meantime, endpoint got disabled or changed. */
 	if (epfile->ep != ep) {
 		ret = -ESHUTDOWN;
-		goto err_fence_put;
+		goto err_fence_free;
 	}
 
 	usb_req = usb_ep_alloc_request(ep->ep, GFP_ATOMIC);
 	if (!usb_req) {
 		ret = -ENOMEM;
-		goto err_fence_put;
+		goto err_fence_free;
 	}
 
 	/*
@@ -1738,9 +1738,9 @@ static int ffs_dmabuf_transfer(struct file *file,
 
 	return ret;
 
-err_fence_put:
+err_fence_free:
 	spin_unlock_irq(&epfile->ffs->eps_lock);
-	dma_fence_put(&fence->base);
+	kfree(fence);
 err_resv_unlock:
 	dma_resv_unlock(dmabuf->resv);
 err_attachment_put:
-- 
2.53.0



