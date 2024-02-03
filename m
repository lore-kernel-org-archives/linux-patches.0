Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 189A113AC6;
	Sat,  3 Feb 2024 04:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933818; cv=none; b=aMNsT29QPb1UYPobAzNeZu8ghcqziQPq3xQGBumBGCvCqa9UDq+4dxXcCJQhQwMAV5huPwoXTYWtknU8HKjrQ36X53HLsSwRzn+hDN3H/xkeTmuCTbBw5ZQvi1I1dsb9uzBeUnmWFv13EO6Gmz/R/318K8oJZWJLdKYwdwLwSBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933818; c=relaxed/simple;
	bh=r/ZdFq0DyknUeo+7EzNMA3Vt8t0y7eVs+ZUSv4+q6ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zljkf7UdQHI2FeVw6ky7WwpkK/mYt4Do9Qlxj9w06SkJ33rF2VPzDgVWiVNs1F4KoIrI/NrO4lad851aX2nymKRnCyWYFRCee91Ce5hu9lq29bMibL9tlkbd+QcH56UHPBF10CjApDwCiM4Jxh+OZDBV/CjZZJSXLjpTpTuDImE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0z9BXXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0z9BXXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D96FDC433C7;
	Sat,  3 Feb 2024 04:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933817;
	bh=r/ZdFq0DyknUeo+7EzNMA3Vt8t0y7eVs+ZUSv4+q6ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0z9BXXTIOO7gyAJv7TOfFeu+qEq6Hy1xFe4tR8ENSwzlr6NPDZJci9tdHrva2qK1
	 TvyhY8hg3JX1w1uOPtiTUSP3PJtSopQCDTdiYzoJ+9ydznbiBjrHfKWsod2uIXRIWN
	 dtOOQaGCTzh/Z154Lix/7qSgZqCAn8acx2UjsmxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Zijlstra <peterz@infradead.org>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 136/353] x86/cfi,bpf: Fix bpf_exception_cb() signature
Date: Fri,  2 Feb 2024 20:04:14 -0800
Message-ID: <20240203035408.016252891@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>

[ Upstream commit 852486b35f344887786d63250946dd921a05d7e8 ]

As per the earlier patches, BPF sub-programs have bpf_callback_t
signature and CFI expects callers to have matching signature. This is
violated by bpf_prog_aux::bpf_exception_cb().

[peterz: Changelog]
Reported-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/CAADnVQ+Z7UcXXBBhMubhcMM=R-dExk-uHtfOLtoLxQ1XxEpqEA@mail.gmail.com
Link: https://lore.kernel.org/r/20231215092707.910319166@infradead.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h  | 2 +-
 kernel/bpf/helpers.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index 7a7859a5cce4..cfc6d2f98058 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1447,7 +1447,7 @@ struct bpf_prog_aux {
 	int cgroup_atype; /* enum cgroup_bpf_attach_type */
 	struct bpf_map *cgroup_storage[MAX_BPF_CGROUP_STORAGE_TYPE];
 	char name[BPF_OBJ_NAME_LEN];
-	unsigned int (*bpf_exception_cb)(u64 cookie, u64 sp, u64 bp);
+	u64 (*bpf_exception_cb)(u64 cookie, u64 sp, u64 bp, u64, u64);
 #ifdef CONFIG_SECURITY
 	void *security;
 #endif
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 991186520af0..b3053af6427d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2509,7 +2509,7 @@ __bpf_kfunc void bpf_throw(u64 cookie)
 	 * which skips compiler generated instrumentation to do the same.
 	 */
 	kasan_unpoison_task_stack_below((void *)(long)ctx.sp);
-	ctx.aux->bpf_exception_cb(cookie, ctx.sp, ctx.bp);
+	ctx.aux->bpf_exception_cb(cookie, ctx.sp, ctx.bp, 0, 0);
 	WARN(1, "A call to BPF exception callback should never return\n");
 }
 
-- 
2.43.0



