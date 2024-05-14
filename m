Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F446433BE;
	Tue, 14 May 2024 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682403; cv=none; b=QtLntCdFdMIGZ0p2fBbNp5eTeWRvwBZYy01qgihZYBhP5kpIK1rhyoWGJ8gzgDERT9CPBXhQDOA9h0tqxGrQFc29c/8HAU0poBmIDf9r1Elyd6+BdUDEcRPencAGyyGxDWHae5p/UVUc5UrDJLb8FoiaCLYJCdHDhebZdYg2tkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682403; c=relaxed/simple;
	bh=aL+dEN0w6DdKs2qo1WGC1J0CjjT5HtqEhUu2nra/O9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMVWAtBd9RTKYcvy0nTSj/G1ubKqnSNtY9MwugClSzznEy+xhOcfn/Sb7ZEX1bjYwk4UMnFcQkIj6QqMXoLQj3SLpqr22ZSWPE5PgThCN+rQgnzGQKAZ4XRXYTGsdBY4r1yIG8hEnrZwfgKiPMv6+40Y8Yk82oKtx6TIlWTP0tA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x6/pNbjP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x6/pNbjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4030C2BD10;
	Tue, 14 May 2024 10:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682403;
	bh=aL+dEN0w6DdKs2qo1WGC1J0CjjT5HtqEhUu2nra/O9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x6/pNbjPolskF45XmSTRm9O0xbMOVbJi/4esJcagh5viAn99drcKRFqMX6T68M93A
	 aJdPb+rbXD7isE7tDGoeuWptyzIF4mBFXFDX7dIo2Y3hvMH7eui/ptUb/vEaB98626
	 HwrAku+ryeqmLX5gjIUzS/A2QbUTQ9riR7Dlr8TU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 056/336] ALSA: emu10k1: fix E-MU dock initialization
Date: Tue, 14 May 2024 12:14:20 +0200
Message-ID: <20240514101040.721394071@linuxfoundation.org>
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

[ Upstream commit e8289fd3fa65d60cf04dab6f7845eda352c04ea6 ]

A side effect of making the dock monitoring interrupt-driven was that
we'd be very quick to program a freshly connected dock. However, for
unclear reasons, the dock does not work when we do that - despite the
FPGA netlist upload going just fine. We work around this by adding a
delay before programming the dock; for safety, the value is several
times as much as was determined empirically.

Note that a badly timed dock hot-plug would have triggered the problem
even before the referenced commit - but now it would happen 100% instead
of about 3% of the time, thus making it impossible to work around by
re-plugging.

Fixes: fbb64eedf5a3 ("ALSA: emu10k1: make E-MU dock monitoring interrupt-driven")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218584
Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20240428093716.3198666-6-oswald.buddenhagen@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/emu10k1/emu10k1_main.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/sound/pci/emu10k1/emu10k1_main.c b/sound/pci/emu10k1/emu10k1_main.c
index 86eaf5963502c..ade90c7ecd922 100644
--- a/sound/pci/emu10k1/emu10k1_main.c
+++ b/sound/pci/emu10k1/emu10k1_main.c
@@ -737,6 +737,12 @@ static void snd_emu1010_load_dock_firmware(struct snd_emu10k1 *emu)
 	u32 tmp, tmp2;
 	int err;
 
+	// The docking events clearly arrive prematurely - while the
+	// Dock's FPGA seems to be successfully programmed, the Dock
+	// fails to initialize subsequently if we don't give it some
+	// time to "warm up" here.
+	msleep(200);
+
 	dev_info(emu->card->dev, "emu1010: Loading Audio Dock Firmware\n");
 	/* Return to Audio Dock programming mode */
 	snd_emu1010_fpga_write(emu, EMU_HANA_FPGA_CONFIG,
-- 
2.43.0



