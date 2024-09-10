Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D971246444;
	Tue, 10 Sep 2024 09:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961121; cv=none; b=SzjHfGCyWyBPSpnJmDmX6cSWgs3DmChIxgPlmcNIwt6TbB1g55lGPwnvzspgeqRGdL1100gk6kdGZFSZXGWx+o78C6Sc50hScOgdGY8nahFODBUUzHGz6EkzC44G9rfIeHe5zBJCyR8BaXjOkXFMEOzBCapjXlyZKR90a3TbdeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961121; c=relaxed/simple;
	bh=J8nZW/RuLz58uwgYX9XaG/09Fw6+IBqGeVfgROxUwO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JamgtQSFXceke/PZUwhLLA7pdPduPFWTUqQC04EOYtBxBYO+/3IAav3FmOQWXEEuW7kmzlXTu6x1zNGwM0ncXUJuJmNf/ifs+R8UbPxjI7pkJ7UUZdsX/EFoJQNmDsGPd62WYCrakTrnhKm0rVAmKtG0q5Q4L0UvL5lyw5XBRXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VXlx23z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VXlx23z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60965C4CEC3;
	Tue, 10 Sep 2024 09:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961121;
	bh=J8nZW/RuLz58uwgYX9XaG/09Fw6+IBqGeVfgROxUwO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VXlx23z9Wy7u/U5z7mJsUOIxNd0ds70IDuashxSM3pTjSoj4KslB7NbShhClFiBNv
	 aF0i7x9yaGisu+5VYKmXOXBMlXPhJfbXTDsUoF+vEB2O/F3VQOn2LZe1qMKGHLUjTY
	 KG8hVT4JKnAaJOee6hSEfXOMja/rgrZHG0AnoVIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 60/96] hwmon: (w83627ehf) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:02 +0200
Message-ID: <20240910092544.177747571@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 5c1de37969b7bc0abcb20b86e91e70caebbd4f89 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/w83627ehf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/w83627ehf.c b/drivers/hwmon/w83627ehf.c
index ad68b6d9ff17..8da5f77b8987 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -1519,7 +1519,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -1545,7 +1545,7 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	/* Limit the temp to 0C - 15C */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 15);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 15000), 1000);
 
 	mutex_lock(&data->update_lock);
 	if (sio_data->kind == nct6775 || sio_data->kind == nct6776) {
-- 
2.43.0



