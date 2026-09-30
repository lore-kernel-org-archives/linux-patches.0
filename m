Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B122D50AC0E;
	Wed, 30 Sep 2026 17:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788966; cv=none; b=nMMmnvqAjOo2sDbyICWP6NLeKyabVif3qHdbcKFoKLJwBbkX2Fl/WalKo8QLJvC/AnnI2Nk0zUWnZm8T00EnDGZSQlmU0myqvPzZrtE6hekNgS6oL/cvuqwTVeBPf4+iJ8VQf1hGnkZarn9BDHbw+2h9vTgZ3tNqnu2o+mndK7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788966; c=relaxed/simple;
	bh=16aDKoNGTQKBqeBJtVWujMWH7MnyW3boefiV4FmOc70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Go4A9TInWwXA7TYs5LvX5odDiKVNaT7MprflIzGNXdsVNPOQm73FeRZ9y8m437AIAq8p30++x3QImU/vnDWhqyyphBFquhOfNDN/bgOx1wHD+LKDHOuTwxTKIOS44kd6LHeAYOCd3SnS1FO/5BaggivetlnJ4zd33DymcrMZRGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sj3hjKHN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sj3hjKHN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FDC1F000FF;
	Wed, 30 Sep 2026 17:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788965;
	bh=BYdTY6s1TLrYMBdDMxKrAN3Jz9HYxBHUfqcSmWM4dUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sj3hjKHNlHlms2aDKCW220mevv8vgQxcDPpqyoiMmTRg90IfS5NSj5ePcSUgGSR+H
	 0oWKjxH6yXYILsoG0EPU/O581ZAIeQTmKNNgRDGBBHRjAdNhJMYVnMNqXanKEGXCRU
	 Bc9nNPoKukT7OPdIRACUFHwSIDrrFqQr5gFqaoPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 304/877] bpf: Fix divide-by-zero in btf_struct_walk()
Date: Wed, 30 Sep 2026 17:20:15 +0200
Message-ID: <20260930152421.259927397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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
index f219a03ceefff..0c040c2e8c4f5 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6851,7 +6851,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		if (btf_type_is_int(t))
 			return WALK_SCALAR;
 
-		if (!btf_type_is_struct(t))
+		if (!btf_type_is_struct(t) || !t->size)
 			goto error;
 
 		off = (off - moff) % t->size;
-- 
2.53.0



