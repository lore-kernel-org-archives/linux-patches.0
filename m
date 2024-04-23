Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 683F4143C45;
	Tue, 23 Apr 2024 21:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908524; cv=none; b=mEuUJ5ThuuAUf6eI7TA14Do3yqml3kzmGWqMAXGE0W60NypHSsRU6QiK0+Ddw62FUzI1z7BiAXuuctCaw0OehUP/hVWBnv0Ow0IajBQ0q6uri5uzd1pxIcpPxatDLCisIeAFK15UkcBzO67eisDUn8601Aw1QuxHhK84mKCg+K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908524; c=relaxed/simple;
	bh=Eql7X4AVZTS73kG6O9iSjweGdJygx9r0Qe13h1SBfyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KbvCdR8YrBqYONyHY7XtmVuLm4yBkSiE6J6soPQfMKkC6h6tO7KixYb5uUwpuiM6P9oksC2iycJ/zJSc+NWtY7OlKIIgt9axt2oKpzydPrQJ+iMV/OTqj51YRqNIy24n7bQb39lvtnd7SWsSnjkoPOkYfVBUdltJOEF+USdZQRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qouhhAWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qouhhAWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA48C116B1;
	Tue, 23 Apr 2024 21:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908524;
	bh=Eql7X4AVZTS73kG6O9iSjweGdJygx9r0Qe13h1SBfyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qouhhAWBlEl6vBqHRPfpawGQrYPO+NwJHXl2C+X71Dfs96XWpIAVF2byqUQG6gewW
	 XSwSoVXapxwO+uQfzeM5eO5cXmN52kUTPDa1JU7bna3DRZkZmacpUyusdYV5XZPWH1
	 eOKieqZ6Pe0O+Wz0q6s770TUkUPlPI5RUnPfpy5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenghao Ding <shenghao-ding@ti.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.8 090/158] ALSA: hda/tas2781: correct the register for pow calibrated data
Date: Tue, 23 Apr 2024 14:38:32 -0700
Message-ID: <20240423213858.882309895@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenghao Ding <shenghao-ding@ti.com>

commit 0b6f0ff01a4a8c1b66c600263465976d57dcc1a3 upstream.

Calibrated data was written into an incorrect register, which cause
speaker protection sometimes malfuctions

Fixes: 5be27f1e3ec9 ("ALSA: hda/tas2781: Add tas2781 HDA driver")
Signed-off-by: Shenghao Ding <shenghao-ding@ti.com>
Cc: <stable@vger.kernel.org>
Message-ID: <20240406132010.341-1-shenghao-ding@ti.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/tas2781_hda_i2c.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -501,10 +501,10 @@ static int tas2563_save_calibration(stru
 static void tas2781_apply_calib(struct tasdevice_priv *tas_priv)
 {
 	static const unsigned char page_array[CALIB_MAX] = {
-		0x17, 0x18, 0x18, 0x0d, 0x18
+		0x17, 0x18, 0x18, 0x13, 0x18,
 	};
 	static const unsigned char rgno_array[CALIB_MAX] = {
-		0x74, 0x0c, 0x14, 0x3c, 0x7c
+		0x74, 0x0c, 0x14, 0x70, 0x7c,
 	};
 	unsigned char *data;
 	int i, j, rc;


