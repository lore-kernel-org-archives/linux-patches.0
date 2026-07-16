Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B625A424D64;
	Thu, 16 Jul 2026 14:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210485; cv=none; b=JXe+C6l6VcCDVBpwWWAOKWRUDxMerwbLc4N6HJanoAa0uoL1DKTiNNlHgdDxRafGf5qKLL7JnA0e5RG1zXg2wdLrMRgCFIrrXZKjEDfLA9JBBgcV1WxehYSY6uz51/D4n6j06DHNGHodqfRkwj8gS8EzuyUZcdN1OO6RV5d2uic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210485; c=relaxed/simple;
	bh=P5F5Tm/JPOvNOE/zJ430I6N5VNexBJ9eejiHUgHdXbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ve5UaEyzBy9vU0uFokSrOwiVVqqXXECBThhavdRWZtlAJ50DUCHV7IB78D/7MqgSxLN5iUFu47i4LqFC0FwzzkOMAR5RrDhqmzG4PZaXk/VjnjSEgEEkUa2vhYpuwWrM7tL/EIVlU7cnYKdQpMzqW3EcIx+mmJ5rz4gcL1oLPsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfpkksTl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfpkksTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C811F000E9;
	Thu, 16 Jul 2026 14:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210484;
	bh=YLPhk6hIznnxxKA+ZQ1iCuEhmWnxsrvOOx4Bk0LacNE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UfpkksTlxUC5r7Ul4UF81Bfvey+uWZUGgRSCToxsQliMXkqmJWlJC4DAqcU137jpD
	 HhksXZxABzc9xcW502AAliBohiT/cNzB5m5gRzO3Qrr7lzonap1MgOE2/s0iMYeN85
	 cAEWYj4jfQ3yyPWfw977tT4sswLHE6DgPQCNbkUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 065/480] iio: gyro: bmg160: bail out when bandwidth/filter is not in table
Date: Thu, 16 Jul 2026 15:26:52 +0200
Message-ID: <20260716133046.115882133@linuxfoundation.org>
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

From: Stepan Ionichev <sozdayvek@gmail.com>

commit 8320c77e67382d5d55d77043a5f60a867d408a2b upstream.

bmg160_get_filter() walks bmg160_samp_freq_table[] looking for the entry
matching the bw_bits value read from the chip:

	for (i = 0; i < ARRAY_SIZE(bmg160_samp_freq_table); ++i) {
		if (bmg160_samp_freq_table[i].bw_bits == bw_bits)
			break;
	}
	*val = bmg160_samp_freq_table[i].filter;

If no entry matches, i ends up equal to the array size and the next line
reads one slot past the end. bmg160_set_filter() has the same shape, driven
by 'val' instead of bw_bits.

smatch flags both:

  drivers/iio/gyro/bmg160_core.c:204 bmg160_get_filter() error:
  buffer overflow 'bmg160_samp_freq_table' 7 <= 7
  drivers/iio/gyro/bmg160_core.c:222 bmg160_set_filter() error:
  buffer overflow 'bmg160_samp_freq_table' 7 <= 7

Return -EINVAL when no entry matches.

The set_filter() path is reachable from userspace via the sysfs
in_anglvel_filter_low_pass_3db_frequency interface, so userspace can
trivially trigger the out-of-bounds read with a value that is not in
bmg160_samp_freq_table[].filter.

Fixes: 22b46c45fb9b ("iio:gyro:bmg160 Gyro Sensor driver")
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/bmg160_core.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/iio/gyro/bmg160_core.c
+++ b/drivers/iio/gyro/bmg160_core.c
@@ -201,6 +201,9 @@ static int bmg160_get_filter(struct bmg1
 			break;
 	}
 
+	if (i == ARRAY_SIZE(bmg160_samp_freq_table))
+		return -EINVAL;
+
 	*val = bmg160_samp_freq_table[i].filter;
 
 	return ret ? ret : IIO_VAL_INT;
@@ -218,6 +221,9 @@ static int bmg160_set_filter(struct bmg1
 			break;
 	}
 
+	if (i == ARRAY_SIZE(bmg160_samp_freq_table))
+		return -EINVAL;
+
 	ret = regmap_write(data->regmap, BMG160_REG_PMU_BW,
 			   bmg160_samp_freq_table[i].bw_bits);
 	if (ret < 0) {


