Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8989120CCD8;
	Tue,  8 Apr 2025 11:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113470; cv=none; b=Ko6I9xe6npQmJyfZHFdwiys1GzEKs/tf5IWyxwrADDQ5AQ5f/QQHNZirLvtp6Uug3EXzUJeoXiN3zZy1qINEFUSNkBHrwiZjXWrutwZ7yr6SKwS/VEfCWKJLF0lGukwvDdvAT+JsNrObHhMS/EfnSzUqnRbC9ab5Fb862Df0YhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113470; c=relaxed/simple;
	bh=kClUr0v1W+zuWl9IPlYeCpcN1YSUXdZYCWpJdVoM3do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WHPh1+Lb3MqEeqDNHM/3sTxU/6u3PfasRIKMqplEyGp4oghWT1Z4N330Ofy1EFf7OYJSjPX58tDZu7zrsvp91faHyNQpFi9UHINgx7Qdf8MV3vUXc21PXq/CFb/WbR/aE4t9gOTMeR5nSezD6jxCkoFYOXX0PNLJN6yJywANA/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLA0BKOQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLA0BKOQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 188FFC4CEEA;
	Tue,  8 Apr 2025 11:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113470;
	bh=kClUr0v1W+zuWl9IPlYeCpcN1YSUXdZYCWpJdVoM3do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLA0BKOQ99cXgztJ1No/Q3k8WMFNDs5kNuTsk8AADf8fjjmqwYNKfA7qHd+klwuvG
	 ZNAiXjtBYErxznrAnGf+95CqCeDK2czu6IIwWHOIfb2JvHsKsyfxyXnrcscp5X4Bwn
	 2ZJJyDegpAa1fZqum0ueNYY45Tq4ZHrZaKeeKwhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Daniel=20B=C3=A1rta?= <daniel.barta@trustlab.cz>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 171/268] ALSA: hda: Fix speakers on ASUS EXPERTBOOK P5405CSA 1.0
Date: Tue,  8 Apr 2025 12:49:42 +0200
Message-ID: <20250408104833.158425856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7a40f66f8fd88..77fa07f0a8455 100644
--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10235,6 +10235,7 @@ static const struct hda_quirk alc269_fixup_tbl[] = {
 	SND_PCI_QUIRK(0x1043, 0x1f11, "ASUS Zephyrus G14", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1f12, "ASUS UM5302", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x1f62, "ASUS UX7602ZM", ALC245_FIXUP_CS35L41_SPI_2),
+	SND_PCI_QUIRK(0x1043, 0x1f63, "ASUS P5405CSA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1f92, "ASUS ROG Flow X16", ALC289_FIXUP_ASUS_GA401),
 	SND_PCI_QUIRK(0x1043, 0x1fb3, "ASUS ROG Flow Z13 GZ302EA", ALC287_FIXUP_CS35L41_I2C_2),
 	SND_PCI_QUIRK(0x1043, 0x3030, "ASUS ZN270IE", ALC256_FIXUP_ASUS_AIO_GPIO2),
-- 
2.39.5



