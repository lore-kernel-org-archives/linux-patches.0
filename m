Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A279611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFF3C433EF;
	Sun, 28 May 2023 19:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302587;
	bh=BjKW6f4O+Cc2Ff81QsN0WPo15RPP722GaehsMsBzWpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GbCJtYcob3ur+avNaYY2X1R8r5vzzRpobeOYBmWtB8A7XMwTPwjvytgiE5y6f0DV7
	 ipu6B2hLH5BjoJsq0jecoAYNnu1BJJOayDHn/VR5/luv4JwqMmFAZmRqF/fetP+ql+
	 hyuUkkY8WthLIyCPKnRB6KSEqCvfkSjdGP4O7Ao8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev
Subject: [PATCH 6.1 063/119] ASoC: lpass: Fix for KASAN use_after_free out of bounds
Date: Sun, 28 May 2023 20:11:03 +0100
Message-Id: <20230528190837.560549010@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com>

commit 75e5fab7db0cecb6e16b22c34608f0b40a4c7cd1 upstream.

When we run syzkaller we get below Out of Bounds error.

"KASAN: slab-out-of-bounds Read in regcache_flat_read"

Below is the backtrace of the issue:

BUG: KASAN: slab-out-of-bounds in regcache_flat_read+0x10c/0x110
Read of size 4 at addr ffffff8088fbf714 by task syz-executor.4/14144
CPU: 6 PID: 14144 Comm: syz-executor.4 Tainted: G        W
Hardware name: Qualcomm Technologies, Inc. sc7280 CRD platform (rev5+) (DT)
Call trace:
dump_backtrace+0x0/0x4ec
show_stack+0x34/0x50
dump_stack_lvl+0xdc/0x11c
print_address_description+0x30/0x2d8
kasan_report+0x178/0x1e4
__asan_report_load4_noabort+0x44/0x50
regcache_flat_read+0x10c/0x110
regcache_read+0xf8/0x5a0
_regmap_read+0x45c/0x86c
_regmap_update_bits+0x128/0x290
regmap_update_bits_base+0xc0/0x15c
snd_soc_component_update_bits+0xa8/0x22c
snd_soc_component_write_field+0x68/0xd4
tx_macro_put_dec_enum+0x1d0/0x268
snd_ctl_elem_write+0x288/0x474

By Error checking and checking valid values issue gets rectifies.

Signed-off-by: Ravulapati Vishnu Vardhan Rao <quic_visr@quicinc.com
Link: https://lore.kernel.org/r/20230511112532.16106-1-quic_visr@quicinc.com
Signed-off-by: Mark Brown <broonie@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-tx-macro.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -745,6 +745,8 @@ static int tx_macro_put_dec_enum(struct
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);
 
 	val = ucontrol->value.enumerated.item[0];
+	if (val >= e->items)
+		return -EINVAL;
 
 	switch (e->reg) {
 	case CDC_TX_INP_MUX_ADC_MUX0_CFG0:
@@ -771,6 +773,9 @@ static int tx_macro_put_dec_enum(struct
 	case CDC_TX_INP_MUX_ADC_MUX7_CFG0:
 		mic_sel_reg = CDC_TX7_TX_PATH_CFG0;
 		break;
+	default:
+		dev_err(component->dev, "Error in configuration!!\n");
+		return -EINVAL;
 	}
 
 	if (val != 0) {


