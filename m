Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D37D142903;
	Mon, 16 Sep 2024 12:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488458; cv=none; b=O3WgsAPyB26vD+d+OChWhfFusujM9EUJLiIamzvi4e/BNABz5yuEfengiEh9Z365jPzfRreHX31YjfnnnAZ8jydSSo7EyMMEJAJWSvnCfJqc8lyARN98sCms4dMSyi1aFhsFBl46+1fC5D28k5wM+7z5A9ArCwJ6UzjS2NFoMzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488458; c=relaxed/simple;
	bh=5G6am7NxkBkcFCP4/aOUDWjXDHNOX6cUvrrBNQ9racQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cMKIOIs8wSPaV9nSbNVwGBjEFyv4IRUzbz5+e50By1PCL0I5RtmJGkf+oWbykiIaWC8beJizjEdkBJ8qI0jquGllybu4apDD9vzY0njh4d6MUqeILyrK2gHv+sGY/hvVAXrHkDGDs9WjodFGEFRDRhRdBusjUSg7CysPTCMYHXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXHHZqnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXHHZqnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BD7C4CEC4;
	Mon, 16 Sep 2024 12:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488458;
	bh=5G6am7NxkBkcFCP4/aOUDWjXDHNOX6cUvrrBNQ9racQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXHHZqnEgE5nC8WfHu7cSTAWrTnfCGZB6rM9yQ8OS4RzRemXrqM2Vp2V0w9F86Puq
	 o/hofsLRrQkLFyPjH34GuaT9Ng8qcVowsGqVaNEKWpk4C5RgukF9hkeCQiC93oV8hS
	 ZvYuMc/RzArlhOVkiqV3vsupsvCYzgyBncvtRR/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Arseniy Krasnov <avkrasnov@salutedevices.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 120/121] ASoC: meson: axg-card: fix use-after-free
Date: Mon, 16 Sep 2024 13:44:54 +0200
Message-ID: <20240916114233.088910724@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114228.914815055@linuxfoundation.org>
References: <20240916114228.914815055@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arseniy Krasnov <avkrasnov@salutedevices.com>

commit 4f9a71435953f941969a4f017e2357db62d85a86 upstream.

Buffer 'card->dai_link' is reallocated in 'meson_card_reallocate_links()',
so move 'pad' pointer initialization after this function when memory is
already reallocated.

Kasan bug report:

==================================================================
BUG: KASAN: slab-use-after-free in axg_card_add_link+0x76c/0x9bc
Read of size 8 at addr ffff000000e8b260 by task modprobe/356

CPU: 0 PID: 356 Comm: modprobe Tainted: G O 6.9.12-sdkernel #1
Call trace:
 dump_backtrace+0x94/0xec
 show_stack+0x18/0x24
 dump_stack_lvl+0x78/0x90
 print_report+0xfc/0x5c0
 kasan_report+0xb8/0xfc
 __asan_load8+0x9c/0xb8
 axg_card_add_link+0x76c/0x9bc [snd_soc_meson_axg_sound_card]
 meson_card_probe+0x344/0x3b8 [snd_soc_meson_card_utils]
 platform_probe+0x8c/0xf4
 really_probe+0x110/0x39c
 __driver_probe_device+0xb8/0x18c
 driver_probe_device+0x108/0x1d8
 __driver_attach+0xd0/0x25c
 bus_for_each_dev+0xe0/0x154
 driver_attach+0x34/0x44
 bus_add_driver+0x134/0x294
 driver_register+0xa8/0x1e8
 __platform_driver_register+0x44/0x54
 axg_card_pdrv_init+0x20/0x1000 [snd_soc_meson_axg_sound_card]
 do_one_initcall+0xdc/0x25c
 do_init_module+0x10c/0x334
 load_module+0x24c4/0x26cc
 init_module_from_file+0xd4/0x128
 __arm64_sys_finit_module+0x1f4/0x41c
 invoke_syscall+0x60/0x188
 el0_svc_common.constprop.0+0x78/0x13c
 do_el0_svc+0x30/0x40
 el0_svc+0x38/0x78
 el0t_64_sync_handler+0x100/0x12c
 el0t_64_sync+0x190/0x194

Fixes: 7864a79f37b5 ("ASoC: meson: add axg sound card support")
Cc: Stable@vger.kernel.org
Signed-off-by: Arseniy Krasnov <avkrasnov@salutedevices.com>
Reviewed-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20240911142425.598631-1-avkrasnov@salutedevices.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/meson/axg-card.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/sound/soc/meson/axg-card.c
+++ b/sound/soc/meson/axg-card.c
@@ -104,7 +104,7 @@ static int axg_card_add_tdm_loopback(str
 				     int *index)
 {
 	struct meson_card *priv = snd_soc_card_get_drvdata(card);
-	struct snd_soc_dai_link *pad = &card->dai_link[*index];
+	struct snd_soc_dai_link *pad;
 	struct snd_soc_dai_link *lb;
 	struct snd_soc_dai_link_component *dlc;
 	int ret;
@@ -114,6 +114,7 @@ static int axg_card_add_tdm_loopback(str
 	if (ret)
 		return ret;
 
+	pad = &card->dai_link[*index];
 	lb = &card->dai_link[*index + 1];
 
 	lb->name = devm_kasprintf(card->dev, GFP_KERNEL, "%s-lb", pad->name);


