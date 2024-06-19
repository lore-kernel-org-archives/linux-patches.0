Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44C7143C65;
	Wed, 19 Jun 2024 13:18:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803128; cv=none; b=sMfODgV7XcOTfu23lQsGTZnto7e5kqe/97LZdPnt/fK+Yz0Hk5W4DajDzqqWZt2329DEcuC+xGHbyc4ggiuBYkHybmCpJ36OeaoS66KJI7acXehbQ0iQdQCFkBmIKuK6XRFYEo5Q0mH2TE1JLMreSPs2aWmqfCZeCkFIIqTg8G8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803128; c=relaxed/simple;
	bh=DsVzL0ElhbxAVAHv2StyoLftzJ5+iZ6LbniwhXdCCEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILFgiCKu0mjaQcM7MyTJHMD/OwfH2fqe4vA/HvGeo2Y0BGKbRgE6dksWv3+iOC3ObsDlaPN4upbzFpi8xt3F+61HNS4FJGU05BmLQRD4XgP10vif9RW6bx6Qf/Mp3q6JmXFI979tXM9gNB2T7QHt1sAW+FUoMWgTKtMie3shmaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ABGepthO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ABGepthO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 588E7C2BBFC;
	Wed, 19 Jun 2024 13:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803128;
	bh=DsVzL0ElhbxAVAHv2StyoLftzJ5+iZ6LbniwhXdCCEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ABGepthO2Ea3vdd1PYF3vRUbwaBf1aB2Bbe0ePvqvOdBKcVzN/NcllhgJfjGxeAVR
	 Bg4pvaQSYYA4NdLqw1xONHoMx7SqAoRvR6FEuI91zAk9twm7K3u8tQwUlMyvF0kEEm
	 DTJ/XP7EzMbO1BeiT18zaZnymqYLVTTb6+QvmbsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 162/281] net/sched: initialize noop_qdisc owner
Date: Wed, 19 Jun 2024 14:55:21 +0200
Message-ID: <20240619125616.072663230@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 44180feaccf266d9b0b28cc4ceaac019817deb5c ]

When the noop_qdisc owner isn't initialized, then it will be 0,
so packets will erroneously be regarded as having been subject
to recursion as long as only CPU 0 queues them. For non-SMP,
that's all packets, of course. This causes a change in what's
reported to userspace, normally noop_qdisc would drop packets
silently, but with this change the syscall returns -ENOBUFS if
RECVERR is also set on the socket.

Fix this by initializing the owner field to -1, just like it
would be for dynamically allocated qdiscs by qdisc_alloc().

Fixes: 0f022d32c3ec ("net/sched: Fix mirred deadlock on device recursion")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240607175340.786bfb938803.I493bf8422e36be4454c08880a8d3703cea8e421a@changeid
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_generic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index 4a2c763e2d116..10b1491d55809 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -673,6 +673,7 @@ struct Qdisc noop_qdisc = {
 		.qlen = 0,
 		.lock = __SPIN_LOCK_UNLOCKED(noop_qdisc.skb_bad_txq.lock),
 	},
+	.owner = -1,
 };
 EXPORT_SYMBOL(noop_qdisc);
 
-- 
2.43.0



