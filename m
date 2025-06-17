Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B1B2EA14C;
	Tue, 17 Jun 2025 15:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175734; cv=none; b=B6tyIGy86u/RPq1QpFPWwk+EqbnsnfV5Yic5symON1N+ykGiLWzLiyWc2i6uvK0ux2c/MafO6B8eRRT7oEsX2jSwSA0ZhTcgygYBgrS7zQUyQTn3ceBRB/CCSE628R/myA5SekC6uQOkrI7Z4FFTmRGZr/vTVhN60lERyYJVius=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175734; c=relaxed/simple;
	bh=t0tmb5aQzr+tvhFR5AgtlVx4btlbGaLO3FELUMGxwqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvKfjmeH/kkNk5jgCguYStyklDlXUvLQmjiRpAUUpgvYi/BftGb/nef4Ps3YNQYtbmu0QR51eswlRr++7bFb65cRVoX36LSL3cx2DSnPAL7cpkjToeQDKNhZ+ZJvL8/5MgIGfQoquMAMQ7+F82ewnwHWVMLBHqC/5jAr2f7M/UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q5ZfFLzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q5ZfFLzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE55C4CEF0;
	Tue, 17 Jun 2025 15:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175734;
	bh=t0tmb5aQzr+tvhFR5AgtlVx4btlbGaLO3FELUMGxwqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q5ZfFLzxOfxSIMKqI1hKTvo8jHjEcG2iYk57nz28o32aNWEvUYgmX6D5XXXktswS2
	 M+UIZk869idlCf+zUmx9H5m+WEHbcWKy2HyqGmHKopyIRyzc/3F+JH8hjNmwfbqACu
	 gEq1MJ0n2fNX56ed7IocMTkaXR8SH8y7QL2Dc++g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Safin <a.safin@rosa.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 204/356] hwmon: (asus-ec-sensors) check sensor index in read_string()
Date: Tue, 17 Jun 2025 17:25:19 +0200
Message-ID: <20250617152346.422649603@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexei Safin <a.safin@rosa.ru>

[ Upstream commit 25be318324563c63cbd9cb53186203a08d2f83a1 ]

Prevent a potential invalid memory access when the requested sensor
is not found.

find_ec_sensor_index() may return a negative value (e.g. -ENOENT),
but its result was used without checking, which could lead to
undefined behavior when passed to get_sensor_info().

Add a proper check to return -EINVAL if sensor_index is negative.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: d0ddfd241e57 ("hwmon: (asus-ec-sensors) add driver for ASUS EC")
Signed-off-by: Alexei Safin <a.safin@rosa.ru>
Link: https://lore.kernel.org/r/20250424202654.5902-1-a.safin@rosa.ru
[groeck: Return error code returned from find_ec_sensor_index]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/asus-ec-sensors.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hwmon/asus-ec-sensors.c b/drivers/hwmon/asus-ec-sensors.c
index f20b864c1bb20..ce2f14a62754e 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -888,6 +888,10 @@ static int asus_ec_hwmon_read_string(struct device *dev,
 {
 	struct ec_sensors_data *state = dev_get_drvdata(dev);
 	int sensor_index = find_ec_sensor_index(state, type, channel);
+
+	if (sensor_index < 0)
+		return sensor_index;
+
 	*str = get_sensor_info(state, sensor_index)->label;
 
 	return 0;
-- 
2.39.5



