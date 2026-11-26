Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705637;
	b=IcJuJhPQliTkPfx9rLP8fQyOS9w8xLxPtiJULc5zKVUrTCmYD5qINsQNQCNKaDj4DqAC
	 5oW82rqsBOM/X3trkqwpQHoZride5q+p6g0+3mnoAlTEalX/SHSffTS3xmc1tydR/dwHL
	 QuNjF1aLNItgVXbqmkJw3rCANiFs4FbFJDhaK6N7yPWnRYCw/2O1EIXFCk4KxHUq1XsN4
	 AbVjfz48C/aA2oZQ95ZeZB1XlDrO4VUFDnt92myRgwBgOu+U/ojaIJ4i8J/TWI4XsrW4p
	 8Nynn2MSvLkL+eXr6NOdLx6aPBu25J7Erv1LucaFJaz7tvZkEmH4edmruJQFhKLC/gg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bMojtWWJ4LVggOvSnqE5y7f8meizl5ZHG19YKM9IHkQ=;
	b=QooncgXdtRD9J14EDIW8XPrgt3FSRzNU5rRPoi0ZQ6061W7VeZWVgyYGzSepn0UKpFuN
	 CrUTgT+FOIaQyJ4GmpwQ9V7SEqILlh7Q3wStwORypl/prxbMrDlyB/+Ta3EmXWTN8SLOp
	 cRZ60ifORVuLSwy/dEudr0RHxXiO9dAWqpcHDRYhGCpqAHEwFA+kxrKd0YNIqAFMHiQ2p
	 wmN2FidAFjeMJd6kI8nQuY3CX5zsDr3eMU/EBA5Y8jo6Xnf8FtlArC/eIY94etcCygo7t
	 DF7I0x9rC4P8c6p91ytrEZBskXUGT3YkWbNzEKerUOjaMb81TDDPI498m8Iqp4UaSow==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfnWz2HQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB2F606A326;
	Thu, 26 Nov 2026 15:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RfnWz2HQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D9A81F0093E;
	Thu, 26 Nov 2026 15:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705637;
	bh=bMojtWWJ4LVggOvSnqE5y7f8meizl5ZHG19YKM9IHkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RfnWz2HQCA59MVUILcrWvPq9ilk0FzWiziTyrV3ccvAh+UCLRndYWgAoHS1kd6YRs
	 IbaIPWeJ2KFvbt1YYEE7b3CqJOakoRPuOIouKqXTrt9NXS+xZWAMWwUIB8RM8YzKvG
	 WnemHueYLZ/WeZo6Kw5CNszBi4HSKADPmkjVdYL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 263/319] iio: hid-sensors: fix a division by zero
Date: Thu, 26 Nov 2026 15:40:31 +0100
Message-ID: <20261126144012.683830552@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

commit fd4c92bbd3a64556e81042ff8d30545b15a3b93a upstream.

convert_to_vtf_format() divides the micro part of a value by
10^(6 + exp).  The unit exponent of a HID field is a nibble and goes
down to -8.  For -7 and -8 the argument of int_pow() is negative, which
the unsigned parameter turns into a huge power of ten: 0 modulo 2^64.
The division by it is a divide error.  The exponent comes from the report
descriptor of the sensor hub, the value from a write to the hysteresis
attribute of the IIO device.

Multiply by 10^(-exp - 6) in these two cases.

Fixes: 73c6768b710a ("iio: hid-sensors: Common attribute and trigger")
Cc: stable <stable@kernel.org>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/hid-sensors/hid-sensor-attributes.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
+++ b/drivers/iio/common/hid-sensors/hid-sensor-attributes.c
@@ -137,7 +137,10 @@ static u32 convert_to_vtf_format(int siz
 	if (val1 < 0 || val2 < 0)
 		sign = -1;
 	exp = hid_sensor_convert_exponent(exp);
-	if (exp < 0) {
+	if (exp < -6) {
+		value = abs(val1) * int_pow(10, -exp);
+		value += abs(val2) * int_pow(10, -exp - 6);
+	} else if (exp < 0) {
 		divisor = int_pow(10, 6 + exp);
 		value = abs(val1) * int_pow(10, -exp);
 		value += abs(val2) / divisor;


