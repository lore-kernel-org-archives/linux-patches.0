Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626086;
	b=WEMxhJBD/hRHAyFr2u1XTVu+9x0LEJO4BjjwN7Ts8ElzsE/lPT3LiP7qpI3av5WFRNzS
	 jewiG0H5IX6ncClhfHOGpJybFoW55GnIBwGN4gHFfwXcLkw1l1/oQV7GUieGWUsTPMKh8
	 Fjl+u0B6I6PhlRYZgossGmWZbIdCmBX+EihgunUFmiWYHCWIyIlXYgH59xEZQ73m7ovmu
	 vd9rQ38gJ6PABGt1FN0Afb1WuHZafLDW9VE5GQRILlX9AFzVaUA9Y25r4OnNXOKRlv5X7
	 kT7/fMfZa4BGVdiTczs0O8ENf7BZfLBNccS+RaiOhRTatxqnrLaCYc/hNRuOeUuH+zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626086;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ed3SR0DZ4FQx56GkUh4febSlOCZ2AJWwvL87t1Vkfg=;
	b=dH6+HkqJg4DhJFnYQfeBAD42NS6j4fxTvVSLU/8EbtGBW/aL9dVi+hn9avE2FTYy/4Gi
	 EjORnGI30yRViQYpiesLKHD0serVmv/M8sIeuntRfTOEy+ucuifPi60V8jLT59mThAUWc
	 glLLAroJp90HGFs1/R2XBjAFQR+jcvDtrtk0j0f9OCYAnL4g8r+Z21gwR6ytaWTYb0D5R
	 SNk21vlWIiXuP+zakHmLACdC1Am34VG9QkxrSslwZlK13r5Uq5yOlKPyTlc0yrhbgmaQJ
	 7SpsCvaeR9C0IS/v5dGh0RDfcG0ew5Wi+qihxmRjhqEZ+NCY2mfSivXoRF8DgQDtM9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfNnyuyb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C12A606A31E;
	Wed, 25 Nov 2026 17:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hfNnyuyb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 052471F000C0;
	Wed, 25 Nov 2026 17:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626085;
	bh=7ed3SR0DZ4FQx56GkUh4febSlOCZ2AJWwvL87t1Vkfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfNnyuybAbVOS1ujO85Xe7VgCtlo42ymfQ3ozupk92ia/iT+sstj713bmLy0tsHYU
	 jeWb1kKvIuqUOSEYKzEuLJjkU/IKo0R8HTMz8V1p8p2MHWou3acXtHHBXInRUn2rEG
	 qFpX6pqKiNK1KoCOcUSMpyAQj2HjicqAJr5Cb4Q0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 727/816] iio: hid-sensors: fix a division by zero
Date: Wed, 25 Nov 2026 15:37:55 +0100
Message-ID: <20261125143906.008929842@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


