Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B39B742DFEC;
	Tue, 21 Jul 2026 19:59:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663976; cv=none; b=D3qmkv8VU4iId3Sz3UARayuQ3X8sjLcunWhE0r5WOSet0cW+1n33LJDgcjoEvrFCkOb+zvl3V0gjkeEvlmnAylJy8XLy5v9harLGMkbYl4abv60BXiKsNi1fpaLBPpfrMMn20GNLvl2rcR/JLENLVwB9BAnjVXASvXfjAvbUfCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663976; c=relaxed/simple;
	bh=JK3fjFXQn8uqn/9BaM1X3vV6F058NGLSNP42GZNTNYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvDj8GIo3VBP3W7w6urtyOQdatsjhFmBaymrKX1b8YoX5Yii2EqZYpR4BmZZTaruEMNmPykgXhxDeEcNwx3rS97UP+VGJo+uVCL7dLsT7qQRqaNBZi8bSkhS3f+GRbN7SO14aCYkAtDVXjeoBAIQpbCxpAjWlWF7oikRWOJM6iQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HWHiUpqr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HWHiUpqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBE761F000E9;
	Tue, 21 Jul 2026 19:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663975;
	bh=ys+edd20ECoPIAt1NFLGSfZ1EPgncwbN63doF1KF63k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HWHiUpqrB3pL7BxX8GxSoEFOP/h4en5VCgoIiR8nba86Jdm/2QgtqhYeoGKBKGc8U
	 eJYSDHSJ34iIF8TvsefaXiTPWcFpIphXRkzGX/uLLD0plRw4Xyvy6AJJzJ41WFYWq8
	 9L3TLpalzUVoF97u5EOiE0jDvhzMqK2DG+R13Gu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1027/1276] Input: ims-pcu - release data interface on disconnect
Date: Tue, 21 Jul 2026 17:24:30 +0200
Message-ID: <20260721152508.977615904@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 441c510a649c8ddce38aa0311334ed8bb546b36c upstream.

During probe the driver claims the data interface, but it never releases
it. Release it in disconnect to avoid leaving it permanently claimed.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -2076,6 +2076,7 @@ static void ims_pcu_disconnect(struct us
 		ims_pcu_destroy_application_mode(pcu);
 
 	ims_pcu_buffers_free(pcu);
+	usb_driver_release_interface(&ims_pcu_driver, pcu->data_intf);
 	kfree(pcu);
 }
 


