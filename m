Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D50AC46444;
	Tue, 10 Sep 2024 09:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961118; cv=none; b=D+GmQrHaffA7ailpCN+rnJuy5BgxdH2PDaqPEMEmMC5an3bPcdlBKtxTv5Up/BT1ltUWca97I43irMO48ruzEoaw6ZOen+Dxf12rQHnPA9AzQAtXvRxU8W0cMhdIRxvBubjqqGh959MWHarQKhw+92gmsXNWhTVzASMH+sz+4co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961118; c=relaxed/simple;
	bh=Bsfdizi7aVWs8PJ9jzOyPM6cbbssLy8gfG6bQ+qneg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buX+4L1lbmpZos2syaaTdc1Bc4q7vtspnoYqQA9+S+blG4z9GobMNEWJgnFLhCvpHy+1rj7Tq9pYkcGUMeBOqmO5XnJ6HvYP81A1l7f4XOFDHSquEg08IeTjWBa3RlVtWfBSKdqpVtc9s8UDls0vOyqqfs3nqW9HDdIC5A2GmJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kusMWXuk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kusMWXuk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 593FAC4CEC3;
	Tue, 10 Sep 2024 09:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961118;
	bh=Bsfdizi7aVWs8PJ9jzOyPM6cbbssLy8gfG6bQ+qneg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kusMWXukJysQK7M1R3JJHkEu9Yyah5GF80Pkzr0TH2fwie1076xX8yjR7klDgZJXg
	 0PJ8ykkVfX7Rgo55YM2n6AtBDfavzeWFdhMH1q96N9pARtdKM4o0nO9fBy7clmF0z4
	 XHJJ8ssV1Kaf5bB3+5yDjJ1yapSRQFupMneNJMKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 59/96] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:01 +0200
Message-ID: <20240910092544.132306256@linuxfoundation.org>
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
index 559101a1c136..23581dc62246 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -2264,7 +2264,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
2.43.0



