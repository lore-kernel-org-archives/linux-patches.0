Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C21F263C90;
	Tue,  8 Apr 2025 11:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111366; cv=none; b=RJotXLRM8PtaDqm3aoLlocyICpHMkLX3PVcAK9LAzAzQd25I3iXg4KdaNhXhyL58IYVucJpSkhNls+MDw2rCMzF/Lvq8wFpfba4SLzNmyQ91ABT3LkfIX7uHo9KSnXeujiQB8PNOcY1rGwMYM6IWFm+9BlAuk603CYrelsbWDDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111366; c=relaxed/simple;
	bh=UK2y2wUzVOhFdLanGNbSg//9UBf71jV7HS6b/Dc3lUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bk33NBpFXAS1mofVLbuqIiUaHNBMHzE8I9i6CXunm00659rB+4NO5+NBqMP5UowlLjfeomOM7ByZLcou1pXwg90/oKWrVo6TVaduRvFwwmx+RddhJnghrRMmT11KBp+TKE9btY4tWyUqVCeL7FXb+FsB8woYYIqFYERGFM/RJmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/8DlMak; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/8DlMak"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D5DC4CEEA;
	Tue,  8 Apr 2025 11:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111366;
	bh=UK2y2wUzVOhFdLanGNbSg//9UBf71jV7HS6b/Dc3lUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/8DlMakuQvjhGX9vz5JeXoA3iKOcUBOSApVjXKH+F5YiD2X8b9qT8fcWkpJN1jCX
	 OxglLDJUwKPBnwrege9WHInMzv450yu7W6/CfrLBgCU7Xb6WrOiq0Xx5kjomUah9hC
	 tbH3hJwlMD3Ui0KkIm7DgoFmFxwBZMkSwUZIWhE8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 406/731] crypto: tegra - Fix format specifier in tegra_sha_prep_cmd()
Date: Tue,  8 Apr 2025 12:45:03 +0200
Message-ID: <20250408104923.716733043@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 795e5bdb0ada2c77ea28611d88f1d5d7ca9b2f4d ]

When building for 32-bit targets, for which ssize_t is 'int' instead of
'long', there is a warning due to an incorrect format specifier:

  In file included from include/linux/printk.h:610,
                   from include/linux/kernel.h:31,
                   from include/linux/clk.h:13,
                   from drivers/crypto/tegra/tegra-se-hash.c:7:
  drivers/crypto/tegra/tegra-se-hash.c: In function 'tegra_sha_prep_cmd':
  drivers/crypto/tegra/tegra-se-hash.c:343:26: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'ssize_t' {aka 'int'} [-Werror=format=]
    343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
        |                          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  ...
  drivers/crypto/tegra/tegra-se-hash.c:343:59: note: format string is defined here
    343 |         dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
        |                                                         ~~^
        |                                                           |
        |                                                           long unsigned int
        |                                                         %u
  cc1: all warnings being treated as errors

Use '%zd', the proper specifier for ssize_t, to resolve the warning.

Fixes: ff4b7df0b511 ("crypto: tegra - Fix HASH intermediate result handling")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/tegra/tegra-se-hash.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 65a50f29bd7e6..42d007b7af45d 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -340,7 +340,7 @@ static int tegra_sha_prep_cmd(struct tegra_sha_ctx *ctx, u32 *cpuvaddr,
 	cpuvaddr[i++] = host1x_uclass_incr_syncpt_cond_f(1) |
 			host1x_uclass_incr_syncpt_indx_f(se->syncpt_id);
 
-	dev_dbg(se->dev, "msg len %llu msg left %llu sz %lu cfg %#x",
+	dev_dbg(se->dev, "msg len %llu msg left %llu sz %zd cfg %#x",
 		msg_len, msg_left, rctx->datbuf.size, rctx->config);
 
 	return i;
-- 
2.39.5



