Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7CEA4CB5B;
	Sun,  7 Jun 2026 10:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827693; cv=none; b=pMOyXfCspGF8d0F9ruXGySiMx/Hngd2bpzHsnUhNRDbq6TJuixG+39/dUpf/IOgsZwk22Y2FQKDIkCVAHCtFDMD7T+D1JE0Y+V2DMnEnyrOj0Cf0xDl0gYtFGTNE9cP4dGOiYcr29LY5MrBk7Xi4tlMit7ctGuMkAmJ2vd38qTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827693; c=relaxed/simple;
	bh=7UPAp1ZwCY4yFSn40kAOeeeCrifOXFMSzPC5LazaUCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rStOSo2FHXbbayFX2mYMBMD8tENLlDZXI8tEZYs8USl7xXAMRvWn/Wyvyg2f92RMcaLmKgePz+QuP6YMCeRHsEzUEQMntdzimdAe3bXyoWXhFFmc5hwRDaRcfesNMJhNDoHSFj3ni7xHWf8b3pNjYnHOZxeamM9kPfJ0gS8XfgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzMQVjR9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzMQVjR9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428121F00893;
	Sun,  7 Jun 2026 10:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827692;
	bh=DRWUhWPLsiUKtFqQVIH54EwqN8WAFl/hPTUoc3a84bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzMQVjR9r4fBhIRXqkJriwT8H8dAcNazBpIAuUjD/u2EKKaC0/X0vp3dUltZLhoeg
	 uFG+dxK6SmfV9cuUrqy8ubPmvvUtQkQmm3aGG26wsUzSn7z0DmPVk2yNU63DYnx+AX
	 bzdG71kcSd6akGbPjSp72i2pPS27V4/XB0ZDB+yo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/315] ipv6: fix possible infinite loop in fib6_select_path()
Date: Sun,  7 Jun 2026 11:58:00 +0200
Message-ID: <20260607095731.045147676@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 9c7da87c2dc860bb17ca1ece942495d28b1ce3b9 ]

Found while auditing the same pattern Sashiko reported in
rt6_fill_node() [1]. Apply the same fix as
commit f8d8ce1b515a ("ipv6: fix possible infinite loop in fib6_info_uses_dev()").

Writers holding tb6_lock can list_del_rcu(&first->fib6_siblings)
without waiting for RCU readers; first->fib6_siblings.next then
still points into the old ring and this softirq-side walker never
reaches &first->fib6_siblings as its terminator. fib6_purge_rt()
always WRITE_ONCE()s first->fib6_nsiblings to 0 before
list_del_rcu(), so an inside-loop check is a reliable detach signal.

[1] https://sashiko.dev/#/patchset/20260526020227.4857-1-jiayuan.chen%40linux.dev

Fixes: d9ccb18f83ea ("ipv6: Fix soft lockups in fib6_select_path under high next hop churn")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260527053133.180695-2-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/route.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index cf9546047b5749..f89220929c4e24 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -481,6 +481,9 @@ void fib6_select_path(const struct net *net, struct fib6_result *res,
 		const struct fib6_nh *nh = sibling->fib6_nh;
 		int nh_upper_bound;
 
+		if (!READ_ONCE(first->fib6_nsiblings))
+			break;
+
 		nh_upper_bound = atomic_read(&nh->fib_nh_upper_bound);
 		if (hash > nh_upper_bound)
 			continue;
-- 
2.53.0



