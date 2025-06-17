Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6A1235071;
	Tue, 17 Jun 2025 16:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178269; cv=none; b=JDGV3QM5rN57RE4kx/fKIerd3cJ0zq5v++d+Mf6gOqEgRLRfZKPtB62rwJSWIoz4fe7VFZE3GWmY5htKlkX4ZoqvgY5ss+/FJCvTMVKw2I57A62BqVXorDo/Vzws3UWbvf3yMN3EgsQJOJphHvZeWwrBUs1i6uNngHXT8ATR6m8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178269; c=relaxed/simple;
	bh=FttFKwQxlksZ0cSyGqeVRTGHvhR7luBksFVy0NHwhks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+PwgEsHrAM3XySf2wSSYviZdxmlWXJTSs6e+IYb1PCEbJTn3Ck+AlbQ39FsP671oBtQuNIQg2bz6hEg6EPSWURLoumlHMZvwzHnJ3v1+5r1+k1RJ5wIjkJX0nlwEzCX5vWnbo9S8bmtICzSVD7d+zk/d5k68gPAefHSLMUvzGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMIuiI9M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMIuiI9M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D190C4CEE3;
	Tue, 17 Jun 2025 16:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178268;
	bh=FttFKwQxlksZ0cSyGqeVRTGHvhR7luBksFVy0NHwhks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMIuiI9Mafli1KpzU8XSiPycWQt1oDp6o4EHZni/HTYun0Pj0ladhifXw5XMXU2Rm
	 xs7mOhSPI+9OkT2uFdX7tLQNkUSLW78mmaV35PXad2tPZFKUjjb7S1Ljsp9JCeGbuG
	 PKIl5Aqw5NtrogjCL9KcBsop6RxJ5J2obYUzbsB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Safin <a.safin@rosa.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 436/780] hwmon: (asus-ec-sensors) check sensor index in read_string()
Date: Tue, 17 Jun 2025 17:22:24 +0200
Message-ID: <20250617152509.220481538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index 006ced5ab6e6a..c7c02a1f55d45 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -933,6 +933,10 @@ static int asus_ec_hwmon_read_string(struct device *dev,
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



