Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57E001D278A;
	Tue, 27 Aug 2024 15:26:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772370; cv=none; b=SWuDUSoLg+b+1PO3Ne7Kj1wVNgQOxhROvYYgpsTjwaYG/xvTFY2Otkt/nqMdUr/0YT57rFK7bKgllLI/ZKVmZIVrsjYJb+jBAKGm4ESJiRMRy4HAcvNuLwimhc6HAnZxnorffbdczLsIwTmqd4ovQSNFO3V9tEnD+tOusmKVQGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772370; c=relaxed/simple;
	bh=WyBm51mR6TEi8pT7pQ0qRGqigcRMlUhvKirgT6a5pRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R/5+fMviUC+ykHSUWRlLKx3xHS+mv/YV6yX1jMFkRFAHX8JMt65dm/KJZb8k36qkLbWpKo4Vb2ygWLqSM5ThXgLMXjURJIx/5NVnFxKwcg7VWbEp5Hfi4oHAPg6fBy2dxR8sw8ym14QHY8S94P6r19j1IQ4d3+DgnRseqarJDrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IWcwju0W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IWcwju0W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2196C6107C;
	Tue, 27 Aug 2024 15:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772370;
	bh=WyBm51mR6TEi8pT7pQ0qRGqigcRMlUhvKirgT6a5pRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IWcwju0WoVb8Zm/0v01y6HaEtRcKruV18RYdH96SRXzuBv3vESstt5HukLZfdP33K
	 dpGpC+IMgYwlODVkgGjRU7rzI+rDn36DLunSr71Q8dakq+Ur5M35jQhOguNxxKQqji
	 wa5S8UHM+h9uphqKORCbGeOJ/YKDMDKvsBM366g4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 194/321] nvmet-tcp: do not continue for invalid icreq
Date: Tue, 27 Aug 2024 16:38:22 +0200
Message-ID: <20240827143845.616170888@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Hannes Reinecke <hare@suse.de>

[ Upstream commit 0889d13b9e1cbef49e802ae09f3b516911ad82a1 ]

When the length check for an icreq sqe fails we should not
continue processing but rather return immediately as all
other contents of that sqe cannot be relied on.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 5556f55880411..76b9eb438268f 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -836,6 +836,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 		pr_err("bad nvme-tcp pdu length (%d)\n",
 			le32_to_cpu(icreq->hdr.plen));
 		nvmet_tcp_fatal_error(queue);
+		return -EPROTO;
 	}
 
 	if (icreq->pfv != NVME_TCP_PFV_1_0) {
-- 
2.43.0



