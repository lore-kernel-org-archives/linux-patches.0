Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9F28FBF0;
	Tue, 26 Aug 2025 13:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213609; cv=none; b=d+BYBJ665c+bV++InbLb6g5cIneqyRJ38JsRg2VAy6iMjWhmwAUI+6qdwW4NxJkqOJW0UsblXqsGdVb2d65Wa6lRUbMZS5YvKjOxXlNujVO/owl6brjqGOWN3En4ziccWNVr6UoT+o+fB3zwVfRndpCyVGJSVRx7g+Fkxll7n8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213609; c=relaxed/simple;
	bh=7kR4G+yk2r/hAjDj+G8V/BHU2epqu70ngXAduDFtqWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e772XOs/rk+IN92ttWsWbhC1gqE3zM/B0V9Z1q5kbrqEx+qg0Dwe4hcORSt54T6RV1GUzdi29GwvtGNrfuHZrlugt5CzruVe4YK/SqE8AmdSlPOTv6QFhtrSepKFBdwQVfn5l6TAeEKetveoN627HXPUwvPObmzvXVBIDp2+Ouo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B2OgUdAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B2OgUdAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70CC4C4CEF1;
	Tue, 26 Aug 2025 13:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213609;
	bh=7kR4G+yk2r/hAjDj+G8V/BHU2epqu70ngXAduDFtqWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B2OgUdAcXYGPQRolZQNRKEO1lJ5jnzDzrF6kYneSlDvW7yGYB1mC9xT4P77I1B8/r
	 slYJNAmd47LmioTFpiPUV4dj4QeiVAGaMpxb+xGubcmL0HuEp7LPc0ctCa0o9P4Zl1
	 BNnNjvJkV6t5hRuoyyIoSbDzJ6LD07w9kkTBxIwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tim Harvey <tharvey@gateworks.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 379/587] hwmon: (gsc-hwmon) fix fan pwm setpoint show functions
Date: Tue, 26 Aug 2025 13:08:48 +0200
Message-ID: <20250826111002.546928764@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


