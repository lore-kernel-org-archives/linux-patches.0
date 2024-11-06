Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BED721DFD90;
	Wed,  6 Nov 2024 12:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895859; cv=none; b=qDuEMpWghj5mli7JIHakI8jxQeD4PS8pphkrrSxGh9eNiuU+u64g0ptVVnELeFzs9hC1HPCNZHcP5yU9FQGImnP96hHICumhphGIxOjmHZZMP6vyTT/YzUTa6qnl3cl76MT4tY+0r6ThKMYAL37c/1RYYxh/VfIw3Mn6cf+3lOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895859; c=relaxed/simple;
	bh=lUfEJ0K0h9GRd0xRTYUeYQ0Mg9yBaKNPE9UrzKFDeAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E2va8Aud1MIVtJ1QQZZ8jX+h96ou3Le9aa6GQNHbBd22LP2YWe6hNqv/cuFz9IcVu7/aSRePI6dFNsJBMbO2g0k3pF5OmTUavra8HGrwnjuDhxSJQFg+ZXwrwyWdtqnC+gyt9dhuK1nFerv9ByZHNF4i8ME7D/dn+aKesYwkZOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=boW07J5N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="boW07J5N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43ACEC4CECD;
	Wed,  6 Nov 2024 12:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895859;
	bh=lUfEJ0K0h9GRd0xRTYUeYQ0Mg9yBaKNPE9UrzKFDeAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=boW07J5Nm1yZzDF59A5hVojjFVX/vwHXOHDtAgj9PGXrEofYsPdjMKEE2muglDnx/
	 o0wU7BAG90mTPjFRxIpsFolhy1VYX6abrFKuweOP9KUCUazQM7L0dejw21FekrJiPz
	 LdIN0Z1fUj9x+oRzdvkkVXAjE3mAsFxugBRUBb1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Ben Greear <greearb@candelatech.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 001/245] lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
Date: Wed,  6 Nov 2024 13:00:54 +0100
Message-ID: <20241106120319.274293314@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit dc783ba4b9df3fb3e76e968b2cbeb9960069263c ]

Ben Greear reports following splat:
 ------------[ cut here ]------------
 net/netfilter/nf_nat_core.c:1114 module nf_nat func:nf_nat_register_fn has 256 allocated at module unload
 WARNING: CPU: 1 PID: 10421 at lib/alloc_tag.c:168 alloc_tag_module_unload+0x22b/0x3f0
 Modules linked in: nf_nat(-) btrfs ufs qnx4 hfsplus hfs minix vfat msdos fat
...
 Hardware name: Default string Default string/SKYBAY, BIOS 5.12 08/04/2020
 RIP: 0010:alloc_tag_module_unload+0x22b/0x3f0
  codetag_unload_module+0x19b/0x2a0
  ? codetag_load_module+0x80/0x80

nf_nat module exit calls kfree_rcu on those addresses, but the free
operation is likely still pending by the time alloc_tag checks for leaks.

Wait for outstanding kfree_rcu operations to complete before checking
resolves this warning.

Reproducer:
unshare -n iptables-nft -t nat -A PREROUTING -p tcp
grep nf_nat /proc/allocinfo # will list 4 allocations
rmmod nft_chain_nat
rmmod nf_nat                # will WARN.

[akpm@linux-foundation.org: add comment]
Link: https://lkml.kernel.org/r/20241007205236.11847-1-fw@strlen.de
Fixes: a473573964e5 ("lib: code tagging module support")
Signed-off-by: Florian Westphal <fw@strlen.de>
Reported-by: Ben Greear <greearb@candelatech.com>
Closes: https://lore.kernel.org/netdev/bdaaef9d-4364-4171-b82b-bcfc12e207eb@candelatech.com/
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/codetag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/codetag.c b/lib/codetag.c
index afa8a2d4f3173..d1fbbb7c2ec3d 100644
--- a/lib/codetag.c
+++ b/lib/codetag.c
@@ -228,6 +228,9 @@ bool codetag_unload_module(struct module *mod)
 	if (!mod)
 		return true;
 
+	/* await any module's kfree_rcu() operations to complete */
+	kvfree_rcu_barrier();
+
 	mutex_lock(&codetag_lock);
 	list_for_each_entry(cttype, &codetag_types, link) {
 		struct codetag_module *found = NULL;
-- 
2.43.0



