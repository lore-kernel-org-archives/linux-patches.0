Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D988A22969A;
	Thu, 12 Dec 2024 16:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022089; cv=none; b=JNsFpystnaSmD0lhFZ0I5ioNn/9+aSTXNh7z4TSDnDjSDZ9BL79T5XB1mgQPK50yRvm7Ht7R3iFOEysm/030MGKrgpAbMz1jDK2ZSb1XxTs+6mFbjK5PD8dcpqfrpWnLSTeEeIQYXnqi1VKyGQAhqoddU8CDr7myY2o3UNgcDes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022089; c=relaxed/simple;
	bh=b9Pvx7ITH4wym343JjBu3lbbXBbasLGhBlWAcA2BZd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pGZ0aXg4w41ikzvUm8go7KK+PIAyX1YFeVPil+BmCmhtIiObwAnIIwM7UTWUztpgT2Uv6NL2tct4+2U7FubbIO/WvxQmCqpWXH1Aj7zkE+B9265zAzOpzRGHb3JeValgBr1jGAn70AUb1sX1c2G17oG62mz3S/1qcbjYijl2NzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQxyR7oF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQxyR7oF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52542C4CECE;
	Thu, 12 Dec 2024 16:48:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022089;
	bh=b9Pvx7ITH4wym343JjBu3lbbXBbasLGhBlWAcA2BZd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SQxyR7oF74t2LKzpyAakf3487O9tQ0BnQm6+0R18q/P2PwUIvlMDTWF6sYrQJqseC
	 eu5IJEoYtgdPAX08ZkMi/SbIyKTH4wbz6c4MoVBhEf1SQyUJ0vfzEk1Be0hrwB2xsc
	 ndfoxzbLEezNWNWGaZb0bfX4+ScKFHLB3kGQlNb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Wang <wangqing@vivo.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 144/565] platform/x86: panasonic-laptop: Replace snprintf in show functions with sysfs_emit
Date: Thu, 12 Dec 2024 15:55:39 +0100
Message-ID: <20241212144317.182358580@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Wang <wangqing@vivo.com>

[ Upstream commit 2d5b0755b754fcb39598df87b3a8656a569e9979 ]

show() must not use snprintf() when formatting the value to be
returned to user space.

Fix the coccicheck warnings:
WARNING: use scnprintf or sprintf.

Use sysfs_emit instead of scnprintf or sprintf makes more sense.

Signed-off-by: Qing Wang <wangqing@vivo.com>
Link: https://lore.kernel.org/r/1634280641-4862-1-git-send-email-wangqing@vivo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 5c7bebc1a3f0 ("platform/x86: panasonic-laptop: Return errno correctly in show callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/panasonic-laptop.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/panasonic-laptop.c b/drivers/platform/x86/panasonic-laptop.c
index 24d4c008778ed..26f4d15c3bf13 100644
--- a/drivers/platform/x86/panasonic-laptop.c
+++ b/drivers/platform/x86/panasonic-laptop.c
@@ -509,7 +509,7 @@ static ssize_t numbatt_show(struct device *dev, struct device_attribute *attr,
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sinf[SINF_NUM_BATTERIES]);
+	return sysfs_emit(buf, "%u\n", pcc->sinf[SINF_NUM_BATTERIES]);
 }
 
 static ssize_t lcdtype_show(struct device *dev, struct device_attribute *attr,
@@ -521,7 +521,7 @@ static ssize_t lcdtype_show(struct device *dev, struct device_attribute *attr,
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sinf[SINF_LCD_TYPE]);
+	return sysfs_emit(buf, "%u\n", pcc->sinf[SINF_LCD_TYPE]);
 }
 
 static ssize_t mute_show(struct device *dev, struct device_attribute *attr,
@@ -533,7 +533,7 @@ static ssize_t mute_show(struct device *dev, struct device_attribute *attr,
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sinf[SINF_MUTE]);
+	return sysfs_emit(buf, "%u\n", pcc->sinf[SINF_MUTE]);
 }
 
 static ssize_t mute_store(struct device *dev, struct device_attribute *attr,
@@ -563,7 +563,7 @@ static ssize_t sticky_key_show(struct device *dev, struct device_attribute *attr
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sticky_key);
+	return sysfs_emit(buf, "%u\n", pcc->sticky_key);
 }
 
 static ssize_t sticky_key_store(struct device *dev, struct device_attribute *attr,
@@ -605,7 +605,7 @@ static ssize_t eco_mode_show(struct device *dev, struct device_attribute *attr,
 		result = -EIO;
 		break;
 	}
-	return snprintf(buf, PAGE_SIZE, "%u\n", result);
+	return sysfs_emit(buf, "%u\n", result);
 }
 
 static ssize_t eco_mode_store(struct device *dev, struct device_attribute *attr,
@@ -664,7 +664,7 @@ static ssize_t ac_brightness_show(struct device *dev, struct device_attribute *a
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sinf[SINF_AC_CUR_BRIGHT]);
+	return sysfs_emit(buf, "%u\n", pcc->sinf[SINF_AC_CUR_BRIGHT]);
 }
 
 static ssize_t ac_brightness_store(struct device *dev, struct device_attribute *attr,
@@ -694,7 +694,7 @@ static ssize_t dc_brightness_show(struct device *dev, struct device_attribute *a
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sinf[SINF_DC_CUR_BRIGHT]);
+	return sysfs_emit(buf, "%u\n", pcc->sinf[SINF_DC_CUR_BRIGHT]);
 }
 
 static ssize_t dc_brightness_store(struct device *dev, struct device_attribute *attr,
@@ -724,7 +724,7 @@ static ssize_t current_brightness_show(struct device *dev, struct device_attribu
 	if (!acpi_pcc_retrieve_biosdata(pcc))
 		return -EIO;
 
-	return snprintf(buf, PAGE_SIZE, "%u\n", pcc->sinf[SINF_CUR_BRIGHT]);
+	return sysfs_emit(buf, "%u\n", pcc->sinf[SINF_CUR_BRIGHT]);
 }
 
 static ssize_t current_brightness_store(struct device *dev, struct device_attribute *attr,
@@ -749,7 +749,7 @@ static ssize_t current_brightness_store(struct device *dev, struct device_attrib
 static ssize_t cdpower_show(struct device *dev, struct device_attribute *attr,
 			    char *buf)
 {
-	return snprintf(buf, PAGE_SIZE, "%d\n", get_optd_power_state());
+	return sysfs_emit(buf, "%d\n", get_optd_power_state());
 }
 
 static ssize_t cdpower_store(struct device *dev, struct device_attribute *attr,
-- 
2.43.0



