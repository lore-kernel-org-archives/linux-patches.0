Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49994ED19C;
	Thu, 17 Sep 2026 15:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659657; cv=none; b=UlQazZQNI6h6z4hFhY5bwOfg1P6hoJkp6mHaHtsT3LUv0nr4D8GZZgWp8YjqnqxzytLS2dJ1k7Yw9wBkT86cxvzpxBlX5Z2iFR/eg4+8kNJZ/fivq4ZjT6tVyHK6OUJcFiGXOcZnNA6PcggnnWt2pz2X+T8A1VkIsfHRWU1zuPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659657; c=relaxed/simple;
	bh=PFU/nHU9S8FOO2JBUErpxZdBAbnXblqoukN6+3eN3WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+x1RLT9NUIocWCXD/ea+Lb9W4HhV6a31B0enzF7u4BZuRYy7U8zIhRzIUrPX2j6zRYriFh9vwJHFs+ie4E6SfwxtZqQ61hklzTlYk1MaCQ3uzsWoWtCqN0nC098SkpYzdjEvCSqbgUgeIgEY+WMEX51drAsmA2EonRkWNe7Gc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=de2h8x5p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="de2h8x5p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD65F1F00893;
	Thu, 17 Sep 2026 15:40:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659649;
	bh=BSJhk3UYRCvZD8KenoZsaia3uVrxZB+NX66/3tEXYrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=de2h8x5pu7IbPDZ9zbO+GfHq/HekfhWjWZ3TtUy9EfyMh7c/YGl77O7ToKy00kTDZ
	 zHg+X9VZ4DXshJt3/Qf1NN973XpWkgZQqDeeIcdm5amk7YBoMOSBXQum6Zdh1aZMXG
	 XCGArFDNLtuXpotlCVeZFwfjjETWuAhKiVPHcCzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 325/733] hwmon: (ina2xx) Acquire hwmon_lock in shunt_resistor_show()
Date: Thu, 17 Sep 2026 16:10:33 +0100
Message-ID: <20260917151359.602712333@linuxfoundation.org>
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

From: Jared Kangas <jkangas@redhat.com>

[ Upstream commit 8afc94bfb0ffdfc4a168081785820aa4818d1d23 ]

shunt_resistor_store() currently acquires hwmon_lock to set
data->rshunt, but the corresponding access in shunt_resistor_show() is
unprotected. Acquire the lock in shunt_resistor_show() as well to ensure
proper synchronization.

Fixes: 3ad867001c91 ("hwmon: (ina2xx) fix sysfs shunt resistor read access")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260729162836.89BDF1F00A3A@smtp.kernel.org/
Signed-off-by: Jared Kangas <jkangas@redhat.com>
Link: https://patch.msgid.link/20260820-upstream-ina2xx-in0-curr1-alarms-v2-1-fdce35abc41e@redhat.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina2xx.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 449a72c6b40bd..8dfe5da13cae5 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -868,8 +868,12 @@ static ssize_t shunt_resistor_show(struct device *dev,
 				   struct device_attribute *da, char *buf)
 {
 	struct ina2xx_data *data = dev_get_drvdata(dev);
+	long rshunt;
 
-	return sysfs_emit(buf, "%li\n", data->rshunt);
+	scoped_guard(hwmon_lock, dev) {
+		rshunt = data->rshunt;
+	}
+	return sysfs_emit(buf, "%li\n", rshunt);
 }
 
 static ssize_t shunt_resistor_store(struct device *dev,
-- 
2.53.0



