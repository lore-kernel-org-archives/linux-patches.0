Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832583264FF;
	Tue, 21 Jul 2026 18:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658876; cv=none; b=Yn1UkdMZz4VFTaL8jdZQgiESMKozmkqZrzzwZqFCKtNrsJ+Xzc5UHcZCZsQAcbxiLN3UhBdkdkKCq7GT/+Ail/k9u9S66wL+zLkvBgzJazHCmj2HwKl19Jp2VgQHFYJW2dI0oUrT3iVh+jqWiugw1TlFN6KR04/oV3X2O9YKl/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658876; c=relaxed/simple;
	bh=rAgTMm6sQ9OOUeiKEWgk9N3wU7CwosJeFOJC5W00v+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ne+WJzFdbJ0GuLJf+A+142YCQak9UHZMv9ej4E7mvOdwRjVUMKxJopnwPdlxWrNFmDGsJyjMX6jFlHcc+Rs4S5VRWOTxYR0HoOskOACJBMxfRLq/7Ln4bVaIy/qYDwPtgdvJ14JH+FmccJeKgY943OjMDFPixmQ46YTRWTBdGEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1QgUkduU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1QgUkduU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C09181F000E9;
	Tue, 21 Jul 2026 18:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658875;
	bh=NeBsheEkPv1RST+DdxKppdYoXRx3EI/ZyKc+qdjS+nk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1QgUkduUoKbLJ3UOOdvJImOHKLuNURaRAwUZNUwTrE0G+6H599uoWOMBXqBsvBHFl
	 NIfq40np1JXr6Q4svCRrjjh6+24S4vXpbk1hqJtHXqSCipkCSFqTh1gV5XDgJIF4dl
	 l+2CB+ocIW71S02TVej/YsbgVUJJwREW9sOaFyY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.18 1310/1611] i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
Date: Tue, 21 Jul 2026 17:23:46 +0200
Message-ID: <20260721152544.919670649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1058,8 +1058,10 @@ static int mlxbf_i2c_init_resource(struc
 
 	tmp_res->io = devm_platform_get_and_ioremap_resource(pdev, type, &tmp_res->params);
 	if (IS_ERR(tmp_res->io)) {
+		int ret = PTR_ERR(tmp_res->io);
+
 		devm_kfree(dev, tmp_res);
-		return PTR_ERR(tmp_res->io);
+		return ret;
 	}
 
 	tmp_res->type = type;


