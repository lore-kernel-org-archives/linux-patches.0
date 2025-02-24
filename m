Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0671624D9;
	Mon, 24 Feb 2025 14:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408404; cv=none; b=K6V/z8Xo7glfJ7/tnfe4FvmC15iXWArifcy2Kxu+HiTkJN+cx7UUNjxzYi8aLETb35tTRthwNYR2X81eS9carQ5HNvJy8HmBcwRgy4sYtq1dCDc59TAOq3cOMhF4UCY/3zFIfwWVp+VEZtWpm1/3HusaAh3h/QGmcABjPP2S5Q4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408404; c=relaxed/simple;
	bh=l8KGbocB25eVQXCyU/+zX/Pz5YYuHvdCErAoJMIQCHM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NVSlTh+WoHRgavbDnymic7JZAxdksgbN/rEzwS/xiwNTCI41DBUBU7rgIl9r/eO37OPw6Dn1nBUl0EaMVqVVx1xhK1SDGuf5zg0HfpAoMwl5dfFdFXrJFOp1H1tTk11H7lsQ9HP9+kahQEGcNXksjx7dawfZ/i7ymkOkA8oMn4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8UmbaS0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8UmbaS0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A3EC4CED6;
	Mon, 24 Feb 2025 14:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408404;
	bh=l8KGbocB25eVQXCyU/+zX/Pz5YYuHvdCErAoJMIQCHM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8UmbaS09kWbGHQgXNGWhQGjf7sHUd5IyZI42bRx2GJpmnhk2GFz+8YSswgARNj26
	 GGOT0yxDMtDMFdyGCmgJfsPRDYW984fyzkQTZZHI2OTj+l/BBCGUHQiqlK4iMfxYEn
	 0ZdXNXx54DeqM6PoHF86u+zh1wBoDsAasMH5iM0M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/154] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Mon, 24 Feb 2025 15:34:07 +0100
Message-ID: <20250224142608.975892524@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 174448badb4409491bfba2e6b46f7aa078741c5e ]

Headset MIC will no function when power_save=0.

Fixes: 1fd50509fe14 ("ALSA: hda/realtek: Update ALC225 depop procedure")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=219743
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/0474a095ab0044d0939ec4bf4362423d@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index f3f849b96402d..9bf99fe6cd34d 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3790,6 +3790,7 @@ static void alc225_init(struct hda_codec *codec)
 				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
 		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
 		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	}
 }
-- 
2.39.5



