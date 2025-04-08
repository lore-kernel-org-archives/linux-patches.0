Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98F77269B0C;
	Tue,  8 Apr 2025 11:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111983; cv=none; b=QOFJWEcGWQP34b9CNEQa7kDEUi43G0dP1n7L4wOGMx5pEIxJEZ9rrV15VilCluGknwC78RCvdNHSK3CppAHaNU7mOPCfqBmuIlktWvXZNqFkymkeHlRDZaoPGFi1bQ91okz3/zTQU4v7YF1hKHeAFtdSOZOeZtlJRC+luTq5WuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111983; c=relaxed/simple;
	bh=rPEwXyDViuDPZ9tRgg4Q01APOowTo1RIlQoppeW3Fg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URMutsNaf9URbVIl8OmdOmRoWIwJoQ70p1KBlw6pu6+hLD848u45N3mzJGB7pr7zNAgw5AHwNBfN0Xcm3vA7yQo/GAcSfUaHHp8lKosC8RKDCz5otmqcbOnHBb6QhyFZ+DywHM96GkHOmhrzIhOg15dSxvl5DT3670kGRUqvwLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+e5n8sf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+e5n8sf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261EDC4CEE5;
	Tue,  8 Apr 2025 11:33:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111983;
	bh=rPEwXyDViuDPZ9tRgg4Q01APOowTo1RIlQoppeW3Fg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q+e5n8sfepOhP1b53hfELCF/wlxoj8rTcR7WbWjGrKRcE6QGzr+hoGHzzpeRSOkeR
	 8yX+SGejXU+x4yIBMo/+TCTjG2ojzBh3olRp5Y06qlXLHrfKDLlSztMyA4fU44RvB5
	 rHq5gSNKSNicxAqgnddQ7E1XNcsx6cbTjfGJqsjI=
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
Subject: [PATCH 6.14 631/731] xsk: Fix __xsk_generic_xmit() error code when cq is full
Date: Tue,  8 Apr 2025 12:48:48 +0200
Message-ID: <20250408104928.948942590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 41093ea63700c..a373a7130d757 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -805,8 +805,11 @@ static int __xsk_generic_xmit(struct sock *sk)
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



