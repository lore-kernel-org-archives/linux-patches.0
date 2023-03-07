Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5A28BA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F750C433EF;
	Tue,  7 Mar 2023 18:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213019;
	bh=QfYdUlt/Ld29B1iV2/oLizqH7hxUCn+kXz4e7A6sfX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=la466KRTHDUzbYT9xEL5xQnd9mexpzTyVLraw/fxhWUZLC3SpL96VRfsmEteEaDJP
	 vwzBrUaGN4xXEKNKSQhpMHD4hoQVWbZPHwqJ9z99PxMiDuJg8bH1B6+KCzP/DPjVrx
	 RECVsmxg+qJMHGuyOaLz0MwekdOF3oVL61ze+/Qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 371/885] ALSA: hda/hdmi: Register with vga_switcheroo on Dual GPU Macbooks
Date: Tue,  7 Mar 2023 17:55:05 +0100
Message-Id: <20230307170018.432726480@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Orlando Chamberlain <orlandoch.dev@gmail.com>

[ Upstream commit 5beb5627a2481aade9aa630b7ebb7f99442321b6 ]

Commit 586bc4aab878 ("ALSA: hda/hdmi - fix vgaswitcheroo detection for
AMD") caused only AMD gpu's with PX to have their audio component register
with vga_switcheroo. This meant that Apple Macbooks with apple-gmux as the
gpu switcher no longer had the audio client registering, so when the gpu is
powered off by vga_switcheroo snd_hda_intel is unaware that it should have
suspended the device:

amdgpu: switched off
snd_hda_intel 0000:03:00.1:
    Unable to change power state from D3hot to D0, device inaccessible
snd_hda_intel 0000:03:00.1: CORB reset timeout#2, CORBRP = 65535

To resolve this, we use apple_gmux_detect() and register a
vga_switcheroo audio client when apple-gmux is detected.

Fixes: 586bc4aab878 ("ALSA: hda/hdmi - fix vgaswitcheroo detection for AMD")
Link: https://lore.kernel.org/all/20230210044826.9834-9-orlandoch.dev@gmail.com/
Signed-off-by: Orlando Chamberlain <orlandoch.dev@gmail.com>
Link: https://lore.kernel.org/r/20230216103450.12925-1-orlandoch.dev@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/hda_intel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/pci/hda/hda_intel.c b/sound/pci/hda/hda_intel.c
index 2dbc082076f69..81c4a45254ff2 100644
--- a/sound/pci/hda/hda_intel.c
+++ b/sound/pci/hda/hda_intel.c
@@ -50,6 +50,7 @@
 #include <sound/intel-dsp-config.h>
 #include <linux/vgaarb.h>
 #include <linux/vga_switcheroo.h>
+#include <linux/apple-gmux.h>
 #include <linux/firmware.h>
 #include <sound/hda_codec.h>
 #include "hda_controller.h"
@@ -1466,7 +1467,7 @@ static struct pci_dev *get_bound_vga(struct pci_dev *pci)
 				 * vgaswitcheroo.
 				 */
 				if (((p->class >> 16) == PCI_BASE_CLASS_DISPLAY) &&
-				    atpx_present())
+				    (atpx_present() || apple_gmux_detect(NULL, NULL)))
 					return p;
 				pci_dev_put(p);
 			}
-- 
2.39.2



