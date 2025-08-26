Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A56332142D;
	Tue, 26 Aug 2025 11:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207201; cv=none; b=oJ1NtAbCu3FcdN+FzA8vHjTaBqlqz5GLvHfZtM1+UluryD6vDFEyYYXiBTBRbjK/sPAFVqrBvYKCIvBUjC9GXL8FdG7rb43JxsPsVx9FOW4dNMWUi8vACcnzFY6Gq2Et2owUOcUrtEIrrgvK41lLtXG660zNmV8Li6CYBRFwshY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207201; c=relaxed/simple;
	bh=LCSvU7Lnq6t6QroEWqTZ2Hgb0WFppfgSUyjsqcYMb5U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DdQcQ9lDmq71MsRuiJHe4nB7rBXYzCowiXSEBhXzDTJEsB8+3KQkQaVInInUYuiDl3BtNPo+qCiTxNfAFxMvbNtUCgXqHzyzP/RHW9D34Dr6Hz24qISjaK4yNOq0dDQRiMiFHNciFgt9Hni7QoNucin053zDs+po5PB92uP+DfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BtAnrz9Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BtAnrz9Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB74EC4CEF1;
	Tue, 26 Aug 2025 11:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207201;
	bh=LCSvU7Lnq6t6QroEWqTZ2Hgb0WFppfgSUyjsqcYMb5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BtAnrz9Z49btjRCzd+Dluf8BA55P66rtG40smBQ2l6ivP2DkMU4jzDVrJ5LRwcA6p
	 6cDg9qN53wiiZ+RY2jYX02fPkeGGVpCg8j1DC4YMtXxIoXD8KhR6+TbtssMuinFHCY
	 BHPRres9GlCfBu4hIOTl+gKtUPXDcl1xUmkujic0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.16 090/457] hwmon: (gsc-hwmon) fix fan pwm setpoint show functions
Date: Tue, 26 Aug 2025 13:06:14 +0200
Message-ID: <20250826110939.605564127@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tim Harvey <tharvey@gateworks.com>

commit 9c62e2282900332c8b711d9f9e37af369a8ef71b upstream.

The Linux hwmon sysfs API values for pwmX_auto_pointY_pwm represent an
integer value between 0 (0%) to 255 (100%) and the pwmX_auto_pointY_temp
represent millidegrees Celcius.

Commit a6d80df47ee2 ("hwmon: (gsc-hwmon) fix fan pwm temperature
scaling") properly addressed the incorrect scaling in the
pwm_auto_point_temp_store implementation but erroneously scaled
the pwm_auto_point_pwm_show (pwm value) instead of the
pwm_auto_point_temp_show (temp value) resulting in:
 # cat /sys/class/hwmon/hwmon0/pwm1_auto_point6_pwm
 25500
 # cat /sys/class/hwmon/hwmon0/pwm1_auto_point6_temp
 4500

Fix the scaling of these attributes:
 # cat /sys/class/hwmon/hwmon0/pwm1_auto_point6_pwm
 255
 # cat /sys/class/hwmon/hwmon0/pwm1_auto_point6_temp
 45000

Fixes: a6d80df47ee2 ("hwmon: (gsc-hwmon) fix fan pwm temperature scaling")
Cc: stable@vger.kernel.org
Signed-off-by: Tim Harvey <tharvey@gateworks.com>
Link: https://lore.kernel.org/r/20250718200259.1840792-1-tharvey@gateworks.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/gsc-hwmon.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/gsc-hwmon.c
+++ b/drivers/hwmon/gsc-hwmon.c
@@ -64,7 +64,7 @@ static ssize_t pwm_auto_point_temp_show(
 		return ret;
 
 	ret = regs[0] | regs[1] << 8;
-	return sprintf(buf, "%d\n", ret * 10);
+	return sprintf(buf, "%d\n", ret * 100);
 }
 
 static ssize_t pwm_auto_point_temp_store(struct device *dev,
@@ -99,7 +99,7 @@ static ssize_t pwm_auto_point_pwm_show(s
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	return sprintf(buf, "%d\n", 255 * (50 + (attr->index * 10)));
+	return sprintf(buf, "%d\n", 255 * (50 + (attr->index * 10)) / 100);
 }
 
 static SENSOR_DEVICE_ATTR_RO(pwm1_auto_point1_pwm, pwm_auto_point_pwm, 0);


