Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75ADE409630;
	Thu, 28 May 2026 20:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998427; cv=none; b=BITA+wUE5oju9EXe9sOlr8eYHgsjYyY/M8W0keDlqaCS3NTer2ScgmxdCaj8kjhy4CVmW/IgZkfQBllmraKRtpvAK0lnY4JHJOgMezzYMGiwgdAvbco+AyOHhGTwhByCFw+N7OiKA0ITg7/t32t+D4B/5BnuMWRfdx0YKGOITKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998427; c=relaxed/simple;
	bh=skGNAlcKBQruuIqs9iUO6WLZwH7/lG6pIHNzfu9G94E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GVVppdQBRVmb7H2+k/p2AV5cP5mE78FJ9FhvHQdgs/iRIZieRoGCJapFmUaCRDnCnj2VnSxJkYWgCYHy2OiXOIPey2qrdB1H5lkXt7R2uv/CO6Gc0zzZPwhpmLZMynVIBDhOtIPdPRPjuwIKzeFr4ORatXC0zsVLchnSwB8inwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztjmjjzG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztjmjjzG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87F211F000E9;
	Thu, 28 May 2026 20:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998426;
	bh=/faiq15wQST21qdkEZEw4RfH+QNFa6nSoLTcZv8Whn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztjmjjzGiaCi/FRYeJe0LYmZh8p9VllpmcZY9/nVTOhTBTYduT2tC7DcVK36Y7Y4T
	 HurVZnkMAQ2254cjpDb0sX9Zv3Hh4mitRczzum3ufzOWoTdDhBwupHPfSzHVPtGDSF
	 4JXY4xrN+rZs0gGAED6bf1KGq2xRaumMWUrwX2QM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 7.0 170/461] hwmon: (pmbus/adm1266) dont clobber GPIO bits before PDIO read in get_multiple
Date: Thu, 28 May 2026 21:44:59 +0200
Message-ID: <20260528194651.985322082@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit 3327a12aee9e10ffa903e28b8445dfd1af5307c0 upstream.

adm1266_gpio_get_multiple() zeroes *bits before the GPIO_STATUS loop
and then a second time before the PDIO_STATUS loop:

	*bits = 0;
	for_each_set_bit(gpio_nr, mask, ADM1266_GPIO_NR) {
		...
		set_bit(gpio_nr, bits);
	}

	ret = i2c_smbus_read_block_data(data->client, ADM1266_PDIO_STATUS, ...);
	...
	*bits = 0;
	for_each_set_bit_from(gpio_nr, mask, ADM1266_GPIO_NR + ADM1266_PDIO_NR) {
		...
		set_bit(gpio_nr, bits);
	}

The second *bits = 0 throws away every GPIO bit the first loop just
populated, so callers asking for any combination of GPIO and PDIO
pins always see the GPIO portion of the returned bits as zero.

Drop the redundant second assignment so both halves of the result
survive.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-2-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -211,7 +211,6 @@ static int adm1266_gpio_get_multiple(str
 
 	status = read_buf[0] + (read_buf[1] << 8);
 
-	*bits = 0;
 	for_each_set_bit_from(gpio_nr, mask, ADM1266_GPIO_NR + ADM1266_PDIO_NR) {
 		if (test_bit(gpio_nr - ADM1266_GPIO_NR, &status))
 			set_bit(gpio_nr, bits);


