Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B912F9D82;
	Sat, 12 Sep 2026 07:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198361; cv=none; b=RwWoFiu/pUyvPodatm5rEneRkZ+cNA6TLdhJfH3JMLt9uhzEQD8UcTv/Z+S1j5J7Xj96PIGN4RCDy4bluzN4y2vXf+bbFjNfMVTlc7CLBFQFmC5q0E1heoRUYF1EVP9AnSqp7kxGo3MKOWik/fQ8LzHZOy23Pxebz2rqMLjxvyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198361; c=relaxed/simple;
	bh=Jqvcc3g07FelcElUci7ET36nwtmp5RLg0LgqYoR6hUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W6EXnda1cKy6/2+U9AqwMZ/khrH3Jqw7Ny4y2/7N4izu17wWYxnP3+73N+ibCKHxHsWXmi1CCA/Llvs0yEgXAFtljWxucINjBToTowfHoM/HjZfxj5M1dmRWxVomWdlJskvWCsoYY7qhyUhwVJ1HwF401Vkt7nAOrOfa/Nf0rcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJkLx7tx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJkLx7tx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A92041F000FF;
	Sat, 12 Sep 2026 07:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198359;
	bh=Ppb2hztvebqRfTNHnhghtgEtruaInT+tf2CCg41vlp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJkLx7tx1T1wUqxm8X2z+DQPbIEfmZ2Xi0SD+tminXSake1BWU9f5ySHf6kc7UXIX
	 r7XhtQ/FuVFGQ4dFAGrXcSdyO5QF6Db2A7s20udCeY0RAPC6cuJ/JReEOP0bGAzjwf
	 0hLRhmscEwSneWLvfwDXzDI8Ky/9bTgVCThTR6R0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0321/1815] usb: gadget: f_fs: Fix fence cleanup in ffs_dmabuf_transfer() error paths
Date: Sat, 12 Sep 2026 08:34:31 +0200
Message-ID: <20260912065656.471497489@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 4ec37c1fdd22e..563390f05f660 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1705,13 +1705,13 @@ static int ffs_dmabuf_transfer(struct file *file,
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
@@ -1760,9 +1760,9 @@ static int ffs_dmabuf_transfer(struct file *file,
 
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



