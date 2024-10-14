Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F0DE571;
	Mon, 14 Oct 2024 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917097; cv=none; b=HI/23YnVz1Cc5+JErIH21ETe/Xfw5XMtJ1h0D/ezeafRK/ZcZMB0cpkYZqof8W/mxPQ77HT2nSoFebe8K+KmsrYmCwCESgz5ujHYhKyqyCokjNqakZ5/jKJOLxs4RuOeXahq8M3XujeqoWsFD/Fl1SzVS3gWx8AD9SjA5l1mJys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917097; c=relaxed/simple;
	bh=TxKd8qSWDMvkwBh5ksyahjk8skYMv7pbHVpyBmUp1tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VMmRIJL21Y/LAb1uceTTPKREm6xgLVGgoPSf03BeZMiBp2evJPku3tQAqWw/HWbdVjyOaygqxNADrv54ZeeXMv+seFtKDVNUHqAomw8DMFPs6fcTi7vgAnElYTA4MxftN2a/PEPpEMbM9B+wb7yC+88YIA90Svk4CQrRiiotpuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfyFLspE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfyFLspE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A32C4CEC3;
	Mon, 14 Oct 2024 14:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917097;
	bh=TxKd8qSWDMvkwBh5ksyahjk8skYMv7pbHVpyBmUp1tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfyFLspEe/1CdYYIGjPJqAhHt1JdHiCAIrW4nnt33Kc3meDnjur19/StE9OwxPwFK
	 RtjppcEKA7RT9Yf/9/Hp+GDGZ/1r2qsAJ+LvrmZyWR0yPoE0wT0eM88H31LqHltQNq
	 OITVU/18DP2/1Z2SlCu+gHmUmg8W+JLGiApY57L0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Linux Kernel Functional Testing <lkft@linaro.org>,
	Eric Dumazet <edumazet@google.com>,
	Xin Long <lucien.xin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/213] net: do not delay dst_entries_add() in dst_release()
Date: Mon, 14 Oct 2024 16:20:57 +0200
Message-ID: <20241014141048.863384473@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit ac888d58869bb99753e7652be19a151df9ecb35d ]

dst_entries_add() uses per-cpu data that might be freed at netns
dismantle from ip6_route_net_exit() calling dst_entries_destroy()

Before ip6_route_net_exit() can be called, we release all
the dsts associated with this netns, via calls to dst_release(),
which waits an rcu grace period before calling dst_destroy()

dst_entries_add() use in dst_destroy() is racy, because
dst_entries_destroy() could have been called already.

Decrementing the number of dsts must happen sooner.

Notes:

1) in CONFIG_XFRM case, dst_destroy() can call
   dst_release_immediate(child), this might also cause UAF
   if the child does not have DST_NOCOUNT set.
   IPSEC maintainers might take a look and see how to address this.

2) There is also discussion about removing this count of dst,
   which might happen in future kernels.

Fixes: f88649721268 ("ipv4: fix dst race in sk_dst_get()")
Closes: https://lore.kernel.org/lkml/CANn89iLCCGsP7SFn9HKpvnKu96Td4KD08xf7aGtiYgZnkjaL=w@mail.gmail.com/T/
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Xin Long <lucien.xin@gmail.com>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20241008143110.1064899-1-edumazet@google.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dst.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/net/core/dst.c b/net/core/dst.c
index 980e2fd2f013b..137b8d1c72203 100644
--- a/net/core/dst.c
+++ b/net/core/dst.c
@@ -109,9 +109,6 @@ struct dst_entry *dst_destroy(struct dst_entry * dst)
 		child = xdst->child;
 	}
 #endif
-	if (!(dst->flags & DST_NOCOUNT))
-		dst_entries_add(dst->ops, -1);
-
 	if (dst->ops->destroy)
 		dst->ops->destroy(dst);
 	netdev_put(dst->dev, &dst->dev_tracker);
@@ -161,17 +158,27 @@ void dst_dev_put(struct dst_entry *dst)
 }
 EXPORT_SYMBOL(dst_dev_put);
 
+static void dst_count_dec(struct dst_entry *dst)
+{
+	if (!(dst->flags & DST_NOCOUNT))
+		dst_entries_add(dst->ops, -1);
+}
+
 void dst_release(struct dst_entry *dst)
 {
-	if (dst && rcuref_put(&dst->__rcuref))
+	if (dst && rcuref_put(&dst->__rcuref)) {
+		dst_count_dec(dst);
 		call_rcu_hurry(&dst->rcu_head, dst_destroy_rcu);
+	}
 }
 EXPORT_SYMBOL(dst_release);
 
 void dst_release_immediate(struct dst_entry *dst)
 {
-	if (dst && rcuref_put(&dst->__rcuref))
+	if (dst && rcuref_put(&dst->__rcuref)) {
+		dst_count_dec(dst);
 		dst_destroy(dst);
+	}
 }
 EXPORT_SYMBOL(dst_release_immediate);
 
-- 
2.43.0



