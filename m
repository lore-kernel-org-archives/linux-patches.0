Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744F92D3A69;
	Sun,  7 Jun 2026 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828522; cv=none; b=ut+QSF1n6UVetf/s4C0/rHJjbM+D9Cus3pxiNk+FKLzdtTE1Isa5EKDkOoA+4bjAxVO3SXpbrH2s3v6C4LOzAKQkJyZakFhjJPv6qcBYptAZeIITJkc30OoswhlY5kpcbsWtKbB/2jTowGcy3Y6j6kBjYFPKCxRBlgkxMASp+RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828522; c=relaxed/simple;
	bh=qmne2RHxWv8ZXW/BPfDHrC8v/eBc+DkYlEi0MlJUJsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dj8grAyph5FuZG8HTHx+KS5uxbzfGi4i/6lfYNI4xANiubboXB30wFrhJb85m47hx+RbWvTIey7Zw9AENl6R1SQe4hO0Tdltqdfa/Bdl7s5omObfi67Mnc8yzIKhHYqtp61P/Vr1kO7K8QfDPzS1NXnbjkNWc3zTkeL7zHrdjdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQPNOucT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQPNOucT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CC01F00893;
	Sun,  7 Jun 2026 10:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828521;
	bh=gZ/W1DIrpOw1QAxCtiPYCkFGJBke7u7Cv1Ukjnz8jJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bQPNOucTUYSdu3F1qONx4Gv1aHsMv9Bw9OHriQbVQgM6wKWu29P8FNf+srD8+9AqR
	 a97bBZvTJQRC3FWMqPqI4SKMsgL0P20lx2J1Tl65SwZAcpg4h3wiSvKNMa4MrTz8l+
	 cNFLGxBCLoGyEBkGS45Fb8UUldJxRDIqA9AeUFZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 190/332] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Sun,  7 Jun 2026 11:59:19 +0200
Message-ID: <20260607095735.046511257@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

From: Sanjay Chitroda <sanjayembeddedse@gmail.com>

commit eedf7602fbd929e97e0c480da501dc7a34beb2a8 upstream.

The work_refresh may still be pending or running when the device is
removed, cancel the delayed work_refresh in remove path.

Fixes: 50dd64d57eee ("iio: common: ssp_sensors: Add sensorhub driver")
Signed-off-by: Sanjay Chitroda <sanjayembeddedse@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/common/ssp_sensors/ssp_dev.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/common/ssp_sensors/ssp_dev.c
+++ b/drivers/iio/common/ssp_sensors/ssp_dev.c
@@ -590,6 +590,7 @@ static void ssp_remove(struct spi_device
 	ssp_clean_pending_list(data);
 
 	free_irq(data->spi->irq, data);
+	cancel_delayed_work_sync(&data->work_refresh);
 
 	timer_delete_sync(&data->wdt_timer);
 	cancel_work_sync(&data->work_wdt);


