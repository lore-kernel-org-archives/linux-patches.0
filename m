Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F79278143;
	Tue,  8 Apr 2025 12:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116883; cv=none; b=Tf41TpRrF5RLST3MvL6vsyNoaKN3dnAtTMsnu2kBrSWpsJxP4MafjQpXI0FmdU2bQuRl0EMety9qQ6JVzRWHHFHAM1AHhLDoOXJUr/TRw7YdWl4hPjmvjVYnsUnV7ZVAKqa3NzB0BaU3VqTPD8E8ctQJgz99uSE/QZwhvJDv+ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116883; c=relaxed/simple;
	bh=KAsCzO1P0Q4s1yMQUG8AF8Iz8oqTOUBxAfTX3TOdTnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GhnBMIeV9Z8PYvy1LzxeRmGalK0bQgwHVszaJ8MmxnXW9tyhqeyeEs64AzOiVTA8aN5U+7GNBdTpREv4E4GR4DHaYCj+sVnlcRSwi2fugCb6jgMfLWeg1/eK84MecQzl9m8N1rUUGmw/6C/822hhzaYGLAQYnFjvnDJ7nQi41kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSEvUXR9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSEvUXR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41A3DC4CEE5;
	Tue,  8 Apr 2025 12:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116883;
	bh=KAsCzO1P0Q4s1yMQUG8AF8Iz8oqTOUBxAfTX3TOdTnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VSEvUXR91w5c6gejuxuD5eyxYlmmwcxD1kSckewz1Re3JSl2kk2F0jOwb4jZ30Ppo
	 /EW85/1LvaUg7kVn0muDBo4dFehqjXqsurSRVgfDgq8txSfBu+lNMx28rWRz6NDBtS
	 38gVreWRkGsxFjpojJFZ3JHkvUM2VgI0cWn56IdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20B=C3=A1rta?= <daniel.barta@trustlab.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/423] ALSA: hda: Fix speakers on ASUS EXPERTBOOK P5405CSA 1.0
Date: Tue,  8 Apr 2025 12:49:51 +0200
Message-ID: <20250408104851.922454533@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Bárta <daniel.barta@trustlab.cz>

[ Upstream commit f479ecc5ef15ed8d774968c1a8726a49420f11a0 ]

After some digging around I have found that this laptop has Cirrus's smart
aplifiers connected to SPI bus (spi1-CSC3551:00-cs35l41-hda).

To get them correctly detected and working I had to modify patch_realtek.c
with ASUS EXPERTBOOK P5405CSA 1.0 SystemID (0x1043, 0x1f63) and add
corresponding hda_quirk (ALC245_FIXUP_CS35L41_SPI_2).

Signed-off-by: Daniel Bárta <daniel.barta@trustlab.cz>
Link: https://patch.msgid.link/20250227161256.18061-2-daniel.barta@trustlab.cz
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_realtek.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/hda/patch_realtek.c b/sound/pci/hda/patch_realtek.c
index ae6b6186c7854..7dafafaf23b74 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10717,6 +10717,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1f1f, "ASUS H7604JI/JV/J3D", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1f63, "ASUS P5405CSA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
-- 
2.39.5



