Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37FBD363C77;
	Wed,  3 Dec 2025 16:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780310; cv=none; b=X+ky3nr7RPz1S5uHx0oEL7GQHzj2nnj64LCw/vSI8zNGh3LsrsrVdkTBey/Q0ix2UOz9xRtDG8R1ap7TR9mewdysPXAhyhDWVvwutqNrcbkq9alO1zdyO1Po5EGG4ClA5hvXIgeDmNXLMwfj0tYJgbmMIIrKyq6rw6NuZKMhtWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780310; c=relaxed/simple;
	bh=xToGr4c8aL+pyxSVG82dpV7te/mioFnx8H8ZyFEd3Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qo3V/avfpEj7D84VQofYVoMPGm3L7tbBytoBVXDSKY3PfO7qMVTrD25eUIC2LzwTuG/PDbObwv8kGTJW1QWsyMQvzoYNTPzyziAx3XF6R5mm15OYOdnoXH9ISmWDOKq77YsA1zYo3F0s9iclEeqnNqEInqrjLbfe8mUtQtNeeE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NTBBvGSv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NTBBvGSv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98818C4CEF5;
	Wed,  3 Dec 2025 16:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780310;
	bh=xToGr4c8aL+pyxSVG82dpV7te/mioFnx8H8ZyFEd3Pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTBBvGSv7z0Di5LYgyGXiRC1zUt/Hsugt5jpPQb7CasoSEKTCvpb/0/Ek8a8+0WGw
	 3nDFsU0TCNkwgWVmWbNHayoOPz+bfT/oqhNJM8K3PGox27g15dRADbHiY5s+XHPEOp
	 +uXL63bDeA1QLMRCbRCuwZ3f0Nzt6Tva4JE3bDY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 518/568] iio:common:ssp_sensors: Fix an error handling path ssp_probe()
Date: Wed,  3 Dec 2025 16:28:40 +0100
Message-ID: <20251203152459.686369339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


