Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F332D23A6;
	Sat, 12 Sep 2026 13:25:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219544; cv=none; b=kAUTc8B/UIi3gwz3L2PuCoHpTxmErkyY4ExLDFEGpHlAo36xCUr6snRLGYjl16kwV82PiaZFsA6MHNJ7wWavN+zEMecHR4BmDrPUGLkoY6gMv+W8bqA1wniBXpeBjTNZgl+LS0ak4ZchDfOU1k6Y2TOgIapXqAir4iZiNYd9r2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219544; c=relaxed/simple;
	bh=7PapSkT0EHdZRW2m7HD3sWzW+6pcd9CtN6WWUwHyV/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BdvvpfUbXYDcPwerL4MUCwIYLuoz4KS2B2YbX2hTyfTFA2JVgP2Hi3/5Z3jN6hxDObx6xZGRO7R6QiToQHpmEIhR64pv1BVwequ9dvG2mFkpmYzikURLr27/U4D4tDAZ3lh0gbLTullvg7UW7ZQsRJnELwaQdJGQ/CjsEztVQ4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iTmgOpA4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iTmgOpA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CDF1F00898;
	Sat, 12 Sep 2026 13:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219543;
	bh=XcU9rhXJlQiIZy5zcWKao/P6IwmXlIjfL79rCm25l1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iTmgOpA4VkbaHYA4L1q0jgQRq/sFEu76lcGblK6a890XurEXcZBPGQEJCcBzremqq
	 5f1JHutzb/GItnrV8nCS6MSO32+1tXcuOAtDb/iU+SL0d4ykckdh0Bd3xYo9rEUjTR
	 KkJdaG87x01I1V7nPotfiQddpJwkL3IKh56AWuhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Venkat Rao Bagalkote <venkat88@linux.ibm.com>,
	Quentin Monnet <qmo@kernel.org>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 1371/1376] tools/build: Use SYSTEM_BPFTOOL for system bpftool
Date: Sat, 12 Sep 2026 09:03:17 +0200
Message-ID: <20260912065638.090976541@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Tomas Glozar <tglozar@redhat.com>

commit 814d051ebed40b27285ab3c5e2454bd01a0f9631 upstream.

The feature test for system bpftool uses BPFTOOL as the variable to set
its path, defaulting to just "bpftool" if not set by the user.

This conflicts with selftests and a few other utilities, which expect
BPFTOOL to be set to the in-tree bpftool path by default. For example,
bpftool selftests fail to build:

$ make -C tools/testing/selftests/bpf/
make: Entering directory '/home/tglozar/dev/linux/tools/testing/selftests/bpf'

make: *** No rule to make target 'bpftool', needed by '/home/tglozar/dev/linux/tools/testing/selftests/bpf/tools/include/vmlinux.h'.  Stop.
make: Leaving directory '/home/tglozar/dev/linux/tools/testing/selftests/bpf'

Fix the problem by renaming the variable used for system bpftool from
BPFTOOL to SYSTEM_BPFTOOL, so that the new usage does not conflict with
the existing one of BPFTOOL.

Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Link: https://lore.kernel.org/20250326004018.248357-1-tglozar@redhat.com
Fixes: 8a635c3856dd ("tools/build: Add bpftool-skeletons feature test")
Closes: https://lore.kernel.org/linux-kernel/5df6968a-2e5f-468e-b457-fc201535dd4c@linux.ibm.com/
Reported-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
Suggested-by: Quentin Monnet <qmo@kernel.org>
Acked-by: Quentin Monnet <qmo@kernel.org>
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/build/feature/Makefile   |    2 +-
 tools/scripts/Makefile.include |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/build/feature/Makefile
+++ b/tools/build/feature/Makefile
@@ -427,7 +427,7 @@ $(OUTPUT)test-libpfm4.bin:
 	$(BUILD) -lpfm
 
 $(OUTPUT)test-bpftool-skeletons.bin:
-	$(BPFTOOL) version | grep '^features:.*skeletons' \
+	$(SYSTEM_BPFTOOL) version | grep '^features:.*skeletons' \
 		> $(@:.bin=.make.output) 2>&1
 ###############################
 
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -95,7 +95,7 @@ endif
 CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
 # Some tools require bpftool
-BPFTOOL		?= bpftool
+SYSTEM_BPFTOOL	?= bpftool
 
 ifeq ($(CC_NO_CLANG), 1)
 EXTRA_WARNINGS += -Wstrict-aliasing=3


