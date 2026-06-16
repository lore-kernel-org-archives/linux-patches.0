Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD35C46AF17;
	Tue, 16 Jun 2026 18:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635499; cv=none; b=k23Kif8WiD+MEDMeyGCe3OOHjnZIkqXKlisLAqp7mRasT8Xeht35EAFEGVHT5b3mAP2BDNxhMmXzJKrPO9rWwNywclF64mRhbxTRhsqHlXkZhTCN42HfoNyBZcrOyrTEvLp6D8nxtLYsV/XPBIeC9wfeHGbB+b6JUrOD/ZT8C/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635499; c=relaxed/simple;
	bh=F70goSYISSC4A3wXW6S4q0SEBMU3yEM57HYionUphCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsYlSyqnv3/CnpNzrBtWYwVmYXcH675u3JQL86a6ggiLFBUqB0D/6hx+tr3nyh9B6HranI5UQU95y07sLSgKpowLn6EHBQwhGX3MhkMUXe33z5cJ5jwa0/o0tcMvgJy8CjKn2wW1yAzK7zlLHTUvYBUj85I63I27pm6ITzUbQpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dIT9+9j/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dIT9+9j/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA4A1F000E9;
	Tue, 16 Jun 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635498;
	bh=CyXt3rrZ3NQK8m56Xvyy6XWifAiKdlwdMH4NOPsTpLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dIT9+9j/4qLmjVdpiaJtVs+lJQM40wXws3iirJxfQKH6cAzZnMmfAEqmSvb9cy+xk
	 n/J9Hrk3ZEsEN74qxb+77xOFIu43aUycPAITtuNproZ6moT2y3mR0oZW9C/4BYTV2b
	 XKtZKoCXaEyPGTZ3TIc9LwAD3Z8baHo7HK+z+6oE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.10 061/342] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Tue, 16 Jun 2026 20:25:57 +0530
Message-ID: <20260616145051.102318300@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -602,6 +602,7 @@ static int ssp_remove(struct spi_device
 	ssp_clean_pending_list(data);
 
 	free_irq(data->spi->irq, data);
+	cancel_delayed_work_sync(&data->work_refresh);
 
 	del_timer_sync(&data->wdt_timer);
 	cancel_work_sync(&data->work_wdt);


