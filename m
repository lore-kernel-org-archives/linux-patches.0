Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35B44F68B4;
	Tue, 13 Oct 2026 12:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894294; cv=none; b=jZlrMZjAjWa/kOmXOrNEnwTA4MJzIaF/J/GHXer0VJvMr0f+Pg25ygsxa7dM46xV9R1oI/42AVJb2KhMPNNvqzXY8f1vF7vESRRr1YajyJAKW5ZBsbPjiMuLCZf1E1oNUi+PON1KdGb8XqIP6OJw8x8VWHVU0H+F7IsbD8/kpdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894294; c=relaxed/simple;
	bh=vupzbVJRE6PWDWZONT2ZG2PR/qNFL7w+FODvlA8KO8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqXpZH/2SqpPmcYlI0PgLZ+UvmQkDOEAJuAqDmwnrYeP8DVh9nE99d/ppi03xe4jOhty9EIzyGf6GwZIlDa3730Zzav4NvR/g8V8aAnWImL8vNHh77gV4QSFaRCLXWVcC/hlg6PJnXaJGT6R4gzXoVtM9AGwYnzlTWlJdDpgnQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SQOZ+JJC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SQOZ+JJC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26C21F00893;
	Tue, 13 Oct 2026 12:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894293;
	bh=GnWbyW1lJ/BOJf+7ANQJskg8pnKghMqJr6paa1+ndgw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQOZ+JJC6WkmB08LUCI6Pp/Yv885gqcG9iOGVyzQXVnzrAGA3JcR0WjOpFjd9NdlL
	 F3wCH/svtmCW+bepev80FnVjCGWvxcebGju51JIg3B9Aet0sNQJTP0dcFVNhs87/Bl
	 S7vLb4d6Spj92WusbHKp1jMw7iZM0dXWPogdP0JQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/621] bpf: Reject writes through untrusted BTF pointers
Date: Tue, 13 Oct 2026 13:38:00 +0200
Message-ID: <20261013112932.341023619@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index 47549e988f2c7..696e1b8d06608 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7372,6 +7372,11 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
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
@@ -7380,8 +7385,7 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
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



