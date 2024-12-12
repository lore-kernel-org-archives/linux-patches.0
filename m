Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44CB3223E81;
	Thu, 12 Dec 2024 17:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024991; cv=none; b=XNNxpnmPdensMX69SBvHt0NaYwR3agI6nNp8ptTtQfBMablTRm8PvSeLptaj4XGC4XeUqXEzAzD2zR0iykjofvA6ITCN5a8KR4qdOq7doRGfDDnK5v45FR+mVS+H6P0wXvgJRFwLuNsRVZMmbHLOUq7pwQtS12luPkVZbGbZd34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024991; c=relaxed/simple;
	bh=qhjy11U5vfGY4HD48C0Jndqgt/IWwJO7wBsbMJxwtM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p7BKVsYkN4X8svK70nV7QT+9kgfR1vLSGkKg1W9MdJRjPHqLdBXqYtQhxcBh7MjZ9QM422B0J7QcB5u38tltWiVAxvEXTfberZc8Qsn7FFuQYgAyNmKt1Im8E5CMp825kuCLZ6RM+OA2b3iRWIUnfgh45rmFvNM0kJId7H11eFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uylsVp+p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uylsVp+p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAA6C4CED0;
	Thu, 12 Dec 2024 17:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024991;
	bh=qhjy11U5vfGY4HD48C0Jndqgt/IWwJO7wBsbMJxwtM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uylsVp+pm1KEjmHN3h8j7xeM9oPEThq19fP2wbFBj6fLLxKyhKSczlplcl/D2uRnA
	 Oh0kevXnb/ORlH28m0tS+fjhK8ZHBp2SHvIV/5oJXwDabGoI2/bwC00My3mEGhnKrE
	 ExYBPYt9piEKipZq9MNkS1Bi0QqSKdFTvTC452Mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Rudenko <mike.rudenko@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 020/321] regulator: rk808: Add apply_bit for BUCK3 on RK809
Date: Thu, 12 Dec 2024 15:58:58 +0100
Message-ID: <20241212144230.444590849@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikhail Rudenko <mike.rudenko@gmail.com>

[ Upstream commit 5e53e4a66bc7430dd2d11c18a86410e3a38d2940 ]

Currently, RK809's BUCK3 regulator is modelled in the driver as a
configurable regulator with 0.5-2.4V voltage range. But the voltage
setting is not actually applied, because when bit 6 of
PMIC_POWER_CONFIG register is set to 0 (default), BUCK3 output voltage
is determined by the external feedback resistor. Fix this, by setting
bit 6 when voltage selection is set. Existing users which do not
specify voltage constraints in their device trees will not be affected
by this change, since no voltage setting is applied in those cases,
and bit 6 is not enabled.

Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
Link: https://patch.msgid.link/20241017-rk809-dcdc3-v1-1-e3c3de92f39c@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/rk808-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/rk808-regulator.c b/drivers/regulator/rk808-regulator.c
index 97c846c19c2f6..da34af37f191f 100644
--- a/drivers/regulator/rk808-regulator.c
+++ b/drivers/regulator/rk808-regulator.c
@@ -959,6 +959,8 @@ static const struct regulator_desc rk809_reg[] = {
 		.n_linear_ranges = ARRAY_SIZE(rk817_buck1_voltage_ranges),
 		.vsel_reg = RK817_BUCK3_ON_VSEL_REG,
 		.vsel_mask = RK817_BUCK_VSEL_MASK,
+		.apply_reg = RK817_POWER_CONFIG,
+		.apply_bit = RK817_BUCK3_FB_RES_INTER,
 		.enable_reg = RK817_POWER_EN_REG(0),
 		.enable_mask = ENABLE_MASK(RK817_ID_DCDC3),
 		.enable_val = ENABLE_MASK(RK817_ID_DCDC3),
-- 
2.43.0



