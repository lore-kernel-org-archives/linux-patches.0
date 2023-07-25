Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6ABA15ACF
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:01:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68484C433C8;
	Tue, 25 Jul 2023 11:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282898;
	bh=M586/vG9QOeG42Mal7DWSYeNE7dWDgLHU0Ky3WPrwuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PahDcMXHcimt1twx7JfJPOah5H+Mii4m6+8C428M2DtUJZBiXYexNeTSoKY5/yLaX
	 M0+bRZT8oThyaJG+0csgiqM/dKD2F2UZAkHICjuxA374OvyG1lK6GsJCv93o7IkPwx
	 XR4RiC6r55Ty0UFga8XLO16RLwOT+PYJR42U4NTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Mohan Kumar D <mkumard@nvidia.com>,
	Sameer Pujar <spujar@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 038/183] ASoC: tegra: Fix ADX byte map
Date: Tue, 25 Jul 2023 12:44:26 +0200
Message-ID: <20230725104509.307153270@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sheetal <sheetal@nvidia.com>

commit 6dfe70be0b0dec0f9297811501bec26c05fd96ad upstream.

Byte mask for channel-1 of stream-1 is not getting enabled and this
causes failures during ADX use cases. This happens because the byte
map value 0 matches the byte map array and put() callback returns
without enabling the corresponding bits in the byte mask.

ADX supports 4 output streams and each stream can have a maximum of
16 channels. Each byte in the input frame is uniquely mapped to a
byte in one of these 4 outputs. This mapping is done with the help of
byte map array via user space control setting. The byte map array
size in the driver is 16 and each array element is of size 4 bytes.
This corresponds to 64 byte map values.

Each byte in the byte map array can have any value between 0 to 255
to enable the corresponding bits in the byte mask. The value 256 is
used as a way to disable the byte map. However the byte map array
element cannot store this value. The put() callback disables the byte
mask for 256 value and byte map value is reset to 0 for this case.
This causes problems during subsequent runs since put() callback,
for value of 0, just returns without enabling the byte mask. In short,
the problem is coming because 0 and 256 control values are stored as
0 in the byte map array.

Right now fix the put() callback by actually looking at the byte mask
array state to identify if any change is needed and update the fields
accordingly. The get() callback needs an update as well to return the
correct control value that user has set before. Note that when user
set 256, the value is stored as 0 and byte mask is disabled. So byte
mask state is used to either return 256 or the value from byte map
array.

Given above, this looks bit complicated and all this happens because
the byte map array is tightly packed and cannot actually store the 256
value. Right now the priority is to fix the existing failure and a TODO
item is put to improve this logic.

Fixes: 3c97881b8c8a ("ASoC: tegra: Fix kcontrol put callback in ADX")
Cc: stable@vger.kernel.org
Signed-off-by: Sheetal <sheetal@nvidia.com>
Reviewed-by: Mohan Kumar D <mkumard@nvidia.com>
Reviewed-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1688015537-31682-3-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_adx.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/sound/soc/tegra/tegra210_adx.c b/sound/soc/tegra/tegra210_adx.c
index bd0b10c70c4c..7d003f0c8d0f 100644
--- a/sound/soc/tegra/tegra210_adx.c
+++ b/sound/soc/tegra/tegra210_adx.c
@@ -2,7 +2,7 @@
 //
 // tegra210_adx.c - Tegra210 ADX driver
 //
-// Copyright (c) 2021 NVIDIA CORPORATION.  All rights reserved.
+// Copyright (c) 2021-2023 NVIDIA CORPORATION.  All rights reserved.
 
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -175,10 +175,20 @@ static int tegra210_adx_get_byte_map(struct snd_kcontrol *kcontrol,
 	mc = (struct soc_mixer_control *)kcontrol->private_value;
 	enabled = adx->byte_mask[mc->reg / 32] & (1 << (mc->reg % 32));
 
+	/*
+	 * TODO: Simplify this logic to just return from bytes_map[]
+	 *
+	 * Presently below is required since bytes_map[] is
+	 * tightly packed and cannot store the control value of 256.
+	 * Byte mask state is used to know if 256 needs to be returned.
+	 * Note that for control value of 256, the put() call stores 0
+	 * in the bytes_map[] and disables the corresponding bit in
+	 * byte_mask[].
+	 */
 	if (enabled)
 		ucontrol->value.integer.value[0] = bytes_map[mc->reg];
 	else
-		ucontrol->value.integer.value[0] = 0;
+		ucontrol->value.integer.value[0] = 256;
 
 	return 0;
 }
@@ -192,19 +202,19 @@ static int tegra210_adx_put_byte_map(struct snd_kcontrol *kcontrol,
 	int value = ucontrol->value.integer.value[0];
 	struct soc_mixer_control *mc =
 		(struct soc_mixer_control *)kcontrol->private_value;
+	unsigned int mask_val = adx->byte_mask[mc->reg / 32];
 
-	if (value == bytes_map[mc->reg])
+	if (value >= 0 && value <= 255)
+		mask_val |= (1 << (mc->reg % 32));
+	else
+		mask_val &= ~(1 << (mc->reg % 32));
+
+	if (mask_val == adx->byte_mask[mc->reg / 32])
 		return 0;
 
-	if (value >= 0 && value <= 255) {
-		/* update byte map and enable slot */
-		bytes_map[mc->reg] = value;
-		adx->byte_mask[mc->reg / 32] |= (1 << (mc->reg % 32));
-	} else {
-		/* reset byte map and disable slot */
-		bytes_map[mc->reg] = 0;
-		adx->byte_mask[mc->reg / 32] &= ~(1 << (mc->reg % 32));
-	}
+	/* Update byte map and slot */
+	bytes_map[mc->reg] = value % 256;
+	adx->byte_mask[mc->reg / 32] = mask_val;
 
 	return 1;
 }
-- 
2.41.0



