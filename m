Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A007C083;
	Wed, 21 Feb 2024 13:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523391; cv=none; b=iPGPfTp8wlWw1gHGPGKHHFh1Vgdu+1oppRaotyx1m45yWOYSP4XgT9+3N3OWRbJ9Mg+rnDDmjyEwYMcTpy1KdpJVQecKejJZfCJ0qEcO309i8MXs6nkOerzG4zpEvykx6QHNaxq0XzVQvf4fmI3wLS57fyYUBHgUN5I4JFQmtXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523391; c=relaxed/simple;
	bh=9Cx1gCdf57L7SD59r0cBYIZv4eDFmOeZ8eaqum9zKXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hAVh9RdnzDYEjBP97B+ucYOyZhsdsLt3sufuQt05KrbR+Z8bd7fNvwj2aD1zFBpl7gNX3MDXsnPQisU5qRk+oCj9J90vGl6RDZ/k5+uJM8Wc/TyYFuyWe6AADgqngMYEQ518vI4Sg+eFI7u7Sxutpbi+9AFpUUfFfsmxIUcwXIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=biIGbieX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="biIGbieX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E865C433F1;
	Wed, 21 Feb 2024 13:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523391;
	bh=9Cx1gCdf57L7SD59r0cBYIZv4eDFmOeZ8eaqum9zKXc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=biIGbieXpilEyF69L98u9D1C3yiHgthf77i7RyxM+/3EN86HCpMPa4F+YY6Pp7my+
	 2v+VOzYVaBNOO/Ghli/J0mXJtouwHurs1U+TBwm2nghqZS6+Vybn2MokqwZ8hF2uY4
	 f0Ra8S2uVPuLg+uJx1q5Q0uP5gyrrINg4V+1kfEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 394/476] iio: accel: bma400: Fix a compilation problem
Date: Wed, 21 Feb 2024 14:07:25 +0100
Message-ID: <20240221130022.586576758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

commit 4cb81840d8f29b66d9d05c6d7f360c9560f7e2f4 upstream.

The kernel fails when compiling without `CONFIG_REGMAP_I2C` but with
`CONFIG_BMA400`.
```
ld: drivers/iio/accel/bma400_i2c.o: in function `bma400_i2c_probe':
bma400_i2c.c:(.text+0x23): undefined reference to `__devm_regmap_init_i2c'
```

Link: https://download.01.org/0day-ci/archive/20240131/202401311634.FE5CBVwe-lkp@intel.com/config
Fixes: 465c811f1f20 ("iio: accel: Add driver for the BMA400")
Fixes: 9bea10642396 ("iio: accel: bma400: add support for bma400 spi")
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20240131225246.14169-1-mario.limonciello@amd.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/Kconfig |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/accel/Kconfig
+++ b/drivers/iio/accel/Kconfig
@@ -128,10 +128,12 @@ config BMA400
 
 config BMA400_I2C
 	tristate
+	select REGMAP_I2C
 	depends on BMA400
 
 config BMA400_SPI
 	tristate
+	select REGMAP_SPI
 	depends on BMA400
 
 config BMC150_ACCEL


