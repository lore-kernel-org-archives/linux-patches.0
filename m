Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C6F198A0D;
	Wed,  5 Mar 2025 17:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197115; cv=none; b=I+ZomHMvkEi8fjTjDUMmM2i5X3CYNyfevq3QSqt8pr90wrE2LUOu3aYICzxnWoT32MCe0FeskvXXlWeVtwyuvNmNBrvVX6H/L1Mttz1kIrOAZNGK6WjY/ieTQp+aH6xgXaMbqvcR8ZhhD0FD+DGSD+bg3+1EuZX6nscnosLmem4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197115; c=relaxed/simple;
	bh=HPQaIpr7bf8bGRxjErire4hkJpc9lLVs4PYPuNQt+tM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9dPCFTCY/WegkKe60MFi8qun9vb4ehb2hBgzwmcRNzeIWQ9eXZH9xJ1V+HTJBhA8gHCuFUhfFQ3pPO3qPz7SmKbG4+B4cQiqFYotUoEprOZZIpcUPVFNDxflifcCqSJGaXoCogAxxV0hMGelnLsU483sRLGLAfqU+ENN0aYWZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSrsxtqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSrsxtqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B0EC4CED1;
	Wed,  5 Mar 2025 17:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197115;
	bh=HPQaIpr7bf8bGRxjErire4hkJpc9lLVs4PYPuNQt+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSrsxtqRGB+Qr4TgeZlavp8Dq4ddAJ1UD4hbGGy0pWhuW5Ng7dfYFovr4af6xRZ9n
	 eqfWSDcWpQJ5+/Xdfz9LLHHIxaQi/k2Q+A/myVD06iE4hGyndMWADeN9Yi6M7gfARt
	 MHQy3/4EJMAZsenqA0OOt7fJebMUsKA+ROMfSu1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 045/176] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Wed,  5 Mar 2025 18:46:54 +0100
Message-ID: <20250305174507.274416744@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 183c8a587acfe..96725b6599ec9 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3776,6 +3776,7 @@ static void alc225_init(struct hda_codec *codec)
 				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
 		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
 		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	}
 }
-- 
2.39.5



