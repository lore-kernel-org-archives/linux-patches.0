Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 784FA23A562;
	Sat, 12 Sep 2026 16:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232369; cv=none; b=H6hDrhvDbP1F8Jn35qLMZZ/WCPk8rbtMbZa3moT0a21YznEPirIB1MDcROOHtxVKAdJ/M6PvdGBRYZI4YmrbbOCHUAZ0iGfFgLgFs/AddbF0ANBXGaM7/0TeDhya3dCWWcTeCzCxn86x4xopCttnjiPI6cgF/AoM+w420lwbNwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232369; c=relaxed/simple;
	bh=Z5nVqP6RKU8hqKwtx51JHToMxT0gGWg/a+G/NyjLFVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W+UqiGygYudZWxHBmIfTiTbRCvdo+b3rA8XSm+DKcW2Sls30hSrAB5BP5mmZB+sUK08Dx5+jEEUojhfaUwiBY3w84fVF54aopymC28g7xYYclgXqPZ5w+t86XOz7V9NPgOvhHNlvNL2+16obR20PU0CXWqV7NA2IFt61Flx5Ub0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pa0dsFUg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pa0dsFUg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746291F000FF;
	Sat, 12 Sep 2026 16:59:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232368;
	bh=chFOKlY2ypuGlaSVV04zdyrt0Ox4UTLS9q7TWxtyRiM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pa0dsFUgSBn9jf3M9JDo5goHNhKpEsy/OjJL2mHqZvaMB5QJi77z6q6aNxEmypRG4
	 HebkDkzrGc/jCzufpy7v3LJJnIpi5CUujvlAR78eY4ijTlE/3se+gohhAYVQH10zS0
	 8iFTaqzdDJtk7ah2ahTM3iyVd0f6JolQre3V92tU=
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
Subject: [PATCH 6.1 1187/1191] tools/build: Use SYSTEM_BPFTOOL for system bpftool
Date: Sat, 12 Sep 2026 09:05:15 +0200
Message-ID: <20260912065614.794558488@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -381,7 +381,7 @@ $(OUTPUT)test-libpfm4.bin:
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


