Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3AB47252F;
	Tue, 21 Jul 2026 20:09:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664542; cv=none; b=jO1fs9/f7sMrwwBhbM+AaRRB3cYbzwXpmtyli3cC7fGj3R6Mk3Q++1TheM0ZcWOXS5E7Ckv5GUjAcJcFt8CAEukMDRCzXSuowLFD7z33OyAYAgQskx5EACuSESuXJN16neX/l5p8THTiB7P0GpLlQDm/3XajXDOdQSShKKu5e4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664542; c=relaxed/simple;
	bh=s4gogwGBaJ87H2qU/op/XvEhkbX0MHmtJcCfZEZQcs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pr0K9jwa85kX495iDFUQTrcIbs9Gl5yGNITjtteTs7sZnn2CclvTYihHGb7ASVd8dEhYBoN4l/PoFLh7h0fifNTVJTo02C7LZ6Ios7IKcp0E/1guoygRvKkZVpEwrMf+IZ6YkFulcpEO/4bWFhgNxPqwsz7NpUB+jGf0q/gIock=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0fqtMuJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0fqtMuJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A20021F000E9;
	Tue, 21 Jul 2026 20:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664541;
	bh=/gCA8TwbUo7qFqI/62xMjEyL17ecDS+VZdkNPafS48s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0fqtMuJ7dmUNCGAycIBjcW/u4Q7Fvw6ZwrUSSoabeBD1/h94hUVpLxuN3a01l7QV/
	 YFupfefuLm++BcIcCSSzJi1BCSKVB8B5evg4Lczgmo+Sw3NGo33WA1nw3XwAsHCJsT
	 1p+6FJAxGSoXWb2qxSnfpnpv9z/z7VPn1dB3kREo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1202/1276] bpf: Convert lpm_trie.c to rqspinlock
Date: Tue, 21 Jul 2026 17:27:25 +0200
Message-ID: <20260721152512.961702783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 47979314c0fe245ed54306e2f91b3f819c7c0f9f ]

Convert all LPM trie usage of raw_spinlock to rqspinlock.

Note that rcu_dereference_protected in trie_delete_elem is switched over
to plain rcu_dereference, the RCU read lock should be held from BPF
program side or eBPF syscall path, and the trie->lock is just acquired
before the dereference. It is not clear the reason the protected variant
was used from the commit history, but the above reasoning makes sense so
switch over.

Closes: https://lore.kernel.org/lkml/000000000000adb08b061413919e@google.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20250316040541.108729-22-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Stable-dep-of: 2f884d371faf ("bpf: Allow LPM map access from sleepable BPF programs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/lpm_trie.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -15,6 +15,7 @@
 #include <net/ipv6.h>
 #include <uapi/linux/btf.h>
 #include <linux/btf_ids.h>
+#include <linux/bpf_local_storage.h>
 
 /* Intermediate node */
 #define LPM_TREE_NODE_FLAG_IM BIT(0)
@@ -361,8 +362,7 @@ static long trie_update_elem(struct bpf_
 	 */
 	slot = &trie->root;
 
-	while ((node = rcu_dereference_protected(*slot,
-					lockdep_is_held(&trie->lock)))) {
+	while ((node = rcu_dereference(*slot))) {
 		matchlen = longest_prefix_match(trie, node, key);
 
 		if (node->prefixlen != matchlen ||
@@ -483,8 +483,7 @@ static long trie_delete_elem(struct bpf_
 	trim = &trie->root;
 	trim2 = trim;
 	parent = NULL;
-	while ((node = rcu_dereference_protected(
-		       *trim, lockdep_is_held(&trie->lock)))) {
+	while ((node = rcu_dereference(*trim))) {
 		matchlen = longest_prefix_match(trie, node, key);
 
 		if (node->prefixlen != matchlen ||


