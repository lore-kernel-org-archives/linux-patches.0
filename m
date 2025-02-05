Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7044918BC26;
	Wed,  5 Feb 2025 15:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767660; cv=none; b=VP+WcwSreyyIqHjLk4OrbOGW1SUdxUJtkR0SZl3a22k4pKc9rNr78ir+M9OjBs3UZArJ/Ci+F7npHL/jnlkzPjhC0ZMpeKAtAZuKO/fBzhBYpSvjido4kOjb/3l6yNfN/TaOKQjb0eAVsKlObDD7tBjQ8hzMlDwGxcR3dipv5Wc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767660; c=relaxed/simple;
	bh=IEz68ZCEYgTdVPhc/wM+ZwLOlMOkJe8sc4v2ewPNitM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JtBlFM8bTqsNhpCTowqGSiWlbQnHVUs3H9/C3OIXww+AGGNiZqYKRA3vyC6+aOYUB/OfaWoVCGt2jhm7GdGHLxZ00NQ0RMz9/wpkQsQ0BGBgWwA6NrKpUBYyFvY2+2QIZmk2w//IQANyJF61OUC42WUfgnRqmv5Eli6KgE2ccI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CITMQSqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CITMQSqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2864C4CED1;
	Wed,  5 Feb 2025 15:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767660;
	bh=IEz68ZCEYgTdVPhc/wM+ZwLOlMOkJe8sc4v2ewPNitM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CITMQSqR+lP9yLEbNBWSdLCv6zHk0WDUh8PDwKcAWdGObAFcrZ+2/TF/YF8esq/tY
	 i0tlxzYshzYU4aUauteuxGigoIm9z+4vTjipKC45buhF+OlsRSEo06HwrlegsGVLb/
	 8NAjQJbRBuUfKXMm08LblH3B5KTr89TOImPlTttQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c92878e123785b1fa2db@syzkaller.appspotmail.com,
	Suraj Sonawane <surajsonawane0215@gmail.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 435/623] iommu: iommufd: fix WARNING in iommufd_device_unbind
Date: Wed,  5 Feb 2025 14:42:57 +0100
Message-ID: <20250205134512.861102122@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 97c5e3567d33e..d898d05be690f 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -104,7 +104,7 @@ static int iommufd_object_dec_wait_shortterm(struct iommufd_ctx *ictx,
 	if (wait_event_timeout(ictx->destroy_wait,
 				refcount_read(&to_destroy->shortterm_users) ==
 					0,
-				msecs_to_jiffies(10000)))
+				msecs_to_jiffies(60000)))
 		return 0;
 
 	pr_crit("Time out waiting for iommufd object to become free\n");
-- 
2.39.5



