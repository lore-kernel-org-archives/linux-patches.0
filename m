Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591238;
	b=Clt4YOXGwz+k6OBDfODwSyU0A+dpBU9IAup993e0EHNMJ97WncPBxWnvKnoTzkbznJcD
	 Z6DA/MvKaaV4o+HjMEG1zIW8ovsJKoRnXd4VbIaySYcmEoHr/UPFNdOO/0NX4NGGxzZl7
	 YAivA8/Pqz5bX/fE3FbVJndS2OahASf8et28PJRD6ir6oVSHQT/s3dlSbfU5Zq+VGDT7d
	 RtB2IdX0U6DU225wIrvXJc78sMu+lbBOlW7PSuhcn64QGUFa/6tpFLLaxHB9V6l3vhrsf
	 HXwu4ge+sbBLg0aITPOgvDA99WdpkKEm6GNUj6JXUrzGpkQA+c9lqX5sMLcyqzB+6NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591238;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=loSz0IyTxdXPSNAwvMp1CvASFGJaKZKDF8ogaWZkea4=;
	b=bfdBcqf1hfSkSxinHdNpUZepSzFkgzEOw3wJywqdgL4obTpB+bSRPtBCX7p42LMJAmOA
	 QuuVk/tstqZqCpXnNT8l/HNXOidGZCWzgUuO8WexnhDF6yIv7ixQnN6T4APDgJaAH+rh3
	 nYn/ZCMKAm4GA28rTpmywHAOHmqw2Xc7UCg1TnEpanbL4no0/fLAQDhymcq4MK6xqLITy
	 S/cNQfBTIzoeGVKNj9W5I/j6nQSK9yYiMAB1R52TBrWfFPCHA1YFYCfFgiUcRc7IsHVdb
	 wU4xqv5P9FX1FZiBNVMgFjSImudyaLKxqkwHEzZuOofkDOBPVJxQtrUM7XsRJUd6xxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=195SOWu6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D706075E2F;
	Fri, 13 Nov 2026 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=195SOWu6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30431F000C4;
	Fri, 13 Nov 2026 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591238;
	bh=loSz0IyTxdXPSNAwvMp1CvASFGJaKZKDF8ogaWZkea4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=195SOWu6temo4wo+YTCWkhpZdJVJtzHbsidiJY/bmb6jav3xOGpj6srlHzRA/WuX0
	 gCR8GVZCp+O9dAfsZkTJw9dr5SHkh1WfyKVHI8GOD1wRkwniSWQ3xqpCV384oNrAPy
	 0jMaxwu1Okgg56zAf8BHOYnmXqkrsHBv39qC/i1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 365/670] ALSA: cs46xx: Handle SCB creation failures before dereferencing
Date: Fri, 13 Nov 2026 10:48:49 -0500
Message-ID: <20261113153824.174306954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 023d3e1176202339cd94a3d732e3aec74e36ba22 ]

With CONFIG_PM_SLEEP enabled, cs46xx_dsp_create_scb() can return NULL
if kmemdup() fails to allocate the SCB data saved for resume.
cs46xx_dsp_scb_and_task_init() and _dsp_create_generic_scb() dereference
the returned pointer without checking it, causing a NULL pointer
dereference on allocation failure.

Check both return values before accessing the SCB descriptors.
Return -ENOMEM when creating the null SCB fails and propagate NULL
from _dsp_create_generic_scb().

Found by Linux Verification Center (linuxtesting.org) with SVACE
static analysis tool.

Fixes: 41116e926cb9 ("ALSA: cs46xx - Fix suspend/resume with new DSP")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261030142529.415697-1-a.kazinsky@ideco.ru
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/cs46xx/dsp_spos.c         | 2 ++
 sound/pci/cs46xx/dsp_spos_scb_lib.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/pci/cs46xx/dsp_spos.c b/sound/pci/cs46xx/dsp_spos.c
index dd23b7d68c164..dd37c185bcf07 100644
--- a/sound/pci/cs46xx/dsp_spos.c
+++ b/sound/pci/cs46xx/dsp_spos.c
@@ -1110,6 +1110,8 @@ int cs46xx_dsp_scb_and_task_init (struct snd_cs46xx *chip)
 
 		null_scb.entry_point = null_algorithm->address;
 		ins->the_null_scb = cs46xx_dsp_create_scb(chip, "nullSCB", (u32 *)&null_scb, NULL_SCB_ADDR);
+		if (!ins->the_null_scb)
+			return -ENOMEM;
 		ins->the_null_scb->task_entry = null_algorithm;
 		ins->the_null_scb->sub_list_ptr = ins->the_null_scb;
 		ins->the_null_scb->next_scb_ptr = ins->the_null_scb;
diff --git a/sound/pci/cs46xx/dsp_spos_scb_lib.c b/sound/pci/cs46xx/dsp_spos_scb_lib.c
index 1f90ca723f4df..af5c78e3fd200 100644
--- a/sound/pci/cs46xx/dsp_spos_scb_lib.c
+++ b/sound/pci/cs46xx/dsp_spos_scb_lib.c
@@ -285,7 +285,8 @@ _dsp_create_generic_scb (struct snd_cs46xx *chip, char * name, u32 * scb_data, u
 	dev_dbg(chip->card->dev, "dsp_spos: creating SCB <%s>\n", name);
 
 	scb = cs46xx_dsp_create_scb(chip,name,scb_data,dest);
-
+	if (!scb)
+		return NULL;
 
 	scb->sub_list_ptr = ins->the_null_scb;
 	scb->next_scb_ptr = ins->the_null_scb;
-- 
2.53.0



