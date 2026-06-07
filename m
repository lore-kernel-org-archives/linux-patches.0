Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3F4257855;
	Sun,  7 Jun 2026 10:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828859; cv=none; b=eoLzPelC8Nv7Max+9J2OMJlrumMJ2v9BrZKs6uswgciBQgUQ1pn2/CpeVMLwlufuLtSN/+s6CoMWQ92vgt2dzJGIzekniCAWBZWk36ft8gBIcI543ACwjV2PB2GU9995QdFyimPB7HLk8l1cnrE0cus+Tgi8DaWfYvjZzuLxkRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828859; c=relaxed/simple;
	bh=64M1n/Ao7EBgO8OSQ27osvw5wC7WJOelsDSpfpFgeGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cVMWxDvlXzGNswNxVhZqITO9sw+U/kJliB5MD84hIJpMYPyKo578pxSvLvNhPTPP0da06Q+MO0JnbY2XmjJy0J7dtWJTvqVokCY7KSWU79CuszdgF6XUwbapAUgIAW6oYFcZQarmHFxGp0J1kwcedMUrnvWjS7zU4Ao1I30SkzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juEpF4xu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juEpF4xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8A01F00893;
	Sun,  7 Jun 2026 10:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828858;
	bh=ZEU2+KSCqvPGdBxUGB0dRk15txfJqm3UeSH2PovxfmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=juEpF4xu2aR0Xv8eZUqf/mpMInJH3klDEB4lbepWtN2bXeRMCDW1UW5FnJ4sG26he
	 NrASIqobgOh0q7d+mzqPtXWoxXnxarWOLQd2ly0zKlZnldJk/3rB/4uoRzI1Sh79qo
	 L7K2vHqLEVrJIEVkh+MVFtVfC13ZZY4nkiS4ht4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aldo Conte <aldocontelk@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 174/307] iio: light: cm3323: fix reg_conf not being initialized correctly
Date: Sun,  7 Jun 2026 11:59:31 +0200
Message-ID: <20260607095734.107987227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aldo Conte <aldocontelk@gmail.com>

commit 1f4f0bcc5255dec5c4c3a1551bf49d8c33b69b20 upstream.

The code stores the return value of i2c_smbus_write_word_data()
in data->reg_conf; however, this value represents the result
of the write operation and not the value actually written to
the configuration register. This meant that the contents of
data->reg_conf did not truly reflect the contents
of the hardware register.

Instead, save the value of the register before the write
and use this value in the I2C write.

The bug was found by code inspection: i2c_smbus_write_word_data()
returns 0 on success, not the value written to the register.

Tested using i2c-stub on a Raspberry Pi 3B running a custom 6.19.10
kernel. Before loading the driver, the configuration register 0x00
CM3323_CMD_CONF was populated with 0x0030 using
`i2cset -y 11 0x10 0x00 0x0030 w`, encoding an integration time of 320ms
in bits[6:4].

Due to incorrect initialization of data->reg_conf in
cm3323_init(), the print of integration_time returns 0.040000
instead of the expected 0.320000. This happens because the read of the
integration_time depends on cm3323_get_it_bits() that is based on the
value of data->reg_conf, which is erroneously set to 0.

With this fix applied, data->reg_conf correctly saves 0x0030 after init
and the successive integration_time reports 0.320000 as expected.

Fixes: 8b0544263761 ("iio: light: Add support for Capella CM3323 color sensor")
Cc: stable@vger.kernel.org
Signed-off-by: Aldo Conte <aldocontelk@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm3323.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/iio/light/cm3323.c
+++ b/drivers/iio/light/cm3323.c
@@ -89,15 +89,14 @@ static int cm3323_init(struct iio_dev *i
 
 	/* enable sensor and set auto force mode */
 	ret &= ~(CM3323_CONF_SD_BIT | CM3323_CONF_AF_BIT);
+	data->reg_conf = ret;
 
-	ret = i2c_smbus_write_word_data(data->client, CM3323_CMD_CONF, ret);
+	ret = i2c_smbus_write_word_data(data->client, CM3323_CMD_CONF, data->reg_conf);
 	if (ret < 0) {
 		dev_err(&data->client->dev, "Error writing reg_conf\n");
 		return ret;
 	}
 
-	data->reg_conf = ret;
-
 	return 0;
 }
 


