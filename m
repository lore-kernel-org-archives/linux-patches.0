Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0EE46D2DA;
	Tue, 21 Jul 2026 17:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655555; cv=none; b=dQqSMXb+hzdX+44zqe/pF8dmGzUXed7F3bBoR5LODGAF5ZmCODD3ichImVk+Hj70jYJxN4IJzUAv6m7+T3qdDC3GkdI9ebK7lPoK7BVNtVaxW6IDpmq6m0UArAtMAOwYy6j/eZKcrK5MppnQaIfH4zdIYWWL2akPm2cKoo85a+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655555; c=relaxed/simple;
	bh=d+q49HI5Ht1AgHsGz6EsbgK25hr5/P+VT9tLHSlC3+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro+Xx+NKdVxD6Fq/BeYx2MepGMTnztGfmUTmOhg+G0cRMYfmlnFszhwp4RC1Y0XIm7ssrbGozQ49eyNfJen6d3ABSiSbaTW1rbZ6C/7l599dkioHls6JJ5CXQSc72NeYiMbQgm9kAtEhWMY+2le7QzKBFV7qbGhUPiUefM3eSig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0zHwJ5C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0zHwJ5C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2E81F000E9;
	Tue, 21 Jul 2026 17:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655554;
	bh=BQQ86jaKJOFbbpmNYrDxsX06Q1iY9OZAsXWi4AODdt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f0zHwJ5CMLWeKqzhaLk6NQJk/+2jN2ui2lsnq78K7oEyS/YbgL2wyG9X2Fw16GzrY
	 VSB7e4l+72hQjGEx3uEslZAJQpmB+NRGzvpoj+emKABfjlEtS76mvQcGeH1jBOneQ5
	 ijMWBaWa6sTXFyUFAtCtTQHwTAkJkjacFQKU/wRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0011/1611] selftests: bpf: Add test for multiple syncs from linked register
Date: Tue, 21 Jul 2026 17:02:07 +0200
Message-ID: <20260721152515.038407136@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Puranjay Mohan <puranjay@kernel.org>

commit 086c99fbe45070d02851427eab5ae26fe7d0f3c0 upstream.

Before the last commit, sync_linked_regs() corrupted the register whose
bounds are being updated by copying known_reg's id to it. The ids are
the same in value but known_reg has the BPF_ADD_CONST flag which is
wrongly copied to reg.

This later causes issues when creating new links to this reg.
assign_scalar_id_before_mov() sees this BPF_ADD_CONST and gives a new id
to this register and breaks the old links. This is exposed by the added
selftest.

Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260115151143.1344724-3-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/progs/verifier_linked_scalars.c       | 33 +++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
index 8f755d2464cf5e..5f41bbb730a713 100644
--- a/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
+++ b/tools/testing/selftests/bpf/progs/verifier_linked_scalars.c
@@ -31,4 +31,37 @@ l1:						\
 "	::: __clobber_all);
 }
 
+/*
+ * Test that sync_linked_regs() preserves register IDs.
+ *
+ * The sync_linked_regs() function copies bounds from known_reg to linked
+ * registers. When doing so, it must preserve each register's original id
+ * to allow subsequent syncs from the same source to work correctly.
+ *
+ */
+SEC("socket")
+__success
+__naked void sync_linked_regs_preserves_id(void)
+{
+	asm volatile ("						\
+	call %[bpf_get_prandom_u32];				\
+	r0 &= 0xff;	/* r0 in [0, 255] */			\
+	r1 = r0;	/* r0, r1 linked with id 1 */		\
+	r1 += 4;	/* r1 has id=1 and off=4 in [4, 259] */ \
+	if r1 < 10 goto l0_%=;					\
+	/* r1 in [10, 259], r0 synced to [6, 255] */		\
+	r2 = r0;	/* r2 has id=1 and in [6, 255] */	\
+	if r1 < 14 goto l0_%=;					\
+	/* r1 in [14, 259], r0 synced to [10, 255] */		\
+	if r0 >= 10 goto l0_%=;					\
+	/* Never executed */					\
+	r0 /= 0;						\
+l0_%=:								\
+	r0 = 0;							\
+	exit;							\
+"	:
+	: __imm(bpf_get_prandom_u32)
+	: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



