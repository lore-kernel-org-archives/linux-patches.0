Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9017F191F7A;
	Tue, 10 Sep 2024 10:44:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965099; cv=none; b=FHVsOx13Wb/HlGnUkTio3iw8ce6BhUoIgBDWMNIfYDqlXQumu+iz/6MYBBA/qmn8qysgK4EyvygVU1DHJ+4sEn8oaWN/Bt4dAsr5jW9lVX+TN7vtuZwocl/Ohpeirh32/hIoEKhOKsCYeV20u9pAAsJpsdV/dLbq8j2T+05++2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965099; c=relaxed/simple;
	bh=nQuXXkSgns5tf2h2ka0WFZFoUNazIk3lghimL23dW+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iJkD8KopNU3OUR8sVkoACgu9lR/AAtCffo+TyUzBE1G1MJIGPc3Z3qy78le/CKf4LVuAuwKiFHj/SgT944gI3qyc7lMAHaLDHvDE+W8BNhtbIv2WuWICHOIgxhclaJ3KrZdFl3QEABIV8zMTmiSXw6gDTn7az66iJLnRvMh/w4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tuFodNbP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tuFodNbP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA627C4CECD;
	Tue, 10 Sep 2024 10:44:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965099;
	bh=nQuXXkSgns5tf2h2ka0WFZFoUNazIk3lghimL23dW+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tuFodNbPsBTNxynzkiaXyWzq/W1R3FPG9NMqsnadWa5W8Niyq/5ANdVnZytZrAWsQ
	 uqpsRfbdbkDacXsuhiUhEEv9rzaZPPAcl1cZVd8zTCMCbI69zwCIdoe9CyqhCFyv/o
	 iiEKjniRnyWH30mNnGNbMH3OYeCJ/9vMUcya2E28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/186] hwmon: (nct6775-core) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:33:52 +0200
Message-ID: <20240910092600.248643825@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5bd15622a85f..3645a19cdaf4 100644
--- a/drivers/hwmon/nct6775.c
+++ b/drivers/hwmon/nct6775.c
@@ -2374,7 +2374,7 @@ store_temp_offset(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_offset[nr] = val;
-- 
2.43.0



