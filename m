Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82673223E75;
	Thu, 12 Dec 2024 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023371; cv=none; b=XvwW5eFfOhxu2f6XkKcpbVKKynERPmtplDpxN/0K4Jsm+wUjoOXWcxegdu6WMkx/UzMNdrbhVr3IYopD9DHKzwh8IwBWP+8imvKRVHcEHjVrdD8+7OCaYxsznqticI/FzABR1QFH6GlSDJRdlrtVkk8Z76omiy60YTmdIrBFwgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023371; c=relaxed/simple;
	bh=xBar6yM4bGSVmlXSSKuR26xcSmryaCZYFni3EtAflcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a1P4vk3tzrQXGJOEhaP6FdcZBnH+d6W9bEzbqGncSBlZpylXSN82wkAf5hM84oUJqW+OOGlF0DfaOLZh1/ALxbRC5nO9zfD3In6NTkrahwQ9ckOCzTz8rQVOlZWe+uSXs4GzeRBWffnc5c7ZLR7+CJQp6zVHLIhXuM8ithSRGTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pxKn1HsG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pxKn1HsG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E61F4C4CED0;
	Thu, 12 Dec 2024 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023371;
	bh=xBar6yM4bGSVmlXSSKuR26xcSmryaCZYFni3EtAflcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pxKn1HsGPnZgx+vAUEKUE+ctzkw3cEZ7jgH0GEV7tkyvpc8YBwezPSblu9DAtkQuY
	 toYHCYfUR6Df7qOEgvd4RrVTrirk8wqoYuULA3gSgQkl+lpcH64VR7SSTk5svwVmUg
	 0kp8J4vk0C1Uib7xs7AQbxBfiFpxTWy8pjMZMvwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Kubiak <michal.kubiak@intel.com>,
	Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 511/565] netpoll: Use rcu_access_pointer() in __netpoll_setup
Date: Thu, 12 Dec 2024 16:01:46 +0100
Message-ID: <20241212144331.975730584@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

[ Upstream commit c69c5e10adb903ae2438d4f9c16eccf43d1fcbc1 ]

The ndev->npinfo pointer in __netpoll_setup() is RCU-protected but is being
accessed directly for a NULL check. While no RCU read lock is held in this
context, we should still use proper RCU primitives for consistency and
correctness.

Replace the direct NULL check with rcu_access_pointer(), which is the
appropriate primitive when only checking for NULL without dereferencing
the pointer. This function provides the necessary ordering guarantees
without requiring RCU read-side protection.

Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20241118-netpoll_rcu-v1-1-a1888dcb4a02@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 2a9d95368d5a2..597e83e2bce86 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -636,7 +636,7 @@ int __netpoll_setup(struct netpoll *np, struct net_device *ndev)
 		goto out;
 	}
 
-	if (!ndev->npinfo) {
+	if (!rcu_access_pointer(ndev->npinfo)) {
 		npinfo = kmalloc(sizeof(*npinfo), GFP_KERNEL);
 		if (!npinfo) {
 			err = -ENOMEM;
-- 
2.43.0



