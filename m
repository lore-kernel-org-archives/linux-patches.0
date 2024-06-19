Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC3182495;
	Wed, 19 Jun 2024 13:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803234; cv=none; b=JoUXr5Pb1B239nCavu8giViIK7BlN2ciKrqVODkWfBXY/LLJOtD01iOhZzrdFJDJ6ESLmeEgmTCeMBSCfExVMin024xWD8Aw3OINmqdOzDdG2Qi5gXn/WIQau3BDMB1rYzsiMJbDP5FxHbXVsDH+t50LATp3nIATpELm3bbYgwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803234; c=relaxed/simple;
	bh=H6mex0kS9qrn+3WVeI9/RLeTN1XoyIC/HQSbB9EPZnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NW+woLp6TKPYvuEff06JW+R9wcnrqMtYMzv/2p9YS1JWQLl6Yi46qe3TXeEYIbVHX0GE6MTDEsTCkC9hRh8MAgm6by386Oj8YXgjL+CK1fDZvEirWPCIY9BGU/mdcv9PJvxID2QO0Ayicx6KvvE+bHahyALL1gRhTiYcSBlmSLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q75pSlf/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q75pSlf/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC5CC4AF1A;
	Wed, 19 Jun 2024 13:20:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803234;
	bh=H6mex0kS9qrn+3WVeI9/RLeTN1XoyIC/HQSbB9EPZnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q75pSlf/tcmoXLH+IX/6ZSJ40zphuEQMI59shSiCh/8HaT9wIAE+5s4sM7MHabtqd
	 S5OtiKuh3MSXQ+3SqXogRoeyogJPQkfu6Osmp1cKxCse6itjdQ8WpB4/SfhjcEFkXG
	 EX0eYh0rg1zAfHOca5gjP5w1SB1sVqxyWAzQU2vA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Crt Mori <cmo@melexis.com>,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 198/281] iio: temperature: mlx90635: Fix ERR_PTR dereference in mlx90635_probe()
Date: Wed, 19 Jun 2024 14:55:57 +0200
Message-ID: <20240619125617.569716229@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

commit a23c14b062d8800a2192077d83273bbfe6c7552d upstream.

When devm_regmap_init_i2c() fails, regmap_ee could be error pointer,
instead of checking for IS_ERR(regmap_ee), regmap is checked which looks
like a copy paste error.

Fixes: a1d1ba5e1c28 ("iio: temperature: mlx90635 MLX90635 IR Temperature sensor")
Reviewed-by: Crt Mori<cmo@melexis.com>
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Link: https://lore.kernel.org/r/20240513203427.3208696-1-harshit.m.mogalapalli@oracle.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/mlx90635.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/iio/temperature/mlx90635.c
+++ b/drivers/iio/temperature/mlx90635.c
@@ -947,9 +947,9 @@ static int mlx90635_probe(struct i2c_cli
 				     "failed to allocate regmap\n");
 
 	regmap_ee = devm_regmap_init_i2c(client, &mlx90635_regmap_ee);
-	if (IS_ERR(regmap))
-		return dev_err_probe(&client->dev, PTR_ERR(regmap),
-				     "failed to allocate regmap\n");
+	if (IS_ERR(regmap_ee))
+		return dev_err_probe(&client->dev, PTR_ERR(regmap_ee),
+				     "failed to allocate EEPROM regmap\n");
 
 	mlx90635 = iio_priv(indio_dev);
 	i2c_set_clientdata(client, indio_dev);


