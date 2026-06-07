Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5A6257855;
	Sun,  7 Jun 2026 10:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828479; cv=none; b=IAPn15JYsa/X6stbN8ET/od+ZKgTX+1ik6ITK2vIZaUWCCuB6OUBRHdnmrFw8PwMH6zjU02UexvTqKpC4F8fvEMcCzyodjm4V2oHlfFPRliMgEh7fvPpiTYAxuTsu+CQfUW4Y+Gi4vVDY/P5GT/GOkHupR3CKeLOKkFP9sW/pW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828479; c=relaxed/simple;
	bh=dBNu1MdqepYWAB65gpaGeQqtkuVo/+z2PFVmIw5rP5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dQO73h3MLZ1+0UBn/fuIi1ixS2JMAJeXoY+KWvMIyxK1Cfv58ybwO3zBHjQYLHorsh6piP22LpM8U9WZjZWGTWo0yK7o81DVpnOyNPu6qOKUoM91vUwcldbtpVMlIG41EPbO+X21IdLy1SFv/xnt2tBYJBp93RH5BjS+QagCBVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXzKbmgT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXzKbmgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C911F00893;
	Sun,  7 Jun 2026 10:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828478;
	bh=BiLgifYMEw00pbeviRRaFdVNsdcDp0f9bd/+cGI0FWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VXzKbmgTz0v4PBWwyDgMAlgs3DzyuSVfMJNxiLXVUKefSmHIOsBTodMUmn3rB3SSd
	 7Tg+gv5Ww1PiFl17hBzCPS8ouRUvRZj16VtoQc2qgTMckCzju1SeMm4xCXEA/mLYoF
	 q89w+1HrNmOQgiRT+Ee1uE/BYfWFPchi8uhRQbc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 166/315] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Sun,  7 Jun 2026 11:59:13 +0200
Message-ID: <20260607095733.689475237@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


