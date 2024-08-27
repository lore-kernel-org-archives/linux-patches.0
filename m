Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B7CDDDC1;
	Tue, 27 Aug 2024 14:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770090; cv=none; b=T1mVNgjlGmCdQ6GMSxkTRLmkmDQhs7tLiFypryAEjUwx9dxQVnlJxf3qSS9Fwqi18CWSquQqXJXpoAogDNNzUq1lRIO+KtxbOAeBtyFggyT5ZeOLtTOsVjW9NxAK+45wte4LF5d/pcPJLKBqulz1iLMmAuWCs/4BdnnXI8EnsJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770090; c=relaxed/simple;
	bh=c56uplUqgZSZ16N+6d8/3c0iZfWKVha6eAobwiFPrwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMxassQO5yR1FRpJkHp2VVBdHEAKubIYew0fBm6hN/mvAW2IDDWA26titz3oM5lpfci5C+tHKLR3ZfKkLwmO5N+QnJKjgKhxrvmu4BHHDAXVFlsUaHZAtLd3LsYnpLHji4DsbdVYsP/U6FR1Ee4koz4KVJL10zfqGTe+pvhKw2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bVRtr7c+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bVRtr7c+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937EBC61047;
	Tue, 27 Aug 2024 14:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770090;
	bh=c56uplUqgZSZ16N+6d8/3c0iZfWKVha6eAobwiFPrwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bVRtr7c+o+72LHFDdz6hAo+ZzIK8ClC5myyu9qUMhUkYgjzVbVudptrJ1B3vmSqCM
	 VdnMv6JSimPBobr13Bsz9IGqix+BL+33c+zaur+ALD49x8QcLE9YR6A0hbJkwiF7qr
	 4fAbEAAuxRmw58JdYpp+ur1E3DKZKEVIoo3N+63c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parsa Poorshikhian <parsa.poorsh@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 082/341] ALSA: hda/realtek: Fix noise from speakers on Lenovo IdeaPad 3 15IAU7
Date: Tue, 27 Aug 2024 16:35:13 +0200
Message-ID: <20240827143846.530444346@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parsa Poorshikhian <parsa.poorsh@gmail.com>

[ Upstream commit ef9718b3d54e822de294351251f3a574f8a082ce ]

Fix noise from speakers connected to AUX port when no sound is playing.
The problem occurs because the `alc_shutup_pins` function includes
a 0x10ec0257 vendor ID, which causes noise on Lenovo IdeaPad 3 15IAU7 with
Realtek ALC257 codec when no sound is playing.
Removing this vendor ID from the function fixes the bug.

Fixes: 70794b9563fe ("ALSA: hda/realtek: Add more codec ID to no shutup pins list")
Signed-off-by: Parsa Poorshikhian <parsa.poorsh@gmail.com>
Link: https://patch.msgid.link/20240810150939.330693-1-parsa.poorsh@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index 82dcea2b78000..5736516275a34 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -585,7 +585,6 @@ static void alc_shutup_pins(struct hda_codec *codec)
 	switch (codec->core.vendor_id) {
 	case 0x10ec0236:
 	case 0x10ec0256:
-	case 0x10ec0257:
 	case 0x19e58326:
 	case 0x10ec0283:
 	case 0x10ec0285:
-- 
2.43.0



