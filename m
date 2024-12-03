Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27DC71F76AE;
	Tue,  3 Dec 2024 15:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238834; cv=none; b=rJNofidZneg7cuu5KG4v437Ymm1zUZqlaXdu1CreZeUC2i3+mEfd9LuAF+ibIiASy+rM6qiqnECGfpxonzJeub1TJyjd5k07L2fiIBkyBZRMrN/FYaXnC/YxYy9KCzSwp2pyYOAvEn2XaX9EPr0Lu/9uvjyqRvhDdox7ApThi1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238834; c=relaxed/simple;
	bh=FB3FYtlH7LU3zjJUVWEhukKa+klV9idxKu9045lc0hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e26bifwJ4osblv09NLnQ3u5PFMpII+AzSIETv/OAlmTMMo3GPCE11sGieQgVqpNQuRM4k/WxWudqypYxNfJibyhVdDTyuusta+jt9m7IrVO269KISNLqcsAXoc/N/4e0W2FCC89AX6PsxpkkAThbSPtwXh3Myjmv7YcJOeY6zg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2/K3J58; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2/K3J58"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99556C4CECF;
	Tue,  3 Dec 2024 15:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238834;
	bh=FB3FYtlH7LU3zjJUVWEhukKa+klV9idxKu9045lc0hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I2/K3J58jS++wLoSjl1zgEUPawQup6AgXy14XA1rN92mMnWQEWyH9pRNih9xfIFLs
	 33Uug1y6gL5EKfBdVzFG+nIE9/503I+8ry5qGxlx7E+tdgCf8ZaKqGhwz6WMyGOFwx
	 miNxbLyA5/nLUB+Fw7eAy3ClEGQXx5U1X0PPalRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 371/817] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Tue,  3 Dec 2024 15:39:03 +0100
Message-ID: <20241203144010.322478612@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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



