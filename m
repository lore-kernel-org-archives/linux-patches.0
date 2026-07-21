Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A03B6351C1C;
	Tue, 21 Jul 2026 20:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664889; cv=none; b=E2Z1jbgjJWRCVBLtARhGiiMX0sGc6DkTu3h83KKvoJbgCsBvGUDAsOc0Wqm65hryqycYWgssfF5q5xJJog/ffw6g4EZKYcsxngT9MDvVCInkX8120sPFuXjGiRgyHZGkbGUDNAGdnwfhmsBhyz1bb0AO9wLzCK0+IDK8alvyxxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664889; c=relaxed/simple;
	bh=kRd/KdAj7PmfSJekHtuxga2z7v+1zIH68IxdOZDs7Ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLaIFyDkx8WdeGpOJRgn8F+4INOFvJcs1Z3ieFOTtiDFROljNYf9kfr38bwSJibnqrsAGZdEpLJzGKBhcjSUT+SrhX6pP8iBLGB5Cbu3G3eudbjQ63YvYhQMA+WB5DSkzAR38Ga61k4QhTN01VDWk8f0/CXG1GGHQNg+anL9aoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJQTsmwf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJQTsmwf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113971F000E9;
	Tue, 21 Jul 2026 20:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664888;
	bh=ty+APxxq4VS1LLJOjdm3BA3a8NzeKsmZ5+3JmvvHmRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZJQTsmwfJk/2FW6Wna8UPA7HRGwj6qxoupPSGFoK1TIkR6SJRUpmnaV22lZl34hjL
	 HIEUes4/nvmDAlNoa1QIxJbKY7V84wOe9jHiMdWxUnNRgmPaVF1Wu9je0HcL94bbGZ
	 aJHNWJF+LhkhLD6Fn01ho9Ltv3VT0gIy6lODMBOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0098/1266] iio: light: tsl2591: return actual error from probe IRQ failure
Date: Tue, 21 Jul 2026 17:08:55 +0200
Message-ID: <20260721152443.996256232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
@@ -1139,10 +1139,8 @@ static int tsl2591_probe(struct i2c_clie
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


