Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3019267B89;
	Tue,  8 Apr 2025 12:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115223; cv=none; b=WsQtNncpqESqDpI1R0zQvqCOnJ2rmuQwwwAvyrKYpveh6vrxc8Jhiw4TOVON8DexnTNRMZdXI6rZTYyP5OY2GobLFrS5dArOu1qIa8tnPjK0AvRZNqj5GO9CXC0zA+fxGKJ8zNK9pmCYzyeb692iPEhbkYxgCx5+9EjPGVjyeYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115223; c=relaxed/simple;
	bh=Sd5BMYrbkBSVQ9HuXOaUFv34BMW02UPBvNQVuPeDinE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjRELSK9v1TOst/bg5nXo0S+kDhRuPxALmwBCDKUphYtGxI8GL6BwW/VFiggJPUulltknXNFHIU0A0+ORXLvz6qfaTx+EtC+4xcCb4sLazwVrmbI/DXkZdFeoHI++KXxgT/lo0OakDLpNirPnf/X94oT5DUr2xD9Jwqtn0lS8mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCwRWPpA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCwRWPpA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C641C4CEE5;
	Tue,  8 Apr 2025 12:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115222;
	bh=Sd5BMYrbkBSVQ9HuXOaUFv34BMW02UPBvNQVuPeDinE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCwRWPpAPYO91GHb1IJ2pI65XIuZC1ufH9/kmjKIDQxIka9J3TXlrfGks4sDU0XO3
	 Q2odKykPIqJGmCmOew9QlmBvDYBM37Vay8wAgYQckmyMNkMTICwTewqhR6iiPOFfeU
	 ZpkRUdTVswGGNvik7MjR/KZa/0kuYa322iJc6lAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@gmail.com>,
	Wang Liang <wangliang74@huawei.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 396/499] xsk: Fix __xsk_generic_xmit() error code when cq is full
Date: Tue,  8 Apr 2025 12:50:08 +0200
Message-ID: <20250408104901.103246406@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 5d0b204654de25615cf712be86c3192eca68ed80 ]

When the cq reservation is failed, the error code is not set which is
initialized to zero in __xsk_generic_xmit(). That means the packet is not
send successfully but sendto() return ok.

Considering the impact on uapi, return -EAGAIN is a good idea. The cq is
full usually because it is not released in time, try to send msg again is
appropriate.

The bug was at the very early implementation of xsk, so the Fixes tag
targets the commit that introduced the changes in
xsk_cq_reserve_addr_locked where this fix depends on.

Fixes: e6c4047f5122 ("xsk: Use xsk_buff_pool directly for cq functions")
Suggested-by: Magnus Karlsson <magnus.karlsson@gmail.com>
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250227081052.4096337-1-wangliang74@huawei.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 89d2bef964698..e04809a4c5d35 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -802,8 +802,11 @@ static int __xsk_generic_xmit(struct sock *sk)
 		 * if there is space in it. This avoids having to implement
 		 * any buffering in the Tx path.
 		 */
-		if (xsk_cq_reserve_addr_locked(xs->pool, desc.addr))
+		err = xsk_cq_reserve_addr_locked(xs->pool, desc.addr);
+		if (err) {
+			err = -EAGAIN;
 			goto out;
+		}
 
 		skb = xsk_build_skb(xs, &desc);
 		if (IS_ERR(skb)) {
-- 
2.39.5



