Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD53B3B0ADE;
	Thu, 16 Jul 2026 14:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211743; cv=none; b=MQxViPxB7uJflSq0lUtxVwqYgi3J8tHHHg9UJBAlqm+ZYO+e2MC246WLg5Y99VoNqW+jkBiu+/TkTWegm4kh17+QSEKaumBeWQJXJT0pWK0xw6/C28NWyLt+jgyUjZVu2Wr2Q4SgT1XqdMm4c4stkxScFUX47jKeoRZuwM46XNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211743; c=relaxed/simple;
	bh=tW4rDh1IXjxEaBM1Od7OF5+teP1JfylWO3UKWFQ++0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWbTx7SpU49PQp6Z/UowO+LpCjwGXXFm26Ag7bUMjNKCR82xvn6wiwOB20b3Yec+jWVlOcTkp+Hcwani0ToACGMDT/ZydLub4Nxi5Dhg15ETxLPoZJjdB/C8aIEPP7vT82XrsFr1FGEsjoYfWg7LHJb4r7EKORf8C1BVgxQfMtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xrd9HLRw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xrd9HLRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F1FF1F000E9;
	Thu, 16 Jul 2026 14:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211742;
	bh=2u3xCIhMJZY9/QTfgZqOWiRCtGBZe9zdgNgBUkjGW/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xrd9HLRw2fgY0ye9NTzds1DbsRRNexTJTGgwH7g3dK4CRhk2BzflIWgyuaRaldptj
	 huyC/LG4W6UOB4Nmyi5SWJK796AFKJw4oinFEzrkKWP+iqVgyHe0bNAD897rhWvdaX
	 AjgqrhiMA1wosE6z2mJrX82DU87P5XUvJplFwHgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stepan Ionichev <sozdayvek@gmail.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 064/349] iio: light: tsl2591: return actual error from probe IRQ failure
Date: Thu, 16 Jul 2026 15:29:58 +0200
Message-ID: <20260716133034.758043154@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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


