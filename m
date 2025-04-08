Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C13F263C90;
	Tue,  8 Apr 2025 11:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744112489; cv=none; b=P+Uk8e9cE+DN4XM3poYildH4/SWh6WVPhdWcdC1eK/3lnNMqmx/bTjwm+GerI5TOpm8B4cXggviCMKoFcKej2VEsHPcobI6T6Yy8FZ40pk1qfmWBiZYkh47g0uPz7y+Sr38JQZLSKeEFslnrtAZhyeN1e5lItA817ky7X6TQsGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744112489; c=relaxed/simple;
	bh=5zdKLb4EUL4cIupZQy/WUXGaSULw/Uqqqxmjao66mXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AM9xoW68eaxSMIyCU7aVsX2lcVBXOe9dp1m0COdAFbrDJLWxJwPKvYb2VAHRDNMib825neHMg6f+vGUFE+7olgCnWRDmgm1Pn06Ith/mKIe6qmX+4lL1YYOTXgxu2c+geJAQfu0dc9xvYU6TpH9Lp5TggFLR+pM4pv9eIT+CiaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRNctEx7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRNctEx7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C764C4CEE5;
	Tue,  8 Apr 2025 11:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744112489;
	bh=5zdKLb4EUL4cIupZQy/WUXGaSULw/Uqqqxmjao66mXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRNctEx75jneBzPKh6mvY1dw+tx7ix3AP/gzZOeUuXfLpaLl6c7EAV0kpBc3FuInr
	 BKvnwUz0q001m6GOBMzKcZDiOGo/pZUWESDzyu70fPjyzjchc/67oMlsqgtMPX9siM
	 EQ8dfMENlAEHfVVB7dAKzSirbaeAt8ACAGhlrrdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/279] RDMA/hns: Fix a missing rollback in error path of hns_roce_create_qp_common()
Date: Tue,  8 Apr 2025 12:47:51 +0200
Message-ID: <20250408104828.723286461@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
References: <20250408104826.319283234@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d7f620eb4f21d..3875563abf374 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1117,7 +1117,7 @@ static int hns_roce_create_qp_common(struct hns_roce_dev *hr_dev,
 				       min(udata->outlen, sizeof(resp)));
 		if (ret) {
 			ibdev_err(ibdev, "copy qp resp failed!\n");
-			goto err_store;
+			goto err_flow_ctrl;
 		}
 	}
 
-- 
2.39.5



