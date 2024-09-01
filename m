Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF1761E87B;
	Sun,  1 Sep 2024 16:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208491; cv=none; b=MhDYbr4Xf/17kOknvVBVSrGE3cgF7fitMpyMZC2TSIMbH3mPbOsyx1DW6Ny7NzQxIa+h7ZWGxmqk/QyQYPfgxHw3EPlfRqtdsY6Nql1XiBsxD7Qz4FJwB+BygxFKf7KzSfKplFkJ3+xn+d0nZQ7mjep0zB6rUrn9+4SE671nUDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208491; c=relaxed/simple;
	bh=LvUn6Sxk30ZzrQ5Qk4KeIHOOBUg6dKS5BTluzQwAv+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZwafFyf1l3feFhaH3g4v6XHDbHqcIeYaURk0J6ZJHLgd8NYwW/+Anms/80o5lUAIVnuyjRJMc9XB7wBR5MRAlL+3YvnUgXKTrfpCqiv6JtLxx5KCzVWJ4w2lbkbZZiNt20uLDen8B6cKBK+D/MS58sc4tyms0KqfyDjKiZry3t4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BexFdbpV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BexFdbpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E58FC4CEC3;
	Sun,  1 Sep 2024 16:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208491;
	bh=LvUn6Sxk30ZzrQ5Qk4KeIHOOBUg6dKS5BTluzQwAv+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BexFdbpV7Pahf2DJp4jMXLLwGR5YZnrhlmhag2xI66pTK7a8UpPJwfVwphuZURKUZ
	 7tz9uwcFLXvAb/3lfCkK9wZdKzK08EdeAphfPj4J+ysWYgEeyx+J4Az7cj50r0Ov0C
	 BKf5234VX7Dyhrkxs2HetACN7gYoZCQ7KWF7Jeww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmo Chou <chou.cosmo@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/149] hwmon: (pt5161l) Fix invalid temperature reading
Date: Sun,  1 Sep 2024 18:16:50 +0200
Message-ID: <20240901160821.183930118@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmo Chou <chou.cosmo@gmail.com>

[ Upstream commit 7bbc079531fc38d401e1c4088d4981435a8828e3 ]

The temperature reading function was using a signed long for the ADC
code, which could lead to mishandling of invalid codes on 32-bit
platforms. This allowed out-of-range ADC codes to be incorrectly
interpreted as valid values and used in temperature calculations.

Change adc_code to u32 to ensure that invalid ADC codes are correctly
identified on all platforms.

Fixes: 1b2ca93cd059 ("hwmon: Add driver for Astera Labs PT5161L retimer")
Signed-off-by: Cosmo Chou <chou.cosmo@gmail.com>
Message-ID: <20240819104630.2375441-1-chou.cosmo@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pt5161l.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/pt5161l.c b/drivers/hwmon/pt5161l.c
index b0d58a26d499d..a9f0b23f9e76e 100644
--- a/drivers/hwmon/pt5161l.c
+++ b/drivers/hwmon/pt5161l.c
@@ -427,7 +427,7 @@ static int pt5161l_read(struct device *dev, enum hwmon_sensor_types type,
 	struct pt5161l_data *data = dev_get_drvdata(dev);
 	int ret;
 	u8 buf[8];
-	long adc_code;
+	u32 adc_code;
 
 	switch (attr) {
 	case hwmon_temp_input:
@@ -449,7 +449,7 @@ static int pt5161l_read(struct device *dev, enum hwmon_sensor_types type,
 
 		adc_code = buf[3] << 24 | buf[2] << 16 | buf[1] << 8 | buf[0];
 		if (adc_code == 0 || adc_code >= 0x3ff) {
-			dev_dbg(dev, "Invalid adc_code %lx\n", adc_code);
+			dev_dbg(dev, "Invalid adc_code %x\n", adc_code);
 			return -EIO;
 		}
 
-- 
2.43.0



