Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB94442902A;
	Thu, 16 Jul 2026 14:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212367; cv=none; b=DfsZVtJv8eOzUbl6mBuZE6FNaQX681/uISJ7Elc0Fp0Cn/0kdDTWlYEVHnnipZIYRDqnmtQrzJiRP7dHSM6uksLp+vv/TaErcsJvzDicsZxQ/gN1uJcKj7uygk0nEveFosqUxqkEyvpt9644udZWIJ016h+h7gDMAT0wmKR6FOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212367; c=relaxed/simple;
	bh=TzY6RkclJTbPQrlTfc4lSc7GHI7VJAIt6tZvUn6TT3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GrAWjdMfSKaK1pCN3xf5XeOx4KpaG3f8zUSniQbtIWsgEVbBcz7vZc9ivSlq+8trbf/WM+Y8FAs0r5bT56dzIxFlaX+IaS8tUt6V/fc/lr/VOoyR+Q1PQIVBkm86upbz0sYOAXUcKq/OotR6I+LdW5776yWL2v3SRqcm6z4acPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dwhOCknh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dwhOCknh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D5A1F000E9;
	Thu, 16 Jul 2026 14:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212366;
	bh=ihDFYQGP5sxj4ElRiD9dRv0ynKa6c9Tyu+aDaiT/T1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dwhOCknhO5f76AsSXnxmg5IS9kvkSCcv5jjDJwLTR5HDZIanz95R09NGdLYdtaEQd
	 kY3BQaFuXpqTOirccnclceCvdiwfzvl1CDkXcBYvFM+qyXI339tEPs3uaFWLBSsNHp
	 F3+BcrkEZ2yNtB1Hyy32Lwswv+LnNyJLvXjUV+48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <vasilykh@arista.com>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 6.12 300/349] EDAC/i10nm: Dont fail probing if ADXL is missing
Date: Thu, 16 Jul 2026 15:33:54 +0200
Message-ID: <20260716133040.033853135@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -84,6 +84,7 @@ static struct res_config *res_cfg;
 static int retry_rd_err_log;
 static int decoding_via_mca;
 static bool mem_cfg_2lm;
+static bool no_adxl;
 
 static u32 offsets_scrub_icx[]  = {0x22c60, 0x22c54, 0x22c5c, 0x22c58, 0x22c28, 0x20ed8};
 static u32 offsets_scrub_spr[]  = {0x22c60, 0x22c54, 0x22f08, 0x22c58, 0x22c28, 0x20ed8};
@@ -1121,8 +1122,14 @@ static int __init i10nm_init(void)
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
@@ -1156,7 +1163,8 @@ static void __exit i10nm_exit(void)
 
 	skx_teardown_debug();
 	mce_unregister_decode_chain(&i10nm_mce_dec);
-	skx_adxl_put();
+	if (!no_adxl)
+		skx_adxl_put();
 	skx_remove();
 }
 


