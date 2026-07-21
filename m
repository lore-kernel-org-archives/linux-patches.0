Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF0A044AB72;
	Tue, 21 Jul 2026 21:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668566; cv=none; b=qob4ayuRaiKL1mlbyFbdP/pmlgaSk2wmHFdOTgROq8J3tti48m5lvuVNqzm1cB0+UX3jrBiYojq/wDAje+ZDfHDxD8BmjIRJxduLG2yDLdBsHSokCvQBy6xzz1vZhHn3Qur/yYeS9jhkBk/toE0viPOfPXWyUwgT7A9lhkm+iYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668566; c=relaxed/simple;
	bh=GH3yhJBvKvXLC6osf8gBEk4Yv6/5Ux8rCSSgQvKMfyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEOpdU8DI3vxKtBg/vQAAZLgJREAq4vr5ZqBVoOlVmJjabHIxXTZgP0NaN4X0zXp+2kNRAaus+8v57QL6ef5Lt/jdF+herOP7p6paT1PUGIESG/iNM4K7mfq888dhb4kqip9si/qWsXaCpgs6BZmEB8PXvxeM+bbPbS3pVIzwbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IhmEehcC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IhmEehcC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311171F00A3A;
	Tue, 21 Jul 2026 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668562;
	bh=omJJxgubGJCtEvUNSuIHkO+0Ft1hwskLp6zeQ4T6EGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IhmEehcCk8jrvYcBdOSJzQUUOoiY0r3cVMBE79Tb4tNaWMxd2xrVbUt2N60oUvyXH
	 qN27mTsZ4OjW6Ml72l7Ub18dbgp8HaHlxsDIV9HQMTvq8fRbVOOH2mW1JVvCkdKziN
	 U3LNJRLKJrXGjLVvXSCTqWzM9FzoSpbd/ZCWiEww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <vasilykh@arista.com>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 6.1 0222/1067] EDAC/i10nm: Dont fail probing if ADXL is missing
Date: Tue, 21 Jul 2026 17:13:43 +0200
Message-ID: <20260721152429.564878284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -76,6 +76,7 @@ static struct res_config *res_cfg;
 static int retry_rd_err_log;
 static int decoding_via_mca;
 static bool mem_cfg_2lm;
+static bool no_adxl;
 
 static u32 offsets_scrub_icx[]  = {0x22c60, 0x22c54, 0x22c5c, 0x22c58, 0x22c28, 0x20ed8};
 static u32 offsets_scrub_spr[]  = {0x22c60, 0x22c54, 0x22f08, 0x22c58, 0x22c28, 0x20ed8};
@@ -826,8 +827,14 @@ static int __init i10nm_init(void)
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
@@ -861,7 +868,8 @@ static void __exit i10nm_exit(void)
 
 	teardown_i10nm_debug();
 	mce_unregister_decode_chain(&i10nm_mce_dec);
-	skx_adxl_put();
+	if (!no_adxl)
+		skx_adxl_put();
 	skx_remove();
 }
 


