Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC02D3264D6;
	Fri,  7 Aug 2026 15:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114904; cv=none; b=XlYvoTN4kQElbE/s/slm7Di+cLyQ06Qf5BmO4Fi3lETjU3yREnPeONiU+4rkqLbaQDytB/vve5KnxCD0I32HKJRd4AJVhNQG7tqT2cOXrHBEe39zgnZYd5ggWDTbL+o08KrCnbiH6pxSUnjCQPErggtNKeMXYZUzIF5GeVcc7I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114904; c=relaxed/simple;
	bh=DVIYgUyzoIIr951KIFinBvbhE/SjJeNUan8DIi/emVo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2Ur6oOJaqrcuYbPZtYve82dJVO7e/C9sHgrEmhUMdljRbRnPLvO19QaeHb7aa1ObF1Qur5CkVHA3grHngSenys5wHUhARIoZxGmaoA7CAj7nwxpanfVGNAaNiLHTPkSni+msSjDA7mdCO3A94soFkKbJ85OnZK+R/QsDop3Z3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UNsO0v6d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNsO0v6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1851F000E9;
	Fri,  7 Aug 2026 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114902;
	bh=R8z4xA9P1ebSCeRgI7AzhigZHb46zpj+VHdX5nyWOLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UNsO0v6d1uy8YqZp8MYNZzHlaIMC/+xZ3FQq170DAbBTUlC9Xjrm9mQsLJT0wLApH
	 ueKCK5X+xB0Gm7pIbDi9IvlfZuqNcgXmc3W0RRq9bnTnz5Cr4dp/Qha6NebBfRVsuL
	 UgeFkdlviMoJbj4WNQ9PqHVVnaG+d1yYTJu4JulY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/396] hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread
Date: Fri,  7 Aug 2026 16:34:06 +0200
Message-ID: <20260807143426.132583636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 06b19fd382457..a927e0b6d3319 100644
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



