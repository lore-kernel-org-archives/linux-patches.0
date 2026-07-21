Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4D03DD870;
	Tue, 21 Jul 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658461; cv=none; b=F37MO7MQ5CJVS+rlTespnWHfSIbXi1upnIIhdEXgHr8vLfCzHxXSaKJx8zonxLtBvXAWcu3hJS+6A1itQ/Rf3JK03gm5ZXril0bsykncYAntU3WEQdywsqu7qwzjwtVLKlt9zwu/ok1A8gFF4QuQHxJtp0spT5BCjnVrbyENE4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658461; c=relaxed/simple;
	bh=s6QUQjJB/+VKZ4lHNs38EikUXzRbcd73XPcLy8nTPPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFU183tI2gDUFulhkTbyXGayswP4UnFT9sv1thyV53OdmdVYSo0ic7lXG71Bkvc6QX+8h1mgPQx2mSCCTqZG5oylJY1JD0sIW8edDl2tcrAlhUOStjhlJEnZArRgM0N3qQOv/Ab2vea/5dU9MuvJNIqdqy7Xay/MrNW8fBbH/Ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYFYy/br; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYFYy/br"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088241F000E9;
	Tue, 21 Jul 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658460;
	bh=r5CgCWiW5VFi5BjHd8WquYaoFOWOTkB8h8C6o1X3XN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GYFYy/brWUWJO7cB5MhBvvOovw7/yQGv0p/p0fBGfLMUW0+Se389bPfKkRBexXQ91
	 x142pkeZL+q/ucYCDHVGvAUGKqtnIDV/WYT3W8+bt6ElxzqkVw+EsrS+7a18AZ2baF
	 eqxf0KxLmJnyfCxQPzEjLWpwK0sv6h52iZdpfXLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Helge Deller <deller@gmx.de>
Subject: [PATCH 6.18 1151/1611] fbdev: s3fb: fix potential memory leak in s3_pci_probe()
Date: Tue, 21 Jul 2026 17:21:07 +0200
Message-ID: <20260721152541.308043861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 3b0ed04bc852887a9164e1bbf521652e8ef3eb92 upstream.

In s3_pci_probe(), the memory allocated for modelist using
fb_videomode_to_modelist() is not freed in subsequent error paths.
Fix that by calling fb_destroy_modelist()

Fixes: 86c0f043a737 ("s3fb: add DDC support")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/s3fb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/video/fbdev/s3fb.c
+++ b/drivers/video/fbdev/s3fb.c
@@ -1446,6 +1446,7 @@ err_reg_fb:
 err_alloc_cmap:
 err_find_mode:
 #ifdef CONFIG_FB_S3_DDC
+	fb_destroy_modelist(&info->modelist);
 	if (par->ddc_registered)
 		i2c_del_adapter(&par->ddc_adapter);
 	if (par->mmio)


