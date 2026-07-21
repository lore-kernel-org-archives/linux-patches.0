Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA77387588;
	Tue, 21 Jul 2026 20:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667082; cv=none; b=gSDlEVGUv9fZYvVrnjvcIr+UpJzyQYjrj1oE22here6HU8yDdj7eD8usC2Q8JkHR0zZFGdeph9AI7LO9mZchk5dpDuhgyY+lpLKqH522xsqWpRkKXPh9FpPUNOi0KAifsPctvl6TVq3cgpfdYz2QUafcXv3ut2Zpp6b3rbkMBsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667082; c=relaxed/simple;
	bh=GwoArsSlYLQea6VwcXu3Rg4VpZQ+WZfBYPoXzdYTr0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUxDep6MfDhIsfFU7nQwiHXzDgP9d69VQsGUGSSZkQd7oF5dRym5rC333CjmGsoqaVq8GVWh7jiRFvvE1wmbxrbmcf7jMif9NWi+x1KakUahrbH53Ihp1z4O8Kmk6m9Ns8CAtdPFstcdaU8fJ1QizeFh+1i6vK7aZ9Scgg8tAaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niczbdnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niczbdnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CF5A1F000E9;
	Tue, 21 Jul 2026 20:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667080;
	bh=1DM3eUT2xnz5s5tBldYDqVZim8ADAHSGwBSdLgC8ljA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=niczbdnw2avRyv0wONLXo4tpMtIhavtJRToT9QSMCnyY/wo3HiJsW/C1uCk4gqyrn
	 Az1ObcI+RYUKx7AOyGLXjLvOFkGqdD/dL0/x6pIpibK9AcOlJqErAZqbYDUmvj3OfN
	 fZoby97EeiI6gRiBhUIHq29SrftRDZK9STLywJDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zero Day Initiative <zdi-disclosures@trendmicro.com>,
	Eric Dumazet <edumazet@google.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0872/1266] ipv4: igmp: Fix potential UAF in igmp_gq_start_timer()
Date: Tue, 21 Jul 2026 17:21:49 +0200
Message-ID: <20260721152501.362216409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b157ff4f727fba..566f3c2b38928a 100644
--- a/include/linux/inetdevice.h
+++ b/include/linux/inetdevice.h
@@ -282,6 +282,11 @@ static inline void in_dev_put(struct in_device *idev)
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
index 9b3cb1cce2e515..732804f3a0aa35 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -232,16 +232,20 @@ static void igmp_gq_start_timer(struct in_device *in_dev)
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



