Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8226B47986A;
	Sat, 12 Sep 2026 12:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215202; cv=none; b=hsMSpMLBOr5UpyQumRB7hhd71sJAWgq8HQ6mvXezu40zff0Z4In0USazKg1S2ye1xpxyLZoZRHOsyygabp/G20u1S2VieCzfRIZRujNGjHOVGW79G6/yHvRSUTUf51dx5d+gV/0LEbBLxNE5TNawkPHuhYArLPLuj+B6WuT70UA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215202; c=relaxed/simple;
	bh=5Wmf2UDd2kjnBQDlgY+9a0KDJ17TehCGfhLpNaq1nkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JAx1C9tTFABSKoKgciZzluW9UdYHa4ihRCoc2Yy3g114SJC6dNE5QaaoUl/lYheFMcVnIH5l2f6fV9xq17y+INsAWwKyy2+7dPXS1u2U5yXRf0cuHvkPVdMcXYTYT0zY8wS8w+vIDE++V6cRYyaFXArBc9unK9CaiQAjGSQt4lM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/GNckU1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/GNckU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36B991F000FF;
	Sat, 12 Sep 2026 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215201;
	bh=NKMVC90x/IOCoD5O++YmoeEEjEWkW8Kg1kE8nOA1lp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/GNckU103O7Vef2VLHygY/RssYxJUFhlyK2pfbnKNW4uy+l4BoTW4MVuOmtzDSqj
	 Be/2ZvKoprSucOfasWCKmxJBVUviFjzd1fuIrXcjg6F19dyKFHbdImR0QAneahAb9h
	 m1x/SD8VnHWp5GXcXZtozUfz7zFYMbgliGD9rZAo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Paul Cercueil <paul@crapouillou.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0484/1376] usb: gadget: f_fs: Fix fence cleanup in ffs_dmabuf_transfer() error paths
Date: Sat, 12 Sep 2026 08:48:30 +0200
Message-ID: <20260912065618.322468275@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cbed66a528269..24bfde82c385b 100644
--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1678,13 +1678,13 @@ static int ffs_dmabuf_transfer(struct file *file,
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
@@ -1733,9 +1733,9 @@ static int ffs_dmabuf_transfer(struct file *file,
 
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



