Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A541632D3;
	Wed,  5 Feb 2025 14:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767063; cv=none; b=PpKwFugNLEqUv1OhfigAbV7cvU57jpUsr9jlSmExu/aGWc2KgsTsKvSwNeNpxfp66rf0kG1wToHWjwelSJj81q0fzVJjLcs0a6KK2jzx+av2JYfQGcgcbR9BYT28R2vmmK0/NpKUEMDovJqRQfP9ZGoMckSVascvH5L421uBdds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767063; c=relaxed/simple;
	bh=q2fMgM9PGBeatQEwHZG8qWMktSejGM8vmEqkKRZdJ3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XSyRy5PuF9nM7QwYMY++SPAyc+/mDD3ZcGO5z3dSba4TP4sbqJVlMKj0DrNpDPKMPN7DFZQWtC/peQDDXwKdkkYBJhSKN+1j2bMcb5gRyLWvgUGGBHw8g5Oww4k2B1Ns4MKZHMDO7im6IpTQHYxdx8OHidnen2EcSlQKugQXF/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oxeFbtk/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oxeFbtk/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863F6C4CED1;
	Wed,  5 Feb 2025 14:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767063;
	bh=q2fMgM9PGBeatQEwHZG8qWMktSejGM8vmEqkKRZdJ3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oxeFbtk/fGFVXJInu+RpL2RgIn1Hj/wlLH3WUz3h2Vgc0rrSaFS5Vf+DtvZUrrg53
	 VWsVTTsyiUrZZz6YIUSEG7HQJGgHRW0u6yGWHOQxaDHCcHm/vKV/6X6xxqG13QfxrE
	 wBgEkfAwjWwwAb3v9XBN/TXuqKWK83XjN3JP7+uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c92878e123785b1fa2db@syzkaller.appspotmail.com,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 401/590] iommu: iommufd: fix WARNING in iommufd_device_unbind
Date: Wed,  5 Feb 2025 14:42:36 +0100
Message-ID: <20250205134510.604746113@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suraj Sonawane <surajsonawane0215@gmail.com>

[ Upstream commit d9df72c6acd683adf6dd23c061f3a414ec00b1f8 ]

Fix an issue detected by syzbot:

WARNING in iommufd_device_unbind iommufd: Time out waiting for iommufd object to become free

Resolve a warning in iommufd_device_unbind caused by a timeout while
waiting for the shortterm_users reference count to reach zero. The
existing 10-second timeout is insufficient in some scenarios, resulting in
failures the above warning.

Increase the timeout in iommufd_object_dec_wait_shortterm from 10 seconds
to 60 seconds to allow sufficient time for the reference count to drop to
zero. This change prevents premature timeouts and reduces the likelihood
of warnings during iommufd_device_unbind.

Fixes: 6f9c4d8c468c ("iommufd: Do not UAF during iommufd_put_object()")
Link: https://patch.msgid.link/r/20241123195900.3176-1-surajsonawane0215@gmail.com
Reported-by: syzbot+c92878e123785b1fa2db@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c92878e123785b1fa2db
Tested-by: syzbot+c92878e123785b1fa2db@syzkaller.appspotmail.com
Signed-off-by: Suraj Sonawane <surajsonawane0215@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index b5f5d27ee9634..649fe79d0f0cc 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -130,7 +130,7 @@ static int iommufd_object_dec_wait_shortterm(struct iommufd_ctx *ictx,
 	if (wait_event_timeout(ictx->destroy_wait,
 				refcount_read(&to_destroy->shortterm_users) ==
 					0,
-				msecs_to_jiffies(10000)))
+				msecs_to_jiffies(60000)))
 		return 0;
 
 	pr_crit("Time out waiting for iommufd object to become free\n");
-- 
2.39.5



