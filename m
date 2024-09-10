Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FC4224F6;
	Tue, 10 Sep 2024 09:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961938; cv=none; b=Ec3Lvl7UdxtTaQUtkRnuftBG6E75LMqSmzhDl15lPiQ55tczJUozKdwrMQg897P9gkUqoSQfT6LRV4p2qrTaQCCW+sACGBML7yLnlgoYL1qK1kJfucoLq1Dm7MDS8gnj3D+5+fEtI+89xbX8bb4bEPqloG6SyJQwUMZDQiVY52E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961938; c=relaxed/simple;
	bh=irsXM0Zgt7q4D1IkjWHTbPXos92erjj/B9ZEGcbjWLE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VKoJgJJdQJjSPfS63VVoBwgmMiLEMluFr8XsuKPS8+Z5k+kO/uyAPvt6oKnKIg7UFJPgllBT3XutL0NNu4gF3/6vAyTYRHGm6DsKx8i1vShQk/d4u1A6iWo0B9aGl1iLeXeUpf3CAkJf9fr0AiJl+uSp1ep3LhuPVx+zaFi6sMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BOXSIWYK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BOXSIWYK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2ECC4CEC3;
	Tue, 10 Sep 2024 09:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961937;
	bh=irsXM0Zgt7q4D1IkjWHTbPXos92erjj/B9ZEGcbjWLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BOXSIWYKDgK7JzMXT2usGGqj/+JRjjLxQQWklQyavtBvDlTq3AIgvu70TdGMWxkMB
	 TPOGvqW+Y5CLEZakXDhgZHIqePB3ce9auPavK83J/J3twl41YH0H+GySPtxtw4HpiN
	 DnfHmMftNcZ+tWkRZ3pJqftok/Q5uWqtlBZpHvrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 222/375] hwmon: (w83627ehf) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:30:19 +0200
Message-ID: <20240910092629.997843937@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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
index fe960c0a624f..7d7d70afde65 100644
--- a/drivers/hwmon/w83627ehf.c
+++ b/drivers/hwmon/w83627ehf.c
@@ -895,7 +895,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -920,7 +920,7 @@ store_tolerance(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	/* Limit the temp to 0C - 15C */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 15);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 15000), 1000);
 
 	mutex_lock(&data->update_lock);
 	reg = w83627ehf_read_value(data, W83627EHF_REG_TOLERANCE[nr]);
-- 
2.43.0



