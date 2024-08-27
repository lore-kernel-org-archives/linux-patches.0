Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D048D19F485;
	Tue, 27 Aug 2024 14:54:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770474; cv=none; b=Xbd53AVhzHPxr17PH3ZjzbJ/Yidf+O2tbh0y4xNd7U9SaykdJsed879FtQioNMLBnJf8CfZqag+bRI/DIPwwJk2B/IDgFUIenlFzBdT1oSV84TbVVe1kJ97hzmPbs4G4eK6DENuL9X7B8p9oCsh1pKUSIbUXQ7sRB9OSvadDhxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770474; c=relaxed/simple;
	bh=Rj/i1w5rYgN23w9s7ficaAzG/ykTcfcGFxDCWb6MRD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlqMG2RNXfGuhUjYPImsbgFm9vyVCgppEv6ckb/yXZQC6d881ngO1xNc/K70DZPWdwUW2GeTFw0Fk2K5k5dBgicO+uLQ3B3sR4tKQZHFUXm4HCONSanZPXywzSkMqgXsI5VrrQAraRm78OlPlTs/GXXx2IDA3oXfi8j+Vnk/oGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KvX4Pl9U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KvX4Pl9U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06805C4E675;
	Tue, 27 Aug 2024 14:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770474;
	bh=Rj/i1w5rYgN23w9s7ficaAzG/ykTcfcGFxDCWb6MRD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KvX4Pl9ULBo+dZJCMHeUn8Xq4cxKUd4cSKS0Qo8hzQCMw8gvTdo4dn8BF9i6863A/
	 mvzAzat+Txs8YjOLnoIsN3TCJ5h5GXzb3x9uF09yefkaakmgvK2KapKDI2gsZavXb8
	 Z9Kf11bR1LuTvpOKB8wkSk3FZsCma6a2j9MWqDWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 239/341] ALSA: hda/tas2781: Use correct endian conversion
Date: Tue, 27 Aug 2024 16:37:50 +0200
Message-ID: <20240827143852.504015146@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 829e2a23121fb36ee30ea5145c2a85199f68e2c8 ]

The data conversion is done rather by a wrong function.  We convert to
BE32, not from BE32.  Although the end result must be same, this was
complained by the compiler.

Fix the code again and align with another similar function
tas2563_apply_calib() that does already right.

Fixes: 3beddef84d90 ("ALSA: hda/tas2781: fix wrong calibrated data order")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202408141630.DiDUB8Z4-lkp@intel.com/
Link: https://patch.msgid.link/20240814100500.1944-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/tas2781_hda_i2c.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/hda/tas2781_hda_i2c.c b/sound/pci/hda/tas2781_hda_i2c.c
index 74d603524fbdb..e5bb1fed26a0c 100644
--- a/sound/pci/hda/tas2781_hda_i2c.c
+++ b/sound/pci/hda/tas2781_hda_i2c.c
@@ -433,8 +433,8 @@ static void tas2781_apply_calib(struct tasdevice_priv *tas_priv)
 
 	for (i = 0; i < tas_priv->ndev; i++) {
 		for (j = 0; j < CALIB_MAX; j++) {
-			data = get_unaligned_be32(
-				&tas_priv->cali_data.data[offset]);
+			data = cpu_to_be32(
+				*(uint32_t *)&tas_priv->cali_data.data[offset]);
 			rc = tasdevice_dev_bulk_write(tas_priv, i,
 				TASDEVICE_REG(0, page_array[j], rgno_array[j]),
 				(unsigned char *)&data, 4);
-- 
2.43.0



