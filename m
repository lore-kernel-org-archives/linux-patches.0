Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9233D1D151A;
	Wed,  2 Oct 2024 14:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878438; cv=none; b=U9hAvce93c8rgHUtifVtV7Foggix6wv47mDiZPvAYoJzdCth9b9jFGs3wbo1a+qULsEu4zsFuEoiwX28jC78IyWoxzDCcirf8ENbnblNU9nQKCaJdGL6cJkSJNZo9kB6XD3VEhnkWdxOviJ4hWkKirnpBgqIsgCIgPoKHsrYJzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878438; c=relaxed/simple;
	bh=c8KfnpoKVswqQh9Dx5Rvgce1rpmXUY00jjsg4P1ufWI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r5nEAzdLQ9t49vIk6CIrkqRU6waQNkjoyWrXCPlGO1TwYd/1f3F/KpSTdpIF2d8qCfZm11cbvJkwi8xlfq4aXSpKzTj4u1V1fc/Eof26DwRJo1g0Bpy69rgG4gN0erk2ybiDKNQurJYrOm+jnITqwSLhRmb4H+d+vq/Hk7qiCc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edFGph4p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edFGph4p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98B1C4CEC2;
	Wed,  2 Oct 2024 14:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878438;
	bh=c8KfnpoKVswqQh9Dx5Rvgce1rpmXUY00jjsg4P1ufWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edFGph4p7MU90G2/cj/vELQdrh2yqUlIQoiI/tOQm+X2U6MPX4gLf4UdfUsCKHXw4
	 91UMhI4KRodJWNyEpsO18SeFegc4vWhht6BGwTeBrtv4wyFAfSr7Y4Buv40+rH2Zo1
	 oYMmCDrvKPjx8DbIYc5x7hh2iCuUyj5tJbmY/WYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 414/634] nvme-multipath: system fails to create generic nvme device
Date: Wed,  2 Oct 2024 14:58:34 +0200
Message-ID: <20241002125827.446056271@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 03a6868f4dbc1..a47d35102b7ce 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -587,7 +587,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
 		rc = device_add_disk(&head->subsys->dev, head->disk,
 				     nvme_ns_attr_groups);
 		if (rc) {
-			clear_bit(NVME_NSHEAD_DISK_LIVE, &ns->flags);
+			clear_bit(NVME_NSHEAD_DISK_LIVE, &head->flags);
 			return;
 		}
 		nvme_add_ns_head_cdev(head);
-- 
2.43.0



