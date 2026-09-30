Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 879E75221F4;
	Wed, 30 Sep 2026 18:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792750; cv=none; b=fUstbaHOLnio2SWIMyobxHIFsmAbqk5Bw6afuK6YNiyRhXNWGrGipV6cHzwsK26TelzJsWtr5fKfeLJhG3rrYzvxSCaGUl1PKa7mfpQIYAKBFqHRcNMvDDK/pQxZsNUrk6LdqBTNl+pypF1GLEGG5SyO+UZ6jIeV+qqn5BCDLe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792750; c=relaxed/simple;
	bh=so7pRcfnmG8vFTQtrXnAOTRc43CGCEB8b5kfYDP/VMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOqPfA8nPqmN4kJp2R4eGDNcLCOqW6pJbtLQynLTWqGxlLddzDMLSEjgXYpIduLOkvdzvOc55H6khtrVUeSHpJaRp8vGkioEp577qHXvnVnHo6Wa3UBjCY/UYtUuAxEgX3d4fM0V/cONNBhS/9vMV3ZvjmvD5YQZGBZnlziSP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oEW/HoWA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oEW/HoWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B961F000FF;
	Wed, 30 Sep 2026 18:25:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792749;
	bh=p5ZICDrVah19xtNRDq0drX3yOIwDYQgpii+2tAfBtSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oEW/HoWAcOfXcuqapzMa9dGCaGpZS8tCDXXrHNQFFmaSajEDZfpEAMZ6HZTgiA+mJ
	 JTYranUmJpq+r0ZIyVZIfwJ2Rdqe9WHXQ/IrhYmpPkcUh6TL5iRP1iQjbS3QWcnI5N
	 rzuVxajrad3nRqUo6/Q1dqCmn/8cOiuPkCxI07hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 013/395] bpf: Fix divide-by-zero in btf_struct_walk()
Date: Wed, 30 Sep 2026 17:24:35 +0200
Message-ID: <20260930152340.904238781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index f92e1c16c3569..86a4f76e79403 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -7004,7 +7004,7 @@ static int btf_struct_walk(struct bpf_verifier_log *log, const struct btf *btf,
 		if (btf_type_is_int(t))
 			return WALK_SCALAR;
 
-		if (!btf_type_is_struct(t))
+		if (!btf_type_is_struct(t) || !t->size)
 			goto error;
 
 		off = (off - moff) % t->size;
-- 
2.53.0



