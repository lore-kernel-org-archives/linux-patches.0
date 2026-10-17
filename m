Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173AF3A1E92;
	Sat, 17 Oct 2026 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260270; cv=none; b=Qt0i0CvaoaLdj7OiM+tAVE0IPw/KGS+99HMosFpCx9rm1qoSc3/X+ZYrSG6gDjqyjVP56HxXGUhO/ecbSGJP1wojrjW5bdyYRw1jSj/G3M2Y+PBa9yIIm554NOfCE8f+zsy/ebk0vmrtj0+LYVjPs6DA91UdlTqM60VWIMz4s64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260270; c=relaxed/simple;
	bh=aUS0ZYEKOV946IuYypITG09UsxWhOcISeTZK9ifPXC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4sa5WmDjuIKi4TN4CInsw7s5YLdWFkBVTkZ8S+4GqaSeUos/3Wz9CAqHC5jFC633hhn8FdG+UkeJCEiab1FFs8tAiaIVEmYHinS9jzUAwlyuhV7n+8b3DQh0z1EbncYvXeyL+e+RWF3Z6hLsUDyJDWMzuw8QSFS3ET+Yg+/UII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RExrOCxw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RExrOCxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9EE1F000C4;
	Sat, 17 Oct 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260269;
	bh=6pkdnMVyIRxCyBnigteFlu3njm/Jq/HMqohfRFmYQu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RExrOCxw9TzqpSzyXDX/AbDS6zWK/syGsg0ssZUp7uNlzMJo/70IapMas0bBYUOjD
	 rzQiSlQtc30b1d7qHLN40IGQmus9TwiOfdg8PdJ2k9nPuLEtamCGVnCG2wdx0zEzB9
	 Ilf7VJ5xCIgyvP+NwkD0vuyY16O7dAX0UjwnsPps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1488/1674] bpf: Reject writes through untrusted BTF pointers
Date: Sat, 17 Oct 2026 18:02:40 +0200
Message-ID: <20261017160509.342283527@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6437863ff24c7..d091def05f064 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6579,6 +6579,11 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
+	if (atype != BPF_READ && (type_flag(reg->type) & PTR_UNTRUSTED)) {
+		verbose(env, "only read is supported\n");
+		return -EACCES;
+	}
+
 	if (env->ops->btf_struct_access && !type_is_alloc(reg->type) && atype == BPF_WRITE) {
 		if (!btf_is_kernel(reg->btf)) {
 			verbose(env, "verifier internal error: reg->btf must be kernel btf\n");
@@ -6587,8 +6592,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 		ret = env->ops->btf_struct_access(&env->log, reg, off, size);
 	} else {
 		/* Writes are permitted with default btf_struct_access for
-		 * program allocated objects (which always have ref_obj_id > 0),
-		 * but not for untrusted PTR_TO_BTF_ID | MEM_ALLOC.
+		 * program allocated objects (which always have ref_obj_id > 0).
 		 */
 		if (atype != BPF_READ && !type_is_ptr_alloc_obj(reg->type)) {
 			verbose(env, "only read is supported\n");
-- 
2.53.0



