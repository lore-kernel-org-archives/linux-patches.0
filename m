Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18B0443CECF;
	Tue, 21 Jul 2026 22:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672588; cv=none; b=RxWu3nlgpEl87t05j6oJ/MSi4AMmbcoIxY1ivR6M3xIfJAlSwlK9P98r63WQwvAFAJfGzz23iu8Zr8yJ0pSc1Mh9thje998krA4zjM/QarF/Rtg1NiXV1gt2tFiN+7EAeNjuMSfgpDAzGNqTnyLLog35+gejolJs4a6vO83gRQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672588; c=relaxed/simple;
	bh=4HX7z2+o2kZ9fOA2B/ozisYEAJVKK83Kr8k+pdamyBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KaGpmifLxqijt0hB1WVgZgnP2heesX04pozI9YvwaZpqgN2+pthpCSe7nQO5K5F+ScbbFdTbB3nHBar+dSx/qcaYVJiGnIkzt48RDnYDqEboKUFCClgvk2aB12I8Rbpk6dtxmRtabOUVREP6JYmg0FB4EJKhkh9lIcK9NGYsxxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFZzCKOj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFZzCKOj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6CA1F000E9;
	Tue, 21 Jul 2026 22:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672587;
	bh=Gn0DyoB83BjkEA6llXOI2oNlsEcTJnAFLAdJQvuO87E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qFZzCKOjutxIk6X7Dc0ROQwJH/W+oiH0b/2Sso65VLGkVNQKhZyrRYSItGU8ED/3o
	 F4ARfGheQAM+UpHKaxQ5LyuAIfsp/W+frXaWk0MFbsC8RC55u/Lo3Yy+qItkndxDjY
	 BANlXEDRzOJtfnIkxT9k/vAzq5Kb3q6Ejg3n9740=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 637/843] i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
Date: Tue, 21 Jul 2026 17:24:32 +0200
Message-ID: <20260721152420.395152940@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1057,8 +1057,10 @@ static int mlxbf_i2c_init_resource(struc
 
 	tmp_res->io = devm_ioremap_resource(dev, tmp_res->params);
 	if (IS_ERR(tmp_res->io)) {
+		int ret = PTR_ERR(tmp_res->io);
+
 		devm_kfree(dev, tmp_res);
-		return PTR_ERR(tmp_res->io);
+		return ret;
 	}
 
 	tmp_res->type = type;


