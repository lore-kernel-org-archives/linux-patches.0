Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAF761922FC;
	Tue, 10 Sep 2024 10:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962997; cv=none; b=U2xZFKb9XjguBa0R4T2gDOjQENUCjCKaZ9svJHZ1LBLyJ/hbHmT9cFaJ9uoz7dZt6o13udsseDjFW9iL4YsZOfM992eKbCqBJwRDZsgDx7FXVbv2HMpxg2s+kvAjc/a1SS1m30p3cWHkttPuzKEqCGJhqliyyL2/RKWrK/pzBsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962997; c=relaxed/simple;
	bh=hVjKGUW090zTGL5uHTNe9Sbxh+WJIikmG7lAke0eB0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tv2ATsGxSW37OvvpMzxzhHghMPanGe8Y6uONTGVbnC2dAgCnXLezVI+3g0fdwOA1LyjGgjcMfObbgoyvvTSUu70aZIjoe52pa+AXXBA+0POdeVsSD0k/OGGzZbOn/pSb7XxAThAAYxAUClgxr7w0BabY4g6YK2oa2Nsi+qM80/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S1sDhnh3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S1sDhnh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5297DC4CEC3;
	Tue, 10 Sep 2024 10:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962997;
	bh=hVjKGUW090zTGL5uHTNe9Sbxh+WJIikmG7lAke0eB0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S1sDhnh3XdWUfPmTQ3NPmnGAxwhrpa7dTXEQaQUgMy4p2Apnee4QCer96DIk30OAk
	 xMCCXTzedipROAeYLAK+E3glzs5I/fjlmad8pTTaFrGA9xt8LszQD0kKUfFQN0nTPT
	 7DvfV3kkdkcf2LROFzVaRuer6g+UAIiPq04h6PBM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/192] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:04 +0200
Message-ID: <20240910092602.134932604@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 0403e10bf0824bf0ec2bb135d4cf1c0cc3bf4bf0 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 9720ad214c20..83e424945b59 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2171,7 +2171,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
2.43.0



