Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704703;
	b=11WoxpmGvipgbNxrbpfaoFXCYYVuHLuVdECy6akOd9FewUWhlKLegEiLWxzs8Z0inyq9
	 JGPrypQPYsLuyrR4cUqpntX8+EB5BmYNZclYWXXdIi7JsWJzHg+GuYjanNcLibHvnR+Vn
	 MkLCbWYVE1a0/dqalT82w7D2bFbLalftUYpOFEZuxMzYWBlpElEN1rGz7tOjhIL87CGIk
	 3Opx0HrQskDrFTKR+Bb34C95Xs9//KgPHULYqLO4FAyx7dxHYYIQjiBn5Ozj7+IT59BxG
	 1InAYRr2Ov12xCvuImKMlmQ0bd17DJvC/mNCJrh+inuVwTT8lJBn0YGEz0PvE6XzC8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704703;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MUTache25H4dCo9ZyfoOuJG4CaWsGWH2Sindwb0tXww=;
	b=y4pteuQLDLik/tzZHC+0fhCvUIwK/Mo7bLOX/lME9jx3K3AMHkD/hPnrOqzCl6Q6BFDF
	 5ziU5cAhbbJopkOTkgphAn+KFVFmikRQXi6EowfJ7Vh1Spy4EYdV9+K8SbvglP4CBghqO
	 bbxjERfQWGY1WZXzA722CbTsRfBAArohk0l9suODSPcttjMBInaouh4xfGNn+D/B/fpxN
	 GQBJBZVqlzGFcsspLOenNEApbb4UV5fVOvzBF+4MXkAOsl43TTqOO+JoFAjxHtqrWWo4e
	 Ka5atakalDTFAktWBR5siiDnqhnEa/UYVIIE9uyrHiMuPNMNEJ6BIpbkOWlNf2M7+YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK2M6ZNd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475DF606A321;
	Thu, 26 Nov 2026 14:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TK2M6ZNd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B3B11F000C0;
	Thu, 26 Nov 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704702;
	bh=MUTache25H4dCo9ZyfoOuJG4CaWsGWH2Sindwb0tXww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TK2M6ZNdF/FA5qzI1rgGFgf42HSCx0mGQZT7NOKPaDrO20VkCaqPjVOu0RWuqXGn3
	 01R+Q8dpGdKRGYM/i2EdQ6A03vALPCca82wytS9ltSqYjPk/eIbdNUqOUhvM5Vec22
	 eefVl9AvGcPyvPXuokivHUfT5vbpzmTwx4WFQkek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 215/265] iio: hid-sensors: fix a division by zero
Date: Thu, 26 Nov 2026 15:39:05 +0100
Message-ID: <20261126143620.268128520@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -142,7 +142,10 @@ static u32 convert_to_vtf_format(int siz
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


