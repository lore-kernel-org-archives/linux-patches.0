Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0009E347BC6;
	Tue, 21 Jul 2026 22:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674317; cv=none; b=Cj5r1VZd+opsMzybO35EHbkLw5JXM2YqUpDDpP3Gp6okS7nJ3h1FRSb7Ng8uUjSX1CDJv9/m97DhDFxh6em7pDCYrSlW4aEaZvwfidX9is/rlQAvJRz48YCXfAoKdDhOmMSBx8n0s7w9+x0jQGMLjljyWkPi9IhSHoRiMMKdj+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674317; c=relaxed/simple;
	bh=5FAC/rVBwPFyflRBHfoOirWViaRnMJtsDs3ueZFEo2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0kafOWowyblbeB+4yDmH0usge9lOAYbIDk7AjUZz5DDAFsqMHYIqrE6kR+DOr4gbAD4F1nwm6xbf1dF3yC/Iq3PLI3Z8gQ7sxKIS6J0xOT+hBv85jr4Wc/gFTNRBEj5LvUZhdoQNsM5lnOdrXqO/VeMAE/MdacB3WNpFiXmXyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZYGaZP3R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZYGaZP3R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A7601F000E9;
	Tue, 21 Jul 2026 22:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674315;
	bh=X+OTvNmV40osTqJXmas7gD0t6fdl2kig5Zr3QdgpkTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZYGaZP3RS4XamVnFJbkdfDNTuD2UCG6yE35JwTw8gYtZF/XKkkf0t+HyFtw2xLWom
	 ctzK6z0K61Rx5BVh54zQDw++eGsNs4Qp6sYkTSpXwtssxqEwwZYiNjvyl7FgQsh8a1
	 HRWWTyehZXVrcuKRrvFajnwdouiWHkpc1Rwo617w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.10 493/699] i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
Date: Tue, 21 Jul 2026 17:24:12 +0200
Message-ID: <20260721152406.817214378@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1063,8 +1063,10 @@ static int mlxbf_i2c_init_resource(struc
 
 	tmp_res->io = devm_ioremap_resource(dev, tmp_res->params);
 	if (IS_ERR(tmp_res->io)) {
+		int ret = PTR_ERR(tmp_res->io);
+
 		devm_kfree(dev, tmp_res);
-		return PTR_ERR(tmp_res->io);
+		return ret;
 	}
 
 	tmp_res->type = type;


