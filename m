Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A835913D508;
	Fri,  6 Dec 2024 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497307; cv=none; b=W0u5XWHRkIyUxWRus5s9Vx95CY37puusSutiq7kaV0nSUF98NRhr+u+vEXNAT/roOfNDyUduUICaGeXJye5US8m8NQxQXVPH4GQ9QuoQfGQG7rtfV2K4d873Lbf4il8jZOAKQmzJB1rhzIeDWW0gohCxI5Zi5xLgeR5kilg4LA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497307; c=relaxed/simple;
	bh=OYStj4tSDBmQO62r4d0LhMkmbkdqO2Z5BtGVpAX+yB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GvbYiGxTDFdg8ve+cu0lvtV1WBdET0GG7T0M4Qs53Xu3CRqH00PG1LwAANK8Nc1rI90/9zfUhOkkOTfNe6Z+JKgMLMx4nsuiUvhvu5edxU3dMIKXXfWZJ0FazN97D2HGcKE4OFqB5ct3wzNj4aPVMq2DFLQjNcUYcO/LEPIktFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t6QuLdu3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t6QuLdu3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17DBCC4CED1;
	Fri,  6 Dec 2024 15:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497307;
	bh=OYStj4tSDBmQO62r4d0LhMkmbkdqO2Z5BtGVpAX+yB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t6QuLdu3+7veQ2mYkGHIjHYe3riRAubA7exCH6Ri+krxU5aDoGG9eK/IpF89l3L78
	 tCGrygtGQM74ouCC2rn503/ENaOmx6W2BcK8WMfhT589N+LSIzU8w7klnHcBBDvmRH
	 P3dZQAAByo7zYc62VDlTifWqw5t0OEwGG7LZ2R2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 255/676] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Fri,  6 Dec 2024 15:31:14 +0100
Message-ID: <20241206143703.290209655@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit a57d5a72f8dec7db8a79d0016fb0a3bdecc82b56 ]

The ndev->npinfo pointer in netpoll_poll_lock() is RCU-protected but is
being accessed directly for a NULL check. While no RCU read lock is held
in this context, we should still use proper RCU primitives for
consistency and correctness.

Replace the direct NULL check with rcu_access_pointer(), which is the
appropriate primitive when only checking for NULL without dereferencing
the pointer. This function provides the necessary ordering guarantees
without requiring RCU read-side protection.

Fixes: bea3348eef27 ("[NET]: Make NAPI polling independent of struct net_device objects.")
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Link: https://patch.msgid.link/20241118-netpoll_rcu-v1-2-a1888dcb4a02@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netpoll.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netpoll.h b/include/linux/netpoll.h
index bd19c4b91e312..3ddf205b7e2c3 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -71,7 +71,7 @@ static inline void *netpoll_poll_lock(struct napi_struct *napi)
 {
 	struct net_device *dev = napi->dev;
 
-	if (dev && dev->npinfo) {
+	if (dev && rcu_access_pointer(dev->npinfo)) {
 		int owner = smp_processor_id();
 
 		while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
-- 
2.43.0



