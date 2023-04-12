Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94912F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:37:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4638FC433A1;
	Wed, 12 Apr 2023 08:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288658;
	bh=dema/5x0PSFWTfcuAlacX0CCwvmU15KutlJWiKA6nzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBB1UKGwKmwmkKYhkuMmFlhnt+QYoPw9XKBFm1KuS0M0X2la2JObcqbTItpjT8wRH
	 Zumx97VRKvQPkSDoI8zEQ//Rz/wicwGyPpXsrMLRtJNKYafPOCK3oqqsccLnrpLimY
	 EzTZBszpD72dAxVHhMyy2lGWb1FykHJASYbkNXgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 62/93] iio: light: cm32181: Unregister second I2C client if present
Date: Wed, 12 Apr 2023 10:34:03 +0200
Message-Id: <20230412082825.751326991@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 099cc90a5a62e68b2fe3a42da011ab929b98bf73 upstream.

If a second dummy client that talks to the actual I2C address was
created in probe(), there should be a proper cleanup on driver and
device removal to avoid leakage.

So unregister the dummy client via another callback.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Suggested-by: Hans de Goede <hdegoede@redhat.com>
Fixes: c1e62062ff54 ("iio: light: cm32181: Handle CM3218 ACPI devices with 2 I2C resources")
Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=2152281
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Link: https://lore.kernel.org/r/20230223020059.2013993-1-kai.heng.feng@canonical.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/cm32181.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/iio/light/cm32181.c
+++ b/drivers/iio/light/cm32181.c
@@ -429,6 +429,14 @@ static const struct iio_info cm32181_inf
 	.attrs			= &cm32181_attribute_group,
 };
 
+static void cm32181_unregister_dummy_client(void *data)
+{
+	struct i2c_client *client = data;
+
+	/* Unregister the dummy client */
+	i2c_unregister_device(client);
+}
+
 static int cm32181_probe(struct i2c_client *client)
 {
 	struct device *dev = &client->dev;
@@ -458,6 +466,10 @@ static int cm32181_probe(struct i2c_clie
 		client = i2c_acpi_new_device(dev, 1, &board_info);
 		if (IS_ERR(client))
 			return PTR_ERR(client);
+
+		ret = devm_add_action_or_reset(dev, cm32181_unregister_dummy_client, client);
+		if (ret)
+			return ret;
 	}
 
 	cm32181 = iio_priv(indio_dev);


