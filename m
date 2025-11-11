Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FA4C97;
	Tue, 11 Nov 2025 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822486; cv=none; b=megIVv96SMCBtuN829hLLkkdz6crZ1Kw7pjydv/kcBndoZPA0IDa/R+2L/FDhoEflKwxmRTl4d4PNpqJrzrdSJWqxqxIh1fCO71I07CBvoP3Jr5tHZhHGT1n3bjUfp1kQOIIPfC0QhwrF634GpuTUtS/J65KhO9M4YMlw1fYH6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822486; c=relaxed/simple;
	bh=qBk3KkO/+3tvQI8+O/BHrIR9rycjLqbj7LwhkDHP8ow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K2q0Sw8xCgXIPk1iX3H+621l99dfOtinSCiZ42rFpM3e+LfADVza00tANHqNckMJocLVgogykcrgQiBZev6IcGmETQLslb+FwR+hLggNaXikQktKt1rT/trz+p5CUi1EFtpzDXqpSahzmeFqd2KcCPJ3MbrwD2ZiWmIqQM2NPrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AB9f3Vpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AB9f3Vpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DACD8C116B1;
	Tue, 11 Nov 2025 00:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822486;
	bh=qBk3KkO/+3tvQI8+O/BHrIR9rycjLqbj7LwhkDHP8ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AB9f3VpnIAGUnfnW36COv+2eOQhmEtosjiqB2lWTd1+AsRCvjiKrmuPdBSrUWM0w7
	 ePgoPPotnpzBKqhvWi4m87tePDtEBQNUT9zs7Co1qUn0BoiMOOLExi4z6XEhm77Rji
	 m5TMxi75xcmbpkhof/K6m0hCvPH/MgPMugPk/fzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 6.17 117/849] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Tue, 11 Nov 2025 09:34:47 +0900
Message-ID: <20251111004539.226746676@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Owen Gu <guhuinan@xiaomi.com>

commit cfd6f1a7b42f62523c96d9703ef32b0dbc495ba4 upstream.

A race condition occurs when ffs_func_eps_enable() runs concurrently
with ffs_data_reset(). The ffs_data_clear() called in ffs_data_reset()
sets ffs->epfiles to NULL before resetting ffs->eps_count to 0, leading
to a NULL pointer dereference when accessing epfile->ep in
ffs_func_eps_enable() after successful usb_ep_enable().

The ffs->epfiles pointer is set to NULL in both ffs_data_clear() and
ffs_data_close() functions, and its modification is protected by the
spinlock ffs->eps_lock. And the whole ffs_func_eps_enable() function
is also protected by ffs->eps_lock.

Thus, add NULL pointer handling for ffs->epfiles in the
ffs_func_eps_enable() function to fix issues

Signed-off-by: Owen Gu <guhuinan@xiaomi.com>
Link: https://lore.kernel.org/r/20250915092907.17802-1-guhuinan@xiaomi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -2407,7 +2407,12 @@ static int ffs_func_eps_enable(struct ff
 	ep = func->eps;
 	epfile = ffs->epfiles;
 	count = ffs->eps_count;
-	while(count--) {
+	if (!epfile) {
+		ret = -ENOMEM;
+		goto done;
+	}
+
+	while (count--) {
 		ep->ep->driver_data = ep;
 
 		ret = config_ep_by_speed(func->gadget, &func->function, ep->ep);
@@ -2431,6 +2436,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


