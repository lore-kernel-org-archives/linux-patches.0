Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B769B18641;
	Sat,  3 Feb 2024 04:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933631; cv=none; b=QGckHrhRnBbgimLVCBVICtQelbFK1Tg5BaRuQ7hhn+ZJ/xtXvjS76IL53COzMLbGD8ny6aVU2GoymO50OjLq/J1AQqTOEbebn3UzK83s8EL63bYewkRo8RrskESrzFGk6JTHiAuN+sYtz37kvC2boxC0++j+/AJ2wrylsZ41IFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933631; c=relaxed/simple;
	bh=RInqa7RzQ3yPg0sCpMuBYkOYdSDF5xOnF9EqUfz4B68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivmf00Wv9pIrvKR4FFqWQiNk2AH8HKUpirWuG05ORIsH4ObV9sXTiJBr4vJmSUimVifAXPW3PoP+E8oG860YWrP9oJKhGIyjSyhbha6QaEzng0px20fYcph6U+XxsvO2Eja8fn8hXhtcvWM+AvCyOVcW963rBxexVuvwsJL50S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PN8lWsef; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PN8lWsef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9CBC433F1;
	Sat,  3 Feb 2024 04:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933631;
	bh=RInqa7RzQ3yPg0sCpMuBYkOYdSDF5xOnF9EqUfz4B68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PN8lWsefPFK8iidFfXA07mgQ/cGWpb3clX5fZBNW7K62ANhkCgah/5MzK/+Ge08YA
	 AVVBL+Gf3SMtypK6CwfXDcJX1Yvd7F0BM8wb61bfRs1ARg4vJti5/cJOiJP4+NFA+I
	 BwDnHslUp6eCWgwiQxkXrq1CFWsYJMQgR1cTxuJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Tong Wu <xingtong.wu@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/322] hwmon: (nct6775) Fix fan speed set failure in automatic mode
Date: Fri,  2 Feb 2024 20:04:42 -0800
Message-ID: <20240203035405.238472645@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xing Tong Wu <xingtong.wu@siemens.com>

[ Upstream commit 8b3800256abad20e91c2698607f9b28591407b19 ]

Setting the fan speed is only valid in manual mode; it is not possible
to set the fan's speed in automatic mode.
Return error when attempting to set the fan speed in automatic mode.

Signed-off-by: Xing Tong Wu <xingtong.wu@siemens.com>
Link: https://lore.kernel.org/r/20231121081604.2499-3-xingtong_wu@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index d928eb8ae5a3..92a49fafe2c0 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2553,6 +2553,13 @@ store_pwm(struct device *dev, struct device_attribute *attr, const char *buf,
 	int err;
 	u16 reg;
 
+	/*
+	 * The fan control mode should be set to manual if the user wants to adjust
+	 * the fan speed. Otherwise, it will fail to set.
+	 */
+	if (index == 0 && data->pwm_enable[nr] > manual)
+		return -EBUSY;
+
 	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
 		return err;
-- 
2.43.0



