Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F7FE1849D3;
	Wed,  3 Jul 2024 11:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005067; cv=none; b=nTA/cFQzY0vs7VYb5vc9AzSTmUaAquZk2ld1BfYNhY7mwFCHKrHgaPRldpL/d0AlwSrZoI9nXWM1PkJ29Vn2n+hmkPAbfNdjmDMYLRSPLQnS1Uib0ezdx9XHNg8qqHiOxnuJMbGnlzliK7qI+XGnAMeeSDGrs4LNVCiXb+QtrZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005067; c=relaxed/simple;
	bh=j7deTUEGXwiDxZ3iHvSHnA8sPnv0tYGkhzCujdRLwIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4ZsGxU73jp4c+e2gZPSfN5Sms8A+488h02lw5pG6330c8YDIKaOVG6nNvCNfsOlRHY222e3e88ln7A7wANfPZmL1xWjE2L7HH2mqv3qIxc5plHSnCpncDDm7PfXwaK6mAzuu5+2TS2Wv016MjL+nf5GLu+55Nx74NIyFtTwqxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vd04y0xU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vd04y0xU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455BFC2BD10;
	Wed,  3 Jul 2024 11:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005066;
	bh=j7deTUEGXwiDxZ3iHvSHnA8sPnv0tYGkhzCujdRLwIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vd04y0xUBqY7ylXKfxEk9BxTJlPXoNyR1G4fFQxKIUgdrH9tCmL9yATCfxbqadzfY
	 3UjhAItp8mwSSnAlv9GDsfYpm48/zCYYZ5GTyI4BslgLrQHjQnDzrV2iGW2Bn3HF3G
	 /k+pEqrTm7k2Sg30bW8xweVhn9AqLiUMaq6c+k5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 249/290] iio: chemical: bme680: Fix pressure value output
Date: Wed,  3 Jul 2024 12:40:30 +0200
Message-ID: <20240703102913.555954708@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102904.170852981@linuxfoundation.org>
References: <20240703102904.170852981@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit ae1f7b93b52095be6776d0f34957b4f35dda44d9 upstream.

The IIO standard units are measured in kPa while the driver
is using hPa.

Apart from checking the userspace value itself, it is mentioned also
in the Bosch API [1] that the pressure value is in Pascal.

[1]: https://github.com/boschsensortec/BME68x_SensorAPI/blob/v4.4.8/bme68x_defs.h#L742

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240606212313.207550-2-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/bme680_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -678,7 +678,7 @@ static int bme680_read_press(struct bme6
 	}
 
 	*val = bme680_compensate_press(data, adc_press);
-	*val2 = 100;
+	*val2 = 1000;
 	return IIO_VAL_FRACTIONAL;
 }
 


