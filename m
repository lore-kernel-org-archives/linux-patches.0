Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D0527FD56;
	Wed,  4 Feb 2026 14:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216534; cv=none; b=jsnHMFUixkYnUmf4TqlqtWrTgWWXONFWhCb5e0hNg+PK9ZQyVc4lxQGC6BA/rjRLS3O2W2hA3NqCYKhH92JUYTFfDW8GlwUv5CgtCUYY9pGvdmrC0dxXZyGYWETCQ45cBh5Fbsc+24o8RtMFv5qXygmjAZigsoG51SvBbEnFcBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216534; c=relaxed/simple;
	bh=0ZnJXAikCcrumcTx3R3ZpZmK/VWnVyax+SlnkWPXHU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3Y19SlqUU8AT+BKj9Z0ZTGmcjZlKfnT5/vOfjhAR3d0TSHaEALdgAuKMR0/alr7Ntq/lmrWXFjzmoimDQ2yXf+BVfRS37f4NMPHroeuya+N/IIuiwSoRxfxfTH4kLljxNT8ikeOfYOp7DWtsSWC3F0ewUn9oUfYk3iYd7V9wiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcZNLg8F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcZNLg8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3DDBC19423;
	Wed,  4 Feb 2026 14:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216534;
	bh=0ZnJXAikCcrumcTx3R3ZpZmK/VWnVyax+SlnkWPXHU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gcZNLg8FRvdK42ncc1mJOXHPFwDIoHhNUF2boObs8MBEWSIqcJD7LNAX2wehRidxd
	 ZyDxWOYYMB0h4PG4MquDsnHehQ99dHfhpd8KaHLv8pgyyFnXJPZWc9dCtWOlHZnEE+
	 mrm6Rv5OgUz5myFjYD2tmQUUrhDgd8VpuOjPNAFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.10 099/161] slimbus: core: fix runtime PM imbalance on report present
Date: Wed,  4 Feb 2026 15:39:22 +0100
Message-ID: <20260204143855.306881896@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 0eb4ff6596114aabba1070a66afa2c2f5593739f upstream.

Make sure to balance the runtime PM usage count in case slimbus device
or address allocation fails on report present, which would otherwise
prevent the controller from suspending.

Fixes: 4b14e62ad3c9 ("slimbus: Add support for 'clock-pause' feature")
Cc: stable@vger.kernel.org	# 4.16
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251126145329.5022-3-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/slimbus/core.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/slimbus/core.c
+++ b/drivers/slimbus/core.c
@@ -498,21 +498,23 @@ int slim_device_report_present(struct sl
 	if (ctrl->sched.clk_state != SLIM_CLK_ACTIVE) {
 		dev_err(ctrl->dev, "slim ctrl not active,state:%d, ret:%d\n",
 				    ctrl->sched.clk_state, ret);
-		goto slimbus_not_active;
+		goto out_put_rpm;
 	}
 
 	sbdev = slim_get_device(ctrl, e_addr);
-	if (IS_ERR(sbdev))
-		return -ENODEV;
+	if (IS_ERR(sbdev)) {
+		ret = -ENODEV;
+		goto out_put_rpm;
+	}
 
 	if (sbdev->is_laddr_valid) {
 		*laddr = sbdev->laddr;
-		return 0;
+		ret = 0;
+	} else {
+		ret = slim_device_alloc_laddr(sbdev, true);
 	}
 
-	ret = slim_device_alloc_laddr(sbdev, true);
-
-slimbus_not_active:
+out_put_rpm:
 	pm_runtime_mark_last_busy(ctrl->dev);
 	pm_runtime_put_autosuspend(ctrl->dev);
 	return ret;


