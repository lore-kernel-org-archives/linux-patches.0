Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813DF2FDC5C;
	Tue, 26 Aug 2025 14:21:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218114; cv=none; b=GJDUNX7z+2Lzz3CqMZB38b24Vbl1MkKIfxb86BguBO50+B2Mme/N1ktNQPYCSVjtfvPpt3qhsqLskzh3ktdtlCnutvKq4RBmGC/+lb2UZJg0pxZPUIhAjVKGujBcz+KAISLu3Pd1dqZqDuQiJM9DbK7VCG7iflUcxfEwQ8elAl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218114; c=relaxed/simple;
	bh=e528EYKKb59N/ihmvJ5KEoM1tTCTsbyyA4uVnRIItmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys40Z1YR6fP/GsYv0IIR5iFgqiwcwZwyml/fzqPpZUOrauv3Jz4MBW/luItmbAQk4YiHAuTMStWD22/0fLEBA+HydeHtl1AcoaoqIiXrggWgrRLwgqiTvSNQq9zLpDELqvnYLTAc6wveHgdJUa2GAp8wso7Q/CvPNWC8d9qAwcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUkgJOoP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUkgJOoP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1106FC4CEF1;
	Tue, 26 Aug 2025 14:21:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218114;
	bh=e528EYKKb59N/ihmvJ5KEoM1tTCTsbyyA4uVnRIItmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUkgJOoPHmcSg2AWsy36GYX3ssvy5yGidfmQtn4/TXSQyVL9ZAkbWjWP1kCOWSqyh
	 /9306TRBW1Sm/sAD8dueowJR+nrcxyi+X/66R5Ib8P4BKBC8S3WkgYRfPDlEapAdge
	 PrMx1TLTtF44mCuiksbJaHrlrkWUhc99+xNdWfHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.10 371/523] hwmon: (gsc-hwmon) fix fan pwm setpoint show functions
Date: Tue, 26 Aug 2025 13:09:41 +0200
Message-ID: <20250826110933.617942726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -65,7 +65,7 @@ static ssize_t pwm_auto_point_temp_show(
 		return ret;
 
 	ret = regs[0] | regs[1] << 8;
-	return sprintf(buf, "%d\n", ret * 10);
+	return sprintf(buf, "%d\n", ret * 100);
 }
 
 static ssize_t pwm_auto_point_temp_store(struct device *dev,
@@ -100,7 +100,7 @@ static ssize_t pwm_auto_point_pwm_show(s
 {
 	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
 
-	return sprintf(buf, "%d\n", 255 * (50 + (attr->index * 10)));
+	return sprintf(buf, "%d\n", 255 * (50 + (attr->index * 10)) / 100);
 }
 
 static SENSOR_DEVICE_ATTR_RO(pwm1_auto_point1_pwm, pwm_auto_point_pwm, 0);


