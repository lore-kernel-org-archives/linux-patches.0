Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F9A919F49C;
	Thu, 15 Aug 2024 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729573; cv=none; b=mK8Q8HK+FyxfkGBfkqKtyxVpUh4aYp0JlHHC5u655gwRokF+icC9PeFCKOgHsjbY/oKAq0q3/tDofsVO+DgvFFMYlPfOCRtOFArI0iQY0ljYYQcAyulAsfhmGqaVLsTKVEgrPFY8eKr2PZTSy5XXDAXMFWzy+xaalC2ExYIS3Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729573; c=relaxed/simple;
	bh=s+LiZTIsFttTtkzkPxIhcECRASsN+vwarWlEK96WAfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3kA7bTAXlDM96WVy59wZWmd0mUKBm022wt/tzXa2baNF6IfGx63S+c7bZWMFnHkJN/GWt5zwhVZk7LdPqaGz7p0H4tzsGszOxI40SfRhaXnQ0e+VtUfP2rP7hg+a8gH8KIoO37dYJryqb1BzP/X4AFs56oTybylhSL4Rt6rh8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwU+jhyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwU+jhyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FEA4C4AF0E;
	Thu, 15 Aug 2024 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729572;
	bh=s+LiZTIsFttTtkzkPxIhcECRASsN+vwarWlEK96WAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwU+jhyLYlvTZm0bGYKeobWIeM9wOx4Lo8WRDqIusgB4z4mGiy/5M1VbforDGrfYH
	 4w7kQf26+gCivl/JL/5+zxhkyDbgwOiI8bszZbAGz6NiIf2CoZjZYDCMbLucUh3dTf
	 30T26AO9CeBWvezAUryH/1Mu12+SsjcfIXafjFAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 141/484] RDMA/hns: Fix undifined behavior caused by invalid max_sge
Date: Thu, 15 Aug 2024 15:19:59 +0200
Message-ID: <20240815131946.863305403@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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
index 35001fb99b944..873069d6ebae9 100644
--- a/drivers/infiniband/hw/hns/hns_roce_srq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_srq.c
@@ -295,7 +295,7 @@ static int set_srq_basic_param(struct hns_roce_srq *srq,
 
 	max_sge = proc_srq_sge(hr_dev, srq, !!udata);
 	if (attr->max_wr > hr_dev->caps.max_srq_wrs ||
-	    attr->max_sge > max_sge) {
+	    attr->max_sge > max_sge || !attr->max_sge) {
 		ibdev_err(&hr_dev->ib_dev,
 			  "invalid SRQ attr, depth = %u, sge = %u.\n",
 			  attr->max_wr, attr->max_sge);
-- 
2.43.0



