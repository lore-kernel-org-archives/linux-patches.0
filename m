Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D2A43302F;
	Tue, 21 Jul 2026 19:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663846; cv=none; b=cXkE1TsrECRtOMO9OUOIw49MesCCYL+hI395hzS4z8Q5dNupw9GNDh0alN8t3AlrRlDRl1pdHrr2gPUDgmH1NGIiE/bFbnxTobRx5Wn7YpTHN61MbCczW0YMqJgW1/g3OwSPcx2mUdEZLtZvQ7V8Ipzne9e3N0XWHGqeL//OpvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663846; c=relaxed/simple;
	bh=6Gar+6WzbMRJ+DDawshjYt9R6GytcRn1RJcTTUqEXYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEMawF6fialZFLCp0Ow9ji5yeyXDb5gTRXxaAbtwNireLIDPeoxpqibVqiYHGZC5jotYuTjZjJKBF1FSanIwvOIvY4Mj+O2PNq2gAyL/syL4uxwPZe3//D987WAZEMrH1T08vZS8joBEiqjt0hwR07WcemT1P26LauDuy1Vyowk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUpERRN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUpERRN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8FE41F00A3A;
	Tue, 21 Jul 2026 19:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663845;
	bh=tAUMwIEO3EoKDVUp60GG1aarbPlupPc2TAgeJpwRPV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VUpERRN+JAqTcNJ2AEKb4OigbmqBQS52QpMZWwl/gTzTa3zCXjoPWj/IDdePq+wpK
	 TmjmBW8He8xytMe2zcvbW5aAO8eRgIfrj9oQ6vGNTuLhpfoaLVIxRRWj25ng1KYN45
	 lxU2USL1nAs+ruWuxQEc3SMjJ1ti4AsdqgCUHA3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.12 0978/1276] i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
Date: Tue, 21 Jul 2026 17:23:41 +0200
Message-ID: <20260721152507.906024905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

commit 71356737a7a55c76fee847563e3d33f8e6dc6b6d upstream.

If devm_platform_get_and_ioremap_resource() returns an error,
mlxbf_i2c_init_resource() frees tmp_res before reading tmp_res->io to
get the error code. This results in a use-after-free.

Save the error code before freeing tmp_res.

Fixes: b5b5b32081cd ("i2c: mlxbf: I2C SMBus driver for Mellanox BlueField SoC")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260714150808.85045-1-xuanqiang.luo@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-mlxbf.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-mlxbf.c
+++ b/drivers/i2c/busses/i2c-mlxbf.c
@@ -1082,8 +1082,10 @@ static int mlxbf_i2c_init_resource(struc
 
 	tmp_res->io = devm_platform_get_and_ioremap_resource(pdev, type, &tmp_res->params);
 	if (IS_ERR(tmp_res->io)) {
+		int ret = PTR_ERR(tmp_res->io);
+
 		devm_kfree(dev, tmp_res);
-		return PTR_ERR(tmp_res->io);
+		return ret;
 	}
 
 	tmp_res->type = type;


