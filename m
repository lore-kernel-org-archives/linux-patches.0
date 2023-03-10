Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924148820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:50:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D75C4339B;
	Fri, 10 Mar 2023 14:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459835;
	bh=Jqbw3s2CuE8wbRmwz/SEgem1CEglRObBL4yKCUluc64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5GFyrAESh9y2qBy/748WgQQZeErLkDgyXJHXvuz26pBgYU7Ml1VQpYw8JjvZPWO5
	 WIsCV43ZAk+Jbq64lJ9x2mZm4vELzsaSpGL41srFASVV+8NCHDUwYQ8HIOsocaPTCd
	 ZgLmj89AKJyl+PHK+k3y1iHb7Kuk47mvNrdEXoyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 135/529] selftests/bpf: Fix out-of-srctree build
Date: Fri, 10 Mar 2023 14:34:38 +0100
Message-Id: <20230310133811.225901952@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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
index 1d91555333608..a845724e0906a 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -119,8 +119,6 @@ RESOLVE_BTFIDS := $(BUILD_DIR)/resolve_btfids/resolve_btfids
 # NOTE: Semicolon at the end is critical to override lib.mk's default static
 # rule for binaries.
 $(notdir $(TEST_GEN_PROGS)						\
-	 $(TEST_PROGS)							\
-	 $(TEST_PROGS_EXTENDED)						\
 	 $(TEST_GEN_PROGS_EXTENDED)					\
 	 $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
 
-- 
2.39.2



