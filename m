Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08882F83CB;
	Tue, 12 Aug 2025 17:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020215; cv=none; b=FBL5qjet5SA82xUvSeqYUh8FZwvBF6/dxQhMMgoDDFq2sUPeEZ3TostgbjeOtJ3owxRi2/MML5QYrasDheSaiatVLlGM1dN9zQ49dJ4gdn9Fabd+0jW76YrcXjJL4xGn14Jzqk5UApQuny2CiejuD+V4RPaGup4eG9fOOGTUTeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020215; c=relaxed/simple;
	bh=E6emPTrJMoBZmp9kWYldUc/ulQ1cJcHezNJDILmjWX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVlp2RLdIdbWGp9cPRHGD90w2tb19rl21QY7MlKpu4qC3uc0294BcXLHNghU2p/QlPy4rlKn5m4QeGsWeG3Bid8iUh3uMlnYkujYW4kXResdagsZmCtHL3mDBMziIcjvFezOxA0UWU/csQYSJ8nYH91GXZO+KWiCCVF6u1jm1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQIzqmH8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQIzqmH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B078C4CEF0;
	Tue, 12 Aug 2025 17:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020214;
	bh=E6emPTrJMoBZmp9kWYldUc/ulQ1cJcHezNJDILmjWX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQIzqmH8T4s3uUcYSlsTrIkyoyuVDT/UtKIl6ccmMe4pAwAJRyCEUS81Z9Qc3QLaG
	 9Bcj6yhBIocqLOq6zqdyh5QVh8UQEQKI235dP+6cpZalnlmi27vtsJ2xId8Yqa329P
	 nrrgnHGIXvokggJnb4p76JZPJkR/WGJVMpdl2Rlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tereshkin <atereshkin@nvidia.com>,
	Chiara Meiohas <cmeiohas@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>,
	Vlad Dumitrescu <vdumitrescu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/253] net/mlx5: Fix memory leak in cmd_exec()
Date: Tue, 12 Aug 2025 19:26:41 +0200
Message-ID: <20250812172949.270706492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chiara Meiohas <cmeiohas@nvidia.com>

[ Upstream commit 3afa3ae3db52e3c216d77bd5907a5a86833806cc ]

If cmd_exec() is called with callback and mlx5_cmd_invoke() returns an
error, resources allocated in cmd_exec() will not be freed.

Fix the code to release the resources if mlx5_cmd_invoke() returns an
error.

Fixes: f086470122d5 ("net/mlx5: cmdif, Return value improvements")
Reported-by: Alex Tereshkin <atereshkin@nvidia.com>
Signed-off-by: Chiara Meiohas <cmeiohas@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Vlad Dumitrescu <vdumitrescu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/1752753970-261832-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index 6dbb4021fd2fa..c83523395d5ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1913,8 +1913,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 
 	err = mlx5_cmd_invoke(dev, inb, outb, out, out_size, callback, context,
 			      pages_queue, token, force_polling);
-	if (callback)
-		return err;
+	if (callback && !err)
+		return 0;
 
 	if (err > 0) /* Failed in FW, command didn't execute */
 		err = deliv_status_to_err(err);
-- 
2.39.5



