Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9A755C0A;
	Tue, 14 May 2024 10:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682388; cv=none; b=b05Pu9uozjxxDX++9I2o6In2+kgPGzsn7edulHaA21ea62R6dVvaWV1N7SCd2kgbr672sNPPZI+EHDV0q295Iz5YcfQjSauREVVj8N8BrsG8qLyizVhOk0dgpuLa8Q9UiKQC5GX6rdVeegywBmh6dg9TD1QLyQh9wRlUePdkvVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682388; c=relaxed/simple;
	bh=ioukrc2Aj1lKDqRum8VUGQmrLGxHznS9SQVhO7SRfVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooXaz9IaDIu23SQUeB4KCHZOg8pMf7hP3C8kYi2VTyuPXGqmi4ygPXhwECCYzTGpY3h0+2V879Xa3xqytzmCEqjJOuCRumeuX3x//4Nu01x19vzoEU8MD1ozZ1dy6T3soUs2Q92Ha8PxgONQA7fwpfznsAgeoQ8KmUj+xIsr05g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qw1VPB74; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qw1VPB74"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24B90C2BD10;
	Tue, 14 May 2024 10:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682388;
	bh=ioukrc2Aj1lKDqRum8VUGQmrLGxHznS9SQVhO7SRfVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qw1VPB743h+nbZWoxEoVyF6Oz4FJ0rvq3ZKGIlMPBx1D2C7ocIg4AY7xG/9kbOENW
	 Qi+jOlT8AjhwF1+2ABEdIRAS13QVukyF6Awhv20h680i7W2ThYN1e17bzNFarQZvey
	 2p8QNSoZ7F2Niadvx77fRxUqfqeOIlbFys6+Jmco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 053/336] ALSA: emu10k1: fix E-MU card dock presence monitoring
Date: Tue, 14 May 2024 12:14:17 +0200
Message-ID: <20240514101040.607887378@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 398321d7531963b95841865eb371fe65c44c6921 ]

While there are two separate IRQ status bits for dock attach and detach,
the hardware appears to mix them up more or less randomly, making them
useless for tracking what actually happened. It is much safer to check
the dock status separately and proceed based on that, as the old polling
code did.

Note that the code assumes that only the dock can be hot-plugged - if
other option card bits changed, the logic would break.

Fixes: fbb64eedf5a3 ("ALSA: emu10k1: make E-MU dock monitoring interrupt-driven")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218584
Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20240428093716.3198666-2-oswald.buddenhagen@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/emu10k1/emu10k1_main.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index de5c41e578e1f..85f70368a27db 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -778,6 +778,11 @@ static void emu1010_firmware_work(struct work_struct *work)
 		msleep(10);
 		/* Unmute all. Default is muted after a firmware load */
 		snd_emu1010_fpga_write(emu, EMU_HANA_UNMUTE, EMU_UNMUTE);
+	} else if (!(reg & EMU_HANA_OPTION_DOCK_ONLINE)) {
+		/* Audio Dock removed */
+		dev_info(emu->card->dev, "emu1010: Audio Dock detached\n");
+		/* The hardware auto-mutes all, so we unmute again */
+		snd_emu1010_fpga_write(emu, EMU_HANA_UNMUTE, EMU_UNMUTE);
 	}
 }
 
@@ -810,14 +815,12 @@ static void emu1010_interrupt(struct snd_emu10k1 *emu)
 	u32 sts;
 
 	snd_emu1010_fpga_read(emu, EMU_HANA_IRQ_STATUS, &sts);
-	if (sts & EMU_HANA_IRQ_DOCK_LOST) {
-		/* Audio Dock removed */
-		dev_info(emu->card->dev, "emu1010: Audio Dock detached\n");
-		/* The hardware auto-mutes all, so we unmute again */
-		snd_emu1010_fpga_write(emu, EMU_HANA_UNMUTE, EMU_UNMUTE);
-	} else if (sts & EMU_HANA_IRQ_DOCK) {
+
+	// The distinction of the IRQ status bits is unreliable,
+	// so we dispatch later based on option card status.
+	if (sts & (EMU_HANA_IRQ_DOCK | EMU_HANA_IRQ_DOCK_LOST))
 		schedule_work(&emu->emu1010.firmware_work);
-	}
+
 	if (sts & EMU_HANA_IRQ_WCLK_CHANGED)
 		schedule_work(&emu->emu1010.clock_work);
 }
-- 
2.43.0



