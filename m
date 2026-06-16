Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B1247A0B4;
	Tue, 16 Jun 2026 16:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628704; cv=none; b=YSNWsE1wBtv0mTYoSxTTAKzxxB71V0OfwEUpG8sLGdLYvnD0sXNVdOd+xKeMEtbyzO3Hjq4wqtm7j+msgjx6XWNyBQCNGgKZF31oQggRpraXwhjuvqGx0PpRehTZgamv6l0TChrdkw2qjnkhisANQw5ohhZawo3raMVSJyxtr2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628704; c=relaxed/simple;
	bh=XZzblt73r8ndRiJUqTW76baVAiUy5skX9EQQcyNfiUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+As0OZocVrbjLSr8PoDRh1JGZbxph6KfHlxGUuWVi4Bh1jpkani6nZNacADgs8OjRwzlFDB1cSnqsfY3+6wxwyGpIr9eJMzBPerUwhyZO46lfhgyo7B5BI6QPAaaf+sEs+Lu7xzogubHF74xFGivviMsHhuhTag1VSnxWKpB2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wGN2Q6M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wGN2Q6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732D71F00A3A;
	Tue, 16 Jun 2026 16:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628703;
	bh=XurB3jmes1k3jCXDR+lR3k2LQZFoD5EnplXEzlnqJ44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wGN2Q6MB2Ph3/XlZsQrG+sthbQbyIG4quuvGX69LEfNx6nNBoztfaVBknyIYT9CU
	 X3DKMvurMxHhpnSk++kIJhoDHC8TPu1tObfWTjn165MsAo3wD6VZrFVFuSyK5BBWA5
	 vUUltB2KwN0M6ZPqBmYWXfZK7NSDqUs5YLU+475w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 114/452] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Tue, 16 Jun 2026 20:25:41 +0530
Message-ID: <20260616145123.709935116@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 
 	del_timer_sync(&data->wdt_timer);
 	cancel_work_sync(&data->work_wdt);


