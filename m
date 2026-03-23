Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030A4383C7C;
	Mon, 23 Mar 2026 14:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277872; cv=none; b=R1uLxJzyU2Mi0r/til3irF90jeIKvsaYY1lr8HJcNrk5wkJLNa+ImA3ppKq8iKg1IC7fXJ0R5TMFWUCqQcfatBgLUsWaDffd8K8qz0K6LQRZ+iSNRWC7ld/Nczuaf0viLtJDZv3JFdNYLdoqtnkgXlCz0EKcNMI+QbwnxMH30+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277872; c=relaxed/simple;
	bh=XDMoW/yalQeEj16OMZWAp8quSCNRSZqYZg10TyDx3vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2PygeNL2dbi0JNK/783+X8J2aKexeNnwv8GFhoAp46j7UE0/2ubmiuquIJ8Ki6Lo9BekObtZkUkbNnTcG3JKai9YKnEx7rZztulJEO7uQ6rHZsDqMStRpUU45nLekQoX2k/+b96LmfXHieWawjMU30oryACoYXNjAICj+jKViE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yj/cFKyH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yj/cFKyH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79654C4CEF7;
	Mon, 23 Mar 2026 14:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277871;
	bh=XDMoW/yalQeEj16OMZWAp8quSCNRSZqYZg10TyDx3vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yj/cFKyHURSB0t0WU10iWB9GPMC/p5Ovz9sPKWe+9I4uwmiLVKV4DuArepeJ9E4KP
	 KxweXIe74405cN4+jTyhMwjl1QquJntHYZDGtg5tQzpD3CR7yr2+A6bOO/fs5c30zx
	 3JfMEoaS7qOgXiuw9wdJGYAzVJrbcHeOl1D1HIiw=
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
Subject: [PATCH 6.6 128/567] hwmon: (it87) Check the it87_lock() return value
Date: Mon, 23 Mar 2026 14:40:48 +0100
Message-ID: <20260323134536.973227899@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index fbe86cec60553..51882f7386cc8 100644
--- a/drivers/hwmon/it87.c
+++ b/drivers/hwmon/it87.c
@@ -3547,10 +3547,13 @@ static int it87_resume(struct device *dev)
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



