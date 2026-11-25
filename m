Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623772;
	b=Rrh++Y3KBM6IiLkjCZJhfh7W+BNjx6yJCOi94j9IlMUpV7WUcKTaIOmSB+jkqn1ftrg/
	 2RkRFdOLa5Bf92JoqqzsdguqZSnagjX84AVodgW/289ZuJn5QSGGjY6H1zK6IzP9+9wsa
	 xvClBE1SfBl/n+c/045rxFDGOkLnBU6rQWfrmSaoyiMPruChbgh1j/qljyWqI+4FTnECM
	 7iyfjUbiekzBiGd8+eXSwHD3uhYki9Cww6XQMj1ajCZCaifcJafTFoHkVECGE9yp7y3rN
	 BwgGe4PJwAGoMhdokXIrez97qzmQsj/X+UVFY5L4XjEoviLpd2KjCpxHcQH21Dwbyyg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iRneP6yXE4PRffpYafFw0KynuTn0hIvTWpdftqi8+A8=;
	b=I/RNXlxQxMZmnbuEpJ4d2rCV1D/MgKCBo4L7id6+5RHvwtGxDlk2Nm/N69vb6g7BE2Qd
	 D14WNvQpS8ZEySSp6Ij+EjWHRzkAdJ+jf+DqfAhsGl+8gvuDgQiXUscegKkmN3VBIiviV
	 nB2tozQf+lYdUtD87poNwh+K9iHMNq/eMEturKI4zJcqz4NGct8xx3QwBL2Se1B3Z2osl
	 yqspIA487u87s+EJdnYMT6VhZg4FKZvIXQuANQ1NPMvnvhf+2g/ha6dDLHdlwJS+3avg2
	 HYlBPAroU2ekYmUXTJ9CB9Que5driutcsF/KKVpMrnJ71tBi7aO50s08MkHtCR7lk9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bygXFJEV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5C5606A31E;
	Wed, 25 Nov 2026 16:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bygXFJEV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B48A1F000C4;
	Wed, 25 Nov 2026 16:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623772;
	bh=iRneP6yXE4PRffpYafFw0KynuTn0hIvTWpdftqi8+A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bygXFJEVt6m61BiB26XFfMF2N4zQcY9bqqqKmrvq6E70HBmeZMaMwJQsP7HF/q/mE
	 kDpltA4Tffz6RWBG+H8dpW5tdtucxUX863GWqEYjLtV2xGO8WWR5jLJK3+Lsj9BhIz
	 POabeQr8xeZ4f6DsYfDTBzjbeCT5kPekWElYDkyQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 965/990] iio: temperature: mlx90614: Fix dual channel probe condition check
Date: Wed, 25 Nov 2026 15:38:52 +0100
Message-ID: <20261125143844.588271050@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

commit 4d4e75b3074bc29525c963a81c19471528f29a45 upstream.

In mlx90614_probe_num_ir_sensors(), the check on chip_info->dual_channel
is inverted.

Currently, if dual_channel is true (MLX90614), the function returns 0
immediately without checking op_eeprom_config1. This forces all MLX90614
devices to be registered as single sensor (num_channels = 2), making the
second object temperature channel inaccessible.

Conversely, if dual_channel is false (MLX90615), the function skips the
early return and performs an unnecessary SMBus read on EEPROM CONFIG1 even
though MLX90615 does not support dual channel operation.

Fix this by negating the condition so that single-channel chips return
early with 0, while dual-channel capable chips (MLX90614) proceed to read
the EEPROM configuration register to detect whether 1 or 2 object channels
are present.

Fixes: 3d5ead238bc8 ("iio: mlx90614: Factor our register IO and constants into model specific descriptor")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/mlx90614.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/mlx90614.c
+++ b/drivers/iio/temperature/mlx90614.c
@@ -569,7 +569,7 @@ static int mlx90614_probe_num_ir_sensors
 	const struct mlx_chip_info *chip_info = data->chip_info;
 	s32 ret;
 
-	if (chip_info->dual_channel)
+	if (!chip_info->dual_channel)
 		return 0;
 
 	ret = i2c_smbus_read_word_data(client, chip_info->op_eeprom_config1);


