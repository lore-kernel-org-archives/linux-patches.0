Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F6C222571;
	Mon, 23 Jun 2025 21:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713987; cv=none; b=f4KQ+uxjhNAouUPvSXsq13y6fBqcbpbqr7XXLGi33OjyR4QHc/TpbSfaVlLIrhMdh4Uf7WLMTDhI8KZIZTODRkLUeL6sTAjb21JjpDSSp8Wogq/xVlTnvipsXmrdtSIyIBNDazLiM7MpYxrc6ImTqSocyLXvhD5CXx8QRUubXt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713987; c=relaxed/simple;
	bh=/kY9JAhOjZT5XFBsG+fplxM92l6/MLSAmB1KOe5hbLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HVDkzNsuJ8prRLAGo289RQFuPCoAtdAdPDZ1wDCH3QJ59i4mCJS5WcPQKhcuy781uoQmbkf0bwOXAQ6qZMqingJNKBc6qNTCm+GiWIVMZyn2pp+m0aCWBItU3Xr4lhXKhO2EDtSMuI9jjybO+2zA/jr3MdcWvq1Duyg6LP+lmQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gA0ASY7n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gA0ASY7n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46BA9C4CEEA;
	Mon, 23 Jun 2025 21:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713986;
	bh=/kY9JAhOjZT5XFBsG+fplxM92l6/MLSAmB1KOe5hbLA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gA0ASY7nN/UwmeRdZWuTeRtrnQ2oO5re0MX5CHj2TqthA5/cLUbp0xFxUjsjJ0flr
	 gu4vYoOeMF/20cL6fUn3fx2fn/wmgqcLF2KRAxNZbgDlB87U/oAKXLB/w2tOFSIeJO
	 kyfN0F2nA/z0JXbMgp1wnoWzo9bLcKQxsumTZ2AA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Safin <a.safin@rosa.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/508] hwmon: (asus-ec-sensors) check sensor index in read_string()
Date: Mon, 23 Jun 2025 15:03:03 +0200
Message-ID: <20250623130648.682926546@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d893cfd1cb829..6f20b55f41f2e 100644
--- a/drivers/hwmon/asus-ec-sensors.c
+++ b/drivers/hwmon/asus-ec-sensors.c
@@ -839,6 +839,10 @@ static int asus_ec_hwmon_read_string(struct device *dev,
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



