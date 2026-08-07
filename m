Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C94360EFF;
	Fri,  7 Aug 2026 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113901; cv=none; b=I8B9bF9PSwP5pbJK7JzGroUSwW/Xw2PlzYOcCmUatpeNwtJe3TWAH5TEHIBBNtEqXvl+tot36WQN83UHQ7rpOHBB3TOooFw11R2CRmtI91HbQ8LqtVtx5Ieo7pY0+kyEg+eeUw/hMWBMseVE+wDS06jgvua+ADornFl2E1UxjH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113901; c=relaxed/simple;
	bh=OIjEIprQSOKeFF5sjLUISuax+yXfP+pCLQWzB0F9LYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=THbTEgblypH/fOrT9KFA/EYnsT+s5PlCv2SeaBWnAVN23srhNM7xDzyPKemn7wE4pSdXnmqwMOdz9soie3l4L8/bS4eCA20EI1k/6c48ikKo2/QGBu1ZUnlCItCWocNxe34u18x2hA2SrZKW7yakd0YGC5L+eZ3cyMpKE2zV+Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jmUleTCR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jmUleTCR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00FF1F000E9;
	Fri,  7 Aug 2026 14:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786113894;
	bh=uOMuVhoCFfJPn0UV9l47JItjhDbguKr6MiIRf9NyfVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jmUleTCRD4lK3R6aAVd+NBCqyyol37KCbZL81aWR4gfCn/NI8xkCwlmHBhD/4CV13
	 bHF6yqgRi8/V7soBaFDdcoIGLK2PWtBEQBJ4nVJCvP8PrTNW+gOobGvArx9pN/R+YZ
	 412Q727quNRcURaPGTv7OZqmPNq5HpCJ3G/XMYiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/337] hwmon: (lm90) Only report alarms if driver is ready
Date: Fri,  7 Aug 2026 16:34:33 +0200
Message-ID: <20260807143420.029670772@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit aa9429edf9fc0e90d6f4da19ea4b5495a54ab117 ]

Userspace can read sysfs attributes before driver registration is complete,
immediately after devm_hwmon_device_register_with_info() has been called.
At that time, data->hwmon_dev is not yet initialized. This can trigger
a NULL pointer access since lm90_update_device() and with it
lm90_update_alarms_locked() will be called. This call schedules
report_work and lm90_report_alarms(), which passes the still-NULL
data->hwmon_dev to hwmon_notify_event() and triggers a NULL pointer
dereference.

Fix the problem by only scheduling the report and alert workers
data->hwmon_dev is set.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: f6d0775119fb9 ("hwmon: (lm90) Rework alarm/status handling")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm90.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/lm90.c b/drivers/hwmon/lm90.c
index 511d95a0efb36..45d5a2427dcb1 100644
--- a/drivers/hwmon/lm90.c
+++ b/drivers/hwmon/lm90.c
@@ -1149,7 +1149,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		check_enable = (client->irq || !(data->config_orig & 0x80)) &&
 			(data->config & 0x80);
 
-		if (force || check_enable)
+		if (data->hwmon_dev && (force || check_enable))
 			schedule_work(&data->report_work);
 
 		/*
@@ -1157,7 +1157,7 @@ static int lm90_update_alarms_locked(struct lm90_data *data, bool force)
 		 * alarms are all clear, and alerts are currently disabled.
 		 * Otherwise (re)schedule worker if needed.
 		 */
-		if (check_enable) {
+		if (check_enable && data->hwmon_dev) {
 			if (!(data->current_alarms & data->alert_alarms)) {
 				dev_dbg(&client->dev, "Re-enabling ALERT#\n");
 				lm90_update_confreg(data, data->config & ~0x80);
-- 
2.53.0



