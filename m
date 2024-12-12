Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41BF205501;
	Thu, 12 Dec 2024 17:20:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024023; cv=none; b=Ksvt8fDYPT0kmdlbkYeXymRtgicAij4s3pkL3v7d+Kk2YrRRQg/sOYu1mN/m8nVBjwHa7j7nMi2RumK7/0hGGouB0tj83iKpbNgDIDDMyzr0Zkw9G7gf3DG3hG12TnTs76MwOe8neux73ILDy3/zJE4DJWzvrTMzUUHFbaxxBkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024023; c=relaxed/simple;
	bh=C5vNwgtAkDmb9p/qtycjEgIjwbGm2FmAucHcViQp1EQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sxyme69S14ZmJ6ZP9QMjauzO4xRU6m9jZVaYbFEOQSN3YvmCT22XfidjdbdXWbPq+OhyV+HnO67ViDz4ABywfFKxCRrXrffZka65BHIXGv1LT/TF3SzG4bwbtYw1dHHa7u0ErI+bLJcEKsJsyF21o0yNYHyZVWvFGZkGpqLHiVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mldf8UGg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mldf8UGg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37104C4CECE;
	Thu, 12 Dec 2024 17:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024023;
	bh=C5vNwgtAkDmb9p/qtycjEgIjwbGm2FmAucHcViQp1EQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mldf8UGgFEBTQf+UcHWNZbH6r7p15dWK1KKnpQ0GxYYQnMwi1mWMndQKFCzLUgelH
	 +gQxy4hATb23a54LEZPqD7l+tdsLDeBWC3h+VUPYudyt/Gu90GZXO7CtNKaPBUcJWv
	 NIPW2njJHbHFeqL7p5Yb6jA9cFrn3FZLf5R/o0q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 161/459] netpoll: Use rcu_access_pointer() in netpoll_poll_lock
Date: Thu, 12 Dec 2024 15:58:19 +0100
Message-ID: <20241212144259.876063554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e6a2d72e0dc7a..533f8a5323a3b 100644
--- a/include/linux/netpoll.h
+++ b/include/linux/netpoll.h
@@ -70,7 +70,7 @@ static inline void *netpoll_poll_lock(struct napi_struct *napi)
 {
 	struct net_device *dev = napi->dev;
 
-	if (dev && dev->npinfo) {
+	if (dev && rcu_access_pointer(dev->npinfo)) {
 		int owner = smp_processor_id();
 
 		while (cmpxchg(&napi->poll_owner, -1, owner) != -1)
-- 
2.43.0



