Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D55913B7A0;
	Tue, 27 Feb 2024 13:30:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040603; cv=none; b=kjCESDOZK4LiTDJRfmovN1ukYgsV44NXcei7ijW64SKfM8iSFLJHUX2+/NfXn6iEY8q7bBou6Jk9Vi60rARtAdD2P5kUP4XdVgh1/T77myrknxknnFKs7VgwSEWt1K4RqUBZLjCN4bIPrNIRWWp5ZZqnA0ZTTomeUibJQ+lZK9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040603; c=relaxed/simple;
	bh=cTAsr1bFUR0TVMuTlYdAXVBDe14LpYA5CxkQLozonxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HlyEx+fyc4+ZVAqaNItFvmw/komBbQ32TJDZQ9EM6i0xeLGvaW/j64ZP3nz3DW6u9jylK5dHjgLEKXGHryk8SVkmY6eE8Wair7a5nQqbFkwtYuy0dYvLndEcrE9Y6Jzu7hs650U12yCcy+qQ/wm9J37/2m1zYimeNYO1S7MD6UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8CNGgLo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8CNGgLo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2906C433F1;
	Tue, 27 Feb 2024 13:30:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040603;
	bh=cTAsr1bFUR0TVMuTlYdAXVBDe14LpYA5CxkQLozonxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8CNGgLoU/kHDqmi+miby+1Pxw3LJH7b9MWPxHjuS8D0UhAIaUjxdt4H4u0RMAaSY
	 HfgIlj/7PkfyclP6XhxZNWJvrmKwJrWRbKRtRy3pu+Jq7i9iNyZZbj9qxcxq8rP8/a
	 ffov3XKBXY2bYPcOAhYXDowMY2AIqNLWe3fdjzsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rui Salvaterra <rsalvaterra@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 043/334] ALSA: hda: Increase default bdl_pos_adj for Apollo Lake
Date: Tue, 27 Feb 2024 14:18:21 +0100
Message-ID: <20240227131631.976955199@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 66f013ee160d2..1b550c42db092 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -1732,6 +1732,8 @@ static int default_bdl_pos_adj(struct azx *chip)
 		case PCI_DEVICE_ID_INTEL_HDA_BYT:
 		case PCI_DEVICE_ID_INTEL_HDA_BSW:
 			return 32;
+		case PCI_DEVICE_ID_INTEL_HDA_APL:
+			return 64;
 		}
 	}
 
-- 
2.43.0



