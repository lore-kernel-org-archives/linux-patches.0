Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5050437473A;
	Tue, 21 Jul 2026 21:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670954; cv=none; b=ktH47CkuGiJLnUKKeGv3s2pCv60d3Zhc8fz1Bi605sJOt+Xz5pFYKh0/NkdEmVM4PDV+gvBeqbidAlb7UO90jd/Do+yxsdRToarL3Ddib7riNlaEQ7l3POJlOmD9pqguFafGg4eEb6WO3Ba3RWr3bN62SAyAiON3NlFgnfTDogY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670954; c=relaxed/simple;
	bh=zeItRSjvZRoDgwgMiiQjSsHfkuh71HIqIFRnenRD5Go=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfjhDqw7eS7P0MdTsqzEJbkOsAIcMogBsiqbXFwBKX+2j4xLS7v538t+Ad/zDTo5yWdLzrgbrhKzGBjSWZs8ayasvAXy1HvejqhxWIBl74Au5qLHFXOI9PnL/gqwLzQV7WeQB6fI83wZI9OiNLSb8NQISb5w8927pbK4aVFyyjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXRY+ZGC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXRY+ZGC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B61811F00A3A;
	Tue, 21 Jul 2026 21:55:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670953;
	bh=wp0j1WB/DiYR77OcrOmgJNK4yQoKzrJ7zVFZjMm0OK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXRY+ZGCWkiB7Ra6mKKzdi3i4AbRHM72WMJ6gnM0YSm95f6TV0lt4CcJhtJxb2p2K
	 dWMuTWHJmWHJyR60E+YeH5OIcuG06C1E0NahTHMuI8zUOfzWzk4r0Zk63IFhPFoWcI
	 nIeo2GmkA8WCs1SsfSXgHBbd2teh1Z4QxfW/0v7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 062/843] iio: light: tsl2591: return actual error from probe IRQ failure
Date: Tue, 21 Jul 2026 17:14:57 +0200
Message-ID: <20260721152407.383415496@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stepan Ionichev <sozdayvek@gmail.com>

commit a00ffd15674bfaf8b906503c1600e3d8709af56c upstream.

When devm_request_threaded_irq() fails, probe logs the error and
then returns -EINVAL, dropping the real error code and breaking the
deferred-probe flow for -EPROBE_DEFER.

Return ret directly; the IRQ subsystem already prints on failure.

Fixes: 2335f0d7c790 ("iio: light: Added AMS tsl2591 driver implementation")
Cc: stable@vger.kernel.org
Signed-off-by: Stepan Ionichev <sozdayvek@gmail.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/tsl2591.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/light/tsl2591.c
+++ b/drivers/iio/light/tsl2591.c
@@ -1141,10 +1141,8 @@ static int tsl2591_probe(struct i2c_clie
 						NULL, tsl2591_event_handler,
 						IRQF_TRIGGER_FALLING | IRQF_ONESHOT,
 						"tsl2591_irq", indio_dev);
-		if (ret) {
-			dev_err_probe(&client->dev, ret, "IRQ request error\n");
-			return -EINVAL;
-		}
+		if (ret)
+			return ret;
 		indio_dev->info = &tsl2591_info;
 	} else {
 		indio_dev->info = &tsl2591_info_no_irq;


