Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9E59267B6B;
	Tue,  8 Apr 2025 10:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744109673; cv=none; b=HcgxmkP5GzczXSWv3o1OUj4bBZ4pVapu5KGaJR689dd/ZISoS/qNJUFzGp3wSaW9kPVph+o1Gkyg0j4LE+PLljnOUJPxqbASgDVZmhiD1BH7Sz9dOQCK220HlAi7T2Moy2xuqhu8CcdfoNuB7qI5TaLZ+yOkcpKxUVytCk2vsnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744109673; c=relaxed/simple;
	bh=omBvyt1M6RENj1wL4KS38cnHEqUNbHSOyDvX6WJGbBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9IfYLjvC+rx1ybvq/X3mUW5gTQ6G2b4DeAY6yzrBjN9fqHJomePRRWlQwRvJizGmxw6mW/rpgJNj6xAYLb1arccuYn85O0Vq5IS27S0ctZlI/S1rc7vWUR9U9niR0JL/Pi4Bwcsb6RhJajsWlzC/6s/HE4gdYJo+9U8YJU68IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y42osU9i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y42osU9i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05846C4CEE5;
	Tue,  8 Apr 2025 10:54:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744109671;
	bh=omBvyt1M6RENj1wL4KS38cnHEqUNbHSOyDvX6WJGbBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y42osU9ig7Q0hL9zB/DLVBEQYKA2yb3navVpcmlCCBXIGfQHBAG/6N6nmraGMWGb8
	 VP7XliWXJIXxf73CRCd9g3Pzt1NkHD8KelcPJ+B/sufgA8+ZtRoWaXnppur2d5hxTe
	 bV4Or3YdaPDgVOz7eUH0WcNDZlNi+efjOI7AHTfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/227] netfilter: nft_ct: Use __refcount_inc() for per-CPU nft_ct_pcpu_template.
Date: Tue,  8 Apr 2025 12:46:29 +0200
Message-ID: <20250408104820.729129270@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.353768086@linuxfoundation.org>
References: <20250408104820.353768086@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 5cfe5612ca9590db69b9be29dc83041dbf001108 ]

nft_ct_pcpu_template is a per-CPU variable and relies on disabled BH for its
locking. The refcounter is read and if its value is set to one then the
refcounter is incremented and variable is used - otherwise it is already
in use and left untouched.

Without per-CPU locking in local_bh_disable() on PREEMPT_RT the
read-then-increment operation is not atomic and therefore racy.

This can be avoided by using unconditionally __refcount_inc() which will
increment counter and return the old value as an atomic operation.
In case the returned counter is not one, the variable is in use and we
need to decrement counter. Otherwise we can use it.

Use __refcount_inc() instead of read and a conditional increment.

Fixes: edee4f1e9245 ("netfilter: nft_ct: add zone id set support")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_ct.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 4b75c7113de4d..f95f1dbc48dea 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -239,6 +239,7 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	enum ip_conntrack_info ctinfo;
 	u16 value = nft_reg_load16(&regs->data[priv->sreg]);
 	struct nf_conn *ct;
+	int oldcnt;
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) /* already tracked */
@@ -259,10 +260,11 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
-	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
-		refcount_inc(&ct->ct_general.use);
+	__refcount_inc(&ct->ct_general.use, &oldcnt);
+	if (likely(oldcnt == 1)) {
 		nf_ct_zone_add(ct, &zone);
 	} else {
+		refcount_dec(&ct->ct_general.use);
 		/* previous skb got queued to userspace, allocate temporary
 		 * one until percpu template can be reused.
 		 */
-- 
2.39.5



