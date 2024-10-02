Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFBB1CFEDB;
	Wed,  2 Oct 2024 13:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876468; cv=none; b=luxnpbscDNBJhgfPjBIN+JSXtk3g/gd0H2+ePl/d4qMsXa7msh33cd1eTBFzpMF9XdSuvuErrNS6jKv1C+ojG/Mwt524IgCDFY94UIz7gyh51WvBStrkvqcB7D2IJCzJm8RQTJJy0iYXUBb815CxYtZIiZ7LJkJkf91Md87ikT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876468; c=relaxed/simple;
	bh=yiL8Y5zhlzbZNzUIGe0tFsgDNsrD0v3swiUDjIWoMWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jv/7ifAEeoDurcLRYajd+YBhobkOYhAb0ewdmKbcZjt9rrUVPVhbaPnm/tDpBPyZcdMq/31eCkGpcFJHHCkVRvpyG61cMA0mCnnot3vIr2N0F6hPiozpgR6dKpzI2KFQMr0VgVZhcBUK4hM/P+1hHOg7xEnJ0iv3PHezyuJxf4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rP0/RMXb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rP0/RMXb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA972C4CEC5;
	Wed,  2 Oct 2024 13:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876468;
	bh=yiL8Y5zhlzbZNzUIGe0tFsgDNsrD0v3swiUDjIWoMWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rP0/RMXbmLqHKLYsadE8kUkjGY4tsoLzcs1fNMOyDqQhX7rNB+aa/HPw8MxdCRYai
	 l7et0Hd5DkpudFx8A+VngtOfqH/wbIJKPcVXaiWIfLpdTBcClKL/sCN3bYQxAU/MVB
	 vCq31JRTVDFmmG9i3ieZ3cy2GUArPxFpw9KAcSdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 453/695] nvme-multipath: system fails to create generic nvme device
Date: Wed,  2 Oct 2024 14:57:31 +0200
Message-ID: <20241002125840.540792475@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 518e22dd4f9be..6d97058cde7a1 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -648,7 +648,7 @@ static void nvme_mpath_set_live(struct nvme_ns *ns)
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



