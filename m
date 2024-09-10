Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AB1118C340;
	Tue, 10 Sep 2024 10:02:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962571; cv=none; b=pxiD5Jn3SZgz2xDsvd5GvVLopZIKHmTmMSBCS1HT/JDs5beNQorfmOSpF9irEUGvGvuWRRWGdhHhsSAWdeP9QK2xMp0smw0vC/j0ilL0V4uBMYwKhBh1xKtKIhOJZJGZfjuqsshzpSJKaOk/QQ5AM28De320F1lweIi0WTHjn9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962571; c=relaxed/simple;
	bh=G0ER95/A8O/EGW/ojtcFMQPLGI5rX52+U8xPXmGKfcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaaHgE+gMc/cxpTSATglMu/6qMT4TWLzjfyhVJRL6F7HzhCWDUXIqcLnyTfcrg0q3DXS7VdlGc9S4DVVQGcaz5nTpXFPCH9iPhd3c625abiZyWR4dROyCqVigd3PR8Izg3Ty1b02CGbTc5CLvHPJg77ohVw4hdwk4YiZmINvyMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0yVLu1ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0yVLu1ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46777C4CEC3;
	Tue, 10 Sep 2024 10:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962570;
	bh=G0ER95/A8O/EGW/ojtcFMQPLGI5rX52+U8xPXmGKfcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0yVLu1ibH4iYuO93PHafNHrfzHadkxyN6IrGo+mlYd+c88qCXGHFA0FcwghhYJmyw
	 umFld/UJZx0oeato7Q2s9FjpGBjMk3VfI+mQYLXgIF+0qP3an9UyofSe+J6vGjRFjB
	 P3w3XgoWLyZplVfby5bgoonDAwCYGz1oartmr5DQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 078/121] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:33 +0200
Message-ID: <20240910092549.596355054@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0403e10bf0824bf0ec2bb135d4cf1c0cc3bf4bf0 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct6775.c b/drivers/hwmon/nct6775.c
index ba9b96973e80..da6bbfca15fe 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -2374,7 +2374,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
2.43.0



