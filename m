Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA5D1849D3;
	Wed,  3 Jul 2024 11:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005072; cv=none; b=AxC0uf+5Xovvy2oReAjs7Y71TWYJS8NS5u0JXYaig5Fzz2zhOipkMC2DIddL1WjwkcssXMZ+E4o90prMz9MgSRDbH+vl3m2qMErc4cNQOvLXfs2JfgiTzeYFfmB4P+Q63l2TuGbMdmLTuSsSyUDUIth6ygMMAN03KpV8LAy2s/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005072; c=relaxed/simple;
	bh=c5HOigGoKD0xn9PyhLw6DVRABknT7FXdnhTDmc0iUJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cruMAwHwqk96X19ehIKtbw4qVSIpgBjRr6i2/DgH2K3rxEUIiHp/l9EDbIDgFsxdkMAvVYTaFefxhAWGQ0tTZljX/Xcw1nGFtJAYkP1wQ99iGNNF0ptef/hTr8n2tCGufyXGR0RvV7LI1U0YKNfGwXohn+40kFzbsHW5YPopG3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsrHCZ0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsrHCZ0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B1DCC2BD10;
	Wed,  3 Jul 2024 11:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005072;
	bh=c5HOigGoKD0xn9PyhLw6DVRABknT7FXdnhTDmc0iUJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GsrHCZ0NX/9xBHK5Dwh2t+orqzlGbWJ/a97WTs9+gB7OXv6dHkvG8GwE5mKQLa1tB
	 UO5MqleobSQCHjA1t+D1unUyrxlqx7g6oukxVXzUKg8McTVz3+fdOp86QiWUjrJBNJ
	 PEuSjqV1FgJwSsNuRE0wWiK90f4dCiUWe3o3Uqec=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 251/290] iio: chemical: bme680: Fix overflows in compensate() functions
Date: Wed,  3 Jul 2024 12:40:32 +0200
Message-ID: <20240703102913.630409866@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit fdd478c3ae98c3f13628e110dce9b6cfb0d9b3c8 upstream.

There are cases in the compensate functions of the driver that
there could be overflows of variables due to bit shifting ops.
These implications were initially discussed here [1] and they
were mentioned in log message of Commit 1b3bd8592780 ("iio:
chemical: Add support for Bosch BME680 sensor").

[1]: https://lore.kernel.org/linux-iio/20180728114028.3c1bbe81@archlinux/

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-4-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -342,10 +342,10 @@ static s16 bme680_compensate_temp(struct
 	if (!calib->par_t2)
 		bme680_read_calib(data, calib);
 
-	var1 = (adc_temp >> 3) - (calib->par_t1 << 1);
+	var1 = (adc_temp >> 3) - ((s32)calib->par_t1 << 1);
 	var2 = (var1 * calib->par_t2) >> 11;
 	var3 = ((var1 >> 1) * (var1 >> 1)) >> 12;
-	var3 = (var3 * (calib->par_t3 << 4)) >> 14;
+	var3 = (var3 * ((s32)calib->par_t3 << 4)) >> 14;
 	data->t_fine = var2 + var3;
 	calc_temp = (data->t_fine * 5 + 128) >> 8;
 
@@ -368,9 +368,9 @@ static u32 bme680_compensate_press(struc
 	var1 = (data->t_fine >> 1) - 64000;
 	var2 = ((((var1 >> 2) * (var1 >> 2)) >> 11) * calib->par_p6) >> 2;
 	var2 = var2 + (var1 * calib->par_p5 << 1);
-	var2 = (var2 >> 2) + (calib->par_p4 << 16);
+	var2 = (var2 >> 2) + ((s32)calib->par_p4 << 16);
 	var1 = (((((var1 >> 2) * (var1 >> 2)) >> 13) *
-			(calib->par_p3 << 5)) >> 3) +
+			((s32)calib->par_p3 << 5)) >> 3) +
 			((calib->par_p2 * var1) >> 1);
 	var1 = var1 >> 18;
 	var1 = ((32768 + var1) * calib->par_p1) >> 15;
@@ -388,7 +388,7 @@ static u32 bme680_compensate_press(struc
 	var3 = ((press_comp >> 8) * (press_comp >> 8) *
 			(press_comp >> 8) * calib->par_p10) >> 17;
 
-	press_comp += (var1 + var2 + var3 + (calib->par_p7 << 7)) >> 4;
+	press_comp += (var1 + var2 + var3 + ((s32)calib->par_p7 << 7)) >> 4;
 
 	return press_comp;
 }
@@ -414,7 +414,7 @@ static u32 bme680_compensate_humid(struc
 		 (((temp_scaled * ((temp_scaled * calib->par_h5) / 100))
 		   >> 6) / 100) + (1 << 14))) >> 10;
 	var3 = var1 * var2;
-	var4 = calib->par_h6 << 7;
+	var4 = (s32)calib->par_h6 << 7;
 	var4 = (var4 + ((temp_scaled * calib->par_h7) / 100)) >> 4;
 	var5 = ((var3 >> 14) * (var3 >> 14)) >> 10;
 	var6 = (var4 * var5) >> 1;


