Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7591A186B;
	Thu,  6 Jun 2024 14:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683185; cv=none; b=MFjv3MqflVr0PHZqGNTHrX4rqXpQ/1B5L4hxYcDZfkssPKZOYoWl7/b7zZXVkczD8sYnSobBbmswnWV+7eHiFMMqFp5flcJcX/0cltOpAECcYfKyrXavhCBIGFvPr4XsROQ4mVBNJ1vMLdW8PUh9wuT53CrJPaD/u2e4E9xWE7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683185; c=relaxed/simple;
	bh=CC9Jg3Eb6DaXnUHIqV/PEo2OsVNf+RBr4HGr/NtdvxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INa61R72VX9EtapS/xXS2VVhYmA1KPl7huYUIvMndKWq9/87UWp5q9JtejrJiRsth45zzM+1YKz058URqvuV3MRnnLA2HNASp0BNd3kvQz+Rs+TVPBam5Go+Pw28Fh24y0dj37SMFwIZ8TgSjTliXWa+EkBH1TGW0plpXE2N3nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CY4e3EiV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CY4e3EiV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC58DC2BD10;
	Thu,  6 Jun 2024 14:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683185;
	bh=CC9Jg3Eb6DaXnUHIqV/PEo2OsVNf+RBr4HGr/NtdvxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CY4e3EiVVYfAVkf0678R0/c0BDYrhffYpXpjKccemA/6TtDmJuzMbpMfW74PmeHb0
	 HNuogmLNzBak7afs09oManaamnv5DFaxaZk+iv42PlP2OwFAzd6kBhAdIysoKS2034
	 KHTtcT9ru9b6ba8hKuUg/4lj7IFZ/uTctRWQ0F6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilay Shroff <nilay@linux.ibm.com>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/473] nvme: find numa distance only if controller has valid numa id
Date: Thu,  6 Jun 2024 15:59:48 +0200
Message-ID: <20240606131701.837213455@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Nilay Shroff <nilay@linux.ibm.com>

[ Upstream commit 863fe60ed27f2c85172654a63c5b827e72c8b2e6 ]

On system where native nvme multipath is configured and iopolicy
is set to numa but the nvme controller numa node id is undefined
or -1 (NUMA_NO_NODE) then avoid calculating node distance for
finding optimal io path. In such case we may access numa distance
table with invalid index and that may potentially refer to incorrect
memory. So this patch ensures that if the nvme controller numa node
id is -1 then instead of calculating node distance for finding optimal
io path, we set the numa node distance of such controller to default 10
(LOCAL_DISTANCE).

Link: https://lore.kernel.org/all/20240413090614.678353-1-nilay@linux.ibm.com/
Signed-off-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f96d330d39641..6cf0ce7aff678 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -213,7 +213,8 @@ static struct nvme_ns *__nvme_find_path(struct nvme_ns_head *head, int node)
 		if (nvme_path_is_disabled(ns))
 			continue;
 
-		if (READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_NUMA)
+		if (ns->ctrl->numa_node != NUMA_NO_NODE &&
+		    READ_ONCE(head->subsys->iopolicy) == NVME_IOPOLICY_NUMA)
 			distance = node_distance(node, ns->ctrl->numa_node);
 		else
 			distance = LOCAL_DISTANCE;
-- 
2.43.0



