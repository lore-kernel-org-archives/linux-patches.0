Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A4B3D6CCA;
	Tue, 21 Jul 2026 22:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673540; cv=none; b=O9Gz0B8a32C2Mym/pacJsDD1GseZnzeDQpJK6t9Wr5TDdXAFyS/lcBfgmZVPs1m8bIzIwmErnZ7yoswwLQdZUyO7mSJlFhAkkwM92yU4pNo3fIf2VU8ABunga45WyQWLPjOn/TblUMsW+qiyOAXrpednxsXnDvi33NLDG4DB9P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673540; c=relaxed/simple;
	bh=A53JOLi5d4r3kKwsBo0OoBwVKearEq0ok9rezIB+qHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rz+rw0K4TBnc6Adv13Z+tKZKBVG9L0YjMrIN432qoq8DScTJKTfoWKuewR8tp/KFSdEWskPvAE7h0wBVlHeaKNlVX5YGdIUsYZhsl/sjPRDAlqSAqcZXorW01cAlDHE83ohqTu7Uo2AblPZukAzElaedpFn3Nfk4+fpb93szhMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R1yIf7dl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R1yIf7dl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D985F1F000E9;
	Tue, 21 Jul 2026 22:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673538;
	bh=e+MOIFVgSDz2Ck3+D5L6UVh2QZdIspsYPsDfpbkMAKs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R1yIf7dlwLUgXde3kaBO1hHiTC2i1Nms4IMAMWaNu2UbKxtDkFhrHJkxeIUTs715+
	 d4Xm5XaCGwPsO6Z7BAdtWERPhS7KlfeJN6EQGC7cvrnxtRuF4vgCj12V4kKJuwtZl5
	 m8Z0wiEFdjCmzLnRDqbzZa6W0U6BUJTiqaNqECfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/699] bus: sunxi-rsb: Always check register address validity
Date: Tue, 21 Jul 2026 17:19:19 +0200
Message-ID: <20260721152400.209054056@linuxfoundation.org>
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

From: Samuel Holland <samuel@sholland.org>

[ Upstream commit 61192938a5870ac36edae81e4775b680dcf02c61 ]

The register address was already validated for read operations in
regmap_sunxi_rsb_reg_read before being truncated to a u8. Write operations
have the same set of possible addresses, and the address is being truncated
from u32 to u8 here as well, so the same check is needed.

Signed-off-by: Samuel Holland <samuel@sholland.org>
Signed-off-by: Andrey Skvortsov <andrej.skvortzov@gmail.com>
Fixes: d787dcdb9c8f ("bus: sunxi-rsb: Add driver for Allwinner Reduced Serial Bus")
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Reviewed-by: Jernej Skrabec <jernej.skrabec@gmail.com>
Link: https://patch.msgid.link/20260301144939.1832806-1-andrej.skvortzov@gmail.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bus/sunxi-rsb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/bus/sunxi-rsb.c b/drivers/bus/sunxi-rsb.c
index 98cbb18f17fa39..411bb5a3e92574 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -429,6 +429,9 @@ static int regmap_sunxi_rsb_reg_write(void *context, unsigned int reg,
 	struct sunxi_rsb_ctx *ctx = context;
 	struct sunxi_rsb_device *rdev = ctx->rdev;
 
+	if (reg > 0xff)
+		return -EINVAL;
+
 	return sunxi_rsb_write(rdev->rsb, rdev->rtaddr, reg, &val, ctx->size);
 }
 
-- 
2.53.0



