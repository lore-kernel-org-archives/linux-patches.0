Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C29E1AF0AF;
	Mon,  9 Feb 2026 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647701; cv=none; b=i+BQ1vTcjX9/JOZVPv2TDOhjocBmE4/aofYkMYP0zjfDcX1bWL+NqGBqxh/mtQqPFCMA0WjCKYuvoooT+G79QDua3WwYDV4EFH41AuaDkZH//13kq37e5fc7JMw+RocVPavwWenUMttOU8zHY9Cx+160zvk/mKfyuuxkzbz1rxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647701; c=relaxed/simple;
	bh=2ijRq9n+dFpHMSFBJSqbWZ0S3ah7aZYFfiVERQDk4GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnZTD+qco5V1gmBPahPffZ8CQguzCauVO8HBfk0+uKcWIa217uXlccbpusRio+tV+K5Gl6wN5NLLJEEvLITf6E+Kz2BEqPUOsyz854PgGylOCN/pgU7eNV1DsOh8oEhZuU+dEvGVvy2RxsRP3SwixlDnAemwvb0Ct5b+QP8fwsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WJVnMB2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WJVnMB2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3833C116C6;
	Mon,  9 Feb 2026 14:35:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647701;
	bh=2ijRq9n+dFpHMSFBJSqbWZ0S3ah7aZYFfiVERQDk4GQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJVnMB2zSGq7N5Iky4ion3hxcyR2g7CmRom+o1kpZEVrrO1c8J0LGsrxVUmWwZFsc
	 xhYHYC9hkoD5x6SC1QvJPucXkuy9r7NSQqkH3rssXFValYmO7LCl5yS2dK5iia1Js+
	 ScsebW0VwIQnBaq0JI5rs/BhyqyefGVyIYD8bHnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guodong Xu <guodong@riscstar.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 164/175] regulator: spacemit-p1: Fix n_voltages for BUCK and LDO regulators
Date: Mon,  9 Feb 2026 15:23:57 +0100
Message-ID: <20260209142326.388102600@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guodong Xu <guodong@riscstar.com>

[ Upstream commit 41399c5d476156635c9a58de870d39318e22fa09 ]

Higher voltage settings were unusable due to incorrect n_voltages values
causing registration failures. For example, setting aldo4 to 3.3V failed
with -EINVAL because the required selector (123) exceeded the allowed
range (n_voltages=117).

Fix by aligning n_voltages with the hardware register widths per the P1
datasheet [1]:
- BUCK: 255 (was 254), allows selectors 0-254, selector 255 is reserved
- LDO: 128 (was 117), allows selectors 0-127, selectors 0-10 are for
  suspend mode, valid operational range is 11-127

This enables the full voltage range supported by the hardware.

Fixes: 8b84d712ad84 ("regulator: spacemit: support SpacemiT P1 regulators")
Link: https://developer.spacemit.com/documentation [1]
Signed-off-by: Guodong Xu <guodong@riscstar.com>
Link: https://patch.msgid.link/20260122-spacemit-p1-v1-1-309be27fbff9@riscstar.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/spacemit-p1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/regulator/spacemit-p1.c b/drivers/regulator/spacemit-p1.c
index 2bf9137e12b1d..2b585ba01a93d 100644
--- a/drivers/regulator/spacemit-p1.c
+++ b/drivers/regulator/spacemit-p1.c
@@ -87,13 +87,13 @@ static const struct linear_range p1_ldo_ranges[] = {
 	}
 
 #define P1_BUCK_DESC(_n) \
-	P1_REG_DESC(BUCK, buck, _n, "vin", 0x47, BUCK_MASK, 254, p1_buck_ranges)
+	P1_REG_DESC(BUCK, buck, _n, "vin", 0x47, BUCK_MASK, 255, p1_buck_ranges)
 
 #define P1_ALDO_DESC(_n) \
-	P1_REG_DESC(ALDO, aldo, _n, "vin", 0x5b, LDO_MASK, 117, p1_ldo_ranges)
+	P1_REG_DESC(ALDO, aldo, _n, "vin", 0x5b, LDO_MASK, 128, p1_ldo_ranges)
 
 #define P1_DLDO_DESC(_n) \
-	P1_REG_DESC(DLDO, dldo, _n, "buck5", 0x67, LDO_MASK, 117, p1_ldo_ranges)
+	P1_REG_DESC(DLDO, dldo, _n, "buck5", 0x67, LDO_MASK, 128, p1_ldo_ranges)
 
 static const struct regulator_desc p1_regulator_desc[] = {
 	P1_BUCK_DESC(1),
-- 
2.51.0



