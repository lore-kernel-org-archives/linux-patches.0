Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F2E230BDB;
	Fri,  9 Oct 2026 14:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555916; cv=none; b=jVcI4scmWprS6oDsMr9HPaMdDnhqxQH84GLJuos8i2gtisUukEYGK49cYulrJ9H+xaB65lIi1j0L4QR5pwuc9nodR8rN6bV1RRgT7V+4pq4mmgSOzqtPI2qGNYQbS/joPOWTlDMM0JflYTGXoFSeW2LOuFDuuXMPjMDvWNwxYDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555916; c=relaxed/simple;
	bh=UfoqoU1zGno1Ws+LNrAtXH0T1V4A9dZODHyqIlVMIjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ExQXK5yHjVYL1j2+axn7+L1v4W61kcFxt1Zr0LxvQy00LqJ9Xew+Kh5VyIgEHghsNCIQjSKQDP4Zg2EJlXxphuRmf1RndIpmawaqYU/Oam2qD+hGpeHNZKrx4+xRQ/LQeVGNHqLm5o1IBnORq8iTA670OxAJ7ICVm7xJRwAPLgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nbDifd8h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nbDifd8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D71271F00899;
	Fri,  9 Oct 2026 14:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555914;
	bh=dqmII2TRcx+hOvesyiUExLTh9NwUBCl+XYk9x8wZthE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nbDifd8hJbk+k47x72CjR+GuLY9S4EuriBssB3KrD1ZMPvILAOPgY0uTLIs/EHdzV
	 mwvVP+uhwfrsnCYByxUeTPcTP0TvythrxYLp8+RTV5PurCY3Bis1Fztcd5wULHcI/M
	 ttKhA6WSJOtfi+X7dFFvtegmDC0dUXh4qxV59FOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dany Patoine <dany_patoine@hotmail.com>,
	Harin Lee <me@harin.net>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 063/428] ALSA: ctxfi: Fix silent playback on Titanium HD (SB1270)
Date: Fri,  9 Oct 2026 16:06:40 +0200
Message-ID: <20261009140947.526405099@linuxfoundation.org>
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

From: Harin Lee <me@harin.net>

commit 4fa0c91c2c4c604e6080690a698d4c6405ba96ca upstream.

Commit 4b490e0d103c ("ALSA: ctxfi: Add ADC helper functions for GPIO")
moved the GPIO_DATA read into hw_adc_stop(), but the Titanium HD
(SB1270) setup in hw_adc_init() uses the local data variable holding
the GPIO_CTRL value.

Writing this value to GPIO_DATA sets the output mute bits. Playback
runs without errors, but the outputs stay muted.

Re-read GPIO_DATA before setting the speed mode bits. Also, add the
delay after writing the mode bits, as in the original sequence.

On affected kernels, switching the output selection was reported to
restore clean playback.

Fixes: 4b490e0d103c ("ALSA: ctxfi: Add ADC helper functions for GPIO")
Cc: stable@vger.kernel.org
Reported-by: Dany Patoine <dany_patoine@hotmail.com>
Closes: https://lore.kernel.org/linux-sound/DM6PR02MB5433A42E81FEFAC400DD1905EA8B2@DM6PR02MB5433.namprd02.prod.outlook.com/
Signed-off-by: Harin Lee <me@harin.net>
Link: https://patch.msgid.link/20260930115824.739412-1-me@harin.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/ctxfi/cthw20k2.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/pci/ctxfi/cthw20k2.c
+++ b/sound/pci/ctxfi/cthw20k2.c
@@ -1895,6 +1895,7 @@ static int hw_adc_init(struct hw *hw, co
 
 	if (hw->model == CTSB1270) {
 		/* Set up the PCM4220 ADC on Titanium HD */
+		data = hw_read_20kx(hw, GPIO_DATA);
 		data &= ~0x0C;
 		if (1 == info->msr)
 			data |= 0x00; /* Single Speed Mode 32-50kHz */
@@ -1903,6 +1904,7 @@ static int hw_adc_init(struct hw *hw, co
 		else
 			data |= 0x04; /* Quad Speed Mode 108kHz-216kHz */
 		hw_write_20kx(hw, GPIO_DATA, data);
+		usleep_range(10000, 11000);
 	}
 
 	hw_adc_start(hw);


