Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE9B129A64;
	Tue, 23 Jan 2024 00:49:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970999; cv=none; b=PDFpqzGMw6gz4n1L1qtH3aIVaSC7J/rvSsQFDc/w6Q290hRX8Bx0oN7oSAi3v9JOrwenAL3gS2ZeDCCKZv5oMxJjpUd80eCqZZptVPINh4AvfujmRKDEiVRI9AuyJyNu+/3+vbnwmBgMDQE6wacUvRvADLWoQooUnf+kTs32+ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970999; c=relaxed/simple;
	bh=ysM4/9sm/YV9LPyYJPR4ekQNUvHOTnZpPI8jcgPpA28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6de4AvpWKNp1Pd/DM4sZiIUIJ+npMMPf4BQVJcj83GujXhNB886l+EuGqVQrn5X/U6FMEVmzOV0xPdOAiXYJ7XTftz9Rd3TAdCiYYhGLKFn/dZNrVZQmmBkWMhAbRJ5P8R4tfZFIAtjaYkKyYQCFTRb4aRdg1T6Gf74iPjM0DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PVIMcOFI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PVIMcOFI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9016FC43390;
	Tue, 23 Jan 2024 00:49:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970998;
	bh=ysM4/9sm/YV9LPyYJPR4ekQNUvHOTnZpPI8jcgPpA28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PVIMcOFIo84z2tGBBeqVTt8oSyDQ9+LvWXHoqoBouAzAMyXyQmtv3x9elrupfmqg6
	 L1QeOmjKOVTiil1l81cd284RPUKn5i0C6b7TGk0U+B6iwMinzoKzbcFTb94Vopzddd
	 2InrPv2Vht4MnzXlO5Dwt7xyfYbK7yM9BZ4Su6TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/417] RDMA/usnic: Silence uninitialized symbol smatch warnings
Date: Mon, 22 Jan 2024 15:55:27 -0800
Message-ID: <20240122235757.351179332@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit b9a85e5eec126d6ae6c362f94b447c223e8fe6e4 ]

The patch 1da177e4c3f4: "Linux-2.6.12-rc2" from Apr 16, 2005
(linux-next), leads to the following Smatch static checker warning:

        drivers/infiniband/hw/mthca/mthca_cmd.c:644 mthca_SYS_EN()
        error: uninitialized symbol 'out'.

drivers/infiniband/hw/mthca/mthca_cmd.c
    636 int mthca_SYS_EN(struct mthca_dev *dev)
    637 {
    638         u64 out;
    639         int ret;
    640
    641         ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D);

We pass out here and it gets used without being initialized.

        err = mthca_cmd_post(dev, in_param,
                             out_param ? *out_param : 0,
                                         ^^^^^^^^^^
                             in_modifier, op_modifier,
                             op, context->token, 1);

It's the same in mthca_cmd_wait() and mthca_cmd_poll().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/533bc3df-8078-4397-b93d-d1f6cec9b636@moroto.mountain
Link: https://lore.kernel.org/r/c559cb7113158c02d75401ac162652072ef1b5f0.1699867650.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_cmd.c  | 4 ++--
 drivers/infiniband/hw/mthca/mthca_main.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_cmd.c b/drivers/infiniband/hw/mthca/mthca_cmd.c
index f330ce895d88..8fe0cef7e2be 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -635,7 +635,7 @@ void mthca_free_mailbox(struct mthca_dev *dev, struct mthca_mailbox *mailbox)
 
 int mthca_SYS_EN(struct mthca_dev *dev)
 {
-	u64 out;
+	u64 out = 0;
 	int ret;
 
 	ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D);
@@ -1955,7 +1955,7 @@ int mthca_WRITE_MGM(struct mthca_dev *dev, int index,
 int mthca_MGID_HASH(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
 		    u16 *hash)
 {
-	u64 imm;
+	u64 imm = 0;
 	int err;
 
 	err = mthca_cmd_imm(dev, mailbox->dma, &imm, 0, 0, CMD_MGID_HASH,
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index b54bc8865dae..1ab268b77096 100644
--- a/drivers/infiniband/hw/mthca/mthca_main.c
+++ b/drivers/infiniband/hw/mthca/mthca_main.c
@@ -382,7 +382,7 @@ static int mthca_init_icm(struct mthca_dev *mdev,
 			  struct mthca_init_hca_param *init_hca,
 			  u64 icm_size)
 {
-	u64 aux_pages;
+	u64 aux_pages = 0;
 	int err;
 
 	err = mthca_SET_ICM_SIZE(mdev, icm_size, &aux_pages);
-- 
2.43.0



