Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06A731E85C;
	Thu, 16 Jul 2026 13:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210125; cv=none; b=fjZSGkaBou2Y7/8M2pb82FgpzZOHgmf7OuctDxpfgfhL3JEdiV03l+mbZYaCvY8gIOIvQZ4uxkzhbc7+oZn7mM6wXmtqJs61o8YShQgLprCR8RRcdKwD+oMYQX5AlX0j2gH7m00VI08WH2X7BbDTm+QXfy5IBHFNCuFG5AoRgkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210125; c=relaxed/simple;
	bh=OE7Gwb3Qsp44mc9pBEetnnjXeppdkrzhz7kFAl8U+VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=re4qYMLlsXzXqE7ograaK/X5Wv0uzWG8/Bty8gcIeUInkLBgzEN67cteiGLS0Y3x/90ZXxOo5+hlzJ6sIpbqMIv8VK8mOGEyAp1otXbCgE/a+sOp18q2BPQZ1/ZIVssYYvSUtNKGqBht40QI4IR+X7z47AU8ZSdsXk0VX5UlD+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BPbAu7yY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BPbAu7yY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B7621F000E9;
	Thu, 16 Jul 2026 13:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210124;
	bh=tFLdT6vWmKxs5rMi+6yjwEYWClG0WWvVXPyTbEU0doY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BPbAu7yYjZhXyLW2ceOqPrTFMB7SNH1lEuXCYh6a8/SYmbyPREDINptysmLnjCwFm
	 Izh3LL2mREoDBKbM+QednfFJG4zYrhJJHDaoLbMOS6NAEcIJVgE+EtV0uyFXda5Zdi
	 IE1uNDjhgb819HejXYslHt+fr/9KqRMViogKDcBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <vasilykh@arista.com>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 7.1 404/518] EDAC/i10nm: Dont fail probing if ADXL is missing
Date: Thu, 16 Jul 2026 15:31:12 +0200
Message-ID: <20260716133056.673756605@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Khoruzhick <vasilykh@arista.com>

commit e360a6d65bb46c527a5909430a31d640cdd5036e upstream.

ADXL is not present in Coreboot- or Slimbootloader-based BIOSes and as
result, the driver fails to probe there.

Since commit 2738c69a8813 ("EDAC/i10nm: Add driver decoder for Ice Lake
and Tremont CPUs"), i10nm_edac supports driver decoder. Switch to driver
decoding when ADXL is not present.

Signed-off-by: Vasily Khoruzhick <vasilykh@arista.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Cc: stable@vger.kernel.org # v6.1+
Link: https://patch.msgid.link/20260414181735.87023-1-anarsoul@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/i10nm_base.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/edac/i10nm_base.c
+++ b/drivers/edac/i10nm_base.c
@@ -79,6 +79,7 @@ static struct res_config *res_cfg;
 static int retry_rd_err_log;
 static int decoding_via_mca;
 static bool mem_cfg_2lm;
+static bool no_adxl;
 
 static struct reg_rrl icx_reg_rrl_ddr = {
 	.set_num = 2,
@@ -1222,8 +1223,14 @@ static int __init i10nm_init(void)
 	}
 
 	rc = skx_adxl_get();
-	if (rc)
-		goto fail;
+	if (rc) {
+		/* Decoding errors via MCA banks for 2LM isn't supported yet */
+		if (rc != -ENODEV || mem_cfg_2lm)
+			goto fail;
+		i10nm_printk(KERN_INFO, "ADXL not found, falling back to MCA-based decoding.\n");
+		no_adxl = true;
+		decoding_via_mca = true;
+	}
 
 	opstate_init();
 	mce_register_decode_chain(&i10nm_mce_dec);
@@ -1257,7 +1264,8 @@ static void __exit i10nm_exit(void)
 
 	skx_teardown_debug();
 	mce_unregister_decode_chain(&i10nm_mce_dec);
-	skx_adxl_put();
+	if (!no_adxl)
+		skx_adxl_put();
 	skx_remove();
 }
 


