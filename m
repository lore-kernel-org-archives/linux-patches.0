Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E0B1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:00:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7D96C433C8;
	Tue, 25 Jul 2023 11:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282835;
	bh=NbDyiOzobj0QDpgxz/hVnzRfoukAlOHY5YWkvSJnopU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uM7XqeyWh6dog5e/c2SeV9pozi3BrrbJBVjb3OXoVtwCBuUmlzVvb4JFGaS3nb8lG
	 cE3F1LDg1S5k85mlJVAcRtcQRilaH/B2bJrwoDvEeDGPmnJ3Qcu34MIZhehONC5gLi
	 WC1LpuL2saohb9/0hKxxrhFVOfi0HZ209b/fN4wA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sheetal <sheetal@nvidia.com>,
	Mohan Kumar D <mkumard@nvidia.com>,
	Sameer Pujar <spujar@nvidia.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 044/183] ASoC: tegra: Fix AMX byte map
Date: Tue, 25 Jul 2023 12:44:32 +0200
Message-ID: <20230725104509.542084640@linuxfoundation.org>
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

commit 49bd7b08149417a30aa7d92c8c85b3518de44a76 upstream.

Byte mask for channel-1 of stream-1 is not getting enabled and this
causes failures during AMX use cases. This happens because the byte
map value 0 matches the byte map array and put() callback returns
without enabling the corresponding bits in the byte mask.

AMX supports 4 input streams and each stream can take a maximum of
16 channels. Each byte in the output frame is uniquely mapped to a
byte in one of these 4 inputs. This mapping is done with the help of
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
sets 256, the value is stored as 0 and byte mask is disabled. So byte
mask state is used to either return 256 or the value from byte map
array.

Given above, this looks bit complicated and all this happens because
the byte map array is tightly packed and cannot actually store the 256
value. Right now the priority is to fix the existing failure and a TODO
item is put to improve this logic.

Fixes: 8db78ace1ba8 ("ASoC: tegra: Fix kcontrol put callback in AMX")
Cc: stable@vger.kernel.org
Signed-off-by: Sheetal <sheetal@nvidia.com>
Reviewed-by: Mohan Kumar D <mkumard@nvidia.com>
Reviewed-by: Sameer Pujar <spujar@nvidia.com>
Link: https://lore.kernel.org/r/1688015537-31682-2-git-send-email-spujar@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/tegra/tegra210_amx.c |   40 ++++++++++++++++++++++------------------
 1 file changed, 22 insertions(+), 18 deletions(-)

--- a/sound/soc/tegra/tegra210_amx.c
+++ b/sound/soc/tegra/tegra210_amx.c
@@ -2,7 +2,7 @@
 //
 // tegra210_amx.c - Tegra210 AMX driver
 //
-// Copyright (c) 2021 NVIDIA CORPORATION.  All rights reserved.
+// Copyright (c) 2021-2023 NVIDIA CORPORATION.  All rights reserved.
 
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -203,10 +203,20 @@ static int tegra210_amx_get_byte_map(str
 	else
 		enabled = amx->byte_mask[0] & (1 << reg);
 
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
 		ucontrol->value.integer.value[0] = bytes_map[reg];
 	else
-		ucontrol->value.integer.value[0] = 0;
+		ucontrol->value.integer.value[0] = 256;
 
 	return 0;
 }
@@ -221,25 +231,19 @@ static int tegra210_amx_put_byte_map(str
 	unsigned char *bytes_map = (unsigned char *)&amx->map;
 	int reg = mc->reg;
 	int value = ucontrol->value.integer.value[0];
+	unsigned int mask_val = amx->byte_mask[reg / 32];
 
-	if (value == bytes_map[reg])
+	if (value >= 0 && value <= 255)
+		mask_val |= (1 << (reg % 32));
+	else
+		mask_val &= ~(1 << (reg % 32));
+
+	if (mask_val == amx->byte_mask[reg / 32])
 		return 0;
 
-	if (value >= 0 && value <= 255) {
-		/* Update byte map and enable slot */
-		bytes_map[reg] = value;
-		if (reg > 31)
-			amx->byte_mask[1] |= (1 << (reg - 32));
-		else
-			amx->byte_mask[0] |= (1 << reg);
-	} else {
-		/* Reset byte map and disable slot */
-		bytes_map[reg] = 0;
-		if (reg > 31)
-			amx->byte_mask[1] &= ~(1 << (reg - 32));
-		else
-			amx->byte_mask[0] &= ~(1 << reg);
-	}
+	/* Update byte map and slot */
+	bytes_map[reg] = value % 256;
+	amx->byte_mask[reg / 32] = mask_val;
 
 	return 1;
 }


