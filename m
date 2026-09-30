Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159292DEA95;
	Wed, 30 Sep 2026 18:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794593; cv=none; b=CeBEYKukWEIIIbBuWWtxpll+crM52ZRfxOHoyblx7Hl6HD/B1Xc8IuTztFxTpGlc1w+++VMeUGvA8t0sdH9OPyW0x0TQJCO7aBvTPRoxW3tu/SWW+yxjiC1+XKB581PMX3pYOnjGsilMp85BhLFK8GEIxfSRb7guxa+ea1+Osjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794593; c=relaxed/simple;
	bh=EtOtssWJE2EQYVNI+xEvanqdjvjVVCzEAUBzx1OQxmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Udsn3fa/S7ZRMUiahWHbZePMa8VSeiulvC27uvh1D3v67i5fe8Q2BrdkZXx+cwLputhc/k52+3Mf85X8BwOFVNc1qpSru1Akbyi5yIBdifTp+AcQfW68BW1iG+wEIUzqwU0hb5InQhGjsXsOObbBBf0wAn1hJFzFczCsDpoSmQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gcvhhFxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gcvhhFxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725921F000FF;
	Wed, 30 Sep 2026 18:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794592;
	bh=aheDhFouXP5t96LQm211ctVVEyYq/PZXHxtY9vC68eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gcvhhFxejFHKSTzbxBo8MKoxD/re1knwY1lj1nzPBRanBcQ0JjTsGxGXOCqKptyLx
	 CcZX/3Ic000AxzEsBoscsOc/YToMjOZ9CbXRuoQhHKVZofu6gwB+yeyk/9hyveFPlS
	 E1hgiUONHWRvPk6gK0BhTs+p/OqLGvs30ZMN5Mok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0264/1193] regulator: da9121: Use subvariant ids in the I2C table
Date: Wed, 30 Sep 2026 17:15:48 +0200
Message-ID: <20260930152440.036907580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 7ddbf1cde4a03e36e17d06fbc711870eb0b256d7 ]

da9121_i2c_probe() stores i2c_get_match_data() in chip->subvariant_id
and da9121_assign_chip_model() switches on DA9121_SUBTYPE_* values.  The
OF table provides those subvariant values, but the I2C id table
currently provides DA9121_TYPE_* values.

Make the I2C id table use the same subvariant namespace as the OF table
so non-DT I2C matches feed the expected data type into the model
assignment code.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260624060024.61300-1-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9121-regulator.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/regulator/da9121-regulator.c b/drivers/regulator/da9121-regulator.c
index 80098035bb13a..a162daa5a054e 100644
--- a/drivers/regulator/da9121-regulator.c
+++ b/drivers/regulator/da9121-regulator.c
@@ -1178,15 +1178,15 @@ static void da9121_i2c_remove(struct i2c_client *i2c)
 }
 
 static const struct i2c_device_id da9121_i2c_id[] = {
-	{"da9121", DA9121_TYPE_DA9121_DA9130},
-	{"da9130", DA9121_TYPE_DA9121_DA9130},
-	{"da9217", DA9121_TYPE_DA9217},
-	{"da9122", DA9121_TYPE_DA9122_DA9131},
-	{"da9131", DA9121_TYPE_DA9122_DA9131},
-	{"da9220", DA9121_TYPE_DA9220_DA9132},
-	{"da9132", DA9121_TYPE_DA9220_DA9132},
-	{"da9141", DA9121_TYPE_DA9141},
-	{"da9142", DA9121_TYPE_DA9142},
+	{"da9121", DA9121_SUBTYPE_DA9121},
+	{"da9130", DA9121_SUBTYPE_DA9130},
+	{"da9217", DA9121_SUBTYPE_DA9217},
+	{"da9122", DA9121_SUBTYPE_DA9122},
+	{"da9131", DA9121_SUBTYPE_DA9131},
+	{"da9220", DA9121_SUBTYPE_DA9220},
+	{"da9132", DA9121_SUBTYPE_DA9132},
+	{"da9141", DA9121_SUBTYPE_DA9141},
+	{"da9142", DA9121_SUBTYPE_DA9142},
 	{},
 };
 MODULE_DEVICE_TABLE(i2c, da9121_i2c_id);
-- 
2.53.0



