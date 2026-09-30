Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6798051357A;
	Wed, 30 Sep 2026 16:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784451; cv=none; b=l2yXWLRJrdwvto24faz1XwpFJ6m7gEYzVHTXmXyFIlo2zN7YvC8B7dMU6ni6uinhE55f0AMBuXnibd+wBeTEGs37/Ltp7+TPUiijZWBRYZOezY+J94bLzkmkEliW3V8V/y7W+pwpohw1aXoGwSr4AuOqEonZFq51N1CafWFhqxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784451; c=relaxed/simple;
	bh=Bo0W/ZSNo8I1McuNXr7RxpuRB7kwZnoY3HCOkcCxGwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oCl9kzT7sqqj54HvEDIVHm5YtnHLvjVNR4Q54Dev4dZ3OLyq3mZYvPuuI/fNxiOxtOutaMWhHb+0QAAmsyT3CYNeTOJWS2+ORC2/rWr+aAzaOmlj6JYFNarGPj4ps9BVTii1Z6wjpnL8USpEOfOiL74XKfh5Y/NbyM7zOUBKlBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKX+o29y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKX+o29y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B451F00893;
	Wed, 30 Sep 2026 16:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784445;
	bh=0faAMU5rAaB7gc4rtbBqechVJ36MrOJS31MBY3M+mxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UKX+o29y0sVHV7WeQfbag46yYrG4KLTUfEmlMF1+oVJuwxRljuoe1J34G1uT2qBNB
	 JIJXFZjlqW88s50V5gpi2CAbJp1T1DfJYC9/Q96f2l2578rxpSs91kCUfEQTB7XWG4
	 2EZ5ftCLWmy43XWqEoelw9Lry6uMKg+viHBy3lww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 156/982] RDMA/mlx5: Fix state and counter desync on loopback enable failure
Date: Wed, 30 Sep 2026 17:14:52 +0200
Message-ID: <20260930152420.161097824@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 0d32eabccbe4b2f8d45be3192c5f3c76c8af703d ]

In mlx5_ib_enable_lb(), dev->lb.enabled was unconditionally set
to true even if mlx5_nic_vport_update_local_lb() failed.

Fix this by only setting dev->lb.enabled on success. On failure,
roll back the reference counters and return the error.

Link: https://patch.msgid.link/r/20260601095818.2227-1-lirongqing@baidu.com
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 987e9087c9d92..9da42edecb05c 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1689,6 +1689,9 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	    dev->lb.qps == 1) {
 		if (!dev->lb.enabled) {
 			err = mlx5_nic_vport_update_local_lb(dev->mdev, true);
+			if (err)
+				goto err_rollback;
+
 			dev->lb.enabled = true;
 		}
 	}
@@ -1696,6 +1699,14 @@ int mlx5_ib_enable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
 	mutex_unlock(&dev->lb.mutex);
 
 	return err;
+
+err_rollback:
+	if (td)
+		dev->lb.user_td--;
+	if (qp)
+		dev->lb.qps--;
+	mutex_unlock(&dev->lb.mutex);
+	return err;
 }
 
 void mlx5_ib_disable_lb(struct mlx5_ib_dev *dev, bool td, bool qp)
-- 
2.53.0



