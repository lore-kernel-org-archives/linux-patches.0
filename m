Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AD7443A80;
	Tue, 21 Jul 2026 22:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672935; cv=none; b=WHE/XR+qPq/T2OZMDS+oy9ZVSTYBwaD97/ltaGWpFxFbriTw/UXFjJuH9VbeCNayXK/lpTPwzmQ12WA9MG1U1T0NHQwFAeFROXwYND7mNWUYe2R9theCMTao5x00pRSuGg+cUU7PCUUCjv/0n/taj3t0654cdxWprOoFxNOxoy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672935; c=relaxed/simple;
	bh=+jR1QFnqp+6mkTeUFsshnG3VidlSxiQ2kzyecR8vBTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eD3UtWwHc9MNE3NvY0RHmtQdzr34hLfGri8QjwLx3aX//NAz3pRNe1J5TdNiY0NCneasl73gAlTfdcoPohEAjghRX1cXLXDnQJkEdGqVZXQj0SGM/DP3+5FhkzebTwL67VYt7P0uL6+pYu5OdjATDfHNitTlg/s2MtCvIUX6VN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffUdMoW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffUdMoW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2102D1F000E9;
	Tue, 21 Jul 2026 22:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672933;
	bh=rbuQXnuvnMdvPK4wEdBCRmZ9tBcr5zVQinOEMQK6h9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffUdMoW0OsEA57mIpTHD5iMlb7zjtope7J2uuxmnNZNFTMWpxSpyePv9Q+gurY1wB
	 eyHphKd+AARxtCWhTrBy/4Ct7e9f2EZoPBNVuGSefv4+blItKY8rrEg5F5qXXcx2GI
	 9K5VmA1j+rhnP9bJI3y0mXTqQgaKd7pyJD+in87Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 810/843] bpf: Convert lpm_trie.c to rqspinlock
Date: Tue, 21 Jul 2026 17:27:25 +0200
Message-ID: <20260721152424.293608333@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
 kernel/bpf/lpm_trie.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/bpf/lpm_trie.c
+++ b/kernel/bpf/lpm_trie.c
@@ -349,8 +349,7 @@ static int trie_update_elem(struct bpf_m
 	 */
 	slot = &trie->root;
 
-	while ((node = rcu_dereference_protected(*slot,
-					lockdep_is_held(&trie->lock)))) {
+	while ((node = rcu_dereference(*slot))) {
 		matchlen = longest_prefix_match(trie, node, key);
 
 		if (node->prefixlen != matchlen ||
@@ -475,8 +474,7 @@ static int trie_delete_elem(struct bpf_m
 	trim = &trie->root;
 	trim2 = trim;
 	parent = NULL;
-	while ((node = rcu_dereference_protected(
-		       *trim, lockdep_is_held(&trie->lock)))) {
+	while ((node = rcu_dereference(*trim))) {
 		matchlen = longest_prefix_match(trie, node, key);
 
 		if (node->prefixlen != matchlen ||


