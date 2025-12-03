Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C47CF358D26;
	Wed,  3 Dec 2025 16:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778861; cv=none; b=pAPXAuz4+NC07Jkl9DF7tFF58PMxVnmCBIRorP0fcNOmakTUcCLnK0YBYXM09XPxI/nmkjsillNFUZXooGE8I0ImYEiOVndPyBJs/gHVHzvEitXC13Pb/O1Cnwm02XS+y5j9217QNoDRkvyT941xtup6piWUIoo2SnlynNiP8o0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778861; c=relaxed/simple;
	bh=fvsmdwy5lTtWlcAe4H+qDQULfKXsQ4FEkSm1MNBkAfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qcl8rkbSb5loN+ifDj75IdeXSjswCTLOPplHzVjDQfsHhuYFPuAZ5oaB6s1i9usddDLVJM750Ei+hyN2c1eDGJeqiQ5RQbbX6cQC2x5bYSAqaMXGyMYtR/YTy/AICwZoVuTc5lzRPYgiI0Gk4GlV3JmRFCA/uB0ZGvXKfj6D0Bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ElL53Xqv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ElL53Xqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F86EC4CEF5;
	Wed,  3 Dec 2025 16:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778861;
	bh=fvsmdwy5lTtWlcAe4H+qDQULfKXsQ4FEkSm1MNBkAfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ElL53Xqv7QaeZCw5XvFCI5b+iSZ8o9YEFIbGGwlm/u02kVY4FXF/bN1KWo4ntK7Lr
	 U3O7PI/lSRkIsoYwQQnK6L96pwICeyvjXqPzx1GE6EMfcm/nciBaZn3KgU0lA5cZ10
	 p6zKb53CnVWpn78Xbn7TsJjXO/YsFeqizuLDubBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 6.1 083/568] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Wed,  3 Dec 2025 16:21:25 +0100
Message-ID: <20251203152443.773565182@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2005,7 +2005,12 @@ static int ffs_func_eps_enable(struct ff
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
@@ -2029,6 +2034,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


