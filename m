Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C31B1362;
	Tue,  3 Dec 2024 15:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241199; cv=none; b=hylu5g4YHh3tKSbgrPjIepHClyk8b11HOjFfO3vbOjB5N8sP+LxgccBP6SF5EwcakjsMrYGVBlxh8fU7d7aUs9za7m7cOdNQbK4XetMpEliahW3k0IgNqxgerRUQ6ibYRwtQPzrLj5LT7d5FXueLMLJnriDJGXXOCb2LsxEeTnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241199; c=relaxed/simple;
	bh=8rolsJOADAtrweau+EIsdD0Ix2pzJHjeQVSIEAe0E5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gSFXdIAowheqwYuBJHE+97/8KK5r7zoK8bUspXEHc7MIt8Ba5v3/w3RmAcs2y1TYEPWIZr/RRTfwRUzxlIEYGDG3h+aff6nMYROuV5X1h34X9p1fiJVLRpAabGboNVAisn48J1CSmg++OO87JrWhjK9yVK0tzYB81jrpHMWB6Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zwcbd/Cy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zwcbd/Cy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E036C4CECF;
	Tue,  3 Dec 2024 15:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241199;
	bh=8rolsJOADAtrweau+EIsdD0Ix2pzJHjeQVSIEAe0E5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zwcbd/CydQvVPK0GKm/9ZjP+VSqFhYuIv8QEGV/bKLmT59Ou8mISRS8wCDNv+lEzk
	 Rt13rribennSMGYF/SQUqm+9YICvICFi+Ykzm0/e/4CajFPq8uWii4tIRgIcW0/8K1
	 sEf9RYmWnWgLzH5+UXWVgByR1l8H+qkp2y8KdiEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 354/826] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Tue,  3 Dec 2024 15:41:21 +0100
Message-ID: <20241203144757.571344336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cd4e28db0cbd7..959a4daacea1f 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -72,7 +72,7 @@ static inline void *netpoll_poll_lock(struct napi_struct *napi)
 {
 	struct net_device *dev = napi->dev;
 
-	if (dev && dev->npinfo) {
+	if (dev && rcu_access_pointer(dev->npinfo)) {
 		int owner = smp_processor_id();
 
 		while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
-- 
2.43.0



