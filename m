Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064F51F706C;
	Tue,  3 Dec 2024 14:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237969; cv=none; b=ZNncxs/ueZfG9tQGRURL85y6iXUK96XtwJUuYRJDaXUApq643fshpc9ppPTXZqSURVa78sjCrsMepFU0FZQCDgKimSAGEMkOYGeeC0lkHrFEUM+1GmXCqFRmbEnhUM0eHWRR9At6clpuIT68Bbw+v5ylUNmbSC8nOFTDk07BfVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237969; c=relaxed/simple;
	bh=LRablAF9Keubf20Zsj11jhQNAmOVKVZCF6NmIV5owZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ic4QzkmMrvEv+BMt0SioIlYSPptRWHpyuQTGEhcJUV99Ov8bp60oXzFscCsE1OLxlaZYOxB8MsFhpi9gd7i2TPG9sQ/Bw0tUuNGx3fYBE0min3Zy9pEHK9qRlJbRxr/IhuWNhjzF0p+tzzvaMQp/ZptjqpFrHi1XA4svZG8p6kU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ8CSRfU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ8CSRfU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66507C4CECF;
	Tue,  3 Dec 2024 14:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237968;
	bh=LRablAF9Keubf20Zsj11jhQNAmOVKVZCF6NmIV5owZ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DZ8CSRfU8hLRZK/ocmKXsHpD5E2ebjLI9KuZRBsAhZ+6kIEqX3KrzrYRF31HOtKNf
	 gEAKp+wPL6o+uFll3aFfUJqoaB9pmDI4CVn0YMkzW5kLMjbMsutnlN2NQ6c41e/jEK
	 hLVFdpOZ8Z4ht/WGMj/eEeM4sJwhqFb544eqYR8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 120/817] hwmon: (nct6775-core) Fix overflows seen when writing limit attributes
Date: Tue,  3 Dec 2024 15:34:52 +0100
Message-ID: <20241203144000.399180772@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 57ee12b6c514146c19b6a159013b48727a012960 ]

DIV_ROUND_CLOSEST() after kstrtoul() results in an overflow if a large
number such as 18446744073709551615 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Fixes: c3963bc0a0cf ("hwmon: (nct6775) Split core and platform driver")
Message-ID: <7d5084cea33f7c0fd0578c59adfff71f93de94d9.1731375425.git.xiaopei01@kylinos.cn>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 934fed3dd5866..ee04795b98aab 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2878,8 +2878,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0,
-			data->target_temp_mask);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, data->target_temp_mask * 1000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -2959,7 +2958,7 @@ store_temp_tolerance(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	/* Limit tolerance as needed */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, data->tolerance_mask);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, data->tolerance_mask * 1000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_tolerance[index][nr] = val;
@@ -3085,7 +3084,7 @@ store_weight_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 255);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 255000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->weight_temp[index][nr] = val;
-- 
2.43.0



