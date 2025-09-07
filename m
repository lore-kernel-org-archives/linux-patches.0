Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E3494315A;
	Sun,  7 Sep 2025 20:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277896; cv=none; b=mTiYvd86l/bDdyNHhbDdn2rc3GTc+sNvzZ5me5SeZ7PFVKexMnlHX32iFNZVesXSzNHjGzPXSiZ8cIoRSlT3isrP17b2f667eLnBL1i0QeOEmbzwmWziO0bBl/pUcfqeY+96fsYgVQzUF4BE+7fDMl+cEVpF+JqOKl0sl3X4/uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277896; c=relaxed/simple;
	bh=aZ0691GZS1twr1QgfGNttl43YfJLZO+zDDSmNMhl8NA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjTsfXN0f4+ObVJzIXrGNQDmEe2ziYDhuUC5/lsUqd1arE0RKGX9/TAcoeMzeZgzJTsaMhvugV1JzB8PhEEPvrFFTIwiPNqoQ6IDxD+NRa3aH4W/gMsX9ZkPnuvFYj994icSSrFTElvaqoSRCBiLow2z7X6gd03OoitTolcynlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzdCX0Tu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzdCX0Tu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB201C4CEF0;
	Sun,  7 Sep 2025 20:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277896;
	bh=aZ0691GZS1twr1QgfGNttl43YfJLZO+zDDSmNMhl8NA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wzdCX0TukY4zP+wqXypPZYGrc2pKEsMRHUtGOhuCsfDjrerI6y4vfNaocqUHhts+Z
	 Z5nDUI4KUX4EFHP1J7akr0sCnI9ICo4pCC5+65BrQwD+CZsIEIJPRQ2qzlxj70/Xdz
	 7VEBMdBOnPUL4W5NrnoGh/6eq+QlIvptIDoIk0vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Packham <chris.packham@alliedtelesis.co.nz>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 155/183] hwmon: (ina238) Correctly clamp temperature
Date: Sun,  7 Sep 2025 21:59:42 +0200
Message-ID: <20250907195619.501175128@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Packham <chris.packham@alliedtelesis.co.nz>

[ Upstream commit 98fd069dd87386d87eaf439e3c7b5767618926d2 ]

ina238_write_temp() was attempting to clamp the user input but was
throwing away the result. Ensure that we clamp the value to the
appropriate range before it is converted into a register value.

Fixes: 0d9f596b1fe3 ("hwmon: (ina238) Modify the calculation formula to adapt to different chips")
Signed-off-by: Chris Packham <chris.packham@alliedtelesis.co.nz>
Link: https://lore.kernel.org/r/20250829030512.1179998-3-chris.packham@alliedtelesis.co.nz
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ina238.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/ina238.c b/drivers/hwmon/ina238.c
index 9a5fd16a4ec2a..a2cb615fa2789 100644
--- a/drivers/hwmon/ina238.c
+++ b/drivers/hwmon/ina238.c
@@ -481,7 +481,7 @@ static int ina238_write_temp(struct device *dev, u32 attr, long val)
 		return -EOPNOTSUPP;
 
 	/* Signed */
-	regval = clamp_val(val, -40000, 125000);
+	val = clamp_val(val, -40000, 125000);
 	regval = div_s64(val * 10000, data->config->temp_lsb) << data->config->temp_shift;
 	regval = clamp_val(regval, S16_MIN, S16_MAX) & (0xffff << data->config->temp_shift);
 
-- 
2.51.0



