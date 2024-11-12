Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A432309BF;
	Tue, 12 Nov 2024 10:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408036; cv=none; b=ZWlDv8T3wMPQPKF+cAKyyTdVxthoRU8tDOMyExPxb0qx5xTtDY0aflqX3Um8VV6NrUmqINmtItm5wpD0LmoPmLO8+NSRcDaxGaYY31ITCzZFol6iTdU/c/ubNyox05xyHg/atSQXITXJVoTg8nIPsJ4/EYsfXYGONdmvhDA7kAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408036; c=relaxed/simple;
	bh=YvVj8TFjElt/I/5Xcsy0ydqIwLb7pFqHteU3fx4CP/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQ/gQWyLW9T8PKdkMJq52RWTrnDJyrG2mOa6mGk0N3EbPJ+PQ7EXZtSHqxq5ro8blMbeP/1C8eEJf9/OS7XpETag5I5T0vtxvA1RRA9Jk7Ci5MQcePIBXF0f/GzuTCaAlTm7cTM3H4XfUQ+VFeOlpPaqEWsZQLmQ+ZNu5GwYlOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHbhV/yK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHbhV/yK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE10EC4CECD;
	Tue, 12 Nov 2024 10:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408036;
	bh=YvVj8TFjElt/I/5Xcsy0ydqIwLb7pFqHteU3fx4CP/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHbhV/yK+zJ7xiJGIedRjgKF7ohfr4N432WR1WY5UtZFgDxjnUf3v44pWDIHghX0o
	 Ec5Oz9DU6L4nnIDBQZJ2s4waFlF9K4uLPy/lvQMc77ftzqQNylg49tr8tnMPhgioDZ
	 8Fmd7JRtFTJG56wc7CnI33X/lw+bwRv+mfswXjUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiYuan Huang <cy_huang@richtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 040/184] regulator: rtq2208: Fix uninitialized use of regulator_config
Date: Tue, 12 Nov 2024 11:19:58 +0100
Message-ID: <20241112101902.405581138@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ChiYuan Huang <cy_huang@richtek.com>

[ Upstream commit 2feb023110843acce790e9089e72e9a9503d9fa5 ]

Fix rtq2208 driver uninitialized use to cause kernel error.

Fixes: 85a11f55621a ("regulator: rtq2208: Add Richtek RTQ2208 SubPMIC")
Signed-off-by: ChiYuan Huang <cy_huang@richtek.com>
Link: https://patch.msgid.link/00d691cfcc0eae9ce80a37b62e99851e8fdcffe2.1729829243.git.cy_huang@richtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rtq2208-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/rtq2208-regulator.c b/drivers/regulator/rtq2208-regulator.c
index a5c126afc648c..5925fa7a9a06f 100644
--- a/drivers/regulator/rtq2208-regulator.c
+++ b/drivers/regulator/rtq2208-regulator.c
@@ -568,7 +568,7 @@ static int rtq2208_probe(struct i2c_client *i2c)
 	struct regmap *regmap;
 	struct rtq2208_regulator_desc *rdesc[RTQ2208_LDO_MAX];
 	struct regulator_dev *rdev;
-	struct regulator_config cfg;
+	struct regulator_config cfg = {};
 	struct rtq2208_rdev_map *rdev_map;
 	int i, ret = 0, idx, n_regulator = 0;
 	unsigned int regulator_idx_table[RTQ2208_LDO_MAX],
-- 
2.43.0



