Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4731332E144;
	Wed,  3 Dec 2025 15:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777033; cv=none; b=R2GqtoYceqiCJ0D/8+C+CM8ydG3P36xRwbw7CGN+ChA8JvR+3+5CIvlULLxHeIYBiuM+47UGiEjsIgLOg5ydPQTiZupHAb20BoIfv+u/R1K813A3Ei1H2qTo7ULVHWiajB5sLh1xQaDD1YZnz48cSHm1EFX5Bzkf5Y3Yumsj2Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777033; c=relaxed/simple;
	bh=3Bg/5uVaSj/nT7hltCLoPzY6EG40f6kUHQVYgwAE78w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=W5PzfetMK5pH/144mJsi3yN5DI5PDrsl2r6Ffk/V8YPldQbM7goC47BKHm2lRMUoHAuH420d9g9E/LqW8CCNbKnQcP6wM0Xr+/IEWqdUSLwzNyx6T6DQE5RpFOZtTpcnCCxOOyCMVyztK5CieEpl9tk6wVFDyc0Jg3BzpQcRXWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9aib0Na; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9aib0Na"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C26A8C116C6;
	Wed,  3 Dec 2025 15:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777033;
	bh=3Bg/5uVaSj/nT7hltCLoPzY6EG40f6kUHQVYgwAE78w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9aib0NavH/vduUGKA0F3ktZoC01aBBN6VamkSvYohcRy41D+LlkZOgb+/NJ4TGju
	 CGdXlcNkp+BGuxyL1EjCMDcZzKUYa1RHzmRr0HVkOma+yfux+dcTo1WAjzhRO/nVV0
	 IQ+agu6m3+cVUAxyN/Byi7ISOz3lhghIag0rS2pg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.17 061/146] iio:common:ssp_sensors: Fix an error handling path ssp_probe()
Date: Wed,  3 Dec 2025 16:27:19 +0100
Message-ID: <20251203152348.701528149@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -503,7 +503,7 @@ static int ssp_probe(struct spi_device *
 	ret = spi_setup(spi);
 	if (ret < 0) {
 		dev_err(&spi->dev, "Failed to setup spi\n");
-		return ret;
+		goto err_setup_spi;
 	}
 
 	data->fw_dl_state = SSP_FW_DL_STATE_NONE;
@@ -568,6 +568,8 @@ err_read_reg:
 err_setup_irq:
 	mutex_destroy(&data->pending_lock);
 	mutex_destroy(&data->comm_lock);
+err_setup_spi:
+	mfd_remove_devices(&spi->dev);
 
 	dev_err(&spi->dev, "Probe failed!\n");
 


