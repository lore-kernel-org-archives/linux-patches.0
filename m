Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88601AC8A6;
	Mon, 14 Oct 2024 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918179; cv=none; b=T4waXIqk/+mouengw6r+rMp6E2sw7IsyJ+yddK+VKRn9N/3ziQmDj64i3gDPv5mczF6wvF2qjJFNCDyLd5S77VFNqk0fJiLQhtFrdQeMPfiqfbVEV9cccYz8oGC0Rjj1no9VGr9wBth6REAxKwggdRZb/bjq/T8iYZVfVME5rhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918179; c=relaxed/simple;
	bh=k7Pz9XUr9jeoMRpanTwGQ2MwJinwJiLkZ8uxH36D15s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlwA/FvypfIC2qVv4zf2owGz3HSFz9IjVZdlbQ47OXBKRSf4rE9PlMNZCYBcQEJBR8r/QXxdP5+IBcE7f3jrsiF/v/QTI+2fL/TPsL9/+MdPXyHVYL05gWTRjiC2rGr8mBwIio2BPepnhWzaBpSfPi8AzCJCX5aFNjr8wCbxKp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt49wk6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt49wk6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA226C4CEC3;
	Mon, 14 Oct 2024 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918179;
	bh=k7Pz9XUr9jeoMRpanTwGQ2MwJinwJiLkZ8uxH36D15s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dt49wk6njsc3W+3TnYDHr+sgHRSdFdyJHZ35+9d6voX6qDQH/a7N48B8+q1QZR/m4
	 Gfvhr3jv21/0QzAtBbe50dcd4jE/mk6TmCIrhIiN4IFucm/c7lK3dM/7mfbLC7J5FC
	 MYTNxl/LuPX9GZxtSYkSqJDB5OhJGcJAExwaYF6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 246/798] nvme-multipath: system fails to create generic nvme device
Date: Mon, 14 Oct 2024 16:13:20 +0200
Message-ID: <20241014141227.598086036@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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
index d0154859421db..93ada8941a4c5 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -548,7 +548,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
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



