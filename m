Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CAB2EA17F;
	Tue, 17 Jun 2025 16:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177100; cv=none; b=PS0ga8P3sOLKDqEtGPHAXctuHo1RtTVXDW+ePAklOcZkyv3hwoof2q9Zqk/efmzpFXpBqBDgAX56hrVxOs4Jfiy+EgZLF8z/M4CP/Qn/CEKdnIiN+LhwInfrRPws3nvSnf8G8KXzAiW40JiaqPCfvbkE3YeJZtWfPSf+uIbpU04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177100; c=relaxed/simple;
	bh=8B7ZxM2C2Jh9ANu6vqZGiK/L9W9vp+UVDJLfzHRvGV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3SY5kh+H/o34UlRV4gh2wMG5cqkp0TyXNfSpXlMIF6ubdomZzTlZsUDSZV4/64Y5dI7ZPqsh5zjcwpHj1JCqdIxQNzF+ItZu0s+6XJ0cPjbgOQWCDfa0Tnsjb60mpoJb6y0RDTPodKyFzoOk9f7noU1FnlNXKI3QtJGhBXYqT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNO1GcAu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNO1GcAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C67CC4CEE7;
	Tue, 17 Jun 2025 16:18:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177100;
	bh=8B7ZxM2C2Jh9ANu6vqZGiK/L9W9vp+UVDJLfzHRvGV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNO1GcAugemxGtpoHsigFMDIkg+tXcYOwSlPGx8CzmGP0pjGrm415kmvJ8SePzU+0
	 0zRq74OfYCL4pql0laxo41Tlc16aICw6x20M/I9V8a8D7JLcw1dYwYk3HZndHeOvxf
	 2gfy9BqbMA3MUG3OZNGbJ6JSM3JbOKKWoE3PI3sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Safin <a.safin@rosa.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 278/512] hwmon: (asus-ec-sensors) check sensor index in read_string()
Date: Tue, 17 Jun 2025 17:24:04 +0200
Message-ID: <20250617152430.859547959@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9555366aeaf0d..fdc157c7394d9 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -910,6 +910,10 @@ static int asus_ec_hwmon_read_string(struct device *dev,
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



