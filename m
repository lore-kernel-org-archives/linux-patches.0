Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56EA46444;
	Tue, 10 Sep 2024 09:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961905; cv=none; b=Hs1E9PRYf5RGsbp4aYpZHZlC2VqhVIsHGPyhWGmId4DPkv1SdsV1wP3/4xXYhaTknIHC5WgTOhCIjb5Jy7Ej33cNQ7lwQs0j8lgzFohJ+DeF/gFOcEQ126ZrA0OBjWwkwKHxCsqRxLog5gDzifxUDCbnbOzWrfpM699+7j+NO7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961905; c=relaxed/simple;
	bh=LxtSbMcO89GqqBTEU7oodrlVhpA9MSnvaQdjLGlCxEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCwa6B9cqLj7hf+VZjdQ4caboSU6wLGqmkszVOdtXuEJIRNDr6Rwu9gz9lRL1RteuhHKKTNhuwjGersdsRVjgLdBQZzcUGnkInHhRN1VlR+oinIDn5b+fyiOKNWI2FedpGECSdEFvfWHso93XCIwztdZCjRm8Qm+W7MO5stPUw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1b5Zzhd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1b5Zzhd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251B3C4CEC3;
	Tue, 10 Sep 2024 09:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961905;
	bh=LxtSbMcO89GqqBTEU7oodrlVhpA9MSnvaQdjLGlCxEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T1b5Zzhd1q/6xyKcE4Gm8HgEKXxCjg0uXd6PBSGIHNvdfaYW3h//FuyKy+Tj9rxYs
	 k6LZtg7dSG3DZNggVBxwuTY/EqFe3gga06511iZTiZ3HsJrMQ3jQTeC4ovhTZXSW8s
	 jAfeuBdaMO5pa4tfUjFWhLJLDAADDkNrSfI8cEn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 221/375] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:30:18 +0200
Message-ID: <20240910092629.966368317@linuxfoundation.org>
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
index 9fbab8f02334..934fed3dd586 100644
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



