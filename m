Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0DBF442124;
	Mon, 17 Aug 2026 15:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979821; cv=none; b=inJ/yqc4v9TOpwTDZ3n+X9oV89wNAkjj6sk2z/g9neUiUQ3IZXvmQeDQxrR3fyXfzDqXQ9zSU4TM7JPUc6beQbINdDJQkLItmu8vtIupn318KyvVrZdnqtOm1E9QaF/JjAyGOk7ctcwMSANSqjYCo2IFXdAT7etQYc2TstxpxR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979821; c=relaxed/simple;
	bh=cV59fe3fAFpA0X7VEXLHjt+LnL3rMlg/NuZNil1hTVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bDIVueq3THzGEYQq703Ava7zOtOnqNiJohoEqhrqgfjP8V7Cth5AWKrvLx1ZzeZAkPFIUhXYa82rXSp2dBJk4qgzRilLcamyXaDX9tK/pjakzEg5ZX9dAuYfSZ8WDyiuxo58jTCbLRpgRkLP+4l4VqyDGeoO8trYY9a7IPwD+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b9wqQG6y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b9wqQG6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D29D1F000E9;
	Mon, 17 Aug 2026 15:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979818;
	bh=dewBjkcEbCxSvDHy8SLIVTaeE3FrejcWYoyBnCOTeFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b9wqQG6yprp8LadVVBMKyTitGZcKM47Ga19yyD++uvTCtJkMq83czy8FYPu/HCheA
	 H12YtHJtay7PamFDNpTiu6LdShoFijA0VbtDA225Lh6QnGBimVKl+RDx8tSJlkNHv6
	 CdM7HnU8iZFJKyEJMcPPvCNzpsPkGaAoZYNFKSEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Luiz Angelo Daros de Luca <luizluca@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 356/609] hwmon: (adt7470) Fix busy-loop and I2C flooding in update thread
Date: Mon, 17 Aug 2026 15:30:52 +0200
Message-ID: <20260817132556.198704328@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1e837760c55db..9569f1faadeb4 100644
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



