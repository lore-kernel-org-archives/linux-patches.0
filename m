Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 298EC18F2F0;
	Tue, 10 Sep 2024 10:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964432; cv=none; b=DUmXQRYl7Tk1fHmrlYp7tO/YJ9q9P87qxYB3hTism5cunkQL8jA/tLMRwcHJZcffsH6cEQ22BKVMLmVmUjQJePPAsx8POtHZYQZnNgcL80onnU5+O6Y5OfiTG1fT+kkIrVoBkq0smkLi5wLEYeXMyd/4owsmLv6CFUt/qncqIJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964432; c=relaxed/simple;
	bh=dUWR+zLobtDhikyPNh4kRUNCF1m6W2cIceZa16GWQfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R2C4TDxBfvwYeUXoV82v0LXkJhILsBHnkjJKJqBV8eQ/U7y/6nkR+mtpGRnnYiFYLlN9GjZBsm8BkHVCNSvLWmLZgyfcUPIHMLGbir06t+LHWOl5fD2NA7+aFhLoyoSOaKi0tljHatP+6w6s05Eo5A/HC1QlIBa+bJveaNhzwYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CbBgKwAS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CbBgKwAS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BC62C4CEC3;
	Tue, 10 Sep 2024 10:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964431;
	bh=dUWR+zLobtDhikyPNh4kRUNCF1m6W2cIceZa16GWQfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CbBgKwASDN/Zu2vjGhEdGv4RCvYmO9Rt/gZ8EKt7O3tkXxXP0UVNVtD4rRmBVc8FL
	 JONzcub/Dk67m3tNbFGs0vh4JqRgB6D60Z9YtiDWaRDplnF6sX8lJoOQ5L8A8//MX5
	 3LWcVin7RWgCNSbd03hTt/IsSwiVjQn4gwltQcmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 154/269] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:21 +0200
Message-ID: <20240910092613.697206265@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index f3bf2e4701c3..8da7aa1614d7 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2262,7 +2262,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
2.43.0



