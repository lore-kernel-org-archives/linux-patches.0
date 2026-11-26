Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705522;
	b=dKGqGBKB5s+Mu5NX6jJQEk8xzThb7Whc/9K3ajJDDsMRoYxYsze2jemh8YWMdOHKgVrg
	 75+lUewaFfNu14UeknwMOEhZ/N/L1TAwLf7ukt1/442QENzXBmKaAJ80HM8ZNggJvzNDG
	 WUXGkfIeUg/WpwukifoHg92gpH83cuLqA3UZhL7p44PEVnGP+A29GASHgO8e3UbedZ54S
	 CZfFCCpibB2ybf/g2IfTcz+UIWeLPlOiDqW7I3JrVx8gTFXlUVGckTJ54Ug1qGBKaXl/C
	 ttwcuKeNlCx1p2/Qtsfmlwn5wqkwejYuj6jApPbIIEqZSv5eSt4xAKYUTXlUKCl5VCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705522;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QcPnue0gdK2Lp54/x18I/9v5VjcWb4/0kt5VH4fCs1A=;
	b=LbOMvpl2gnxZ/Hv0IWyPLjBY9KzA5TdxMMndF825mQL/K5HTye8jP1Ewcz3LGbNV/69Z
	 dPIZq3OWHQTVDdnoxWcgU6jNJUHEsHhy+2pkSEJ60cccsTnnGiP/tGyv3TogLAe8h2nc6
	 82gPrPLEjM40G2DgQ4rShnkgNSeTsmRStvKV+8xFPzLzh/wZbva37uBYy9o6lLtmm4MIO
	 mkikKM2WnL6LPIAwG3DpB4vMTahPIAfjvt07D0tifbcgsPZAbYEsxtLbCXWWgyo7uJiTO
	 UsogRK965V1+0xX2kM2m/BaHuQemdfoWA4LigH+DIiUDQyahuj3Khnb+JWu8/k16/DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdxC3k7t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52557606A332;
	Thu, 26 Nov 2026 15:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BdxC3k7t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9D71F000C0;
	Thu, 26 Nov 2026 15:05:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705521;
	bh=QcPnue0gdK2Lp54/x18I/9v5VjcWb4/0kt5VH4fCs1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BdxC3k7t7xRBsdyJVD9x8HwkRh9agjKeioH9vX5AEsOWeZuygvI3cdst5yc0q1hVG
	 /Lmik0jwvPY1zbUBF2iJIZvG+pfW+9z04PatLVh207RCP5usTSaHWYWoIuqL5nHPgJ
	 y+H1s6YoD4jSge1qyrD/4zl/6wGvhda0WdyXtB8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rupesh Majhi <zoone.rupert@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 219/319] hwmon: (aht10) Fix update_interval overflow on 64-bit
Date: Thu, 26 Nov 2026 15:39:47 +0100
Message-ID: <20261126144011.689796706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rupesh Majhi <zoone.rupert@gmail.com>

commit b5c5b67e02406fb48acf57cf2c30a570230fd6aa upstream.

On 64-bit, update_interval writes are clamped to LONG_MAX ms, but
ms_to_ktime() overflows above 9223372036854 ms and the interval wraps.
LONG_MAX becomes -1 ms, so every read starts a new measurement and
update_interval reads back -1.

Clamp to INT_MAX like sht4x, so the limit is the same on all platforms.

Fixes: 8c78f0dee437 ("hwmon: Add AHT10 Temperature and Humidity Sensor Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Rupesh Majhi <zoone.rupert@gmail.com>
Link: https://patch.msgid.link/20261108172651.220121-1-zoone.rupert@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/aht10.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -182,7 +182,7 @@ static int aht10_read_values(struct aht1
 static ssize_t aht10_interval_write(struct aht10_data *data,
 				    long val)
 {
-	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, LONG_MAX));
+	data->min_poll_interval = ms_to_ktime(clamp_val(val, 2000, INT_MAX));
 	return 0;
 }
 


