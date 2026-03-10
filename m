Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE45C352C4F;
	Tue, 10 Mar 2026 11:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141186; cv=none; b=MbyGZs5tYkRRmeKm58cUpZitqe/5lJzk1qLzb8T7UnP7Yif2K/+vtumzmO/r3GIatE6MeCs8abCZvVEOOzlnBDXC5hYgF0TGjlgtWVSZxmkPid6UC0Er7hwdFfqN1I0hpCQoSgO3XekaiZb5BvHa/ZkQm5tGuZWkM3gnwWLNprg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141186; c=relaxed/simple;
	bh=0YIp9WWztdCyT558xYzb9HQjv0h6QBChvpN97EC1J1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfVEchxTrgEQLnPsNZ9HP/8f2+Feh8pHx3c64Wr0qVW/fscI+RoByUF2cAUmmCSLeurSw6UfFeiO3+VsB56hrmV9rWAR74Rd4xjtTHsvGp+z6JtsU0M1s5+xLc7XJMngM+7XjB/e1YsBB5n4vjYncQgG/LH1OHeHdX8NyybY5c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DMNQXxy3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DMNQXxy3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E02C19423;
	Tue, 10 Mar 2026 11:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141185;
	bh=0YIp9WWztdCyT558xYzb9HQjv0h6QBChvpN97EC1J1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMNQXxy3VYzZ9y61IxYzjmo/y4CiTqkHrgJm50CiROB0grOLVTMWMO7Q0W3WQH/Yo
	 puLbKMyzSwT9EC2EnQLMql7fGnd7NFRAJOTt5c6PZ5TO3ADccCwXCRZ9AWZUesYwjg
	 3axv3MI+Xrrq+0Z+aWrNK6Eu28zAR7JbxGDuSAYtEFUiRSLcRKA7Jp9iGL+eYk75nf
	 bQXkZZqP8poQwtKjCEUZSm5b2udXtCiea/TCk3IuYMx0GcUSaySDj+ZAbL4NDchPXU
	 PXR1Rxx2pJMuRkEzl4GzSf88BANCgwhW7mHOPmjx27DxOvFrv3KWrBcac2Xspf6Nj+
	 WjDppA5teprSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Felix Gu <ustc.gu@gmail.com>,
	Antonio Borneo <antonio.borneo@foss.st.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 187/311] pinctrl: pinconf-generic: Fix memory leak in pinconf_generic_parse_dt_config()
Date: Tue, 10 Mar 2026 07:03:54 -0400
Message-ID: <75333806f5b4c72b26294f9ba80a6154d7e4a147.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 7a648d598cb8e8c62af3f0e020a25820a3f3a9a7 ]

In pinconf_generic_parse_dt_config(), if parse_dt_cfg() fails, it returns
directly. This bypasses the cleanup logic and results in a memory leak of
the cfg buffer.

Fix this by jumping to the out label on failure, ensuring kfree(cfg) is
called before returning.

Fixes: 90a18c512884 ("pinctrl: pinconf-generic: Handle string values for generic properties")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Antonio Borneo <antonio.borneo@foss.st.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinconf-generic.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 366775841c639..38a8daf4a5848 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -351,13 +351,13 @@ int pinconf_generic_parse_dt_config(struct device_node *np,
 
 	ret = parse_dt_cfg(np, dt_params, ARRAY_SIZE(dt_params), cfg, &ncfg);
 	if (ret)
-		return ret;
+		goto out;
 	if (pctldev && pctldev->desc->num_custom_params &&
 		pctldev->desc->custom_params) {
 		ret = parse_dt_cfg(np, pctldev->desc->custom_params,
 				   pctldev->desc->num_custom_params, cfg, &ncfg);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	/* no configs found at all */
-- 
2.51.0

