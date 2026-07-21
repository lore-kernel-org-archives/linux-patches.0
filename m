Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DD8439322;
	Tue, 21 Jul 2026 22:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671465; cv=none; b=fo7vKWAd5aJ2oG78TEldfi0YdXxCjHaZTURnTA8Bep9xz3ke1eJN7q0g5tA+QMTxTkSyweOR/joc6ysdUZqONvjFWLoiFr73iwuaGtKzNSlH2CMssV5aOsoXWAe4uDIuw/d6wrR8SQhfqyuRIRH1lh4/BBB05rLkRZUxR1q0Xhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671465; c=relaxed/simple;
	bh=HzmA43qNv+MbuIuVxK76LxtwtYVCuTmLB57/J6YkUN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsccmbz0iAbkI2kQnP1Bag71cJQf+s6dh88lpFDemkegHb6D6hCzuv90splTZE4zwdw7y4YB1t98tAb4KLgCKaZty1ooKw+jMF5vfNNXA/GDbS7omIRmQ1R958KXeShfeE8nJ+0G26lFhIELBQngBwGyQTnOji+2CcbFg5nyd/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1eo27sLl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1eo27sLl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D077F1F000E9;
	Tue, 21 Jul 2026 22:04:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671464;
	bh=puByh6QoGLg4omrxhUMHT0g3W4+y11UKgm1R+jZRkRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1eo27sLl9VRqQ6FG9C+J8zkvATtimG8KY8TP4NztGr7zk8CJkmB7dSeC7V4Yurn+4
	 h+vky42Cs746psABRdQpm2EML/sySdkzJaQNnHDS5jl5yok0b83EMRQLIao28sbK9t
	 y9u/1qSBFOBA1ds9lbvKCgFbY8uHiLP0d/XUEsTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samuel Holland <samuel@sholland.org>,
	Andrey Skvortsov <andrej.skvortzov@gmail.com>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 255/843] bus: sunxi-rsb: Always check register address validity
Date: Tue, 21 Jul 2026 17:18:10 +0200
Message-ID: <20260721152411.760494302@linuxfoundation.org>
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
index fac8627b04e346..a16d689aa28fff 100644
--- a/drivers/bus/sunxi-rsb.c
+++ b/drivers/bus/sunxi-rsb.c
@@ -446,6 +446,9 @@ static int regmap_sunxi_rsb_reg_write(void *context, unsigned int reg,
 	struct sunxi_rsb_ctx *ctx = context;
 	struct sunxi_rsb_device *rdev = ctx->rdev;
 
+	if (reg > 0xff)
+		return -EINVAL;
+
 	return sunxi_rsb_write(rdev->rsb, rdev->rtaddr, reg, &val, ctx->size);
 }
 
-- 
2.53.0



