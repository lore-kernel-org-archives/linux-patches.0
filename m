Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7833803CF;
	Sat, 12 Sep 2026 07:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197901; cv=none; b=IQ14R9fTN54SnxOmuIdZgzOdi+e1BrZ6ZOyALAwhhkPu2SKQjxp68eTCrLWPL/qfFDeoZqSbEwGaJMgbhe2/71qrIIv1rjBwPyHaCy/hflts+NG/wpRcRjdFIq+PachviqB/p+hDH1BiTTa7QG69ItzJn3uubg8ZHpyIqHns11Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197901; c=relaxed/simple;
	bh=m1LA2u4GKNJjc69OyX1eGQYxhUGPtTPUsOCI4la0ixA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFHKpqFone62Ey38YoDuH9yEbSLx/YjMTRpuPSiZtM956w3WMDzMqsjdu2++bGqQ8IjeGB9cqiJfQ/bACWTXiU5CJToClRxkvVAzxjKPRCQuESwG84NWkyCDr/oZkAGSprT/xZTY/RL3McQjPYPn7c6GQekCDpvLnf/pXcafda0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vydlSwLA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vydlSwLA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98BEC1F00893;
	Sat, 12 Sep 2026 07:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197899;
	bh=IBfKbnZTxdAXmKZi95XCCqnVu33e5zzQNs941Fve/KY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vydlSwLA0w+5ucM7+X724mIaet1UDL0DiU7T++nhII8TheYjOhOJ9BfGgKADbHaP+
	 MovS6FbVHvngqoBcyAt6VgqgIFNcDB3WRpvbsy8tO/C171tiOVrNB7GhGfNzQ4ksyp
	 iXBzbEbhWqWZzo//55H5PKeuLUF0g+KdFJH+l9Zo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0268/1815] bpf: Reject writes through untrusted BTF pointers
Date: Sat, 12 Sep 2026 08:33:38 +0200
Message-ID: <20260912065655.261370239@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit ac65c710cc643cbc52b899627577357867249530 ]

check_ptr_to_btf_access() lets program-type btf_struct_access callbacks
validate writes before the default BTF access path rejects non-read
accesses. That bypasses the read-only policy for untrusted BTF pointers
created by helpers such as bpf_rdonly_cast().

Reject non-read accesses through PTR_UNTRUSTED BTF pointers at the
common entry point, before the callback branch to handle all cases.

Fixes: 282de143ead9 ("bpf: Introduce allocated objects support")
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 4e8b653fb34b9..6f78dd4043e54 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5790,6 +5790,11 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
+	if (atype != BPF_READ && (type_flag(reg->type) & PTR_UNTRUSTED)) {
+		verbose(env, "only read is supported\n");
+		return -EACCES;
+	}
+
 	if (env->ops->btf_struct_access && !type_is_alloc(reg->type) && atype == BPF_WRITE) {
 		if (!btf_is_kernel(reg->btf)) {
 			verifier_bug(env, "reg->btf must be kernel btf");
@@ -5802,8 +5807,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 				reg_arg_name(env, argno), tname, off, size);
 	} else {
 		/* Writes are permitted with default btf_struct_access for
-		 * program allocated objects (which always have id > 0),
-		 * but not for untrusted PTR_TO_BTF_ID | MEM_ALLOC.
+		 * program allocated objects (which always have id > 0).
 		 */
 		if (atype != BPF_READ && !type_is_ptr_alloc_obj(reg->type)) {
 			verbose(env, "only read is supported\n");
-- 
2.53.0



