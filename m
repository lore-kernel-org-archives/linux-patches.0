Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693711F3D56;
	Tue, 21 Jul 2026 17:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653857; cv=none; b=rd60DG7naPt6gugbkGlFKwVO9Oluw0NKn2X8+VqBvkPNXbywYGKSGUF/twdgogngajauptm6S9671+0cGcNMeVavCMmCUkoG3BzXs5aTT/AWsg7sQfYoqQKV8JCAcTv+I7Affx/5I9Hxvf3+z/zWBVsVF1/9OICJZ2NsBzYYms0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653857; c=relaxed/simple;
	bh=oiDL7xUaBQwmYoGsuZJwV3iwhFuVoI8TRz4c6nrqAow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT2D5JarZknpjuRm3qlV1yzEFilxafAYH6GjtuNeSs8lMq8fH6JcLtGO8ExI7PyRUANKuKzM9FJQdBKtEir9BfLSkLfl8B7/Tr6wyUV80eaKduamyIOdIBgFHmBJUNelll0Mam95ZdbfNZcriV9nQCU4tanO/CKHhZQ2X/11R9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xizga/ce; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xizga/ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA7B1F000E9;
	Tue, 21 Jul 2026 17:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653856;
	bh=2EgkAnzbgyVKFIOBsG1A7lr0LvxPhILnD1rDsHKnqNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xizga/ce8Hls0BnoWsRLy/aczj4TkIg+WIjyEt20kZLeh3RlXeB7094FqaAexQMgk
	 LZ3MfkQHzd1l4HZ6+MO2QdYjkLA3Q6a0Kd87AnWVS/KJe1BR/qhNo9ap3+nDneU7oy
	 FZf8JLneSqSkFuHoxZ8kbM2zJs/B5D/qvKBQJpw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1486/2077] ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()
Date: Tue, 21 Jul 2026 17:19:19 +0200
Message-ID: <20260721152627.848097063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7b19c0f81ed1fdaec6bc522569be367199a9edf3 ]

A race condition exists between device teardown (inetdev_destroy) and
incoming IGMP query processing (igmp_rcv), leading to a Use-After-Free
in the IGMP timer callback.

During device destruction, inetdev_destroy() drops the primary reference
to in_device, which can drop its refcount to 0. The actual freeing of
in_device memory is deferred via RCU (using call_rcu()).

Concurrently, igmp_rcv() runs under RCU read lock and obtains the
in_device pointer. Because the memory is RCU-protected, CPU-0 can safely
dereference in_device even if its refcount has hit 0.

However, if CPU-0 calls igmp_gq_start_timer() and re-arms the timer, it
attempts to acquire a reference using in_dev_hold(). This increments the
refcount from 0 to 1, triggering a "refcount_t: addition on 0" warning.
Since the in_device memory is still scheduled to be freed after the RCU
grace period (as the free callback does not check the refcount again),
the device is freed while the timer is still armed. When the timer
expires, it accesses the freed memory, causing a kernel panic.

Fix this by using refcount_inc_not_zero() (via a new helper
in_dev_hold_safe()) to prevent acquiring a reference if the device is
already being destroyed. If the refcount is 0, we do not arm the timer.

A similar issue in IPv6 MLD is fixed in a subsequent patch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: Zero Day Initiative <zdi-disclosures@trendmicro.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260705181756.963063-2-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/inetdevice.h |  5 +++++
 net/ipv4/igmp.c            | 14 +++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/linux/inetdevice.h b/include/linux/inetdevice.h
index dccbeb25f70141..6032eea2539a60 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -293,6 +293,11 @@ static inline void in_dev_put(struct in_device *idev)
 #define __in_dev_put(idev)  refcount_dec(&(idev)->refcnt)
 #define in_dev_hold(idev)   refcount_inc(&(idev)->refcnt)
 
+static inline bool in_dev_hold_safe(struct in_device *idev)
+{
+	return refcount_inc_not_zero(&idev->refcnt);
+}
+
 #endif /* __KERNEL__ */
 
 static __inline__ __be32 inet_make_mask(int logmask)
diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 523aecb3c9be72..73e9ebb17afaa1 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -248,16 +248,20 @@ static void igmp_gq_start_timer(struct in_device *in_dev)
 		return;
 
 	in_dev->mr_gq_running = 1;
-	if (!mod_timer(&in_dev->mr_gq_timer, exp))
-		in_dev_hold(in_dev);
+	if (in_dev_hold_safe(in_dev)) {
+		if (mod_timer(&in_dev->mr_gq_timer, exp))
+			in_dev_put(in_dev);
+	}
 }
 
 static void igmp_ifc_start_timer(struct in_device *in_dev, int delay)
 {
-	int tv = get_random_u32_below(delay);
+	if (in_dev_hold_safe(in_dev)) {
+		int tv = get_random_u32_below(delay);
 
-	if (!mod_timer(&in_dev->mr_ifc_timer, jiffies+tv+2))
-		in_dev_hold(in_dev);
+		if (mod_timer(&in_dev->mr_ifc_timer, jiffies + tv + 2))
+			in_dev_put(in_dev);
+	}
 }
 
 static void igmp_mod_timer(struct ip_mc_list *im, int max_delay)
-- 
2.53.0



