Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB4D319EEDB;
	Thu,  6 Jun 2024 14:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683128; cv=none; b=sQNGkhYCTtVE7Kr7qqB6L0aHOAaQqwaRcOG2MsBHAMOxLbGbzsbLIF8t4kRVmdOBmt6wzVcI6ktqsvcg00IenSNYbjzDRw9agGMwDi/Cvi7E0whRIShi79hiypmYBoVHxu9M7c9EUrDn/PolL5priJkQK/i2rig+d4WcwbUo4wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683128; c=relaxed/simple;
	bh=8SGQUxbGgNQndRI1hXDd8ivMnS7EzPsSfRwBAFG3ZSQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kQPa853gVRAAwLDG2KRZnvyYYEpAaif1yrc7qiAUZm6E2iKpuesajYmsF4w5Mwb8YN82ocNXnzsAcFhSJiyKDqP0gpzRUxs3GG1VogO+n5vn7zTmlAYCxzFqMgNbepz34SaOTKH2OoAtkr+kNd8xqx9kwbP8nmpQAJtgckKq3W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xev1T3EW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xev1T3EW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C749FC32782;
	Thu,  6 Jun 2024 14:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683127;
	bh=8SGQUxbGgNQndRI1hXDd8ivMnS7EzPsSfRwBAFG3ZSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xev1T3EWltjj+Tzl1QLbN9u0zveCRlEFmbqCN9H1kd8BCd1FgxTWKppuzhEZ+n+zC
	 LGl9AvkJOAL/BXaZPO8caTpJfUxBUnRoNA0joUHiKcioMKaOH8YJ+CiDaf0f6SX79i
	 ytpiQWTLayLt8dJMkRDWH834eTKijIFg4ZVG0/Xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 071/744] ALSA: emu10k1: make E-MU FPGA writes potentially more reliable
Date: Thu,  6 Jun 2024 15:55:43 +0200
Message-ID: <20240606131734.687316281@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

[ Upstream commit 15c7e87aa88f0ab2d51c2e2123b127a6d693ca21 ]

We did not delay after the second strobe signal, so another immediately
following access could potentially corrupt the written value.

This is a purely speculative fix with no supporting evidence, but after
taking out the spinlocks around the writes, it seems plausible that a
modern processor could be actually too fast. Also, it's just cleaner to
be consistent.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Message-ID: <20240428093716.3198666-7-oswald.buddenhagen@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/emu10k1/io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/pci/emu10k1/io.c b/sound/pci/emu10k1/io.c
index 74df2330015f6..5cb8acf5b158c 100644
--- a/sound/pci/emu10k1/io.c
+++ b/sound/pci/emu10k1/io.c
@@ -285,6 +285,7 @@ static void snd_emu1010_fpga_write_locked(struct snd_emu10k1 *emu, u32 reg, u32
 	outw(value, emu->port + A_GPIO);
 	udelay(10);
 	outw(value | 0x80 , emu->port + A_GPIO);  /* High bit clocks the value into the fpga. */
+	udelay(10);
 }
 
 void snd_emu1010_fpga_write(struct snd_emu10k1 *emu, u32 reg, u32 value)
-- 
2.43.0



