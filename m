Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 746531D0438;
	Wed,  2 Oct 2024 14:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880126; cv=none; b=h3gYNHFN6kDzE/RxTdhbaiJzJbDwbWwOraAEHIrIH38mW9SVOb20+88ZIs7C8OMdnncCwLbI8gJoDdP2EmCTRLHTL4mIICt+M7Ljml9EqkTWFu6GpZAbEQ/D0FkkeVJxqm0OzAXfo2khcsx/7fe2nGFricXkIWLhhWXVulJ/Oxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880126; c=relaxed/simple;
	bh=h7uvZTaS0GAPG6wq7STjxN4U71j4rb3YssaT1vekxLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X8TTy5RhXxKaBCNX1lQIn3E5P3fq0DM+A2pnEsYCS+ChzehPhA1lzpNHEym6fCFm8asS1Jdb5TY0WkWNwZ5wCYr8ApWhE4+z2iAfNXx7oAN1+5oTzL3rD6lR28AlFMjxU8IxnVcfiT4WsXruoIp2gV+csOhftdvVxMKcad2JZxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DcVCdrzC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DcVCdrzC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0BEEC4CEC2;
	Wed,  2 Oct 2024 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880126;
	bh=h7uvZTaS0GAPG6wq7STjxN4U71j4rb3YssaT1vekxLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DcVCdrzCltK5RzJN8dVx0ZGBtYzP1Bh75TeqFXpdhhdsSeWiTp9XWVq3o+EXnyW7W
	 D+iZRao1w7GjxYMwUQ0B0J5ZRM6HZ2w+WlfDsjAAgo8xwtCxTaJ1a2hCUOW8Z43JJ2
	 xkTd9qbV1rUCS/ScgGfNLP1AJyWBUmzbQizI48Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 352/538] nvme-multipath: system fails to create generic nvme device
Date: Wed,  2 Oct 2024 14:59:51 +0200
Message-ID: <20241002125806.322741788@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Reinecke <hare@kernel.org>

[ Upstream commit 63bcf9014e95a7d279d10d8e2caa5d88db2b1855 ]

NVME_NSHEAD_DISK_LIVE is a flag for struct nvme_ns_head, not nvme_ns.
The current code has a typo causing NVME_NSHEAD_DISK_LIVE never to
be cleared once device_add_disk_fails, causing the system never to
create the 'generic' character device. Even several rescan attempts
will change the situation and the system has to be rebooted to fix
the issue.

Fixes: 11384580e332 ("nvme-multipath: add error handling support for add_disk()")
Signed-off-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/multipath.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index 645a6b1322205..37ea0fa421da8 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -585,7 +585,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		rc = device_add_disk(&head->subsys->dev, head->disk,
 				     nvme_ns_id_attr_groups);
 		if (rc) {
-			clear_bit(NVME_NSHEAD_DISK_LIVE, &ns->flags);
+			clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
 			return;
 		}
 		nvme_add_ns_head_cdev(head);
-- 
2.43.0



