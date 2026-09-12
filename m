Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A314F2DC321;
	Sat, 12 Sep 2026 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226521; cv=none; b=oSvOKxlEfPU6SgMnz/CfjbsSui7macKRzJEmQQjKVUe7jw2oIZvbYVTOd7fTUfFRVy9qJDNeS40WQ2QWBvicKWW3426xRKosXxzJsiKieB6WqrAqGDmt75NyEbsv1k2HJv1gZgQ6NgZU1DpK8EYPkdiNbeA7hAYJxdVKnr4PjdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226521; c=relaxed/simple;
	bh=qTyQVGsp1aXJldqbUyI384CZVNumRaGzeAlZhPIJA50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK/akeD1kGq5JQMRvmfMn8Ky3swH3Dn55NSaUviT6kCdA1rrUNOyw7CKIP/v3SkT3F6URDVcXOGfn9flyYrknrWuySugBJlNh3u8barLe0neFUSSagu4sQ8OVdyVr4ovRtZbvxtCsxbbZCOBzuVDCYauZ4y7TsHtBK2uB0CDkAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ew3uqkzh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ew3uqkzh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9B4C1F000FF;
	Sat, 12 Sep 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226520;
	bh=6VztjjzOcB1On+8BIBIn/hmJdA2HE9/wwxWetVNi66A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ew3uqkzhSnNeZtXK6CqpYkirVZNZV19wb8GizOIZUv+3FROf04x7PDl6KGwyXaS/a
	 kcxSs8ar6IsQyEJB40T0gVZ2FI9ONfnrMBfhenfdpBj/qpJK4S5otkmNkVILnnmLst
	 xrV6BVxFp2f8yfy8LUnE61QovWEAyoKMAeB+aO+w=
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
Subject: [PATCH 6.6 1420/1424] tools/build: Use SYSTEM_BPFTOOL for system bpftool
Date: Sat, 12 Sep 2026 09:04:12 +0200
Message-ID: <20260912065639.060068096@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -403,7 +403,7 @@ $(OUTPUT)test-libpfm4.bin:
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


