Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ACEE56B;
	Tue, 23 Jan 2024 00:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968365; cv=none; b=iJRIVeL2rYtSn+/Qhslg76Re7FEcee9xhsjUeMse8g8yWDwx+kNJLaCyeBvrMwAnB0ugbgniL+U+hqq2g7Hnm/9Fmp672b0l8rl1J189qpVWv7BAQti3bvLXOvI55F1OVpds2e3zo2iqsUptZFrU5AVn7kkSViBtkPOpxM8kRAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968365; c=relaxed/simple;
	bh=J8fvjeS1PaXi6SugFY29VNRHsWMNB0BopS6YpY9jhmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QigbAPLX+FQfqfrAl35a00hKkFw7EcQTfWiiEAfcqRrhA1GslHS3xo2jKs4ooEU+oSpqoLl1nRixs9Gan/Lz8nJ2rpHU9RUKCZJtfCXzDMId22PodxdPfa11tcVGoE3IsvjR1DtjAT21m5Gf2nMHH/i0Q3Hz0rFdJ2o4+G0ClH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=13QJLV+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="13QJLV+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A805C433C7;
	Tue, 23 Jan 2024 00:06:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968364;
	bh=J8fvjeS1PaXi6SugFY29VNRHsWMNB0BopS6YpY9jhmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=13QJLV+R3oJNnyCNhsB4ym38APcAmg5YDH37I+y9uEBKQ3Dfk5tmb5j2Nzqw0gQIW
	 Wu8OFsjIyqf1rRR9DsMvrDfokhvU4i2v6KLABbjBVOMPJ5fYU3J2r6hvDCYpnMRj6h
	 jFiVjTKeT4yaQiiqPnnBMkcFSkXe2uvmM9pWv+S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 086/148] RDMA/usnic: Silence uninitialized symbol smatch warnings
Date: Mon, 22 Jan 2024 15:57:22 -0800
Message-ID: <20240122235715.880135685@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 83aa47eb81a9..71b8a4143a2a 100644
--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -641,7 +641,7 @@ void mthca_free_mailbox(struct mthca_dev *dev, struct mthca_mailbox *mailbox)
 
 int mthca_SYS_EN(struct mthca_dev *dev)
 {
-	u64 out;
+	u64 out = 0;
 	int ret;
 
 	ret = mthca_cmd_imm(dev, 0, &out, 0, 0, CMD_SYS_EN, CMD_TIME_CLASS_D);
@@ -1961,7 +1961,7 @@ int mthca_WRITE_MGM(struct mthca_dev *dev, int index,
 int mthca_MGID_HASH(struct mthca_dev *dev, struct mthca_mailbox *mailbox,
 		    u16 *hash)
 {
-	u64 imm;
+	u64 imm = 0;
 	int err;
 
 	err = mthca_cmd_imm(dev, mailbox->dma, &imm, 0, 0, CMD_MGID_HASH,
diff --git a/drivers/infiniband/hw/mthca/mthca_main.c b/drivers/infiniband/hw/mthca/mthca_main.c
index af7f2083d4d1..82a04a07b384 100644
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



