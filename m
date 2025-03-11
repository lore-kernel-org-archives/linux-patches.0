Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924AA1CAA8F;
	Tue, 11 Mar 2025 15:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707274; cv=none; b=nvmlUVA81eC4KNyEf4DJoxjYeBUU2pgnWkg6ITZYpRI5FjP8aGZYtCuShDdjdc3itTANkh4YFpq3foppi1k8SbIk6LjtFguVlq5po8gysdLFoRpgoWGaVSq6jk3yXE46W993wTe1G1+ZritLK7I41dIl7+3watd8ve9bTeid52c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707274; c=relaxed/simple;
	bh=TSecE3ZVCsxdPDiwOy4uJP6tDFvLsOWUYMFRKdAEBXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FI8FbnSuVso2PzmJesu12reCuUqQcbc+n2XG4j9diAF37acIDkUFY/WHB1BioQBRvMKZEW937ecW0aHst/eauCfypuvwX5TmTz+xgY1nFptEVBmx2OWeCr7WvMV3AsdkSVLr+T0x6DzXFdph0MKrZCQ60Fom5d89ab3G+apIu0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HsLZPUHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HsLZPUHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C6CC4CEE9;
	Tue, 11 Mar 2025 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707274;
	bh=TSecE3ZVCsxdPDiwOy4uJP6tDFvLsOWUYMFRKdAEBXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HsLZPUHRiXAqtNNpN9DV+UY8QOAfFpY4LeyumymYEWAsHv4Gfm7R9i7zAMM6Z541V
	 iFk0jEu34DKfNjI1cXQ84g1A9XlpirjPMenoJFt5sUKOICxBAE5Lw0Kc16bQz+idaS
	 TEJjjQmAjahf9mk6Ld028RFZOdyCo7PTs9/j49GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/462] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Tue, 11 Mar 2025 15:59:59 +0100
Message-ID: <20250311145811.524208357@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2df73f59aea91..18730b0934fe1 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3713,6 +3713,7 @@ static void alc225_init(struct hda_codec *codec)
 				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
 		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
 		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	}
 }
-- 
2.39.5



