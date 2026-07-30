Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0323243F0B5;
	Thu, 30 Jul 2026 15:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423883; cv=none; b=erRkuriv9eRjl1DWvYBwoM7pSpZUYoKqgMmBlewhWvPCWxv4eO0itilVnl0wxE9shYb8i+5V4DYgbS7CV902dy+4EJmiXEgt83mqoBRITB71VIvZm3fcc1ZN8TAWwbvy0I4S+PtKFY03W3Ncy+pAPf6dryNuGDXMaBvYXdJxGGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423883; c=relaxed/simple;
	bh=X8kTRMC6uKKqvTAv2tXzwMOCvVYk5bWKnvBOIngIWC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPiNdUMdOOzskDHagopFLiYAcs2kRnZz5clR/h8ueByuskZVMZmb/qdI7/L/ofwf8Zkvp5twEYRy6tlfqfr08lba9S48TSyVo01uTBK9uIwwGH/njSxDJvZiiGy3Ykx5WB97jWmDOgrwNnEe0GIkefyGHoZ35Qggxs5GwaSEhpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msRWIAa1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msRWIAa1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585E41F000E9;
	Thu, 30 Jul 2026 15:04:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423881;
	bh=uoNMmdRFJVEoEef8k5UfRs+wbWfzRSckR9Epxm+Utcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=msRWIAa1TNRCl00/Q/IsORe/Y828depHUwnYIITWxBVGGh6jwyJqVRNJRbz2Lw+F2
	 AH5TBiEKtJ3vtBUYEbA6vwDjhEFQlHUhS0oUYcTPRUZVQIx4EbL55WwpeknL4mL2p0
	 FTqka8EnB7qvmp7GW9PgYg0bvlfpaFrZcnSIEIwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 172/675] hwmon: (nzxt-kraken3) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:08:22 +0200
Message-ID: <20260730141448.793726333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit f151d0143ac4e086f92f52328ebdbdc50933d8ef ]

Calling hid_hw_stop() does not stop the device IO.
This results in a race condition between hid_input_report() and the point
immediately following the execution of hid_device_io_start() within
the driver probe function. If the probe operation fails after "io start"
has been initiated, this race condition will result in a UAF vulnerability.

Fix the problem by calling hid_device_io_stop() before calling
hid_hw_stop().

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: f3b4b146eb107 ("hwmon: Add driver for NZXT Kraken X and Z series AIO CPU coolers")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nzxt-kraken3.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nzxt-kraken3.c b/drivers/hwmon/nzxt-kraken3.c
index d00409bcab93ad..05525406c5fbb5 100644
--- a/drivers/hwmon/nzxt-kraken3.c
+++ b/drivers/hwmon/nzxt-kraken3.c
@@ -948,7 +948,7 @@ static int kraken3_probe(struct hid_device *hdev, const struct hid_device_id *id
 	ret = kraken3_init_device(hdev);
 	if (ret < 0) {
 		hid_err(hdev, "device init failed with %d\n", ret);
-		goto fail_and_close;
+		goto fail_and_stop_io;
 	}
 
 	ret = kraken3_get_fw_ver(hdev);
@@ -960,13 +960,15 @@ static int kraken3_probe(struct hid_device *hdev, const struct hid_device_id *id
 	if (IS_ERR(priv->hwmon_dev)) {
 		ret = PTR_ERR(priv->hwmon_dev);
 		hid_err(hdev, "hwmon registration failed with %d\n", ret);
-		goto fail_and_close;
+		goto fail_and_stop_io;
 	}
 
 	kraken3_debugfs_init(priv, device_name);
 
 	return 0;
 
+fail_and_stop_io:
+	hid_device_io_stop(hdev);
 fail_and_close:
 	hid_hw_close(hdev);
 fail_and_stop:
-- 
2.53.0



