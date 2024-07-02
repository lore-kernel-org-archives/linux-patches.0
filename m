Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5D21BE24E;
	Tue,  2 Jul 2024 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941008; cv=none; b=l3WezR/z3Fk8WcnDBjMgAsWTA3ZrFkT/BS4fDZUDlIDKlIAEDL6UGOjrkDy675yvAzwY0aMDAr6QQm7NaDk5GjOXugj7aQ4ccwoscpUWRl4ayzIN2RUhu4d5fBLKo70fwjhd4kSmKrGxP+JRcJJE0S+0986br3Tuy3kiQ8/BUV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941008; c=relaxed/simple;
	bh=7uZDbg2o/mtG/DW3qTM8Dnr2+CG/tc4phGSfrMwtJaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZbldFZuVC65fqrGrinw1uI2vB1T3qMipKvYmmS/RE85h2VoDvgpuaEhBiPbIJAss7L0iT/wWRGI4/Ma2sPZxKlCW28/LDAWJN7OC7VfvZPX1T4d4gp6y6AvfVsBc9x4kXD/cSpGj4NZmGdgNriLlyo7H9gSStLTwxDUbmDj03yc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1s0Lvoa9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1s0Lvoa9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E906C116B1;
	Tue,  2 Jul 2024 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941008;
	bh=7uZDbg2o/mtG/DW3qTM8Dnr2+CG/tc4phGSfrMwtJaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1s0Lvoa9XB8PfhrPJPmnUnrv0Cvi3pVu3/FRQkzHTa0XfkI1OY+p/v6TnwJI/Uear
	 NhxSc+2zof5EM0o6iwmtCX5PO5olyHYka3vTuHd5fu8WGfaqecbgr3pgMvJ7B01TYq
	 oz0lCLqto4twmdoJoRR/JjPiswxRqT+Jsx/2IH8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 100/163] iio: chemical: bme680: Fix pressure value output
Date: Tue,  2 Jul 2024 19:03:34 +0200
Message-ID: <20240702170236.847294003@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170233.048122282@linuxfoundation.org>
References: <20240702170233.048122282@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 


