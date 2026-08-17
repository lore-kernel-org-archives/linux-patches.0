Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482FF3B811F;
	Mon, 17 Aug 2026 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975992; cv=none; b=rpS+EeonVG/ipgOatBpr+grqxs7IwS/WsXeF2NgZTj9u8BEpNEKpYSdTNXWkMIxZHrh+M/JHIH1bLpki4w8fS6sI/JJK810pEP7tM8vRZMc1rJJ5z+W0rHVmT2IYQDWoqYlSDrkVHY75pX+aOx1qA3mKGllJpyJJk0MRAVYMHsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975992; c=relaxed/simple;
	bh=rE6JcfuQT7PU15pINrWvOpq+J4GpNkZGM5pSVLhy63s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6oY3hglBBUjjfIDyO6D+JFk4+oBZO3aC94k8JDiDp4INHukZQxnKcp0scbMw8j/wfCmF4nMA+xAUVVsD4nu95yGZP/Cu4BIidjKGIXgf5J1ubBMt18Sos/ppvYvDSjUF8pK2N6FzhS54LQCv7RlyE8fn9qmu1rOyriQdrei7lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x79VtAWI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x79VtAWI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C92D1F000E9;
	Mon, 17 Aug 2026 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975991;
	bh=cXhbyKOXviS7anKj4iVeVXj63q9D/O83vHc/9QnSeQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x79VtAWIHaE+A7Tb5v9ZDQ06O8lxEwQ0Youv424w9eHNP2v0WMQKq9TBR4APz1gBu
	 KRFqKZhqetoi/in2X/AMfvteeE4BXKPHWAaRCF7tyHz0EJ/kmAM6XePTlpkEe/8D6j
	 wincQHvvfddcAl4DH/ugyCAycd3unm/VM4fWklIM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/389] hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread
Date: Mon, 17 Aug 2026 15:30:58 +0200
Message-ID: <20260817132547.751925281@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luiz Angelo Daros de Luca <luizluca@gmail.com>

[ Upstream commit cb0b7f9c43b0abbd422a7e4c2c85e91db429207c ]

When userspace configures 'auto_update_interval' to 0 via sysfs, the
background kthread executes schedule_timeout_interruptible(0), which
returns immediately.

If 'num_temp_sensors' is concurrently or previously set to 0, the
msleep_interruptible() delay inside adt7470_read_temperatures() also
becomes 0. This combination forces the background thread into a tight,
unbounded busy-loop, hogging the CPU and flooding the I2C bus with a
continuous stream of transactions.

Fix this vulnerability by raising the lower limit of the clamp_val in
auto_update_interval_store() from 0 to 500 milliseconds. This guarantees
a reasonable minimum sleep window between sensor updates, protecting the
system from intentional or accidental I2C bus denial of service.

Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/r/20260716213252.EACA71F000E9@smtp.kernel.org
Fixes: 89fac11cb3e7 ("adt7470: make automatic fan control really work")
Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
Link: https://lore.kernel.org/r/20260727-adt7470_fixes-v2-3-598e38a46ba6@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adt7470.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 71e357956ce4c..8450737dd4bde 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -408,7 +408,7 @@ static ssize_t auto_update_interval_store(struct device *dev,
 	if (kstrtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = clamp_val(temp, 0, 60000);
+	temp = clamp_val(temp, 500, 60000);
 
 	mutex_lock(&data->lock);
 	data->auto_update_interval = temp;
-- 
2.53.0



