Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F282A47AF71;
	Tue, 16 Jun 2026 17:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630851; cv=none; b=VSKMbIkTbfYTM5Vvun5TsHh97x4t81UlktTU+tpM7aKpc32KfA/zmLoFczhjOAL4RWhWiOQL9CoQjek8GIWR2SAKHWomuxg1WXedT3InWsxOk71tUkfldrNLoXLq6FyQdfdAu9QECN+Mv50aN1qoLEd151p6FJDhZ0/mzC+VEns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630851; c=relaxed/simple;
	bh=uHw4LBAExPShWwRx1MDZKbUPUfCV+huoDWIS1qzhJ18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHLeipCrIMqUwdVDiEO7oiKjXln9B5B8gTxBLmDtIxHZEQibvV6jR6jvixaoxXwNtFWr7ssHrdwDYk/7RVx6XbHdBdGNKl5039bgvNH+9zCsc9WtxYqBsaKHWDmAOoZqxVijO1jw/HFmfSpPIAzyQ125K1D0eHHfOgzy03ZFilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ApYVCxhK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ApYVCxhK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 989941F000E9;
	Tue, 16 Jun 2026 17:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630849;
	bh=TsX1tuCpTmDn7A9zyShBYtbgjgPyPGWv2sOj6B8wi9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ApYVCxhKFb64HYf/JUgyfFJA/KnAKFOolNEdKZq37OvjKFb5k9synBhcCl8hJRo2S
	 elfiC3tm97cmL2XW3VMS0so42Y9AkzanadgciVmTHhXvYqr11vh20Jvyy4sFyXLfwS
	 3mdQzkks3GnmJinWJ6huclHxc5oxk9fO6DV+hFQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanjay Chitroda <sanjayembeddedse@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 109/522] iio: ssp_sensors: cancel delayed work_refresh on remove
Date: Tue, 16 Jun 2026 20:24:16 +0530
Message-ID: <20260616145131.044162719@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


