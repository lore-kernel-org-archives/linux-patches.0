Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB084429003;
	Thu, 16 Jul 2026 14:15:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211327; cv=none; b=oifMuPUjsNLYzaKuW0Q8o4Owicag4yI5bNGAh9eMEalMkmMTFCwlzLimyld8BdrhnnaYwrIF1ZVB+49b3PGc4qgA/3IsusI6pBbc7MMj4Jkme5so2wtQVHNrmUkYoTC1yIG+c6DP4rTz2BflX7MoOekywrg1eJNYnJEiODplqgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211327; c=relaxed/simple;
	bh=Tl+f/bilQWoQBbQV4nfxurmUFchMS4D2YRt2T5h9E1M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tYREUfGWfzwchQJcbjFjuaSDqrBV9EApPeOsS+BjMm0dB3qIvf1NKUWWzpcqi2D+PgxBtW1R67OccP54fFzBc/5wLg6dMNDI8zWJUjD8sGjcqgMMYeV/bx4lbVYcFMuZJKmWMHB0vl+c4OMXToJuQEoFGt6CAwjT+n0JoWnq2oA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ifYCB2SM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ifYCB2SM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87CD1F000E9;
	Thu, 16 Jul 2026 14:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211325;
	bh=Izrx4RgX/hVBVBY7WRKrJJ6pJ0AweN+i9iAoMl1KF4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ifYCB2SMuxQMe7aPtrB9XWm96hSbrgeXeXACjrwOUhDJlQPuBAwnTjEOXx0JnDcae
	 N/1PZhC63eYxnahfVZhqMX1smc6Fh7PUM8/YYdf9Sr2NGLeCLw0DuY2Doaw+JJkczr
	 5/QBZZ2cpW1C+paq1318KUEb6Opzn4zkDzI8VcKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Khoruzhick <vasilykh@arista.com>,
	Tony Luck <tony.luck@intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>
Subject: [PATCH 6.18 386/480] EDAC/i10nm: Dont fail probing if ADXL is missing
Date: Thu, 16 Jul 2026 15:32:13 +0200
Message-ID: <20260716133053.151136685@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1207,8 +1208,14 @@ static int __init i10nm_init(void)
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
@@ -1242,7 +1249,8 @@ static void __exit i10nm_exit(void)
 
 	skx_teardown_debug();
 	mce_unregister_decode_chain(&i10nm_mce_dec);
-	skx_adxl_put();
+	if (!no_adxl)
+		skx_adxl_put();
 	skx_remove();
 }
 


