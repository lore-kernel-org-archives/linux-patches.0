Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E824C97;
	Tue, 11 Nov 2025 00:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822599; cv=none; b=c22WXa8dMvt7SyC2krIa7JiCnciuvwvM3OJZLgfieax5zF8z39yTZvF1Hubm1dxU0loI7gfJhml+NClEBfw6D4EJ8ACjAbC1D67MLAdSZYNP4JRjMN++oTiCBeZbyVA77ltxnJ62H0zbAFup+/zLIBGmK29NCu/VRoZy9nj8bEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822599; c=relaxed/simple;
	bh=APn0V5kaqnhZClzem5ZZRBp0TAQaw3BAGv7YesHevPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pI9ODT8ZZaSSkLL8zoHokdtMgQMW+f6/BnNcTkfm/8CNM0sucs1jj7NDInOYXJk9THQKb7pYWLUVO49r/2epDM2GgenmTTSMX5ObpoXN7zOsMwrlP6Lkf0wtMW0PII4w6N6tJV2H+1PVkH0IwlMuKQuP4Tf9hf3261sWCuGpHL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a2zEBvXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a2zEBvXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7A4C4CEF5;
	Tue, 11 Nov 2025 00:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822599;
	bh=APn0V5kaqnhZClzem5ZZRBp0TAQaw3BAGv7YesHevPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2zEBvXI6tEWKUGdyxP5UPoF1wm706pcjg+o+EEt2mDY1+LiYIMPq4RuilZAkaGsX
	 MFtcE16L9PE8JrZgpuw6ymPnWEwLLYX7N2KfQWYnFgceahD3+t1QcTXlNCJucPl2ZT
	 uHS1upjRLjVDFMzHhIAbOcZht/9EV+Lyg8PW6nLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Owen Gu <guhuinan@xiaomi.com>
Subject: [PATCH 6.12 082/565] usb: gadget: f_fs: Fix epfile null pointer access after ep enable.
Date: Tue, 11 Nov 2025 09:38:58 +0900
Message-ID: <20251111004528.813359854@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
@@ -2418,7 +2418,12 @@ static int ffs_func_eps_enable(struct ff
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
@@ -2442,6 +2447,7 @@ static int ffs_func_eps_enable(struct ff
 	}
 
 	wake_up_interruptible(&ffs->wait);
+done:
 	spin_unlock_irqrestore(&func->ffs->eps_lock, flags);
 
 	return ret;


