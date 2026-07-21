Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC4833845A7;
	Tue, 21 Jul 2026 20:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664944; cv=none; b=LzywjdKvBEnIZNN7gowBdFGP94Qoikf/QB9IpajxDehyHllgRkVUPXs1lNemc4D7+EzE4nWr0G6SZjfERUu8pohKvU8e3Al7RzsmwZ/Ck/Ac6YggysH7KBBCwq3SzdXCbDZaLdACldb3EWqsgkfl9UxsB3NzVFDyGpvO/ClWfzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664944; c=relaxed/simple;
	bh=g76bs5V/WCowp4k5bTEF0CI9Fz4VT6Sfdlf7zm16sb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ScHqdKtnlpY7HN9eozj3yknuU6Y8qERtTJs4DlLfJJVkJvQPbymuCGrlAm53TFU/qY2+5upnW0DXtTyaTYMr5Xk+0iv+vef68gAtHpVvwFRquNRSVPfG3s/KxIPCsF3ddmXeLUj7gdc6PHpp+pMyCv4U9QI39PcIIBA4B2yOSCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s5oYoftr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s5oYoftr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CC191F00A3A;
	Tue, 21 Jul 2026 20:15:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664941;
	bh=OK5hON7o3Ol/kXcnbxEUoKI6UpikemJWKVMPvzXUQU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s5oYoftrY3s2OYEGbR+vjfs6CTso2wpWP06AUBifx+oMf8vvfILjfQ+aBZ85Ex/IE
	 i1LAwHsuJs/4lxlpMCiKYMPkez0ECsE+4Zj60FVM83AjlYiCjppqtsFf+zuxK2EjBi
	 vHN0pB65pGGVje1pAvZ6ecN0VBBYGhSJxtnU2gtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0090/1266] iio: gyro: bmg160: bail out when bandwidth/filter is not in table
Date: Tue, 21 Jul 2026 17:08:47 +0200
Message-ID: <20260721152443.817980844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -204,6 +204,9 @@ static int bmg160_get_filter(struct bmg1
 			break;
 	}
 
+	if (i == ARRAY_SIZE(bmg160_samp_freq_table))
+		return -EINVAL;
+
 	*val = bmg160_samp_freq_table[i].filter;
 
 	return ret ? ret : IIO_VAL_INT;
@@ -221,6 +224,9 @@ static int bmg160_set_filter(struct bmg1
 			break;
 	}
 
+	if (i == ARRAY_SIZE(bmg160_samp_freq_table))
+		return -EINVAL;
+
 	ret = regmap_write(data->regmap, BMG160_REG_PMU_BW,
 			   bmg160_samp_freq_table[i].bw_bits);
 	if (ret < 0) {


