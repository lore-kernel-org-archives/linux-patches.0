Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B35F23D2A2;
	Wed, 30 Jul 2025 09:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868556; cv=none; b=ScWFGhH7Q864CPAJ/TWUElwhm1rj3814dVdui7tRFg/mZ5hN8TP9RI/6cl70Rpj+G5SkUgw/Xe8ySh1nTBKhdApiGeSqPSl8Vplmz3/gPMXGnkCWvc+J+qnsQtQszEOzmeueGVbmQ61ly0W3FGRWPMDjz7pBdPSSF5CJUPdkv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868556; c=relaxed/simple;
	bh=+zeQakzBckWsFqy1our8N2B3Xw1cUc+PnSWQEB7ZcgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr3fmvighsfr7SygxR0sw9D/QK2VRqD0UXay4sHXgsP19HrGWglso6S5BF7uNPFFwk3JAOI33TF44SXwMWIxSPlVtwNozXOFgf20SMaqYQBOMvoGHT7DMaw7P9I53Dd7X1gEdkqRsJSg5/kkm026ER1uw1wRpBhrAUqI57xZWh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVIo85Ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVIo85Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CEDC4CEE7;
	Wed, 30 Jul 2025 09:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868556;
	bh=+zeQakzBckWsFqy1our8N2B3Xw1cUc+PnSWQEB7ZcgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVIo85Ms1nvIZrcyk2pmhhvg9uBDArPG2u9dCxhquKMIiwCXMtF2Js5GlGBIouUFo
	 RiCjiHjfvvaSjJi3bqTGvIF+FF+haV0aRQCo7QVK3q+gUmhTfnLtoZ720sION32XOJ
	 676ToP0W3ZX/shNs87aZwIYv1Eir0hiIvzgW0ilc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7ed9d47e15e88581dc5b@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/117] xfrm: state: initialize state_ptrs earlier in xfrm_state_find
Date: Wed, 30 Jul 2025 11:34:47 +0200
Message-ID: <20250730093234.285387093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 94d077c331730510d5611b438640a292097341f0 ]

In case of preemption, xfrm_state_look_at will find a different
pcpu_id and look up states for that other CPU. If we matched a state
for CPU2 in the state_cache while the lookup started on CPU1, we will
jump to "found", but the "best" state that we got will be ignored and
we will enter the "acquire" block. This block uses state_ptrs, which
isn't initialized at this point.

Let's initialize state_ptrs just after taking rcu_read_lock. This will
also prevent a possible misuse in the future, if someone adjusts this
function.

Reported-by: syzbot+7ed9d47e15e88581dc5b@syzkaller.appspotmail.com
Fixes: e952837f3ddb ("xfrm: state: fix out-of-bounds read during lookup")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 7a298058fc16c..912a4161a7420 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1324,6 +1324,8 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
 
 	rcu_read_lock();
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
 	hlist_for_each_entry_rcu(x, &pol->state_cache_list, state_cache) {
 		if (x->props.family == encap_family &&
 		    x->props.reqid == tmpl->reqid &&
@@ -1364,8 +1366,6 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	else if (acquire_in_progress) /* XXX: acquire_in_progress should not happen */
 		WARN_ON(1);
 
-	xfrm_hash_ptrs_get(net, &state_ptrs);
-
 	h = __xfrm_dst_hash(daddr, saddr, tmpl->reqid, encap_family, state_ptrs.hmask);
 	hlist_for_each_entry_rcu(x, state_ptrs.bydst + h, bydst) {
 #ifdef CONFIG_XFRM_OFFLOAD
-- 
2.39.5



