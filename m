Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CDE137F007;
	Tue, 10 Mar 2026 11:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141270; cv=none; b=bNMsMgyFUGfJKS9UacX4OpnMxs0qGHZn2glamDZbhslHnuwIEEHKhgE5R5WuLCTfj8/hoqkGk2ixEekA7zx9IjiKBiVovZbmyLjx7pfqOuIUpkIyeBFefDTYLG+D0oPmEwhjOp1DsgVthyD8ahwq9Lnt0cPRwsdAoOyqgAOH9W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141270; c=relaxed/simple;
	bh=Nmn3pd55AbPU6h+QXBxMe77wqRdnNSVG7PDQgLk58sM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCBNs4kFQU01rXqB55BWqF52ehjP2cGDl24HnwPGCLisN1cl3QRXAjRQEZiVvBNfKAiZR4Qb07z+Pw9X9JFsWWmn4cVs4XmtOsXU4wp7pchulB2EtR9BnS0iVC1pXUtUzxAV2aCIGDyMsrj1jRCQTfsHKf1OVZn26oYVfojo288=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z5nQTqPV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z5nQTqPV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B72C1C2BC86;
	Tue, 10 Mar 2026 11:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141270;
	bh=Nmn3pd55AbPU6h+QXBxMe77wqRdnNSVG7PDQgLk58sM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5nQTqPVF7sJ+zEkftH7fw6ZmHuAi7W0W5WAJ0k6N9lRHIlAVm+iNptxnkbToWROF
	 T7dYBfhHsL46z82Xi0hmhBi8HKMd00scjFMiS6MTeZkPKLBHYvcBcmFjJIGAfpBNNA
	 tgSgPcKVUEGBT4mmtbKGpUiko2sFPLdJKKLxsWHz6+PZJAmbP9zT7HjlKe4MUlkV1x
	 AuL3WbpGyhFVZumzzR5A0A/1P1IdfxZL9H5p+CJ9VaIESK89EEgfiRYurQiFs18qgM
	 CoTF68Z/NtGSlYZeFJgKzyeYGQBk57CRdjxNrycKTJ8o73/lvwRRbSNojyWcZVWtJS
	 9VEg6fepXwlLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Olivier Sobrie <olivier@sobrie.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 272/311] hwmon: (max6639) fix inverted polarity
Date: Tue, 10 Mar 2026 07:05:19 -0400
Message-ID: <f05227b565b9c735b2821cc823f59cea96a1d3e9.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Olivier Sobrie <olivier@sobrie.be>

[ Upstream commit 170a4b21f49b3dcff3115b4c90758f0a0d77375a ]

According to MAX6639 documentation:

  D1: PWM Output Polarity. PWM output is low at
  100% duty cycle when this bit is set to zero. PWM
  output is high at 100% duty cycle when this bit is set
  to 1.

Up to commit 0f33272b60ed ("hwmon: (max6639) : Update hwmon init using
info structure"), the polarity was set to high (0x2) when no platform
data was set. After the patch, the polarity register wasn't set anymore
if no platform data was specified. Nowadays, since commit 7506ebcd662b
("hwmon: (max6639) : Configure based on DT property"), it is always set
to low which doesn't match with the comment above and change the
behavior compared to versions prior 0f33272b60ed.

Fixes: 0f33272b60ed ("hwmon: (max6639) : Update hwmon init using info structure")
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Link: https://lore.kernel.org/r/20260304212039.570274-1-olivier@sobrie.be
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6639.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index 99140a2ca9955..48fde4f1a1561 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -610,7 +610,7 @@ static int max6639_init_client(struct i2c_client *client,
 			return err;
 
 		/* Fans PWM polarity high by default */
-		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x00);
+		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x02);
 		if (err)
 			return err;
 
-- 
2.51.0

