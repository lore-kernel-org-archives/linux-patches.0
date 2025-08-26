Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE1D29BDBA;
	Tue, 26 Aug 2025 11:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208328; cv=none; b=ljANcG4h+SQQsE4WdDhGByX2ELiXNQK2EUPYDimROOyjfodke3v0q2xxWMoGhGFN7QokDS0b5YrIo0jV60HQ/3Xohkf84z7VpcO8efw2VfSnLGkfbFxwxAEe+Z0FbaZtudsrq46dMzWX2rndeda5wj8U3CMvwahvJBX7z7NxyiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208328; c=relaxed/simple;
	bh=X6TFNQrNTKyfA0V1Vqq0B0Rkt3URPoMwG+9UMedB2r8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n4D3XE3hlp3/uO/MwQkxZ3VebE35oym+0X0HZcjixQYO0+gQ19UBK7TCPWphkrq62nLLGJo+1RBMH9RIssWwGcWcl9G9Un5jitqoC4raq57WdYpc1R8GbXlmqBF0/AU/nX7RiREK2eN+aE+kU2d808yb0Nt8qej314Yq+4LRrvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F4C2uxua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F4C2uxua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC58C4CEF1;
	Tue, 26 Aug 2025 11:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208327;
	bh=X6TFNQrNTKyfA0V1Vqq0B0Rkt3URPoMwG+9UMedB2r8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F4C2uxuayCgWN+xzSs6eaCknqCclAQ/NNQwKhAG6Q4/gLig/Rmf3CmY7/CDR4KaRd
	 TyDeZVLFx/4gNsKXITjM20Dx9HB6fiUdgSJDIYCPyyhRAmAdpirp2z+vVe+lj9OQRg
	 HrH0mXqlDWKK5A+FE431WUJul4KfEpEIvHbQlpMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.12 068/322] hwmon: (gsc-hwmon) fix fan pwm setpoint show functions
Date: Tue, 26 Aug 2025 13:08:03 +0200
Message-ID: <20250826110917.249708272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


