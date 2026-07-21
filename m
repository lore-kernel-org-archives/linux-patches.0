Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA0C6357CEB;
	Tue, 21 Jul 2026 21:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670156; cv=none; b=AWdNDqCHOKepqA0/x2jk+u+23C0AQ7WpqpsSg8o/RKzetXbzHIc/vIL299mX4Mh4Vst68pcCmu6Bl9nJm/4dTvPyws3lHppSA6BXtRST02QzjJ62F6P3KgCPoXvgaH3qwiJTQz/3IUtzatqa/yHQDLFaIH2K9UtuBBPerH8FaFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670156; c=relaxed/simple;
	bh=AhslXXSgQulh7AWinQPnpUsEOz7ZXX4knr+3i2QokwM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ruW6L5xUcZYTbrFC/pI9KARn0n/2wfBr9FteBpGJvyrT1RY0s93zOJqtWBOhzarloUStqWR9xaPlVdMkfTB6kJLyYcBrfKcES0TvUsYBe5QMgVtMJw44cruag5VuVIfyCmmbLLdnj8Gow+FxLTOn2YbWkNYhU6k6t+0kFkhn+E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aicgdpXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aicgdpXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4D61F000E9;
	Tue, 21 Jul 2026 21:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670155;
	bh=tX+p2QnzruOt/ooYTAD+wSolDtqJ+OGIJVKU9apS2sc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aicgdpXcU/ieyG+huJSOgfU3d/0KTe8TpEKZwJamASVPrLwuQAUlWfBQL1DMf2HhD
	 rDe8zYoX7fWCCnCgvyLGsyKGMq0AkGZDTmby1a3knLMuydSPSSCo8X/oVDgNIdErP7
	 g2lG47GVsmzb86mWXqO6KZwpnwewj9ayLHmW4/2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.1 0825/1067] i2c: mlxbf: Fix use-after-free in mlxbf_i2c_init_resource()
Date: Tue, 21 Jul 2026 17:23:46 +0200
Message-ID: <20260721152443.006549858@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -1088,8 +1088,10 @@ static int mlxbf_i2c_init_resource(struc
 
 	tmp_res->io = devm_ioremap_resource(dev, tmp_res->params);
 	if (IS_ERR(tmp_res->io)) {
+		int ret = PTR_ERR(tmp_res->io);
+
 		devm_kfree(dev, tmp_res);
-		return PTR_ERR(tmp_res->io);
+		return ret;
 	}
 
 	tmp_res->type = type;


