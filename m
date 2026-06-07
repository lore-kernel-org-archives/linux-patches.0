Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324342C1595;
	Sun,  7 Jun 2026 10:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828823; cv=none; b=oUxsSnVfJIp1ICkfuCC4FJP5VPX696PwYcD+j/vO+pTw6999nFqG3UCEfwUM0KcjjqivzQ18zkjBJdzcQ4C4s29/8A9TbdCWBlUIDjZV4OZFmidBjwIN8xWbxQWLRvnMA/VZ9n6zl2/p9w/8mQAigAUTbruJUmBsM5let773NVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828823; c=relaxed/simple;
	bh=TwX6Af6RpAPViHpjsjCdAxtTHCHzFdYTjB0VY7BXr74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sr+mThQ8lIZAnqARCHnO1cQovbkiGK3hkMAQvfujzbVtjWeg1pg59DlbCSgzEnlSRLOKfMz4bUpuUUgkEAf3lj2bMcnrqw+rR/Zqp8Q8kM73lybpVoaks3X2iz86sOIhodNDOQkM4vp9tLwQWkFngXT7JcIvROsw5G9JeQnkSlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylpwTID0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylpwTID0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817761F00893;
	Sun,  7 Jun 2026 10:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828822;
	bh=TWxyOt3nWlYSW9B/U8c2lSBtIL4neBS+DgBFzUv+dWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylpwTID0AMJmqlPVXLgwpyU6HO+2NgC1S1ulfkRYHmZ8wQSdTWzXRxO/p6JSmXvlN
	 cCMrOqNDlhAMNpGI0Kk5Cf8MB6Vq5pYKNpr5jXoKQnoDGysOtsS43PB4PVqaK3P62H
	 2beIO99UjyTk7lcKyc9bhM5V0W7e+QeqiJUk+Cs4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 171/307] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Sun,  7 Jun 2026 11:59:28 +0200
Message-ID: <20260607095733.999521276@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


