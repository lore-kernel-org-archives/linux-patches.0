Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4B514D37D5;
	Thu, 17 Sep 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665843; cv=none; b=trkiPO62f/3G7y3zfeTcuNcg1iUlUs/ONtY3N8q2mi0fjodeV8BJxsV+HAD2H+fPZiffq5c9JpXF5UnWq0sNec/QXPmaWnjAciYutkbUMee3QYH+wp5XEIlOkIREE8pTVCm+GKaK3p9JIwj3kupn06a7xKrwQu0BQbXrMHCU4V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665843; c=relaxed/simple;
	bh=4etKhEjTZsitI2sgXE+lNemDqLaI3+BkN749CiT8W3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KPnVBBWcHF94TqjGQi50rfuDPn3p6NjkgKFqeFVrH+a/QakXllRWc7HLkyWif157M1u5KDWjYv6QWxbPBl88DeQwL9F0hseCSHcraPjotMb42E9SlM+FTCx8Pj2+wbaG4R0NVDkNKAEsQFVClZBnpy3s7oWVf3oNSApDmETrctM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qShd5g2k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qShd5g2k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D20DD1F00893;
	Thu, 17 Sep 2026 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665841;
	bh=1E+4qENheGHAhfwJ5t/cttxqLGuMIN4Q9uA/0Za2nPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qShd5g2kM+QXQtDtzJsDXkpFQVZbL60xns0vCjCuQ5yPLe4Psapc7A/fdUSW3WV5S
	 5x2nmFg/M+lb8y0fvBHa1vHqbTJzkBxhSmHBUqlKXw7JQgUYCPGtI1ZbDeyqbnLnjG
	 EsFMOR7eXneXRt7xC/b4V+nSl+DRqpWwUWbqQVII=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Jared Kangas <jkangas@redhat.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0838/1250] hwmon: (ina2xx) Acquire hwmon_lock in shunt_resistor_show()
Date: Thu, 17 Sep 2026 16:10:33 +0100
Message-ID: <20260917151614.665747661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 9c2dc9c0fd4d5..cde119054f301 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -891,8 +891,12 @@ static ssize_t shunt_resistor_show(struct device *dev,
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



