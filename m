Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B903090C7;
	Mon, 13 Oct 2025 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368502; cv=none; b=EPwXzYsY6C8aKv3t6PQNiPuPvAQlVdv+XiMLB8Watv6NDtUUM4poMiMjaj57HhiC/lIV57ask1g2WzImtT+oIeHDsmBdddIVin9LJFkHRIbq0gdGMGKs+Tl7lhmZYU8jqQjQCYO6KlVkh3hhDrRhjTG78l25a4jQEDSx9vkPgFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368502; c=relaxed/simple;
	bh=fkNjWNc7KuQnSD8BmK71MA3KSfMmz/Jx8meR13Ac9bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTcDcTjXSp88Kn8qhPNuGMyZw7hCSRO1oDi6RfiHP+v/izXfbcYwhzH7jgUe+X3llNAlv/PFZK8egtuImgapHDoyWbIsmYBaffHdWjdCrzyn2GDvAECL0RcnTimvs6iJYlI4YO6jCx347h5TCi7Qaykkg/1fHBW0jFIzOnclKgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O3LHt/pz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O3LHt/pz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAA0C4CEFE;
	Mon, 13 Oct 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368502;
	bh=fkNjWNc7KuQnSD8BmK71MA3KSfMmz/Jx8meR13Ac9bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O3LHt/pzNglo4Pd6ULM+gupWlCJJ4Zp2fLZL8rcVxh2Kq6wFz3ul5fFu3OA1wHeE6
	 XXB/SzsDLH/i1ix2KgpReNrNAEBoSzosu6WBoo7C73zetPfWqYIcSt5QSz4gbBnUW8
	 HdVVjaa4BHafmNekuRdrb/h5a+354HqrYiBzAeuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenghai Huang <huangchenghai2@huawei.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 176/262] crypto: hisilicon/qm - set NULL to qm->debug.qm_diff_regs
Date: Mon, 13 Oct 2025 16:45:18 +0200
Message-ID: <20251013144332.467033142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chenghai Huang <huangchenghai2@huawei.com>

[ Upstream commit f0cafb02de883b3b413d34eb079c9680782a9cc1 ]

When the initialization of qm->debug.acc_diff_reg fails,
the probe process does not exit. However, after qm->debug.qm_diff_regs is
freed, it is not set to NULL. This can lead to a double free when the
remove process attempts to free it again. Therefore, qm->debug.qm_diff_regs
should be set to NULL after it is freed.

Fixes: 8be091338971 ("crypto: hisilicon/debugfs - Fix debugfs uninit process issue")
Signed-off-by: Chenghai Huang <huangchenghai2@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/hisilicon/debugfs.c b/drivers/crypto/hisilicon/debugfs.c
index 45e130b901eb5..17eb236e9ee4d 100644
--- a/drivers/crypto/hisilicon/debugfs.c
+++ b/drivers/crypto/hisilicon/debugfs.c
@@ -888,6 +888,7 @@ static int qm_diff_regs_init(struct hisi_qm *qm,
 		dfx_regs_uninit(qm, qm->debug.qm_diff_regs, ARRAY_SIZE(qm_diff_regs));
 		ret = PTR_ERR(qm->debug.acc_diff_regs);
 		qm->debug.acc_diff_regs = NULL;
+		qm->debug.qm_diff_regs = NULL;
 		return ret;
 	}
 
-- 
2.51.0



