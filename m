Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1009BA45
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:09:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30909C4339B;
	Tue,  7 Mar 2023 18:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678212583;
	bh=bx9XhhKqyzdiwr9XXPNYrdSdntVa0Em8LmD5fI6h4B8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDrsUM5kONr0LdGT14hL8Sxnk81QOUO8JIZvdqnmDfng9yWBCl4bOQ+ACphGmcaS4
	 vshlerYRh+d/xe8kjni0ebI9v81XZtdMfpUxqY1cEmmwVlLDsvMq+NRP0Ui+3cOwtt
	 rnrvtt1U7yhpHV8EYitwZEJvIoA9C7sZw3wCs2ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 230/885] selftests/bpf: Fix out-of-srctree build
Date: Tue,  7 Mar 2023 17:52:44 +0100
Message-Id: <20230307170012.015218264@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Leoshkevich <iii@linux.ibm.com>

[ Upstream commit 0b0757244754ea1d0721195c824770f5576e119e ]

Building BPF selftests out of srctree fails with:

  make: *** No rule to make target '/linux-build//ima_setup.sh', needed by 'ima_setup.sh'.  Stop.

The culprit is the rule that defines convenient shorthands like
"make test_progs", which builds $(OUTPUT)/test_progs. These shorthands
make sense only for binaries that are built though; scripts that live
in the source tree do not end up in $(OUTPUT).

Therefore drop $(TEST_PROGS) and $(TEST_PROGS_EXTENDED) from the rule.

The issue exists for a while, but it became a problem only after commit
d68ae4982cb7 ("selftests/bpf: Install all required files to run selftests"),
which added dependencies on these scripts.

Fixes: 03dcb78460c2 ("selftests/bpf: Add simple per-test targets to Makefile")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230208231211.283606-1-iii@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/Makefile | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index 1fda7448f4a2f..687249d99b5f1 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -149,8 +149,6 @@ endif
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
 # rule for binaries.
 $(notdir $(TEST_GEN_PROGS)						\
-	 $(TEST_PROGS)							\
-	 $(TEST_PROGS_EXTENDED)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
-- 
2.39.2



