Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45EE9446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:40:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3BDC433C7;
	Sun, 13 Aug 2023 21:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962844;
	bh=hjGAXGdxgCqpelzW6v1gH7/+sX4uAgel7hNYy3DSLSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X2eSwitYBoyqZCv2wvhzuTHDUK1p7sMErdo8i55ZED7V21cI6B7zoFa/43YyALbTt
	 7jlD4isN2VV52eWzN9E2W0PKBjEuZhzhV/xvArRJCZus6qX+JiTw/jOXHS6xnnvFSP
	 dPx5xek7zm8PjruWAUrNIsiJ5s7m9X6WoxvhsVI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Yonghong Song <yhs@fb.com>,
	Pu Lehui <pulehui@huawei.com>,
	Luiz Capitulino <luizcap@amazon.com>
Subject: [PATCH 5.10 08/68] selftests/bpf: Workaround verification failure for fexit_bpf2bpf/func_replace_return_code
Date: Sun, 13 Aug 2023 23:19:09 +0200
Message-ID: <20230813211708.410184002@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211708.149630011@linuxfoundation.org>
References: <20230813211708.149630011@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yonghong Song <yhs@fb.com>

[ Upstream commit 63d78b7e8ca2d0eb8c687a355fa19d01b6fcc723 ]

With latest llvm17, selftest fexit_bpf2bpf/func_replace_return_code
has the following verification failure:

  0: R1=ctx(off=0,imm=0) R10=fp0
  ; int connect_v4_prog(struct bpf_sock_addr *ctx)
  0: (bf) r7 = r1                       ; R1=ctx(off=0,imm=0) R7_w=ctx(off=0,imm=0)
  1: (b4) w6 = 0                        ; R6_w=0
  ; memset(&tuple.ipv4.saddr, 0, sizeof(tuple.ipv4.saddr));
  ...
  ; return do_bind(ctx) ? 1 : 0;
  179: (bf) r1 = r7                     ; R1=ctx(off=0,imm=0) R7=ctx(off=0,imm=0)
  180: (85) call pc+147
  Func#3 is global and valid. Skipping.
  181: R0_w=scalar()
  181: (bc) w6 = w0                     ; R0_w=scalar() R6_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
  182: (05) goto pc-129
  ; }
  54: (bc) w0 = w6                      ; R0_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff)) R6_w=scalar(umax=4294967295,var_off=(0x0; 0xffffffff))
  55: (95) exit
  At program exit the register R0 has value (0x0; 0xffffffff) should have been in (0x0; 0x1)
  processed 281 insns (limit 1000000) max_states_per_insn 1 total_states 26 peak_states 26 mark_read 13
  -- END PROG LOAD LOG --
  libbpf: prog 'connect_v4_prog': failed to load: -22

The corresponding source code:

  __attribute__ ((noinline))
  int do_bind(struct bpf_sock_addr *ctx)
  {
        struct sockaddr_in sa = {};

        sa.sin_family = AF_INET;
        sa.sin_port = bpf_htons(0);
        sa.sin_addr.s_addr = bpf_htonl(SRC_REWRITE_IP4);

        if (bpf_bind(ctx, (struct sockaddr *)&sa, sizeof(sa)) != 0)
                return 0;

        return 1;
  }
  ...
  SEC("cgroup/connect4")
  int connect_v4_prog(struct bpf_sock_addr *ctx)
  {
  ...
        return do_bind(ctx) ? 1 : 0;
  }

Insn 180 is a call to 'do_bind'. The call's return value is also the return value
for the program. Since do_bind() returns 0/1, so it is legitimate for compiler to
optimize 'return do_bind(ctx) ? 1 : 0' to 'return do_bind(ctx)'. However, such
optimization breaks verifier as the return value of 'do_bind()' is marked as any
scalar which violates the requirement of prog return value 0/1.

There are two ways to fix this problem, (1) changing 'return 1' in do_bind() to
e.g. 'return 10' so the compiler has to do 'do_bind(ctx) ? 1 :0', or (2)
suggested by Andrii, marking do_bind() with __weak attribute so the compiler
cannot make any assumption on do_bind() return value.

This patch adopted adding __weak approach which is simpler and more resistant
to potential compiler optimizations.

Suggested-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20230310012410.2920570-1-yhs@fb.com
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Tested-by: Luiz Capitulino <luizcap@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/connect4_prog.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/bpf/progs/connect4_prog.c
+++ b/tools/testing/selftests/bpf/progs/connect4_prog.c
@@ -33,7 +33,7 @@
 
 int _version SEC("version") = 1;
 
-__attribute__ ((noinline))
+__attribute__ ((noinline)) __weak
 int do_bind(struct bpf_sock_addr *ctx)
 {
 	struct sockaddr_in sa = {};


