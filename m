Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEE4432E65;
	Thu, 30 Jul 2026 14:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421731; cv=none; b=VckVO/RwRpsYchMeXt/BXhSquEsdoxHE7xAmXj/FjHGeVjh9iVNoa5OEcoRZ5eJzBx3lBnW0zwj/5BgyAqZ1Ei/OM/J3oUo9LvX5REfq7EdODn5yWfsBoe3jpGtHSgpRIkzBDO/Oyy4WNikB4W0qA8i5+E4Sz/hJUc5VKgtxy1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421731; c=relaxed/simple;
	bh=u7VgTGUj2n+PczGq11BhUlASqZ9UP+2o+8myG17eu0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQI7LFT7HTE50F3A9NwehwrxPMNRMemEt7cYAaUmaieNkNnjvQKa+mDuos8vLPHjJI433WVz8inIO2HnM3L3E6Ms6M+vLotHmPdtVtHiFL6nikIG3oj7ZIUWGtUmDipoMBTUZhP1URRpyvl+LcMkx44e0vqNFfBIyh1OVjPnWsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvQ4Jkuh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvQ4Jkuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499051F000E9;
	Thu, 30 Jul 2026 14:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421729;
	bh=kOh0njX40fCXmKWRJbqxpa5k13WqmvJDzdbbEd2XWzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hvQ4JkuhAPSxPGF5ylbWmMJ7mA8AdaByYhJ98uboNPkfJy0ElDYwTWn/kUcHj3aH5
	 BOs4zmDYzdvafmASpY0KzITkFFFHYxIz81ZPBduwvRZ+OhWYcj0GWK4MKhRwQ28xm+
	 6NuMBh4JDQT3d7wPCeH+dVRDWdfZJE1pQ1Y1pU0o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 175/744] hwmon: (nzxt-kraken3) Stop device IO before calling hid_hw_stop
Date: Thu, 30 Jul 2026 16:07:28 +0200
Message-ID: <20260730141448.008016989@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



