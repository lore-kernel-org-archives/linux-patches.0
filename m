Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 840FC1AB538;
	Mon, 14 Oct 2024 15:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919067; cv=none; b=Iu4PMj9ORe9UjhCLvUjLMTvUMCpjHflECZxgAvGKNN2pnHY25JcA441KKizo3+cX9SZ5pdax0EDeCYrrOuUQKxQw+1KamEK+Nt5tCl4YsLwveT5y6Zt20bqBPIJbgEV4xsU39v9tL1PwqTDm3T/pUny0nzyzdyyOEf0EOmqXANI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919067; c=relaxed/simple;
	bh=1OfgciQKTtRDsDQG+HvcMc4huedjevJP9/8tpMCbiXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EW7bKek5zSNvwgQY8YBHPd1QQ5naEZ6L8XohqAjHqaa7tEAWiJd3y4XbImht9IJDoGIcc4M25Mb0ernhWFFnk18h4z2xSfN7oEzQ2HyNO4cVpSbnEceGjjg7nC44OdnADPloRbxfXWlfUJj8QNogZPWiumQ1ZvGxHqCnS1dqQnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rrca6jwm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rrca6jwm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB80C4CEC3;
	Mon, 14 Oct 2024 15:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919067;
	bh=1OfgciQKTtRDsDQG+HvcMc4huedjevJP9/8tpMCbiXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrca6jwmLlgwP6/7taVm9B74ssm3vC/XB/Wdb6RCYvLznctV0GnUKUccz6w3zsmeN
	 TipYL/k8oDgLg00t4rCuXXYjpel1W2e/ucEKbYfizcScgESvIZOc1ghVSDfDBJj5mF
	 1wE2kz43ZFrS4qeiuo3UlubHA4dI43+RinqUlTt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 504/798] of/irq: Refer to actual buffer size in of_irq_parse_one()
Date: Mon, 14 Oct 2024 16:17:38 +0200
Message-ID: <20241014141237.778859370@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 39ab331ab5d377a18fbf5a0e0b228205edfcc7f4 ]

Replace two open-coded calculations of the buffer size by invocations of
sizeof() on the buffer itself, to make sure the code will always use the
actual buffer size.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/817c0b9626fd30790fc488c472a3398324cfcc0c.1724156125.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/irq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/of/irq.c b/drivers/of/irq.c
index a8e306606c4bd..c0578e22c625b 100644
--- a/drivers/of/irq.c
+++ b/drivers/of/irq.c
@@ -357,8 +357,8 @@ int of_irq_parse_one(struct device_node *device, int index, struct of_phandle_ar
 	addr = of_get_property(device, "reg", &addr_len);
 
 	/* Prevent out-of-bounds read in case of longer interrupt parent address size */
-	if (addr_len > (3 * sizeof(__be32)))
-		addr_len = 3 * sizeof(__be32);
+	if (addr_len > sizeof(addr_buf))
+		addr_len = sizeof(addr_buf);
 	if (addr)
 		memcpy(addr_buf, addr, addr_len);
 
-- 
2.43.0



