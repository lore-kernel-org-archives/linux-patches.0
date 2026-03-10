Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B76387562;
	Tue, 10 Mar 2026 11:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141979; cv=none; b=VJA4pixuzdpIynDS3ifxlm9L1icLYUAhy+WJE2o8mlobxstOkmO/uVSPogsT4tk+VocQS4S+TEBsCSjRdmo95ipSi3guK5JBTRjHeCALA1ZeU9YQE3mEU057wP0kffqPjrKwljeMaN6g+bWpnS88M95fRy9S6mD44FIn5Qx31NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141979; c=relaxed/simple;
	bh=/qlSY6Pm6/sIM1dAnHuYYznTzt3nZC7U2hMMt9nRtK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LISnQix3U5djYVG+/KHsJ6H93s3DWjN4Qj5KhzSF1ZwV9xlw5HvKHmkmvp1C7aKJGB1QEzUoIMoWuSPacNrFvbPvM9l8Jt6ZyG/xBCMktMti79fyw4QjMV5SMkn/Im+/Xt+ZNU/9CYwEON5M4ABNQOfzF8J8ZZG/+rHZLfMjMaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZLT0SYpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZLT0SYpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67FBC2BC86;
	Tue, 10 Mar 2026 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141979;
	bh=/qlSY6Pm6/sIM1dAnHuYYznTzt3nZC7U2hMMt9nRtK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZLT0SYpuM32R0ncDTjVi2J+BRSe4eNqHnnYFskVszo3nIqh/liTFoZfuliiEl4mWt
	 DBPfV5DzWoP/4p2fd4fo5T3J8LydikaCQWOjlhuQq86z3QGVXLJlBeSHOd4AqfeoJI
	 E5RAlUFdIb0RH5inMbNIQehY4fTe06PEFRgGXgo9oOS9xnzTwxO1fYJMuDj+g92BeA
	 aT/wXWSCjH/Oq25utFQlrdUDZJKqK8D5kVXBd89vG2noRGVddCF4SrGv4RV72gNw5d
	 fKebbpuGIV4s8cXhDm0I2iRX7SKAUBs+AgiTZrXPsGOZxry+bgFM6CalkxgNnzGgPS
	 Lgv6uk1AU2nmg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Minseong Kim <ii4gsp@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 104/314] Input: synaptics_i2c - guard polling restart in resume
Date: Tue, 10 Mar 2026 07:16:03 -0400
Message-ID: <251b18038109ba202ffa6e71cb453ec2bf9e0466.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Minseong Kim <ii4gsp@gmail.com>

[ Upstream commit 870c2e7cd881d7a10abb91f2b38135622d9f9f65 ]

synaptics_i2c_resume() restarts delayed work unconditionally, even when
the input device is not opened. Guard the polling restart by taking the
input device mutex and checking input_device_enabled() before re-queuing
the delayed work.

Fixes: eef3e4cab72ea ("Input: add driver for Synaptics I2C touchpad")
Signed-off-by: Minseong Kim <ii4gsp@gmail.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260121063738.799967-1-ii4gsp@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/mouse/synaptics_i2c.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/input/mouse/synaptics_i2c.c b/drivers/input/mouse/synaptics_i2c.c
index c8ddfff2605ff..29da66af36d74 100644
--- a/drivers/input/mouse/synaptics_i2c.c
+++ b/drivers/input/mouse/synaptics_i2c.c
@@ -615,13 +615,16 @@ static int synaptics_i2c_resume(struct device *dev)
 	int ret;
 	struct i2c_client *client = to_i2c_client(dev);
 	struct synaptics_i2c *touch = i2c_get_clientdata(client);
+	struct input_dev *input = touch->input;
 
 	ret = synaptics_i2c_reset_config(client);
 	if (ret)
 		return ret;
 
-	mod_delayed_work(system_dfl_wq, &touch->dwork,
-				msecs_to_jiffies(NO_DATA_SLEEP_MSECS));
+	guard(mutex)(&input->mutex);
+	if (input_device_enabled(input))
+		mod_delayed_work(system_dfl_wq, &touch->dwork,
+				 msecs_to_jiffies(NO_DATA_SLEEP_MSECS));
 
 	return 0;
 }
-- 
2.51.0

