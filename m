Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9B026ADD;
	Mon, 24 Feb 2025 14:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408102; cv=none; b=A8USyAjSTG4nujbFzrD0QHQw5GOhNTEUd3vImZKQOW6FhQGMQLXF1EhaKzg1aMcl2C2DGp5ss51/S8OiFi1gdLFFNiYpFUOusk30SkvOE5O8A/CwLNOFhbD3bJrqCooB7MDeIZsIqg7foY5bFxkqZp99CT/buX/vFQ5eoMswgeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408102; c=relaxed/simple;
	bh=njJS734vhDT1GmCV7aqoE8zMbQQDOiWQfClZ4NzaxWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9W+rO4Oqxou37PT4AHjL10Sy7Mn4/nrk9W9wLAWCcjThkO2I+x1pa5zh1gwYyv+3rseJF2+WpEvTMbcjviTLXTxA99KFLa/Owt56wLhw2T6YiddKLMCOPDdN8xhmE3VETqeuqEkbBmP3sCCptNQABObVKMUeph5pSHSkskgvhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcsw85UY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcsw85UY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CA2AC4CED6;
	Mon, 24 Feb 2025 14:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408102;
	bh=njJS734vhDT1GmCV7aqoE8zMbQQDOiWQfClZ4NzaxWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jcsw85UYKrcx8ewlAucBqidmcqfa9ZvGOPDab4dKpD4flGDBSizJsqEWU8xdvZiXg
	 ItxwlW2BJYAqKGKXnJG5qVQVidj7XhHx548JhVWbfd9Zypcmd3FVqHdrO7fLrfWrH3
	 YM+nGBve1uZ8zSCeZEAxHGJLSI+FBzNIhikfHvmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/140] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Mon, 24 Feb 2025 15:34:27 +0100
Message-ID: <20250224142605.682475281@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index abe3d5b9b84b3..75162e5f712b4 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -3779,6 +3779,7 @@ static void alc225_init(struct hda_codec *codec)
 				    AC_VERB_SET_AMP_GAIN_MUTE, AMP_OUT_UNMUTE);
 
 		msleep(75);
+		alc_update_coef_idx(codec, 0x4a, 3 << 10, 0);
 		alc_update_coefex_idx(codec, 0x57, 0x04, 0x0007, 0x4); /* Hight power */
 	}
 }
-- 
2.39.5



