Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FF36206F18;
	Tue,  8 Apr 2025 12:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114727; cv=none; b=TBB0PSiJ9uVppp/P+tMg8InwO5q9VECLwUoAN3HFAZuOfmQi1mPcPaizzjAXIPRW5cHjPBvD372tlnmregrlXVXynngtT6J/AG8IYvE+Txj45oKTcB+IdMG5tkUn7mpNEFfp5ez8IpKsK9lcCE4QiAC/GdEnqldcBtRrIjIZjIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114727; c=relaxed/simple;
	bh=ALx2zBFl2hFmTHGDneDCXIKjKV/giaXYS64TP4Hv30Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lSxK9cwp/lnAUrV3hslXrSRh5jn4RLJroq/+71FyQfcqQ/qla0cmSogxdvO8760lMFejoE9idBmuc6kP/nzVi7nSOVlNHf7cpoFz4QyBhXyF9uSTa6AJPyL5NpJA5Q/TMCZRqPHbPFTcvLyjBHJmsddnySlR/JYTwSOz+MNV/CU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wnBtXPTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wnBtXPTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DBF2C4CEE5;
	Tue,  8 Apr 2025 12:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114727;
	bh=ALx2zBFl2hFmTHGDneDCXIKjKV/giaXYS64TP4Hv30Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wnBtXPTUcT2BwND5J9kI0NxFNu1LqFfwSGXae5uH8BQ7S2DB2IPD2/r3toLDjxX8g
	 5BtxrjaXJ03lYvdoGqTRFOAIRn6zhaFBqUQyhbdPBhWvN+/xpIda7pX5J1L7pt1r+p
	 X9K3q1fJkZEKd5e2540JIB/XhcRlUnWQhVuHQ8TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 174/499] crypto: tegra - Fix format specifier in tegra_sha_prep_cmd()
Date: Tue,  8 Apr 2025 12:46:26 +0200
Message-ID: <20250408104855.515309592@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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



