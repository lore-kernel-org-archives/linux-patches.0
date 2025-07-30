Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037E923D2A2;
	Wed, 30 Jul 2025 09:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868589; cv=none; b=evj3fDJj39RxjJVf838Cv+A1z/u/btK75xNGWduY6B71qdphtNrmyVK4mrjiqigJ3pgeVKeNFrltKTUGTH9XbyxXYg5upvgAS9LSxBFZE/Su43C9d0sjAdzwYd7R6Bv+P14y8DNBqXphNKgyl7MWcYmjNNtG6uSx/NYIGPob0wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868589; c=relaxed/simple;
	bh=CFnOKN+rUQVAwSCRUc7SVvpfvX9vVnR19+SFR4UeWxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Js8gAAOxbAmJQ8rqwf2Kfa4H2fNeXT1A2LQe4mzDIQM2dtjWjPufJEgfxyObo+VORBU5NHor3Xxf+aBGI+uroJCQonNR5Av+zQSyHtAv0gUMaJc/7qlROWETGu+aj+Gh305cFzHE9A7JWFBqCzpiv3v+TxdfytwbFF5YDISlgqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DeIHlhDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DeIHlhDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A90C4CEF5;
	Wed, 30 Jul 2025 09:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868588;
	bh=CFnOKN+rUQVAwSCRUc7SVvpfvX9vVnR19+SFR4UeWxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DeIHlhDn/OctW46lJ2jiftWMrEePNYNUBCNlZtryLd+Jmpj0YW0qKSYC4c0qW2Q9N
	 ratCoKokEY8sey/7+LUvQWjI7kkqq5ZSrHp+W5n9XhqKaNtMRVinsAiVUl8Ku2j/88
	 wI8w8FwSQXYDH+3vc61ArthLfSQeDPtIEnTkDN2k=
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
Subject: [PATCH 6.12 024/117] net/mlx5: Fix memory leak in cmd_exec()
Date: Wed, 30 Jul 2025 11:34:53 +0200
Message-ID: <20250730093234.514260252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e733b81e18a21..5bb4940da59d4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1925,8 +1925,8 @@ static int cmd_exec(struct mlx5_core_dev *dev, void *in, int in_size, void *out,
 
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



