Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B024A2F9492;
	Tue, 17 Jun 2025 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177585; cv=none; b=WSursMp2K96kbui7Xrkw/k2ERkE6nGAMRSRnoqtwS13Wm5MM2r4vDIYE+QaVfbjNiJ3wUScoc39SChO2DDymPWpAR9zwGtxzZqFYzWjezSfebfFzrLVbLV3/5i+aBmorQWzGVSm44sG+WbhXysBWwFyxBhXieGNBpgn16ui3TyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177585; c=relaxed/simple;
	bh=SE0c2ktNiFQGhglbMYELqRJJ5tsKWp1cdVqsemKO8oA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3c4FEzlg4fuYm3Yk5WlD3ys6DCcCDRkr0nL6+t4dyWaaUAqKhi/noXh6aen0/Z79dHaXEQZ8skhxWIEzHwN/0Fwg7pzFjn1T8B4qOa/LgaQL2poix9IHKPioMBbc3uKlMEJEUdvrPZOnMkG46lFm0C2pCctNdsqxo2sbBb/NN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qyllv3rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qyllv3rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C31AC4CEE3;
	Tue, 17 Jun 2025 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177585;
	bh=SE0c2ktNiFQGhglbMYELqRJJ5tsKWp1cdVqsemKO8oA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qyllv3rlvfFKlkB7fH7lRZUI0PrKpAV8y+PSRPjKZJuc0Nrja0wWZ82uxlJ0TJNLZ
	 BADUXPhV1giZyEdvpRuC5u2IHTVXMAmvQjzzxt6qbuM97j8bG3uUxN5jYRSYFJJPOv
	 87E2flaXlee2WTBmQo6z0Kr/g0SjiIkEOPYd9vIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Wu <wuyun.abel@bytedance.com>,
	Tengteng Yang <yangtengteng@bytedance.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/512] Fix sock_exceed_buf_limit not being triggered in __sk_mem_raise_allocated
Date: Tue, 17 Jun 2025 17:25:11 +0200
Message-ID: <20250617152433.572981021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengteng Yang <yangtengteng@bytedance.com>

[ Upstream commit 8542d6fac25c03b4bf36b2d762cfe60fda8491bb ]

When a process under memory pressure is not part of any cgroup and
the charged flag is false, trace_sock_exceed_buf_limit was not called
as expected.

This regression was introduced by commit 2def8ff3fdb6 ("sock:
Code cleanup on __sk_mem_raise_allocated()"). The fix changes the
default value of charged to true while preserving existing logic.

Fixes: 2def8ff3fdb6 ("sock: Code cleanup on __sk_mem_raise_allocated()")
Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
Signed-off-by: Tengteng Yang <yangtengteng@bytedance.com>
Link: https://patch.msgid.link/20250527030419.67693-1-yangtengteng@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index 0842dc9189bf8..3c5386c76d6fe 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -3157,16 +3157,16 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 {
 	struct mem_cgroup *memcg = mem_cgroup_sockets_enabled ? sk->sk_memcg : NULL;
 	struct proto *prot = sk->sk_prot;
-	bool charged = false;
+	bool charged = true;
 	long allocated;
 
 	sk_memory_allocated_add(sk, amt);
 	allocated = sk_memory_allocated(sk);
 
 	if (memcg) {
-		if (!mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge()))
+		charged = mem_cgroup_charge_skmem(memcg, amt, gfp_memcg_charge());
+		if (!charged)
 			goto suppress_allocation;
-		charged = true;
 	}
 
 	/* Under limit. */
@@ -3251,7 +3251,7 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
 
 	sk_memory_allocated_sub(sk, amt);
 
-	if (charged)
+	if (memcg && charged)
 		mem_cgroup_uncharge_skmem(memcg, amt);
 
 	return 0;
-- 
2.39.5



