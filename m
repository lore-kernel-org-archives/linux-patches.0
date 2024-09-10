Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B8A18F2F9;
	Tue, 10 Sep 2024 09:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961323; cv=none; b=eFalTl+lTA4wBdOesaHZnIbtQUw7NssK7COs+rUMImkiqhvskmw++oIbdn3WIl/E8R22X/f1mY5iklve9GMEFCLOjTWAxmz+U3iH6LmsjVGGVPigNMp4MwzBNp/CFPIyqp5LxbsQ2SJ8xI1LeL2mJ2bdiP2kKY+7Pys9dck1dp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961323; c=relaxed/simple;
	bh=PLKXgzmeIAjsnpQ+Ar5kV74DkaGBaD3bjdgTXCYvaxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QU+EiPNj/0d2f7gDs7RkmkxOzp8StL6wu/jV658G/Jnx/2njh5FLETCoamqmhNAeB2SYVH9H2S9RzLwR2q32Hk7RURdxJ36DGc2oYrq1d0VhTO3bhZT8KfB75BrFsBm6BktMRQSeZIjpPQZEFl0Wd2Ffz3qLiyaFhf8FDmVJ2Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XvgSvyfC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XvgSvyfC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52168C4CECC;
	Tue, 10 Sep 2024 09:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961323;
	bh=PLKXgzmeIAjsnpQ+Ar5kV74DkaGBaD3bjdgTXCYvaxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvgSvyfCIN9ViYGhF0Fx47N4qmdRju6CFaqF7n5wcDkwd5yZusOIztssfyhK1VFic
	 xDZ2mag6EXH+8EL8M9iTBYcV6dVUOBdnGxcmZn1sBq6qcm+JUzw4XKG6vaDLRHY+Yg
	 B2PYLxgnZks4bG6kM/FeNOy2rr1YVth5E6YHcZp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasiliy Kovalev <kovalev@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.10 014/375] ALSA: hda/realtek - Fix inactive headset mic jack for ASUS Vivobook 15 X1504VAP
Date: Tue, 10 Sep 2024 11:26:51 +0200
Message-ID: <20240910092622.741698404@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasiliy Kovalev <kovalev@altlinux.org>

commit a83e4c97ddd7473406ec5e1df8d5e7b24bd7e892 upstream.

When the headset is connected, there is no automatic switching of the
capture source - you can only manually select the headset microphone
in pavucontrol.

This patch fixes/activates the inactive microphone of the headset.

Signed-off-by: Vasiliy Kovalev <kovalev@altlinux.org>
Cc: <stable@vger.kernel.org>
Link: https://patch.msgid.link/20240905140211.937385-1-kovalev@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_realtek.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/pci/hda/patch_realtek.c
+++ b/sound/pci/hda/patch_realtek.c
@@ -10356,6 +10356,7 @@ static const struct snd_pci_quirk alc269
 	SND_PCI_QUIRK(0x1043, 0x1e02, "ASUS UX3402ZA", ALC245_FIXUP_CS35L41_SPI_2),
 	SND_PCI_QUIRK(0x1043, 0x1e11, "ASUS Zephyrus G15", ALC289_FIXUP_ASUS_GA502),
 	SND_PCI_QUIRK(0x1043, 0x1e12, "ASUS UM3402", ALC287_FIXUP_CS35L41_I2C_2),
+	SND_PCI_QUIRK(0x1043, 0x1e1f, "ASUS Vivobook 15 X1504VAP", ALC2XX_FIXUP_HEADSET_MIC),
 	SND_PCI_QUIRK(0x1043, 0x1e51, "ASUS Zephyrus M15", ALC294_FIXUP_ASUS_GU502_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e5e, "ASUS ROG Strix G513", ALC294_FIXUP_ASUS_G513_PINS),
 	SND_PCI_QUIRK(0x1043, 0x1e63, "ASUS H7606W", ALC285_FIXUP_CS35L56_I2C_2),


