Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6B0D2236EA;
	Thu, 12 Dec 2024 16:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019520; cv=none; b=anafgRWxRtpEivuafTriuCrQFP8PDhY/Z2j4fUdAaVH0VknN/ut+WhiXjxDVwYn7C+6nZztREF8TtkXy7Tio6o+YmWPr+0uL9CYc0CmRqfIG4DDvePAjsGnZMjYjgC+6OIaiVPH9ZdpnF+GyNZUz9UeE4cWxvJt7JeNFSf1Dflo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019520; c=relaxed/simple;
	bh=3Sd+fUH3YrTqhcfb3OTIPDr3rtYqWjDjMefXw9rbssM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXWMJU2laBrcZ67mNMRXlpt8iaI9WmxXQdMh87uHTKGQB1Bv3jr2L2xeC4OLHQTB3lfE/lLqt7K7ptmONkNPjdkugA4IYDqZwEmXsolSIyOuI+CALmBEhl3u9YvaheRq9DQBobRq4UAA6jYrWrkE7UdPjfqt8Pj4WqgH01zmo7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ33jmen; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ33jmen"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBA9C4CECE;
	Thu, 12 Dec 2024 16:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019519;
	bh=3Sd+fUH3YrTqhcfb3OTIPDr3rtYqWjDjMefXw9rbssM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FZ33jmeneeD7LM5mnUSr3Szj0nlzSN/nxqb27Yd9t7Rl2N1zQtcg0/5hIpxmnZpzJ
	 fUf4tZTuqXiBXq14/3T5CKFQHQEbl2SgLeLin0N4l7ClcoPy/GpJs7gKDtiOSTgKeP
	 lh71oegWtW7EQ4Ugo+o1MJEV4XVr2p+VxL/9LO64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/772] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Thu, 12 Dec 2024 15:52:23 +0100
Message-ID: <20241212144358.120609114@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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



