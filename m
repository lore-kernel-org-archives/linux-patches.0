Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8DCA51A725;
	Wed, 30 Sep 2026 16:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784640; cv=none; b=rkYgXvXs8CFJcmJ00URWUKPVnG6KAMBHDY8iR+vtkUpxV8Hg33BsFV6vA1RMTKXNv9wCfwWclPiCiKDUQu26CjQOfEWJ64+bahlwsLy6lK2Xk0PTblAWY4nzJ2JSA6UM5Xh8TvHYhBoA62hM30Nek76hFAfhTfoDLEkvUMQGlow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784640; c=relaxed/simple;
	bh=/+7sA01jm84bBulbccOohFKyYG9YSxCdd4n/Sl6y3Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B97OQOoZ9DZs9bTzdG0HLXgs7xDGKNlVq4LYGGCdmh/BU144oEKIAL6GbUtwZ7o5i+ecwekZ+bg19usfUwpZYnZwcMmhYQhoUCboPsKTsmkc3eaTh7jgp0lyNYiVF03emqB98DXVUhuV21EkmI7rFsLpqToybvI6X9FskU21QE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VSP01G8p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VSP01G8p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 655E11F000FF;
	Wed, 30 Sep 2026 16:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784634;
	bh=S9YP3fzQCNBGiNB621gQDOKaF0xC/3KvU2jI5qpNDqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VSP01G8p5/+hl5XDw8XhKXVg/w7c5gDa5LO5hrO2Dq5phqMu0/KDKn1RzwG2sljnC
	 vz0AGhWDizi6BUEVkT6cmFvhblpAgaf7a6mx318kGeIY0cfWYiXRcJuCrDENII/phr
	 4HTzQC9CmWZNRKvgLaw1qISiWr8ymuvmXWRiDQyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/982] regulator: da9121: Use subvariant ids in the I2C table
Date: Wed, 30 Sep 2026 17:16:01 +0200
Message-ID: <20260930152421.633029093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e4c753b830888..3b34e1e027ef0 100644
--- a/drivers/regulator/da9121-regulator.c
+++ b/drivers/regulator/da9121-regulator.c
@@ -1179,15 +1179,15 @@ static void da9121_i2c_remove(struct i2c_client *i2c)
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



