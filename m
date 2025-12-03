Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5839A43ABC;
	Wed,  3 Dec 2025 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764776718; cv=none; b=ntrusbgIcdbZYtwjOiHWrr1an36gugn3ypLcMNKEVw3LVKUARDuAEnrkc9YpjBFA7/XKEM4D6uLCgNziaKbgTMceA2c0fi9N5MvtTeGwMbrU6QYcrM06Kw885G3Jh1kkyEvvywFunVCQBXX7EPoBX8hTwyeZr3cekF8thw5nIMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764776718; c=relaxed/simple;
	bh=YTnzj3LUDSMBK43iEdXY5x1nY6Zhpy6P33syQ8WkQNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LgHwxDo+pkJv6Lw6Lxl423UIL2M1IhS/2Bk99SjJz3YRdomWq6ITyBSVgM/Xbgl1ZobAMT88XeIvwNqFcXXbNbAFoeklB7C8gQiDI7EDzQJhFHcNQ8Uj/4orq/wIuP6bO2rpJuw/GpvZY+7LJSJmOYNeySVVe+CVIgDqE9Kbfyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XpKMCIuA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XpKMCIuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A0EC4CEF5;
	Wed,  3 Dec 2025 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764776718;
	bh=YTnzj3LUDSMBK43iEdXY5x1nY6Zhpy6P33syQ8WkQNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XpKMCIuAtAhvQPb+ygnm4KOqFoGs+IJs7OG2BFnqA9a1ftPJUfBTjXT6kP+LWobWc
	 tN5tG/zi1UblQO2j5oeCsW13LduF7BqDbMEP3qsBcFca45mnUso53jUhx8sGawAzov
	 bXI1Euwz9N3dMpaxwMRP8XV0YCZh8Sfhsa7Mz2a0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 266/300] iio:common:ssp_sensors: Fix an error handling path ssp_probe()
Date: Wed,  3 Dec 2025 16:27:50 +0100
Message-ID: <20251203152410.489499226@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152400.447697997@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 21553258b94861a73d7f2cf15469d69240e1170d upstream.

If an error occurs after a successful mfd_add_devices() call, it should be
undone by a corresponding mfd_remove_devices() call, as already done in the
remove function.

Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/ssp_sensors/ssp_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/common/ssp_sensors/ssp_dev.c
+++ b/drivers/iio/common/ssp_sensors/ssp_dev.c
@@ -515,7 +515,7 @@ static int ssp_probe(struct spi_device *
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "Failed to setup spi\n");
-		return ret;
+		goto err_setup_spi;
 	}
 
 	data->fw_dl_state = SSP_FW_DL_STATE_NONE;
@@ -580,6 +580,8 @@ err_read_reg:
 err_setup_irq:
 	mutex_destroy(&data->pending_lock);
 	mutex_destroy(&data->comm_lock);
+err_setup_spi:
+	mfd_remove_devices(&spi->dev);
 
 	dev_err(&spi->dev, "Probe failed!\n");
 


