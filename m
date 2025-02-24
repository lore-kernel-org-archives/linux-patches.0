Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320C127701;
	Mon, 24 Feb 2025 14:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408910; cv=none; b=aqC/eCL7HjEKGVC/HxiR4bApwTtsalgrTX0FC4as3XuFfymSqus4C9vn6hjOAH1RpYs+Azb8TKbrlV2wSMGtPOCpq4iyA6A6g/KXxPFPJDx1kSQmJnRyzAlf8c4ijFUYD+Gwk1dGgxWQts941yASTVe7LiqJdz4z5AItNxcrvBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408910; c=relaxed/simple;
	bh=9119VAZoVEtH08aCJ4/7xUHgPdSHFkQdh+RFc0KRmi0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBpIJgApFdu4gFRf88+Z74p9xMq6MOcmaRC0O1p/Z7WHcG7VM0TGvYz6euWXC8QB8M+cX7DhiqIh2EKQgOW80Qq7wWFgxmoXny/H/j4v56iXM386JZI8jtY4MSOqC/v1x71jwcWJBzeall99//DmycD2id4RoxRaINoJlyjtuuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfOVlzLd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfOVlzLd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF94C4CEE6;
	Mon, 24 Feb 2025 14:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408910;
	bh=9119VAZoVEtH08aCJ4/7xUHgPdSHFkQdh+RFc0KRmi0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PfOVlzLdvg6bt0oAxUU9CcjLEvrfFaAPLvblBQ0ULT3Ybn0Rm8elT+z9P/wAyOEfD
	 pTBkS/dUR9CI8GzkNldcHNVQDP/k+T6IErTSi8v7uVKzwK5Q4kqJmiAdmRz6X0tgPm
	 QeDcLPBuS+Y/jMMvzlcxggQzYJJtaEvnfngDcT64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 024/138] ALSA: hda/realtek: Fixup ALC225 depop procedure
Date: Mon, 24 Feb 2025 15:34:14 +0100
Message-ID: <20250224142605.420549611@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 6c352602987ba..ffe3de617d5dd 100644
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



