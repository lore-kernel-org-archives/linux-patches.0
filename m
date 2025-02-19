Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B841DE4C2;
	Wed, 19 Feb 2025 09:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956683; cv=none; b=amJWSm8OuQc2ZPdAHVWPB2liAC93PVX9YXdo7Pd0Cx11ZFoi9q+3PzwZ4fGzTNQM8+xPfJjr8rMG29RZ2XSGOOFB8ptt0Fk8MxZ8P0aiaCmZk4pl1Pfe4EpmMVBDTYOYxAi8mGuuuExCXaU4Tj5HsWmKMaFxbWU6ZLENgHFhY60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956683; c=relaxed/simple;
	bh=NRFk/zsYP3t6iIN7GjXDye6/ngXHFsMLP+sZ59q5ahY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugYjs5wY9y3TQIZt0MlkJTye/2ArM7vOQjlj+1aTk7ZKC3qWFTvXeZc/EgpwXWm+co8HmACEeUbnrmadjeRDCATT9ENLJejp4usbh9uRl17VH7DGjzNJyuVIcXUeUolcSkdI184402C7sM1q5nRmsYhrTKyn0cjJLy0bASxwTxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrRp1bZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrRp1bZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85805C4CED1;
	Wed, 19 Feb 2025 09:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956682;
	bh=NRFk/zsYP3t6iIN7GjXDye6/ngXHFsMLP+sZ59q5ahY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrRp1bZ0G5eLHk9YnM+2mz/2AtRCmhVUfcnRX62hWreXlIHRzvm+Ezlp77fw04naz
	 +Nvncex2eoJHFhiXAsy6SIDmlQWEnwnm/Koy4e82X8NVXZCcSTPHbvZUSILcQ4Xo3/
	 WrfR9Jd4ZdgjKUnjpSSia8EKc06BDzWo/bTooyJs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 6.1 264/578] staging: media: max96712: fix kernel oops when removing module
Date: Wed, 19 Feb 2025 09:24:28 +0100
Message-ID: <20250219082703.410243000@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>

commit ee1b5046d5cd892a0754ab982aeaaad3702083a5 upstream.

The following kernel oops is thrown when trying to remove the max96712
module:

Unable to handle kernel paging request at virtual address 00007375746174db
Mem abort info:
  ESR = 0x0000000096000004
  EC = 0x25: DABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x04: level 0 translation fault
Data abort info:
  ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
  CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
user pgtable: 4k pages, 48-bit VAs, pgdp=000000010af89000
[00007375746174db] pgd=0000000000000000, p4d=0000000000000000
Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
Modules linked in: crct10dif_ce polyval_ce mxc_jpeg_encdec flexcan
    snd_soc_fsl_sai snd_soc_fsl_asoc_card snd_soc_fsl_micfil dwc_mipi_csi2
    imx_csi_formatter polyval_generic v4l2_jpeg imx_pcm_dma can_dev
    snd_soc_imx_audmux snd_soc_wm8962 snd_soc_imx_card snd_soc_fsl_utils
    max96712(C-) rpmsg_ctrl rpmsg_char pwm_fan fuse
    [last unloaded: imx8_isi]
CPU: 0 UID: 0 PID: 754 Comm: rmmod
	    Tainted: G         C    6.12.0-rc6-06364-g327fec852c31 #17
Tainted: [C]=CRAP
Hardware name: NXP i.MX95 19X19 board (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : led_put+0x1c/0x40
lr : v4l2_subdev_put_privacy_led+0x48/0x58
sp : ffff80008699bbb0
x29: ffff80008699bbb0 x28: ffff00008ac233c0 x27: 0000000000000000
x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000000
x23: ffff000080cf1170 x22: ffff00008b53bd00 x21: ffff8000822ad1c8
x20: ffff000080ff5c00 x19: ffff00008b53be40 x18: 0000000000000000
x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
x14: 0000000000000004 x13: ffff0000800f8010 x12: 0000000000000000
x11: ffff000082acf5c0 x10: ffff000082acf478 x9 : ffff0000800f8010
x8 : 0101010101010101 x7 : 7f7f7f7f7f7f7f7f x6 : fefefeff6364626d
x5 : 8080808000000000 x4 : 0000000000000020 x3 : 00000000553a3dc1
x2 : ffff00008ac233c0 x1 : ffff00008ac233c0 x0 : ff00737574617473
Call trace:
 led_put+0x1c/0x40
 v4l2_subdev_put_privacy_led+0x48/0x58
 v4l2_async_unregister_subdev+0x2c/0x1a4
 max96712_remove+0x1c/0x38 [max96712]
 i2c_device_remove+0x2c/0x9c
 device_remove+0x4c/0x80
 device_release_driver_internal+0x1cc/0x228
 driver_detach+0x4c/0x98
 bus_remove_driver+0x6c/0xbc
 driver_unregister+0x30/0x60
 i2c_del_driver+0x54/0x64
 max96712_i2c_driver_exit+0x18/0x1d0 [max96712]
 __arm64_sys_delete_module+0x1a4/0x290
 invoke_syscall+0x48/0x10c
 el0_svc_common.constprop.0+0xc0/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x34/0xd8
 el0t_64_sync_handler+0x120/0x12c
 el0t_64_sync+0x190/0x194
Code: f9000bf3 aa0003f3 f9402800 f9402000 (f9403400)
---[ end trace 0000000000000000 ]---

This happens because in v4l2_i2c_subdev_init(), the i2c_set_cliendata()
is called again and the data is overwritten to point to sd, instead of
priv. So, in remove(), the wrong pointer is passed to
v4l2_async_unregister_subdev(), leading to a crash.

Fixes: 5814f32fef13 ("media: staging: max96712: Add basic support for MAX96712 GMSL2 deserializer")
Signed-off-by: Laurentiu Palcu <laurentiu.palcu@oss.nxp.com>
Cc: stable@vger.kernel.org
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/media/max96712/max96712.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/media/max96712/max96712.c
+++ b/drivers/staging/media/max96712/max96712.c
@@ -376,7 +376,6 @@ static int max96712_probe(struct i2c_cli
 		return -ENOMEM;
 
 	priv->client = client;
-	i2c_set_clientdata(client, priv);
 
 	priv->regmap = devm_regmap_init_i2c(client, &max96712_i2c_regmap);
 	if (IS_ERR(priv->regmap))
@@ -409,7 +408,8 @@ static int max96712_probe(struct i2c_cli
 
 static void max96712_remove(struct i2c_client *client)
 {
-	struct max96712_priv *priv = i2c_get_clientdata(client);
+	struct v4l2_subdev *sd = i2c_get_clientdata(client);
+	struct max96712_priv *priv = container_of(sd, struct max96712_priv, sd);
 
 	v4l2_async_unregister_subdev(&priv->sd);
 


