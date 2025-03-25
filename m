Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650A525A342;
	Tue, 25 Mar 2025 12:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905780; cv=none; b=pLo7onQRixo5n6AIske723FDjEwTADMc+JxGDz9yEzxEF6O7peZXrsXL1SMbnlSaP4STEaSvjdpBLzcXwqB2DgAsjYAmSliMTMYTzgNKzz4vgoF6Gzd3oEjRfX1YcbE4owlzJtw7YNy5m9lMw5Dkz3xT5S5qt3rjqxb9Sebzyq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905780; c=relaxed/simple;
	bh=qwVHMCqtAcn2Bd5+p4Tc8wKaGKy9RIZLMPQ9SyMvZy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hszQA8t1pHJV3KzU6+H6CndTzoE6fcIgl1nIlIEXNsF7OEMfcj2Y7y3iU56Af17347i/IzMKK3bQRY36zSsL1OzkjGk1nVoNebHJ4DaxSKp1uCKiK55VlTF5xv5iBbWm1X+eibm48b9jyD/kl1B/PLZM7UIgA68JjD9U8mW81lc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=udaxMq7f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="udaxMq7f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1258CC4CEE4;
	Tue, 25 Mar 2025 12:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905780;
	bh=qwVHMCqtAcn2Bd5+p4Tc8wKaGKy9RIZLMPQ9SyMvZy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=udaxMq7fCUamBEGyETtBEsaJVf1xh0kgoyAbquJWDU2tgmh023cCErSab5PbzgwE1
	 o6eDezupYv5DaV0Fj+YDoKoBzmyt5kjyB0muHD7IJl4qjLlVQZfG6T5rvw1nlvoG19
	 wtbLhvhL/kH4KLSWEhfrKz25wJc+uvknO9pP3x2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 159/198] RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()
Date: Tue, 25 Mar 2025 08:22:01 -0400
Message-ID: <20250325122200.827436395@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 444907dd45cbe62fd69398805b6e2c626fab5b3a ]

When ib_copy_to_udata() fails in hns_roce_create_qp_common(),
hns_roce_qp_remove() should be called in the error path to
clean up resources in hns_roce_qp_store().

Fixes: 0f00571f9433 ("RDMA/hns: Use new SQ doorbell register for HIP09")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20250311084857.3803665-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index 86a48ca127862..0f0351abe9b46 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1213,7 +1213,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
 			ibdev_err(ibdev, "copy qp resp failed!\n");
-			goto err_store;
+			goto err_flow_ctrl;
 		}
 	}
 
-- 
2.39.5



