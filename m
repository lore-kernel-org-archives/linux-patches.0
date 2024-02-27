Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE62D145B02;
	Tue, 27 Feb 2024 13:48:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041707; cv=none; b=Q+gHj0+3gGLC21VXwiCLUv6sfRqNHwg4veD/G6oOGpAymOczF1cj/T/hFu+ECosxL/kATIst2oum001phY2jcTZpqawz9f5qKZFV8nsHFv/4vDyl6ORn78oz9Jo0KIjX1vCgoHCvu/C1cFM3JASKOLQkzb4KWKeq70O0zBWM/+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041707; c=relaxed/simple;
	bh=jEgZpCrDuxzsAF/NxbwFH1mJL2GqAHWaYBlUN2tv1SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VctB6S/ruM0sh0gSVRdMK4gLhwwCYDLoETlJoSOxh2hxLhj7Nb01P99m/hkZ7+rDO9NL81sF7UTWTbnFhvMeSEdkqAA+YnfyswrZChSK2o99JeMq+KPE9ddHbWgD3NvOdWwcOBpLYhY4+eHhB2OMNK43IUsh2LvnfImnJpthSNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MhkuTSts; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MhkuTSts"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A54C43390;
	Tue, 27 Feb 2024 13:48:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041706;
	bh=jEgZpCrDuxzsAF/NxbwFH1mJL2GqAHWaYBlUN2tv1SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MhkuTStsLvRSLkPVK6f6Z6yM1O6JJv7xhwPgiWjrUzAhUoVKWFYvhc9WUD/M1c0hq
	 MVvLlWhIYlELE/FoRqnOXRUzVxx1Bwcf2lhN3iL0Hr7gxJM9HWoc1pGOB63x5P5Nm4
	 oLi/Zvd+J704Ggesgrfkez3hbzoVAUZhLFptTrc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 042/299] ALSA: hda: Increase default bdl_pos_adj for Apollo Lake
Date: Tue, 27 Feb 2024 14:22:33 +0100
Message-ID: <20240227131627.341670644@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rui Salvaterra <rsalvaterra@gmail.com>

[ Upstream commit 56beedc88405fd8022edfd1c2e63d1bc6c95efcb ]

Apollo Lake seems to also suffer from IRQ timing issues. After being up for ~4
minutes, a Pentium N4200 system ends up falling back to workqueue-based IRQ
handling:

[  208.019906] snd_hda_intel 0000:00:0e.0: IRQ timing workaround is activated
for card #0. Suggest a bigger bdl_pos_adj.

Unfortunately, the Baytrail and Braswell workaround value of 32 samples isn't
enough to fix the issue here. Default to 64 samples.

Signed-off-by: Rui Salvaterra <rsalvaterra@gmail.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20240122114512.55808-3-rsalvaterra@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 1596157556862..a6a9d353fe635 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1738,6 +1738,8 @@ static int default_bdl_pos_adj(struct azx *chip)
 		case PCI_DEVICE_ID_INTEL_HDA_BYT:
 		case PCI_DEVICE_ID_INTEL_HDA_BSW:
 			return 32;
+		case PCI_DEVICE_ID_INTEL_HDA_APL:
+			return 64;
 		}
 	}
 
-- 
2.43.0



