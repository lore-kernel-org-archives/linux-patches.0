Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC9A53EC812;
	Wed, 30 Sep 2026 19:29:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796577; cv=none; b=GnwevsDN8UL4UkbrKf2vBsB+ffbaO+MmLu+Tnrf34/OwE4hZU1V6g0Ota1OeWVZD50Mj39kRgvr7grtrZk6sqL0dZ4VJS96RlKtOP8tp21x8qfS7rnpjuwRzC0sXXENIdCkoZ9VMiFezFRrcLm+/5tb07Y+XRhNODaALGr0G1f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796577; c=relaxed/simple;
	bh=9rFq35iNrSumG2wLTZrnNK8XZ1iechnVwEx6kK73jZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nOpVv4DTJcABd3g2RkKbejzsCX9PDpk5gz+3yhHt6/cF0CWeQdt8S2rzvYhN16I7WctfIj/YG8DdPLrHsyBnjCLUPFw1L02D6bk7HotyUoYB3nBt1z8sEuNTZ3s9br8+6M6mbCa24058OUl33QeTPSb8gFaMWtAaWNvQanON4dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwdRz4lG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwdRz4lG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 557EC1F000FF;
	Wed, 30 Sep 2026 19:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796575;
	bh=RPWwiM81eF7Mfnz+VYURnEZuPeFa8QHQ0rFRIBKbTlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BwdRz4lG3WWI++ybSObe2IGdSem3ulyVUEridRnyvd7F0sFcrXs4QjowuO0H4qg9I
	 FeQ8OPlTc4X8eNKitDAFieOljJLZL0NPCwqsrtrexyYQR8IsKYAC1QCRoQibZ8Isoh
	 AlgtnZovgcajFf8R5L0pVNMCW/OoTWGgODDMT/kI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0963/1193] bpf: Fix divide-by-zero in btf_struct_walk()
Date: Wed, 30 Sep 2026 17:27:27 +0200
Message-ID: <20260930152455.639803647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit b0b3dc66529676228cb938cbcad66920f735c223 ]

When an access goes past the struct and the last member is a flexible
array, btf_struct_walk() folds the offset back into a single element with
(off - moff) % t->size, but never checks that the element type has a size.

BTF takes an empty struct, so this in program BTF

	/* event could be empty */
	struct event {
 #ifdef HAVE_TIMESTAMP
		__u64 ts;
 #endif
	};

	struct batch {
		int nr;
		struct event events[];
	};

divides by zero at prog load time. Getting there needs a PTR_TO_BTF_ID that
is not MEM_ALLOC, e.g. a plain read of a local kptr stashed in a map from a
sleepable program.

Oops: divide error: 0000 [#1] SMP KASAN PTI
RIP: 0010:btf_struct_walk+0x53f/0x1570
Call Trace:
 <TASK>
 btf_struct_access+0x42a/0xcd0
 check_ptr_to_btf_access+0x4dc/0x1160
 check_mem_access+0x3a45/0x8740
 check_load_mem+0x36a/0xd10
 do_check_common+0x3ef0/0xb210
 bpf_check+0x6d3b/0x8580
 bpf_prog_load+0xf7c/0x2720
 __sys_bpf+0xa83/0x3690
 __x64_sys_bpf+0xc7/0x150
 x64_sys_call+0x1f3f/0x27e0
 do_syscall_64+0xe5/0x610
 entry_SYSCALL_64_after_hwframe+0x76/0x7e
 </TASK>

Reject a zero-sized element type. The fixed array path in the same function
already bails out on the same thing:

	btf_struct_walk()
	...
		/* skip empty array */
		if (moff == mtrue_end)
			continue;

		msize /= total_nelems;

Fixes: 9c5f8a1008a1 ("bpf: Support variable length array in tracing programs")
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260910122316.186384-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 1c9119f0dfd72..60018b87589de 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6212,7 +6212,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		if (btf_type_is_int(t))
 			return WALK_SCALAR;
 
-		if (!btf_type_is_struct(t))
+		if (!btf_type_is_struct(t) || !t->size)
 			goto error;
 
 		off = (off - moff) % t->size;
-- 
2.53.0



