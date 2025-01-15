Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C691DB142;
	Wed, 15 Jan 2025 10:54:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938463; cv=none; b=fPCL8ZFQMFrh9+avSmZexrdALQnyOhcGisVXs3gU4CvrGXuGylCjjBRx6oufnSTx1Crgl7MZqcOfOMfEZw9k7sD7CYpeH+ECRL+I/K/Xz33wdPtulG9hBO1jQl0c25uXoccssdeDOp1vOYqvPdL7GZceMVTgi/XsdmYSQuNEcWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938463; c=relaxed/simple;
	bh=ScLmvV2NCDPUXqckpyslVzJUQCmeG2tA5eD9ePq5DXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0gxWFFFR8OvQst5E+lQjgzkWQHAXejrv9YMXJQVoXFny9QVS1TdHM3pxeaLWwTZMEVGsIXEDdvpU3TWIHWH9JHUt3IEh4HsofuFCys9//zTzUXbHKRRNbS7gvUc4cXY25E/7tRRe4zAqOPZOxPPkCVrXUgWQEJ2ciZIErypxpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYPowwgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYPowwgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3252AC4CEDF;
	Wed, 15 Jan 2025 10:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938463;
	bh=ScLmvV2NCDPUXqckpyslVzJUQCmeG2tA5eD9ePq5DXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYPowwgfkEQsUELo2AL2mPC5+NMeejMEfWRdIoGMEkGmOnnD+xmgq1JOsSoirEMsq
	 RYZoltsTftAKMqUzbj4ulG8yrQLN2/btOO3BJ/nLQcN0trTekSPjj+/lztzwsqJThz
	 cqVQpwoeUbo7/A+32No/80AWFBX2KidjcDORdqUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 162/189] iio: adc: rockchip_saradc: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:38 +0100
Message-ID: <20250115103612.868204891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 38724591364e1e3b278b4053f102b49ea06ee17c upstream.

The 'data' local struct is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the struct to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 4e130dc7b413 ("iio: adc: rockchip_saradc: Add support iio buffers")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-4-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rockchip_saradc.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -368,6 +368,8 @@ static irqreturn_t rockchip_saradc_trigg
 	int ret;
 	int i, j = 0;
 
+	memset(&data, 0, sizeof(data));
+
 	mutex_lock(&info->lock);
 
 	iio_for_each_active_channel(i_dev, i) {


