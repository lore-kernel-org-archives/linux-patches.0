Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E451922D0;
	Tue, 10 Sep 2024 10:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963776; cv=none; b=BndGC6nsWBk3PSUk3f9rZcsyDAUdu+/5sqlsauNmJUi1UQuFbg6lHq7wvle9tlWuoDbCI1rGFhHwLQzIJoldC6XjmzL7/8T4abfARmA8YIRLfhMaGObGIv2heZK+K96k7fkCxMfiTKnv5zOcLWwJvhgm/s8XLJw9x/ltIq1lY3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963776; c=relaxed/simple;
	bh=grd2TSZwhTrUi1t95a/ZFzuUq7e2Q/Csd7DJdonwH/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHIyIF+YyS9BfXpveEt4UeFFQcyV532TjzmTv6xp1wmMXUwhMOoYboMWvXMetrJSa7F+NKOv1AjDZT5B9ZV0pm4lGLbTmDKyOMb7K+njrvRIIcO7IBhWNssJXwPBxzswfA5J9tuOl+GCgDCQ+fdt42Nbx3/cuzIWpKihvHmIYms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tzFb+67v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tzFb+67v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82C1FC4CEC3;
	Tue, 10 Sep 2024 10:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963775;
	bh=grd2TSZwhTrUi1t95a/ZFzuUq7e2Q/Csd7DJdonwH/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tzFb+67vpeT5JwY4eUty9C0Vq26Wr6cF5vUka0kXuXMuqKT2B1LRebB6D9CZKR5Y/
	 y+Dr/NX5fZ2qo+nbL5/6Vt6hCuPplbC9msY3ZEU2ARifBTlQXJBJDRB8d0K13vjwD2
	 uUnlkv4q7Pi4d2fFGXKxsnDLM1EdqpK2N/RLCdNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/214] hwmon: (w83627ehf) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:47 +0200
Message-ID: <20240910092604.680598381@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 5c1de37969b7bc0abcb20b86e91e70caebbd4f89 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/w83627ehf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index 705a59663d42..b6bae04d656e 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -895,7 +895,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -920,7 +920,7 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	/* Limit the temp to 0C - 15C */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 15);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 15000), 1000);
 
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_TOLERANCE[nr]);
-- 
2.43.0



