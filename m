Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B94811710
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 15:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DBFC433C8;
	Mon, 11 Sep 2023 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694446081;
	bh=+z5PYyhH9oTjyJNITYybeFkHTAEagxFpW6638dp4q/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oJqip+U38Qs5+4f1Nf6px6j6KlWr/iBgLRibL6kWL42uECZVhWOktQCm2cYidrw6N
	 FaOABDroQHEuTpqnh0jViJnApnVP+FS+RulsBe5rzV0s4sTaSGwNU6v5739KU2ueQA
	 mdDT9s+MjDMKl/itF5U0Nwdv+AtTC8E5UewTitKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vitaly Rodionov <vitalyr@opensource.cirrus.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 546/600] ALSA: hda/cirrus: Fix broken audio on hardware with two CS42L42 codecs.
Date: Mon, 11 Sep 2023 15:49:39 +0200
Message-ID: <20230911134649.737871765@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134633.619970489@linuxfoundation.org>
References: <20230911134633.619970489@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vitaly Rodionov <vitalyr@opensource.cirrus.com>

commit 99bf5b0baac941176a6a3d5cef7705b29808de34 upstream.

Recently in v6.3-rc1 there was a change affecting behaviour of hrtimers
(commit 0c52310f260014d95c1310364379772cb74cf82d) and causing
few issues on platforms with two CS42L42 codecs. Canonical/Dell
has reported an issue with Vostro-3910.
We need to increase this value by 15ms.

Link: https://bugs.launchpad.net/somerville/+bug/2031060
Fixes: 9fb9fa18fb50 ("ALSA: hda/cirrus: Add extra 10 ms delay to allow PLL settle and lock.")
Signed-off-by: Vitaly Rodionov <vitalyr@opensource.cirrus.com>
Link: https://lore.kernel.org/r/20230904160033.908135-1-vitalyr@opensource.cirrus.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/pci/hda/patch_cs8409.c |    2 +-
 sound/pci/hda/patch_cs8409.h |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/patch_cs8409.c
+++ b/sound/pci/hda/patch_cs8409.c
@@ -888,7 +888,7 @@ static void cs42l42_resume(struct sub_co
 
 	/* Initialize CS42L42 companion codec */
 	cs8409_i2c_bulk_write(cs42l42, cs42l42->init_seq, cs42l42->init_seq_num);
-	usleep_range(30000, 35000);
+	msleep(CS42L42_INIT_TIMEOUT_MS);
 
 	/* Clear interrupts, by reading interrupt status registers */
 	cs8409_i2c_bulk_read(cs42l42, irq_regs, ARRAY_SIZE(irq_regs));
--- a/sound/pci/hda/patch_cs8409.h
+++ b/sound/pci/hda/patch_cs8409.h
@@ -229,6 +229,7 @@ enum cs8409_coefficient_index_registers
 #define CS42L42_I2C_SLEEP_US			(2000)
 #define CS42L42_PDN_TIMEOUT_US			(250000)
 #define CS42L42_PDN_SLEEP_US			(2000)
+#define CS42L42_INIT_TIMEOUT_MS			(45)
 #define CS42L42_FULL_SCALE_VOL_MASK		(2)
 #define CS42L42_FULL_SCALE_VOL_0DB		(1)
 #define CS42L42_FULL_SCALE_VOL_MINUS6DB		(0)


