Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0DB32D0C4;
	Mon, 27 Oct 2025 19:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593446; cv=none; b=gXhNVuPnh+pISi3LQZASfZfWiZyrO52T2TqQihl1mCWCL6Aq+fbmJCC1o+B+9tPlNAjLqms7MWR6boGb3XoHwwoQg2Q+WlI5FFnLsccPLVvLsRBgpHdCf3GUXj6AFS2S5m3RO8gseo4apTH8DdDr4Rbr3Q+icH72JTMp6h7UWKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593446; c=relaxed/simple;
	bh=6fGQ5jucbnJkdgvTMh6e0WkB3ikehg3geC4dQ/apsrE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJRpo3jHL4eNdVeNDd+YNlNBDc9IUj3OAH51+HCbwPKbJvq+ygn2dPgd+VmqwHeW9/omietqzgQ8bykpcYaGXB94zT3EpobFSFehT4VXwldfti6TNEfysiUc5wZncPV+4znGl914lyKxry0YoM+VrOYLtPEFe4srsnMQHpFvb3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7cpuSdS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7cpuSdS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFCF0C4CEF1;
	Mon, 27 Oct 2025 19:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593446;
	bh=6fGQ5jucbnJkdgvTMh6e0WkB3ikehg3geC4dQ/apsrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N7cpuSdSIL93mjN52TSQuO8sCKbeo6Z78V2+WeygLHxRa5Lih3Uk4ZvVKJ+4H9xIA
	 zwoDaPeVi2ydNyO4eMaepJXnbWm0mcj2v4GdTdCj1ExK+wCB1VjZrclxRHybf7oZGn
	 epdNZdp3vY/PNM1FtyakY6Ru8Frbqp5Mb4EXrjb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Thomas Richard <thomas.richard@bootlin.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 136/184] hwmon: (cgbc-hwmon) Add missing NULL check after devm_kzalloc()
Date: Mon, 27 Oct 2025 19:36:58 +0100
Message-ID: <20251027183518.608924188@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit a09a5aa8bf258ddc99a22c30f17fe304b96b5350 ]

The driver allocates memory for sensor data using devm_kzalloc(), but
did not check if the allocation succeeded. In case of memory allocation
failure, dereferencing the NULL pointer would lead to a kernel crash.

Add a NULL pointer check and return -ENOMEM to handle allocation failure
properly.

Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Fixes: 08ebc9def79fc ("hwmon: Add Congatec Board Controller monitoring driver")
Reviewed-by: Thomas Richard <thomas.richard@bootlin.com>
Link: https://lore.kernel.org/r/20251017063414.1557447-1-liqiang01@kylinos.cn
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/cgbc-hwmon.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hwmon/cgbc-hwmon.c b/drivers/hwmon/cgbc-hwmon.c
index 772f44d56ccff..3aff4e092132f 100644
--- a/drivers/hwmon/cgbc-hwmon.c
+++ b/drivers/hwmon/cgbc-hwmon.c
@@ -107,6 +107,9 @@ static int cgbc_hwmon_probe_sensors(struct device *dev, struct cgbc_hwmon_data *
 	nb_sensors = data[0];
 
 	hwmon->sensors = devm_kzalloc(dev, sizeof(*hwmon->sensors) * nb_sensors, GFP_KERNEL);
+	if (!hwmon->sensors)
+		return -ENOMEM;
+
 	sensor = hwmon->sensors;
 
 	for (i = 0; i < nb_sensors; i++) {
-- 
2.51.0



