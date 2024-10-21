Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E711D04BB;
	Mon, 21 Oct 2024 10:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506498; cv=none; b=tkuiUgDnoKEbMmjAgtm+J17KlxSkt7fI+4lLrDn8FNoyBYxdEX+RUO6WWtVTqIceomtQzfcpkT6qYG5KFGK7VnvnhXH+eqmwdAkGpYL095FoAUQ+HclZ0Ae7D0fVb4jqkmH2rBZmTo3YYx6fb+cRc/SNSBVGYnQ8FL8lJF9rLU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506498; c=relaxed/simple;
	bh=DtFJCgmosMs+7wWYgaYZySSnaOxuRS2S5/wvaWSMa9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JMezOnMNgqXRnylP8NTNd+W5x2Xz47tYOvg5L+Rh7aYdNn5cEYQe9wAN2Y89n5yCbL3iGU37XEGPaDxkHVUTX8aUFiGj+LSqfVcsg00Dp51J1I3PqZFzKVWaHLSm+tUJOyqcQQSEeuaT6NVTa/TTlEK+hxXH7/iSV6FP3cgFEcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sq5B6M9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sq5B6M9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B59CC4CEC3;
	Mon, 21 Oct 2024 10:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506497;
	bh=DtFJCgmosMs+7wWYgaYZySSnaOxuRS2S5/wvaWSMa9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sq5B6M9eh6MkwVp8aedGTWcoh3uohJ6s5VwqV5G8TYb49N4h65jQ7IqytGzwlCTlG
	 uDO4horYGdUAsyrfJcfUYWIIlHoVZagBGhSaLME4cqKJgBN6J+jR7UNURZqOTw5Ulm
	 B3HJHh+v07xc93+7XUoq6AfiYZ7uzdnF52VdIWFM=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 024/135] lib: alloc_tag_module_unload must wait for pending kfree_rcu calls
Date: Mon, 21 Oct 2024 12:23:00 +0200
Message-ID: <20241021102300.282974151@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
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

commit dc783ba4b9df3fb3e76e968b2cbeb9960069263c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/codetag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/codetag.c b/lib/codetag.c
index afa8a2d4f317..d1fbbb7c2ec3 100644
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
2.47.0



