Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BB72F2C64;
	Tue, 17 Jun 2025 15:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175649; cv=none; b=gAlVpyE8pVLnBr1pSBvKcBL/Xundwv3XwxCAVcKBJVb/JDHBFYGIyKGFrinSXrdspQeTmTN9zFyiHrSzN7Lexf+DAn+pmt7uKrjjZ4rALM1pslOQgU2avThUweF+kqX3o7HspokAGli4afWpdVuycbONjF9bxXX5knQuzvNvMzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175649; c=relaxed/simple;
	bh=t3ZWamaGPA7srMqFRXERs7kWP3c1/koVy6W4j9B4y3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uubXV8oZSjs12ELu5XCKMa2wGR+SuYSj0k6cMsstq1LNFC4VieTqcd8mmxyczb0W8WTTL2gGp0/TDExs4afNPmIjBLhbbfA5IpQhv8shPd90/0s0xTRIZioijMokGbfBjHyB73Lmml1hvJExmqUJlFJPB8Ve7YV3XrvKSKmjW2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6+3MsLq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6+3MsLq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62934C4CEE3;
	Tue, 17 Jun 2025 15:54:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175648;
	bh=t3ZWamaGPA7srMqFRXERs7kWP3c1/koVy6W4j9B4y3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K6+3MsLqexNXRJXFEJeGDdQpF2t4InZo+y9JOa12PxwyERK3ehRxZWIkYMfYUfN3s
	 DsdUI2N9MMvqkZYnzWhGv45IIZNH5lCdc096C9GkncTnVOxpkD2KPrnORcF3YarRXy
	 MbRownHN03emMYF6XuTN8y+t0ukxM67Axf0TBAyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anton Protopopov <a.s.protopopov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 150/512] bpf: Fix uninitialized values in BPF_{CORE,PROBE}_READ
Date: Tue, 17 Jun 2025 17:21:56 +0200
Message-ID: <20250617152425.683638630@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit 41d4ce6df3f4945341ec509a840cc002a413b6cc ]

With the latest LLVM bpf selftests build will fail with
the following error message:

    progs/profiler.inc.h:710:31: error: default initialization of an object of type 'typeof ((parent_task)->real_cred->uid.val)' (aka 'const unsigned int') leaves the object uninitialized and is incompatible with C++ [-Werror,-Wdefault-const-init-unsafe]
      710 |         proc_exec_data->parent_uid = BPF_CORE_READ(parent_task, real_cred, uid.val);
          |                                      ^
    tools/testing/selftests/bpf/tools/include/bpf/bpf_core_read.h:520:35: note: expanded from macro 'BPF_CORE_READ'
      520 |         ___type((src), a, ##__VA_ARGS__) __r;                               \
          |                                          ^

This happens because BPF_CORE_READ (and other macro) declare the
variable __r using the ___type macro which can inherit const modifier
from intermediate types.

Fix this by using __typeof_unqual__, when supported. (And when it
is not supported, the problem shouldn't appear, as older compilers
haven't complained.)

Fixes: 792001f4f7aa ("libbpf: Add user-space variants of BPF_CORE_READ() family of macros")
Fixes: a4b09a9ef945 ("libbpf: Add non-CO-RE variants of BPF_CORE_READ() macro family")
Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20250502193031.3522715-1-a.s.protopopov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/bpf_core_read.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/lib/bpf/bpf_core_read.h b/tools/lib/bpf/bpf_core_read.h
index c0e13cdf96607..b997c68bd9453 100644
--- a/tools/lib/bpf/bpf_core_read.h
+++ b/tools/lib/bpf/bpf_core_read.h
@@ -388,7 +388,13 @@ extern void *bpf_rdonly_cast(const void *obj, __u32 btf_id) __ksym __weak;
 #define ___arrow10(a, b, c, d, e, f, g, h, i, j) a->b->c->d->e->f->g->h->i->j
 #define ___arrow(...) ___apply(___arrow, ___narg(__VA_ARGS__))(__VA_ARGS__)
 
+#if defined(__clang__) && (__clang_major__ >= 19)
+#define ___type(...) __typeof_unqual__(___arrow(__VA_ARGS__))
+#elif defined(__GNUC__) && (__GNUC__ >= 14)
+#define ___type(...) __typeof_unqual__(___arrow(__VA_ARGS__))
+#else
 #define ___type(...) typeof(___arrow(__VA_ARGS__))
+#endif
 
 #define ___read(read_fn, dst, src_type, src, accessor)			    \
 	read_fn((void *)(dst), sizeof(*(dst)), &((src_type)(src))->accessor)
-- 
2.39.5



