Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F6935A3BA;
	Thu, 12 Mar 2026 20:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347009; cv=none; b=adkPY/3K/oZ9e5++d2be0HIOsCKn9w5VQMXHc4xv5AD6ei0wwLjeW7ZGDR3iF4ric70GiDlwR2yd1rZPBA+m/SsUAm/cFOTpltEX1UEZuEITMJl3zZh/Jcukf+lhQ5jRnE7YykdiQaj74oaU2rwhunNLFjs7zwUf5eDZ0ytlXEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347009; c=relaxed/simple;
	bh=KxvCbh3vQELoXYX+7Rtp2HIpSF648bGSG8CSSmsJJxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=apNHk/xmHOiVRCLRE9z2IEdHu/T7oiQlGVVjmEUHIAepqOEOSUrfGLKo4Z6Kin2mZuJ5LggZnwGFKMIn0HwbV2asbpTTwYivP9WmA0uHr7khgNsvjFAIEypkCGibAx47XV1LsJcVKCbgLB11ZCY4E+od3YdV1I+5RTB0H6hbWpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zR+91jY8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zR+91jY8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E6BC4CEF7;
	Thu, 12 Mar 2026 20:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347009;
	bh=KxvCbh3vQELoXYX+7Rtp2HIpSF648bGSG8CSSmsJJxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zR+91jY86atLhReQHKeeIVwq0n6hBQTWXyKhnPA86CXbH2S6GTm/qrYcCUHIrC6cH
	 VlG115m4XvCazz7SO4/Bnx61ySH2AzsRNa68/HcDL/9O9xdrOuHN4yPN9e62OV/9yh
	 lfW39X0MuH/b4Naj0tqqsmiCKrGL3OGCI33xgphc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Crawford <frank@crawford.emu.id.au>,
	Guenter Roeck <linux@roeck-us.net>,
	Jean Delvare <jdelvare@suse.com>,
	linux-hwmon@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/265] hwmon: (it87) Check the it87_lock() return value
Date: Thu, 12 Mar 2026 21:09:26 +0100
Message-ID: <20260312201024.772363750@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 07ed4f05bbfd2bc014974dcc4297fd3aa1cb88c0 ]

Return early in it87_resume() if it87_lock() fails instead of ignoring the
return value of that function. This patch suppresses a Clang thread-safety
warning.

Cc: Frank Crawford <frank@crawford.emu.id.au>
Cc: Guenter Roeck <linux@roeck-us.net>
Cc: Jean Delvare <jdelvare@suse.com>
Cc: linux-hwmon@vger.kernel.org
Fixes: 376e1a937b30 ("hwmon: (it87) Add calls to smbus_enable/smbus_disable as required")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20260223220102.2158611-15-bart.vanassche@linux.dev
[groeck: Declare 'ret' at the beginning of it87_resume()]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/it87.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/it87.c b/drivers/hwmon/it87.c
index e233aafa8856c..5cfb98a0512f0 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -3590,10 +3590,13 @@ static int it87_resume(struct device *dev)
 {
 	struct platform_device *pdev = to_platform_device(dev);
 	struct it87_data *data = dev_get_drvdata(dev);
+	int err;
 
 	it87_resume_sio(pdev);
 
-	it87_lock(data);
+	err = it87_lock(data);
+	if (err)
+		return err;
 
 	it87_check_pwm(dev);
 	it87_check_limit_regs(data);
-- 
2.51.0



