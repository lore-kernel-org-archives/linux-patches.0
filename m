Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2393ABA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:39:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 984B0C433D2;
	Tue,  7 Mar 2023 17:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210772;
	bh=kp+Hf0sogtO9WEZgKLzcFtYwXYP9z6zaDiLxIz/lYEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCbAUnTw4EpmYLnjk1C1Icqkim2NPYm6GIaC6BHuyQCHm5OhYWO/4XAij5wQIO4RO
	 9SAiIKxOUDx5+Ft21rppCIuna4UWpD1g/lZIC+EFhmqt0zXPormRyuXWCDGsA1uRpX
	 LG6tZZL/TRogsGghYhser/NUDg5TfkiqCGOFH2Tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Quentin Monnet <quentin@isovalent.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0648/1001] bpftool: Always disable stack protection for BPF objects
Date: Tue,  7 Mar 2023 17:57:00 +0100
Message-Id: <20230307170049.717583979@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Holger Hoffstätte <holger@applied-asynchrony.com>

[ Upstream commit 878625e1c7a10dfbb1fdaaaae2c4d2a58fbce627 ]

When the clang toolchain has stack protection enabled in order to be
consistent with gcc - which just happens to be the case on Gentoo -
the bpftool build fails:

  [...]
  clang \
	-I. \
	-I/tmp/portage/dev-util/bpftool-6.0.12/work/linux-6.0/tools/include/uapi/ \
	-I/tmp/portage/dev-util/bpftool-6.0.12/work/linux-6.0/tools/bpf/bpftool/bootstrap/libbpf/include \
	-g -O2 -Wall -target bpf -c skeleton/pid_iter.bpf.c -o pid_iter.bpf.o
  clang \
	-I. \
	-I/tmp/portage/dev-util/bpftool-6.0.12/work/linux-6.0/tools/include/uapi/ \
	-I/tmp/portage/dev-util/bpftool-6.0.12/work/linux-6.0/tools/bpf/bpftool/bootstrap/libbpf/include \
	-g -O2 -Wall -target bpf -c skeleton/profiler.bpf.c -o profiler.bpf.o
  skeleton/profiler.bpf.c:40:14: error: A call to built-in function '__stack_chk_fail' is not supported.
  int BPF_PROG(fentry_XXX)
                ^
  skeleton/profiler.bpf.c:94:14: error: A call to built-in function '__stack_chk_fail' is not supported.
  int BPF_PROG(fexit_XXX)
                ^
  2 errors generated.
  [...]

Since stack-protector makes no sense for the BPF bits just unconditionally
disable it.

Bug: https://bugs.gentoo.org/890638
Signed-off-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Quentin Monnet <quentin@isovalent.com>
Link: https://lore.kernel.org/bpf/74cd9d2e-6052-312a-241e-2b514a75c92c@applied-asynchrony.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/Makefile | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/bpf/bpftool/Makefile b/tools/bpf/bpftool/Makefile
index f610e184ce02a..270066aff8bf1 100644
--- a/tools/bpf/bpftool/Makefile
+++ b/tools/bpf/bpftool/Makefile
@@ -215,7 +215,8 @@ $(OUTPUT)%.bpf.o: skeleton/%.bpf.c $(OUTPUT)vmlinux.h $(LIBBPF_BOOTSTRAP)
 		-I$(or $(OUTPUT),.) \
 		-I$(srctree)/tools/include/uapi/ \
 		-I$(LIBBPF_BOOTSTRAP_INCLUDE) \
-		-g -O2 -Wall -target bpf -c $< -o $@
+		-g -O2 -Wall -fno-stack-protector \
+		-target bpf -c $< -o $@
 	$(Q)$(LLVM_STRIP) -g $@
 
 $(OUTPUT)%.skel.h: $(OUTPUT)%.bpf.o $(BPFTOOL_BOOTSTRAP)
-- 
2.39.2



