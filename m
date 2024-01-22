Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2872612FF73;
	Tue, 23 Jan 2024 01:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971810; cv=none; b=X3+iqJ9m4b86KjS1gN5WSfNMLodd6fxX0/EjLUcofqUItBU9yJD43awowWSmxBM+1XKMTtXip3s9h6++vEq4sPz87W3Kb6Wng4rCaHcHoDQQgysHonB6Uq+PajSpSTMcoVNqTRnsI0CInxvHPpxQJNPQ/YXBM1Nww92TOrHDrlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971810; c=relaxed/simple;
	bh=OX2RYQlSDfQINUcEkGSDPPcl55u7DutfZmKCOVjRwbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soXd7qbBresWnTbalLe335KY8rMVqowVxFR6J4/t8m7A4dpEs88Yp6IFnrlsNUW1WPQZSL8o4kpJgxCkX0JodI8kdETNicKNXEurVVFFug23H/4FYDxvDpjkk+WdKWCPTwvRE1qqU7ZPXlP+Uz7SGpJrJvJlYzvaOSjfN+gluXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2tLvlGFf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2tLvlGFf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFD8C433C7;
	Tue, 23 Jan 2024 01:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971810;
	bh=OX2RYQlSDfQINUcEkGSDPPcl55u7DutfZmKCOVjRwbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2tLvlGFfSHbu5UNCaalsb8wd4umqqKW1FEk6gWR4q5w2YNm+0DMfBBYGMvgYBq0Y9
	 UdDWTI/rTUg99viZ7BjAmQ3pYn5H0Tun/ZKFpIFODzNzqLeCLiN3Pje9ye007iCpUf
	 FOe4Fk5NYZdpjYpujEy33oMWCnK3H2/aQK1InDDA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Arnd Bergmann <arnd@arndb.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 236/286] mfd: syscon: Fix null pointer dereference in of_syscon_register()
Date: Mon, 22 Jan 2024 15:59:02 -0800
Message-ID: <20240122235741.155854900@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index df5cebb372a5..60f74144a4f8 100644
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



