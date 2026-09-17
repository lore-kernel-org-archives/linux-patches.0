Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABA615448BE;
	Thu, 17 Sep 2026 15:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659780; cv=none; b=Qm7UXpw0mHsltPuMXdCI8D61r4OCCBLZ7gptiT2MnADY+xtHguCkwIne6HWMaUfzq0VrmZ1LRVxsSqLqMV9Psfe/Ajo4/QDVF2pNueONOBt4UXXrKNmIRrEDX6zXZK6cHnwT3ZAFV5XXbHypqqddO/u98P04MnbAliYjo1Xl/4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659780; c=relaxed/simple;
	bh=LwUU1dxEyap28JMJMPNqfFsvo4Hrk2dUeLxM+fcLBlY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3794RieunmQqdBH09DIn5tb6c01WwhUHGPVyOkdaAztXgTc+Z8T772MpEoVL/kW/K4i0bEPfgJIja49RN8vmHNO95BvEXXg/Q2SpeYZJbWXb+iCxwRYVlNUInOaCsayJ+s7G1ucgnt+zbHLFXxNy29XVA63Sb3MRUFX+5Y1gHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U9iCAjzs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U9iCAjzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB99E1F000FF;
	Thu, 17 Sep 2026 15:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659770;
	bh=LYUlqJfmDSnQEKFN4WGttcRW1g9vqDOC3RX+Yi8O6ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U9iCAjzsAFVO4Sw6+tR3liLjcZa1Y9jGAue1Mg8YK8qLV153/wOnv6JicZtfEp+fL
	 Mpr1csiXyqSIUxuFTpyV4o7E/O25epe/N2qtY7qImYpQbMLrbNRu7hCxX8sC4KcoQ1
	 en/PqSOiT0iD3YaTCIBTzEoNIqVuvQPvDAXIaWf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Zini <alessandro.zini@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 331/733] hwmon: (sht4x) Add missing locks
Date: Thu, 17 Sep 2026 16:10:39 +0100
Message-ID: <20260917151359.773321673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 06b7cf395b1fb652a50db39674a759658fbfba0d ]

Sashiko reports:

Heater sysfs callbacks (heater_enable_store, heater_power_store, and
heater_time_store) are exposed to data races without the hwmon lock.

If a user-space process reads hwmon data while another process enables
the heater, heater_enable_store() executes without holding
hwmon_lock(dev). This can interleave I2C commands and mutate shared
state (data->heating_complete and data->data_pending) concurrently
with sht4x_read_values(), leading to corrupted I2C sequences.

Fixes: 53dfa12299c1 ("hwmon: (sht4x) Rely on subsystem locking")
Cc: Alessandro Zini <alessandro.zini@siemens.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://patch.msgid.link/20260821144916.2889031-1-linux@roeck-us.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/sht4x.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/sht4x.c b/drivers/hwmon/sht4x.c
index 9cace0e8acdab..7a0dc2ed723d8 100644
--- a/drivers/hwmon/sht4x.c
+++ b/drivers/hwmon/sht4x.c
@@ -277,6 +277,8 @@ static ssize_t heater_enable_store(struct device *dev,
 		heating_time_bound = 1100;
 	}
 
+	guard(hwmon_lock)(dev);
+
 	if (time_before(jiffies, data->heating_complete))
 		return -EBUSY;
 
@@ -314,6 +316,8 @@ static ssize_t heater_power_store(struct device *dev,
 	if (power != 20 && power != 110 && power != 200)
 		return -EINVAL;
 
+	guard(hwmon_lock)(dev);
+
 	data->heater_power = power;
 
 	return count;
@@ -344,6 +348,8 @@ static ssize_t heater_time_store(struct device *dev,
 	if (time != 100 && time != 1000)
 		return -EINVAL;
 
+	guard(hwmon_lock)(dev);
+
 	data->heater_time = time;
 
 	return count;
-- 
2.53.0



