Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B1513A25F;
	Tue,  9 Jul 2024 11:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523933; cv=none; b=K2Se5iIPnZZTCKzIFwGrTkrrtL17wH0IOyRAhIfuF/DcM7eA0sdWw5TPZEM/kOKZoox+Pmp3et+kc36eSSurQp2RFCnlmvS4MMeOVMxrGlzmuQEp7JuzEUqZmHdBp6mCqF92KR8GtJL/QctLVLMvnqAvmYOdcauHmeRgfGMvY/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523933; c=relaxed/simple;
	bh=YWWowoIoG7XoujikJMrxgiM9lpcIK6bVr6ucyelKBIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UafzooqcQ71t1Mtu6llCeotywwPQwAlx2VMj3i5PGazWxzk4d22YxJNwxm8j9JiUiY/IRaqxGcKY92K873TJnbxNHLs8nfv9aYS51xLjzpin2Mvw6yQJiLWAFIn+DNBlkqa0bWlQ+PhSChETTDRtkld8XxVWBZsh4CbD9sIuQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oz4b24Nu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oz4b24Nu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE6C3277B;
	Tue,  9 Jul 2024 11:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523932;
	bh=YWWowoIoG7XoujikJMrxgiM9lpcIK6bVr6ucyelKBIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oz4b24Nud7Kjsxvd0Lz+yhVHN/SLC6atZ1fVpjpHGGb8nT1k22ECMpNH8jGCRGW2o
	 v6XGIywBon4Xnz25irTV8I+trf+4gVeAk7EmhX9y7L3AHJnlH9OyAa+gujkwigtJzk
	 5zZPPYeH7rQB4L3zq2bOe2C9PYBBB8hbwxAm1W8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jemarch@gnu.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 017/197] selftests/bpf: adjust dummy_st_ops_success to detect additional error
Date: Tue,  9 Jul 2024 13:07:51 +0200
Message-ID: <20240709110709.581256549@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 3b3b84aacb4420226576c9732e7b539ca7b79633 ]

As reported by Jose E. Marchesi in off-list discussion, GCC and LLVM
generate slightly different code for dummy_st_ops_success/test_1():

  SEC("struct_ops/test_1")
  int BPF_PROG(test_1, struct bpf_dummy_ops_state *state)
  {
  	int ret;

  	if (!state)
  		return 0xf2f3f4f5;

  	ret = state->val;
  	state->val = 0x5a;
  	return ret;
  }

  GCC-generated                  LLVM-generated
  ----------------------------   ---------------------------
  0: r1 = *(u64 *)(r1 + 0x0)     0: w0 = -0xd0c0b0b
  1: if r1 == 0x0 goto 5f        1: r1 = *(u64 *)(r1 + 0x0)
  2: r0 = *(s32 *)(r1 + 0x0)     2: if r1 == 0x0 goto 6f
  3: *(u32 *)(r1 + 0x0) = 0x5a   3: r0 = *(u32 *)(r1 + 0x0)
  4: exit                        4: w2 = 0x5a
  5: r0 = -0xd0c0b0b             5: *(u32 *)(r1 + 0x0) = r2
  6: exit                        6: exit

If the 'state' argument is not marked as nullable in
net/bpf/bpf_dummy_struct_ops.c, the verifier would assume that
'r1 == 0x0' is never true:
- for the GCC version, this means that instructions #5-6 would be
  marked as dead and removed;
- for the LLVM version, all instructions would be marked as live.

The test dummy_st_ops/dummy_init_ret_value actually sets the 'state'
parameter to NULL.

Therefore, when the 'state' argument is not marked as nullable,
the GCC-generated version of the code would trigger a NULL pointer
dereference at instruction #3.

This patch updates the test_1() test case to always follow a shape
similar to the GCC-generated version above, in order to verify whether
the 'state' nullability is marked correctly.

Reported-by: Jose E. Marchesi <jemarch@gnu.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240424012821.595216-3-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/dummy_st_ops_success.c      | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c b/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
index 1efa746c25dc7..cc7b69b001aae 100644
--- a/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
+++ b/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
@@ -11,8 +11,17 @@ int BPF_PROG(test_1, struct bpf_dummy_ops_state *state)
 {
 	int ret;
 
-	if (!state)
-		return 0xf2f3f4f5;
+	/* Check that 'state' nullable status is detected correctly.
+	 * If 'state' argument would be assumed non-null by verifier
+	 * the code below would be deleted as dead (which it shouldn't).
+	 * Hide it from the compiler behind 'asm' block to avoid
+	 * unnecessary optimizations.
+	 */
+	asm volatile (
+		"if %[state] != 0 goto +2;"
+		"r0 = 0xf2f3f4f5;"
+		"exit;"
+	::[state]"p"(state));
 
 	ret = state->val;
 	state->val = 0x5a;
-- 
2.43.0



