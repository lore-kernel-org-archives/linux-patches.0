Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFEE230BC6;
	Wed,  5 Mar 2025 18:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198484; cv=none; b=TR4r91SSPq6ZGEGrV2WW4zKyFTtK9xNoN9wHBqQYGM4mDc5qBH/SHCn1dLZGpa29DW0U1QdnVZFrs3lSv9EDyB5Z4lmIvuMI7gQ926erJyDJMXEOEMMuvS1VG782cqZn7cuHh0sRJDXj8qkWo0hJtYjJ+lA3qerYsdqpUxD/FCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198484; c=relaxed/simple;
	bh=NoUPoY8xU31N4mu2vMh6ME70umzEdPMtY+hw4hy3Nqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSgE7RuPF93ugOQe4Cj7R9oh9kQvdmj+aiAGRVZUa68Wgw7FpLgMdl6tdpdpNQTNgm3xeNvP8Ma5whLSzyVptOIiQq/nA7eK5NdRV2msgAdi4US+mTK7zGBYDuuLbidk4y6R+NDIJC8B3UiMNdF6GlEnZYB8G8LH0oYBYQ3RKWQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+2h6POt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+2h6POt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A964C4CED1;
	Wed,  5 Mar 2025 18:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198483;
	bh=NoUPoY8xU31N4mu2vMh6ME70umzEdPMtY+hw4hy3Nqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+2h6POt2YDv6CywasxPGab9S/kf8NlQS6/SIp0Rxw9gXfq4Vl9XjBzssg/fapZdb
	 bxENvrOkuRR8eIWQXQsWfCEjGVYyZ0MyfxRKbUJcnIjqgtG3M6G+r0iKncyjZHhCCC
	 g1kW+5JqC8tcgYrBblxth7jVx0IR5RzYhXwe/Nxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 043/157] ALSA: hda/realtek: Fix wrong mic setup for ASUS VivoBook 15
Date: Wed,  5 Mar 2025 18:47:59 +0100
Message-ID: <20250305174507.032991764@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 9e7c6779e3530bbdd465214afcd13f19c33e51a2 ]

ASUS VivoBook 15 with SSID 1043:1460 took an incorrect quirk via the
pin pattern matching for ASUS (ALC256_FIXUP_ASUS_MIC), resulting in
the two built-in mic pins (0x13 and 0x1b).  This had worked without
problems casually in the past because the right pin (0x1b) was picked
up as the primary device.  But since we fixed the pin enumeration for
other bugs, the bogus one (0x13) is picked up as the primary device,
hence the bug surfaced now.

For addressing the regression, this patch explicitly specifies the
quirk entry with ALC256_FIXUP_ASUS_MIC_NO_PRESENCE, which sets up only
the headset mic pin.

Fixes: 3b4309546b48 ("ALSA: hda: Fix headset detection failure due to unstable sort")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219807
Link: https://patch.msgid.link/20250225154540.13543-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ffe3de617d5dd..5441425292195 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10595,6 +10595,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x13b0, "ASUS Z550SA", ALC256_FIXUP_ASUS_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1427, "Asus Zenbook UX31E", ALC269VB_FIXUP_ASUS_ZENBOOK),
 	SND_PCI_QUIRK(0x1043, 0x1433, "ASUS GX650PY/PZ/PV/PU/PYV/PZV/PIV/PVV", ALC285_FIXUP_ASUS_I2C_HEADSET_MIC),
+	SND_PCI_QUIRK(0x1043, 0x1460, "Asus VivoBook 15", ALC256_FIXUP_ASUS_MIC_NO_PRESENCE),
 	SND_PCI_QUIRK(0x1043, 0x1463, "Asus GA402X/GA402N", ALC285_FIXUP_ASUS_I2C_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1473, "ASUS GU604VI/VC/VE/VG/VJ/VQ/VU/VV/VY/VZ", ALC285_FIXUP_ASUS_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1483, "ASUS GU603VQ/VU/VV/VJ/VI", ALC285_FIXUP_ASUS_HEADSET_MIC),
-- 
2.39.5



