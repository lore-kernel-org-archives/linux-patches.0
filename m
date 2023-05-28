Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2074569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 810EFC433D2;
	Sun, 28 May 2023 19:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302402;
	bh=xHObUSzGA6iy6yTqEZmmkcXD1NTqCiTeZ2G6EjoefXk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbemUTUvNmn6Tz1p6JfLkYLG4KJw3FC8fnhR/Cbu8p0WmYyYsTge7roy05dVjIsm7
	 xRDKhK7qXIILEIm000PDHf0BUNnPzgIxD0G8Br/yJuI+oKb07scSplUb2UvLZpTY54
	 X/Dem/Gz+X0mxuqb0ezgP3jkUm2b2LlXfiM1Z9IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.3 116/127] net/mlx5: Collect command failures data only for known commands
Date: Sun, 28 May 2023 20:11:32 +0100
Message-Id: <20230528190840.022307653@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shay Drory <shayd@nvidia.com>

commit 2a0a935fb64ee8af253b9c6133bb6702fb152ac2 upstream.

DEVX can issue a general command, which is not used by mlx5 driver.
In case such command is failed, mlx5 is trying to collect the failure
data, However, mlx5 doesn't create a storage for this command, since
mlx5 doesn't use it. This lead to array-index-out-of-bounds error.

Fix it by checking whether the command is known before collecting the
failure data.

Fixes: 34f46ae0d4b3 ("net/mlx5: Add command failures data to debugfs")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1920,9 +1920,10 @@ static void mlx5_cmd_err_trace(struct ml
 static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 			   u32 syndrome, int err)
 {
+	const char *namep = mlx5_command_str(opcode);
 	struct mlx5_cmd_stats *stats;
 
-	if (!err)
+	if (!err || !(strcmp(namep, "unknown command opcode")))
 		return;
 
 	stats = &dev->cmd.stats[opcode];


