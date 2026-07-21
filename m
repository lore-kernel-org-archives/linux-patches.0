Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3795843B48C;
	Tue, 21 Jul 2026 21:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668482; cv=none; b=UpcpQXwMAmnzMmAHhGL3EkxwRT2rgsPkKGkWoImkXNpUmCS5mukLp97gVqV+WVKt3YXoghZbEtZGT92iE/MK9esE1MQIlRKXObUMOlF1/WQ5Rwob3Z190Mpz9WC9/pdEO8VO2357NRa6jkwULnvHcZXleBQYuFbEN+cLIlmTIsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668482; c=relaxed/simple;
	bh=qnB4n/pZidgrCtpgvHq89J+Lo9ySc4l6HA4V6FCFnV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDpb433VSHUHpx0XWhcj7aiB/Jqjt+9+Iq5U6iGVl7z8CYQCYMTlRCeIsvKxPxRgUI5Akh/FBoVq+unxQGFKBgk5DSFg6NxiBtS+4QsfZl2/QxJkSiPG+JaV3g2vHW693hv9z6LI1v5Q6mPb22ekelmthWVDgypK0s4OcQlG/vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1nrj0X5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1nrj0X5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E96A1F000E9;
	Tue, 21 Jul 2026 21:14:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668481;
	bh=HN45NSPTLrKzsbEPO7ejta80LgWwBsu19axMmCJR5bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1nrj0X5h8ng7sPmLHK9jUZ4EoA1J+0lj0mr0WuBpGTOGEn6VXcMVvnuRCMF+UKNG
	 eHgX2xQvSU74kguqukBfQD9TVH6rgp9ohhguvAM4a28ToeqYp1K3OyBk1xMipWMzxw
	 z1tG94P95INeyjSaYyYKTWUgwmXUm8AtDrQyzeNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Ijae Kim <ae878000@gmail.com>,
	Myeonghun Pak <mhun512@gmail.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.1 0190/1067] usb: typec: anx7411: use devm_pm_runtime_enable()
Date: Tue, 21 Jul 2026 17:13:11 +0200
Message-ID: <20260721152428.843217871@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Myeonghun Pak <mhun512@gmail.com>

commit 0ef7cc27da8b9e315a4a5a665c68c44206f5e559 upstream.

anx7411_i2c_probe() enables runtime PM before returning successfully, but
anx7411_i2c_remove() tears down the Type-C partner state, workqueue, dummy
I2C device, mux, switch and port without disabling runtime PM.

Use devm_pm_runtime_enable() so runtime PM is disabled automatically on
driver detach. Since devres action registration can fail, route that
failure through the existing probe unwind path.

This issue was identified during our ongoing static-analysis research while
reviewing kernel code.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Cc: stable <stable@kernel.org>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260701114006.75738-1-mhun512@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/anx7411.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1543,7 +1543,9 @@ static int anx7411_i2c_probe(struct i2c_
 	if (anx7411_typec_check_connection(plat))
 		dev_err(dev, "check status\n");
 
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret)
+		goto free_wq;
 
 	return 0;
 


