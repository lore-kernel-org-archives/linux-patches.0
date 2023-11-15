Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 701A543ACE
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWgkZ4Ud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2433FC4AF78;
	Wed, 15 Nov 2023 20:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081419;
	bh=U+9aApnqTq8jIPBLX3KWPVfgqYTEybRY9dlAFBenP2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWgkZ4UdlTsgTdE+SfM4nKQLfgXc26Ol8CMije0L76y4oPau2ixkRJWLtmRH0r9oX
	 5ugQAPTNxfSE6+LddpKesq5/P4tYQv4YH5ZIZ3ueen3HdktRkeDg17yYl1/V5Drp8j
	 t1cPkT6T+AQdEmzpzmfdRYp3Kv3o0ujSIPXdKsJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/244] RDMA/hns: Fix signed-unsigned mixed comparisons
Date: Wed, 15 Nov 2023 15:35:35 -0500
Message-ID: <20231115203556.926581737@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit b5f9efff101b06fd06a5e280a2b00b1335f5f476 ]

The ib_mtu_enum_to_int() and uverbs_attr_get_len() may returns a negative
value. In this case, mixed comparisons of signed and unsigned types will
throw wrong results.

This patch adds judgement for this situation.

Fixes: 30b707886aeb ("RDMA/hns: Support inline data in extented sge space for RC")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20231017125239.164455-4-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 4554d3e78b37b..59e1f51022f16 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -244,7 +244,7 @@ static bool check_inl_data_len(struct hns_roce_qp *qp, unsigned int len)
 	struct hns_roce_dev *hr_dev = to_hr_dev(qp->ibqp.device);
 	int mtu = ib_mtu_enum_to_int(qp->path_mtu);
 
-	if (len > qp->max_inline_data || len > mtu) {
+	if (mtu < 0 || len > qp->max_inline_data || len > mtu) {
 		ibdev_err(&hr_dev->ib_dev,
 			  "invalid length of data, data len = %u, max inline len = %u, path mtu = %d.\n",
 			  len, qp->max_inline_data, mtu);
-- 
2.42.0



