Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6AE27466A;
	Fri,  7 Aug 2026 15:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115933; cv=none; b=L7J/D6WR+mVrf5MXCXoSXtcLGcjSAP3O7xw8QJSWtjzNvLjwkmEkSBRdK6gl9P28+lS3ReKbnzqQoNwHG+uuEQYaq9oeycg0SxRYg7b79Ki4XFIj2mX0TFkR5xIUZMxdSJ1c4v0LGNudTKKJuGuIxQ/o/1/W83AzZpDyaw/8Hzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115933; c=relaxed/simple;
	bh=4T/G8HDthkVPiMjs1CfI9F0pylrcAHzi/wlwX3XqWb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prDpTNcCb3/k0z/bXbgN1Kbs1yv02gYleyoEwiQHGDNQ5+s51/5vjMTB13q1kPP3EDXNVna95oXyptYTQwE80zjS9B5Xa2sj67GNt0YURx/9zSos/IkhM5S0ikEPe0EuXus3yqI3yocb/ENhz+srLdkKq7gMP3evFd9BUfu/z7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dl4e0GAe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dl4e0GAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0C781F000E9;
	Fri,  7 Aug 2026 15:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115932;
	bh=44nKSlg4KEcbtYANhAJPTrYzs4EWOFyR093UqajShkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dl4e0GAek2KX6u2utVonLENSNnIic501KS/uYIfvABtM8Lm1rGVVWcIB4/EVyqdnQ
	 6gMkVhpDAsTyxG4NCLZmJS+A0tUH19a1iMtOd2n1xOHvWvTBlrrzli8U32ZY/zyW9+
	 DWi2zL55BTHCdtFyC0colSUFeUP3WElUVL+7rowQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/261] hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread
Date: Fri,  7 Aug 2026 16:36:49 +0200
Message-ID: <20260807143416.509122610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3d4b4b6bd47fd..06d60f76cabbd 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -509,7 +509,7 @@ static ssize_t auto_update_interval_store(struct device *dev,
 	if (kstrtol(buf, 10, &temp))
 		return -EINVAL;
 
-	temp = clamp_val(temp, 0, 60000);
+	temp = clamp_val(temp, 500, 60000);
 
 	mutex_lock(&data->lock);
 	data->auto_update_interval = temp;
-- 
2.53.0



