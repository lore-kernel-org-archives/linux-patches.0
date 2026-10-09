Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13CA1A682B;
	Fri,  9 Oct 2026 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556068; cv=none; b=bUOBG1lEtazsKgsi/ETztRXcKbycokBOmDsUpfouySXI6Bv4zXlqaIz+gRuYzGwlv4gzqBHIVSet7T/l+m4rfJIzmc/P73v77Bk1uTnFvlGA3oLHxJE6OKhJgPZ1DJMw9uIJdsNvMPK/7wCJ8MbPkbm2F3wSUomjI++7fIC2J/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556068; c=relaxed/simple;
	bh=oR7VjYdCPWTlQ6/NnuUV/IC3Q1W8ZOkykPSm69ZHna4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W1Eb5g/+fSizu9yqBou6z/ByNZYLaFXReDbkRZgYo3HiuXIAM/DL7N13fA82TYbVpzY2w7GVBxJ2OwZ1zDAiSqfUAEfljz/sOCjSMXgswEvbpeqxWRb/OCAHElWVm9AA73wyRUcp8NK1Lez2NaAeG5dozA3+k2Ox/LNPFkv0q5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbW6Z+PJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbW6Z+PJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00B131F000FF;
	Fri,  9 Oct 2026 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556067;
	bh=xyitts8EnYMkV9SxV6rd0TOdWyMGEl8p8XcWN9tod4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NbW6Z+PJXyUYrPXEn31mqIk5p4gsThgxw3vM2C8zH0oSdrU7oltapSAszCk0uVic3
	 FZLSYANDzmYs1RwgQCiyh4HGuV5i284AVzkfx3oPB6VkMXI+pjNK3KUBJp2JXXLpOW
	 UGD2sKltx6fiYg1e/3ZrjIcyiTNvOOcOYKT6bmEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kailang Yang <kailang@realtek.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 115/428] ALSA: hda/realtek - Add headset mode for Dell Pro QC1255
Date: Fri,  9 Oct 2026 16:07:32 +0200
Message-ID: <20261009140948.725022977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kailang Yang <kailang@realtek.com>

[ Upstream commit 608c0c8947f03069b651ace54538a115f5b23123 ]

It lost its headset microphone functionality, and this patch will restore it.

Fixes: 97272a5704bf ("ALSA: hda/realtek - Fixed Headphone noise issue for Dell QCM1255")
Signed-off-by: Kailang Yang <kailang@realtek.com>
Link: https://lore.kernel.org/3c251e40a2944ae4ae479e4c2e4e63a4@realtek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/realtek/alc269.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/hda/codecs/realtek/alc269.c b/sound/hda/codecs/realtek/alc269.c
index 1e0612c39c89b..c003cb7d54037 100644
--- a/sound/hda/codecs/realtek/alc269.c
+++ b/sound/hda/codecs/realtek/alc269.c
@@ -6891,6 +6891,8 @@ static const struct hda_fixup alc269_fixups[] = {
 	[ALC236_FIXUP_DELL_HP_POP_NOISE] = {
 		.type = HDA_FIXUP_FUNC,
 		.v.func = alc285_fixup_invalidate_dacs,
+		.chained = true,
+		.chain_id = ALC255_FIXUP_DELL1_MIC_NO_PRESENCE
 	},
 	[ALC274_FIXUP_HP_89E9_GPIO] = {
 		.type = HDA_FIXUP_FUNC,
-- 
2.53.0



