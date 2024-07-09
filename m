Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8557E157A4F;
	Tue,  9 Jul 2024 11:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523488; cv=none; b=YHPVpZgqlEDU+m7rp5wmrOB4lwdhGSa7Ny3dnz9sMnF9WnNbCTcQ8C9bq+nxFeUg0Ealiim6VwAtUwikJkn+S+XRKndlTSXQwWYVJ+vG67qebDvspqepzbC1DinhnYcAZdCq7OynscE9G+lxRa0qEhUnAysysC7iOHZl2ODvBKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523488; c=relaxed/simple;
	bh=BRBnCOIEA8/tJodoUUwWR6Hq8LLbdXWhPXmuU01zgsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AjIZENAwBBBfVb+NwwRPYSDBTS0YAdZ7YyA2v86/6RyKQrD6c+y5ZMyrBPL3jFP0aR7rpdYLCF44fWYsOoOH/1nHY5WLIVa6LKQ2sACDXJnMC5BK6a0pFawHlhZ7XjUo/ngVq137P7NiSSgvFH+TNfj+LMG3MEECaXI2FJb0HfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iJLnrxb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJLnrxb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3E36C32786;
	Tue,  9 Jul 2024 11:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523488;
	bh=BRBnCOIEA8/tJodoUUwWR6Hq8LLbdXWhPXmuU01zgsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iJLnrxb2RiC5OGdb4aiukj8N/4evrMOAWwHihCjhLrfRoGmZNGmMijheqLndPDPMq
	 ppzdsaSrX/8rdwgqtRAOzvA3hND5gh2bJDmdDuFH2OS42oogv37AvXXnsoVs2tS8TF
	 BiK3aPIONB43R7bePmOYZxzrI+gf/Xuhu+cTeZ3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jose E. Marchesi" <jemarch@gnu.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/139] selftests/bpf: adjust dummy_st_ops_success to detect additional error
Date: Tue,  9 Jul 2024 13:08:31 +0200
Message-ID: <20240709110658.589735293@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



