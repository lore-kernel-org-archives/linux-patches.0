Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 043DD427F99;
	Mon, 17 Aug 2026 14:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977502; cv=none; b=CnsKczWY412JrX/OaSiaC11XPMgVt5rU63GF8PxWjuNiUBPiPoPfJXTRPR2etHh8KcYfEViCLPdiUyse23VW2N9v5LTlJJBALopSABuaK/pxzL1SyLc/2cxQTNymguRaK84zHnWwpcso7NAzxYiksoaeLp5A1JtfH2g0qQXCUWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977502; c=relaxed/simple;
	bh=tHbNBzgrOxAaqz1Sy3ikCWWZHrmMRRhC0UcokiAhA9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBI3wThdeKkduzP00t7zolIaYb7ae0fv5yjxTWL37vRWr01l0F9Z0bPmzbX7FOvUWAFcXFc3Fy18VL7huJnNoc/9GHFqrOmsBN1CYAVTGFhdZP2wvTquQ1KVCT0/iPIH+goTUdh2aYN2V6vIstQDfdBcWfB9AhtGbI28boqZngE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1KhFNW5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1KhFNW5B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26D901F000E9;
	Mon, 17 Aug 2026 14:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977500;
	bh=PfDwSuRin5QApuBezL2ZN69RuJngVfGSO/gNENYer0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1KhFNW5B4bnT/AkI6NkV7AsqTjpvNx/MFoOzvK7YXkGdpZSn8af8Y40f7ja5XGB47
	 Z7/eZczYvnDaJON1l6Nom8QToCUpmJrXTQ6L1QS4M23/Zb4PmpNa77jKVbGj3XJw+x
	 ka/DSy1nhScWPIe9LgLGxz7+bRgRStDueb6VWCpg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lee <david.lee@trailofbits.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.15 314/456] netfilter: ipset: do not update comments from kernel-side hash adds
Date: Mon, 17 Aug 2026 15:31:44 +0200
Message-ID: <20260817132552.010639613@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lee <david.lee@trailofbits.com>

commit f30415929be8aeb002d557c8d3f7ab2d2188003a upstream.

mtype_resize() copies comment pointers with memcpy(), not the comment
objects themselves. During the window after an entry has been copied but
before the table swap and backlog replay, the old table is still
published for packet-side updates while the replacement-table entry
already holds the same ip_set_comment_rcu pointer.

If xt_SET --add-set ... --exist hits that old entry in this window,
mtype_add() calls ip_set_init_comment() even though packet-side adds
carry no comment payload. That call frees the shared comment through the
old entry, so the replacement-table entry now holds a stale pointer.
When the queued add is replayed on the new table, mtype_add() calls
ip_set_init_comment() again and strlen() dereferences the stale pointer.

Fix this in mtype_add() by skipping ip_set_init_comment() when
ext->target marks a packet-side add. Userspace adds still update
comments, while packet-side adds can no longer free comment storage
shared with a resize copy.

Fixes: f66ee0410b1c ("netfilter: ipset: Fix "INFO: rcu detected stall in hash_xxx" reports")
Cc: stable@vger.kernel.org
Signed-off-by: David Lee <david.lee@trailofbits.com>
Assisted-by: Codex:gpt-5.5
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -964,7 +964,7 @@ overwrite_extensions:
 #endif
 	if (SET_WITH_COUNTER(set))
 		ip_set_init_counter(ext_counter(data, set), ext);
-	if (SET_WITH_COMMENT(set))
+	if (SET_WITH_COMMENT(set) && !ext->target)
 		ip_set_init_comment(set, ext_comment(data, set), ext);
 	if (SET_WITH_SKBINFO(set))
 		ip_set_init_skbinfo(ext_skbinfo(data, set), ext);


