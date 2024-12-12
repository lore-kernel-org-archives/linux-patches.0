Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81FFF20A5EE;
	Thu, 12 Dec 2024 17:39:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025184; cv=none; b=dQCxJpxRQOqXB9Pr2H+JjtJuVOwYsyYJZuNbn/rQbKuQjJB7lB82xNtJvWvlIW/A6LNu9PXllZGXVvLkWm4ybTXLoUuZYiZSwVaVKuImgFbt0o47sWQuSepirixKPsLqcH/ufRNHJHNFyEBh8l7HWM6iRtvJaNUoxfN2KCruSv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025184; c=relaxed/simple;
	bh=3H23y+nhAz9BuiyO6FHCQB15Dym9+QCrFh8NP/rdzA8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g42/wORV+oaWFAAcUH+0YPe5PQZJn/zkZUjYAUv6wIwEa9l4eal5IPzAZ/BLsoFCH9VpTfIJPeuOU9ndBxtJC8QvKyB/TOMKkylRZHfDkjCDIw1y3zyVYPlQGFQj5ZeFc6Hnj+qFgNOVO6D/2RZS57pYh5wwFzg8P2foWo0gWJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHAswu22; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHAswu22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AA8C4CECE;
	Thu, 12 Dec 2024 17:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025184;
	bh=3H23y+nhAz9BuiyO6FHCQB15Dym9+QCrFh8NP/rdzA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHAswu22cbcsB2IKyX93EJPOhV6mVK53xuc3wXcU6x7mo7CbZRBM+GLAzAXS4jPqk
	 ZhdVoOKtaQ8Vb695UxDFz0dsD9WM9JzNRZBKv1E6kIQllCjoq84MApYglTSXBK4CVA
	 Y+G6yy3QcGBqv24TM7RmMcwdZ6lS1AloLafM/byA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/321] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Thu, 12 Dec 2024 16:00:03 +0100
Message-ID: <20241212144233.340015634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 676f1ff161a98..3ff0303672842 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -78,7 +78,7 @@ static inline void *netpoll_poll_lock(struct napi_struct *napi)
 {
 	struct net_device *dev = napi->dev;
 
-	if (dev && dev->npinfo) {
+	if (dev && rcu_access_pointer(dev->npinfo)) {
 		int owner = smp_processor_id();
 
 		while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
-- 
2.43.0



