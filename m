Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D2011705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:38:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D3EC433C8;
	Mon, 11 Sep 2023 14:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443080;
	bh=f9qaVZEs6RGA82Ir3CZxA2TCVXMfGN1k/gWlPTp1FhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AiWyv9vVcmKT2CaAmI9CPy50VVUvb6Nr7VwoZ74UFSbK2+CRBn7T0JffJNUdduEA
	 FvOncajc2fsySIMqnbti+p+xaPMHQv/SxOZLt0L7OsjvjXgNM1e6frmQLxVVglnpIJ
	 wReyxnd9uhcbBWhib4ETsWHgHTrbY7ibC+OseFOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 251/737] mlxsw: i2c: Fix chunk size setting in output mailbox buffer
Date: Mon, 11 Sep 2023 15:41:50 +0200
Message-ID: <20230911134657.607602371@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 146c7c330507c0384bf29d567186632bfe975927 ]

The driver reads commands output from the output mailbox. If the size
of the output mailbox is not a multiple of the transaction /
block size, then the driver will not issue enough read transactions
to read the entire output, which can result in driver initialization
errors.

Fix by determining the number of transactions using DIV_ROUND_UP().

Fixes: 3029a693beda ("mlxsw: i2c: Allow flexible setting of I2C transactions size")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/i2c.c b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
index 2c586c2308aef..d23734ecb416a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/i2c.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/i2c.c
@@ -444,7 +444,7 @@ mlxsw_i2c_cmd(struct device *dev, u16 opcode, u32 in_mod, size_t in_mbox_size,
 	} else {
 		/* No input mailbox is case of initialization query command. */
 		reg_size = MLXSW_I2C_MAX_DATA_SIZE;
-		num = reg_size / mlxsw_i2c->block_size;
+		num = DIV_ROUND_UP(reg_size, mlxsw_i2c->block_size);
 
 		if (mutex_lock_interruptible(&mlxsw_i2c->cmd.lock) < 0) {
 			dev_err(&client->dev, "Could not acquire lock");
-- 
2.40.1



