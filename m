Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADDC21A6161;
	Tue, 30 Jul 2024 16:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356752; cv=none; b=s2pA6YdC3WP9I1gVHQe+1OnDGTOqn3gBlitFq4RJ5yuHBC/sON+aGv3STr0v/FJBF49teI5DeSiByHCQoXwdZL5x2QTrkXv9b48KCgVpkKI7xajdcB/++MllcDXds22kI+x8hWw+cIL0B8J10jBVX0BSRi7YP1yxSUYhMz36Tx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356752; c=relaxed/simple;
	bh=oVeiIKZctN3YJO9DLRfCnDF6ptDTI5GEFzRQNimG0UQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sl96MN9sUrV5Cg8znF9373tAwnzhE4CODNeEhIiP+75eRjIqYsZzHB3pmlZo3IYaP4rKonpaY7ia8UZwF/5uyxyKcBQx2W//CN6vEHd91H1Rwe2kB2d8+PkTY0waMJxycpnUmv9x0T/S0QgxZgMu9OxfwqzasFxv5AGvfDANP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quKgQi6M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quKgQi6M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A28C4AF0A;
	Tue, 30 Jul 2024 16:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356752;
	bh=oVeiIKZctN3YJO9DLRfCnDF6ptDTI5GEFzRQNimG0UQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quKgQi6MCHMk71dHvtHis/HGdVPC04Gvvu3s5pmEPssIdaPJnwjKFEqWVzJBkGUsU
	 mQvQgbPWL2nGdTRJo3YvP7AyH0sYqLOulFJvSkqHfP7YHkoFRYMRRIywuzvazPIQFO
	 9Ib7ZojTQg4P8b7OkhzPM8PVD+IZUH1koZ5dFsKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 225/440] RDMA/hns: Fix undifined behavior caused by invalid max_sge
Date: Tue, 30 Jul 2024 17:47:38 +0200
Message-ID: <20240730151624.648794563@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 36397b907355e2fdb5a25a02a7921a937fd8ef4c ]

If max_sge has been set to 0, roundup_pow_of_two() in
set_srq_basic_param() may have undefined behavior.

Fixes: 9dd052474a26 ("RDMA/hns: Allocate one more recv SGE for HIP08")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://lore.kernel.org/r/20240710133705.896445-7-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_srq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_srq.c b/drivers/infiniband/hw/hns/hns_roce_srq.c
index 6a4923c21cbc6..727f926500712 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -296,7 +296,7 @@ static int set_srq_basic_param(struct hns_roce_srq *srq,
 
 	max_sge = proc_srq_sge(hr_dev, srq, !!udata);
 	if (attr->max_wr > hr_dev->caps.max_srq_wrs ||
-	    attr->max_sge > max_sge) {
+	    attr->max_sge > max_sge || !attr->max_sge) {
 		ibdev_err(&hr_dev->ib_dev,
 			  "invalid SRQ attr, depth = %u, sge = %u.\n",
 			  attr->max_wr, attr->max_sge);
-- 
2.43.0



