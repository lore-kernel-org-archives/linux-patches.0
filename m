Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B46569E
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D36A6C433EF;
	Sun, 28 May 2023 19:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302702;
	bh=ZHb71VJnjpfKBwMpCg8Wa8UHt+4GCmuBRaQoT5abHAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNRrQuKa9sDX1OXca26LJV/cp4oPSkFYjfYxUbaB8FtmQx8Hi6xEEZgKDFWOF3XEl
	 S4tXoV3gEFkNWnrjpqoKc1KUOBDYzdg9qhds2LINfv9BuEX3ZA6FXy7zo8318iiBK9
	 dA9Nfw/Iz4KShHHGXxLXUB2peRMyRWWsD+ZQ/bTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 111/119] net/mlx5: Collect command failures data only for known commands
Date: Sun, 28 May 2023 20:11:51 +0100
Message-Id: <20230528190839.170175018@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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
@@ -1894,9 +1894,10 @@ static void mlx5_cmd_err_trace(struct ml
 static void cmd_status_log(struct mlx5_core_dev *dev, u16 opcode, u8 status,
 			   u32 syndrome, int err)
 {
+	const char *namep = mlx5_command_str(opcode);
 	struct mlx5_cmd_stats *stats;
 
-	if (!err)
+	if (!err || !(strcmp(namep, "unknown command opcode")))
 		return;
 
 	stats = &dev->cmd.stats[opcode];


