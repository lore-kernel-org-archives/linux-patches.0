Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2F3B47DF;
	Tue, 21 Jul 2026 20:55:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667340; cv=none; b=Lplmn7GSgDM17dDwj6qupusF6354sbbr/BgUwc1vmJfZ+xOlHlZ2efLkDDhDR6v+8XTExIPjFDHKSuuT/F7jIIxqdWQWNnxyGE1J7FrdAucpnPsADUEdjfAKyytMAicbILdC1uyPwZuc5brEHsc46D46wa6c92psOwqi+Nu7g00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667340; c=relaxed/simple;
	bh=ijBX98cNc1zSfJS/+LnuZXZx7Cb1SWqUm8VDLPyLqEw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1Jh94PCQiLbXCkjvqpknkaNhPi/E//OSTRlZda+SRbDGay9JuQN1n0OlkzKHTAdxHCUqsDZV40odI1gz4qzfIJOqRH5HJkUoi1O2pWF6tZ7tEtWBuGfFx1pH3JgSRV3d7kq/oDyigobCWQkAKy1yKO84BISbPn4ER+9l4FzVyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRtgbOAV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRtgbOAV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA11D1F000E9;
	Tue, 21 Jul 2026 20:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667339;
	bh=4Y8YFFojPz9L2iXyto9+kHjY32f+jIPLUMMVMK96uPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRtgbOAVIJlzmke3vXF/ZimytY4iknuUruhFqOoTpxJoHyBwoj4tIsyOOSXF1BW3S
	 UQzoVlOpEnHnrjEq5bZZwGPOhvZMuKXzoq9e97jm0idumxtvMroUyFUzXvMG1kakBr
	 Gi1ZCXEVvPPe22tqjDZK9wdDf70yI0nrKg+opYHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 1025/1266] i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
Date: Tue, 21 Jul 2026 17:24:22 +0200
Message-ID: <20260721152504.762960419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


