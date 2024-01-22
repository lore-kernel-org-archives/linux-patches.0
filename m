Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBC461673;
	Tue, 23 Jan 2024 01:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974950; cv=none; b=qCjA9N7OEfl7ZKh8BNYx7Hi4BEwZxdFthmfvuPw70dlAdziZ9ePtQg8CoLESPNPL6V3F+ok/MIm1Yw8H2VF2PMZ7Z8y4IrHhhlZT/ZvUK5r+PIx8ac4RRxwDWJvBTvsj4hlUH5xcHO+fFW4peBln2YjjlbJ3yZqyz4dg4/JbDr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974950; c=relaxed/simple;
	bh=RkffaHa+FuoEImnKQ75hzZYsZjvyHYpUlvj23FbLCis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTdHVumvT9uU0MLCZSprlMFob0/V93kEY9LBEiycfA3PLgK93Mo1c4lk0QdUz/wD8B2Z9/zaHIa4bSOqv8+aGmYLLHkQ0Wu6p7ngBuFRWqmO6Thxc+R3QlGDN8+GOuXgYmLQvgH+FP3Rzz2dxXllHO7rDHvddSp4fpPVPg0QoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2kQ0Y0z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2kQ0Y0z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66E3C43390;
	Tue, 23 Jan 2024 01:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974949;
	bh=RkffaHa+FuoEImnKQ75hzZYsZjvyHYpUlvj23FbLCis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2kQ0Y0z39LYifnv7zinwoU0gU06w6FuzHp/D1UHe4Noqtai9xrcoCJghnWYcsbyMw
	 zetBWbCddcc7ckUlXvdkqn+BOOw5v3Tw9mKkcrdECDCMGFwUcxIfVrpnNeSkJcRsTN
	 pc7sRw1ssS28/RrkSFXj0xmuvqAAH3VtK2aSaioY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 292/374] mfd: syscon: Fix null pointer dereference in of_syscon_register()
Date: Mon, 22 Jan 2024 15:59:08 -0800
Message-ID: <20240122235754.943550411@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit 41673c66b3d0c09915698fec5c13b24336f18dd1 ]

kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure.

Fixes: e15d7f2b81d2 ("mfd: syscon: Use a unique name with regmap_config")
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20231204092443.2462115-1-chentao@kylinos.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/syscon.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/mfd/syscon.c b/drivers/mfd/syscon.c
index 191fdb87c424..552b1861adad 100644
--- a/drivers/mfd/syscon.c
+++ b/drivers/mfd/syscon.c
@@ -103,6 +103,10 @@ static struct syscon *of_syscon_register(struct device_node *np, bool check_clk)
 
 	syscon_config.name = kasprintf(GFP_KERNEL, "%pOFn@%llx", np,
 				       (u64)res.start);
+	if (!syscon_config.name) {
+		ret = -ENOMEM;
+		goto err_regmap;
+	}
 	syscon_config.reg_stride = reg_io_width;
 	syscon_config.val_bits = reg_io_width * 8;
 	syscon_config.max_register = resource_size(&res) - reg_io_width;
-- 
2.43.0



