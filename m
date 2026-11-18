Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056827;
	b=GXiGqlC7Y16HwgGiIwmWjWTv/cSiK1MN0+3JKeXRyTVfaSAt4LJttbxtiuevkJQNEQE2
	 i9CN7GwC7d5WME1ZeLKu3uD2C42zM72J9s9ogjuUAEiKjdBU/YHJtPjLrXD87YOSjd1Dc
	 C++kY/4HvfwRDQ/SYwoFbAQfP1x45+r+tP7K/WFDtFAzeEQwhHRc8RoEATjJaX/6zg8V0
	 /tBRNllK5YkdijDEqXnGX57VZzHBxZCKI3B9los+7iVBUoZ6OhyYmtkoWNVEAVIxRYoka
	 oVJ2dWHnk6xhtyifjNDwerwNTIZjw8yHWwaS5uBIot3fS56xd5Qt9ClRuFR+m3/pY8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056827;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bf5tqEr1yzzOGNGXR2+3pOfuLzeZxeDa0dkseCbM/rg=;
	b=VV0wgXSYVpFkeFyZCgMOrSN0fqZFpFkPXFAN/g3jTfmc+AX1ZRsa5t1xLWeanSAzvNBa
	 t1KeW8nPfwvVnnDEWfypdoKKD9r8DFf5OTO6viilg/NavUbvt0gK46iWdZKF7n/6BocAd
	 qpDXOLE3wYLhMmamvSHzfgFBIhjnjnrZt2nzamAClIA1SDWXMqyg+E8INLvXC3XD/P0wM
	 GRG6frJnPx3OZZBPmzXYVGT7JrIDs4LgzhNzYkDsUk29UJwmsw1Ckxq8ZGBAr/oP5BZ2h
	 NjdQVHFN1Q3LoAWZeUUdfAe7QIFUDQyQkjmKG+EZFsIZE/39ypb33ZvZxB2gzeetr+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ljc2itGK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E44606A331;
	Thu, 19 Nov 2026 02:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ljc2itGK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81DFA1F000C5;
	Thu, 19 Nov 2026 02:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056827;
	bh=bf5tqEr1yzzOGNGXR2+3pOfuLzeZxeDa0dkseCbM/rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ljc2itGK3hssCcNqy3xMCK7Wh4LAkAiBNdn4u8jfxsS7M7uPrq/UEFekM3dtHcEwO
	 rtp+qBTcWxXj8P1OhFsmiK++b9rruqnzdPW8yr6g9yMBUblUCPIsMJrZOlY9c/UiRr
	 SCsbf6X0ajBlJwct1Wl4b+DM8rw/oR+72bFIvCdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil Kaushik <anilkaushikwireless@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2085/2214] gtp: hold RCU for the device lookup when adding a PDP context
Date: Wed, 18 Nov 2026 16:02:41 +0100
Message-ID: <20261118150134.045728858@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil Kaushik <anilkaushikwireless@gmail.com>

[ Upstream commit fe3e1a42fb7eb18d8c55d714b50a3d51f8cd6ffe ]

gtp_genl_new_pdp() calls gtp_find_dev(), which looks the device up with
dev_get_by_index_rcu(). Since commit e2d1baca2b33 ("gtp: remove useless
rcu_read_lock()"), this only runs under the rtnl lock, and kernels with
CONFIG_PROVE_RCU_LIST warn:

  WARNING: suspicious RCU usage
  net/core/dev.c:1047 RCU-list traversed in non-reader section!!
  ...
   dev_get_by_index_rcu
   gtp_find_dev
   gtp_genl_new_pdp

Hold the RCU read lock around the lookup only: gtp_pdp_add() allocates
with GFP_KERNEL, and the rtnl lock keeps the device alive afterwards.

Found with the gtp selftest on a debug kernel.

Fixes: e2d1baca2b33 ("gtp: remove useless rcu_read_lock()")
Signed-off-by: Anil Kaushik <anilkaushikwireless@gmail.com>
Link: https://patch.msgid.link/20261016093225.1036375-3-anilkaushikwireless@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/gtp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/gtp.c b/drivers/net/gtp.c
index 18ce889f5619f..cc10995b5ec6f 100644
--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -1101,7 +1101,10 @@ static int gtp_genl_new_pdp(struct sk_buff *skb, struct genl_info *info)
 
 	rtnl_lock();
 
+	/* the rtnl lock keeps the device alive once found */
+	rcu_read_lock();
 	gtp = gtp_find_dev(sock_net(skb->sk), info->attrs);
+	rcu_read_unlock();
 	if (!gtp) {
 		err = -ENODEV;
 		goto out_unlock;
-- 
2.53.0



