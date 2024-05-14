Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CE866B5E;
	Tue, 14 May 2024 11:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684854; cv=none; b=OEk5ManXdQLNsKe7LMhSyIYAlKSaxsziHuKDzbFGDAWNael1OPpRlBu5mGAVlRxaQg+T23K6+xi8m3QO9V+wLouMLe258LRBYMRjH8pccubQCszBhbyq6SvOw4KzUBsyeTAV3pHNVEWBYuGkCmSmd9l/NXDH1aPVNmHdgrhAarQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684854; c=relaxed/simple;
	bh=PxxySRbN8zLQXOQ23cIR9oXQWS56Lbm8rxK+rqwjY+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIK4CINbsXAH4gRRmvEWgSBdhwAp/CKbbBWp4Vs8SLdLO+sCwnLdUULBb1MEvxZ0XJxJbJ+Wsvdl8dc75AYtTrx/bjo9kU9AgMT0gpvjeiKkPPlbYj1C18npGX+pfBHYJBlEbeOIsL415TN0WNxy2k39HMeH5QWR9ame8sHWU+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GspGBcnu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GspGBcnu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12238C32782;
	Tue, 14 May 2024 11:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684853;
	bh=PxxySRbN8zLQXOQ23cIR9oXQWS56Lbm8rxK+rqwjY+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GspGBcnu7IpgXbStV3VgZnnz+eIuXo7/9/Dk0stAuSte3deGo5SJAX0Jj8aCbd67Z
	 hq4sSS7K6ZasY9UFX5FQUEEnzJxzDE0hopup5LDYMJTVlcWZ3m8YIpnlzWXNXYlf62
	 iw1Z6uYox0BzjPyNZ6OG+5Yaq3XR/zw80Qv6iUQg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/301] ALSA: emu10k1: fix E-MU dock initialization
Date: Tue, 14 May 2024 12:15:29 +0200
Message-ID: <20240514101034.434275284@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101032.219857983@linuxfoundation.org>
References: <20240514101032.219857983@linuxfoundation.org>
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



