Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4712331EAE;
	Sat, 12 Sep 2026 16:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230088; cv=none; b=uXnjIsm9hagOuSsKAQtLP7msTL8rR8rmyPCqxHW7JqX5t1OMn16dFnRYED8nicTQljCXqWpAuhxJW0nKz4Dv7Ln5nUb8tZ+ToN0Gq9QEo/8a2k+mg/lgA8C5kydzEdTaoNi2kjc6pz6+ENWu7f10bQSY91hTjvoKaimYEb3F4ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230088; c=relaxed/simple;
	bh=tDms4/hcilLdtDk6ZfGsJMXss6jwIOvYmrTj8fppqBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rCuksguHumobSUnouar5NU/x7jyibm2B37EtKrJdFU5eFUJLAkUn4iFzfF+FaxdPBXAY6qgXj744DlR21BoQ5MtP+5aO6oo8CJi5VJQcRQW40XXjKLU3vNZK9qnF4FtIVrjwA6P2gAqhiIy/KVczXM787W73CvhXacZgqEA4hrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv9L8F2C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv9L8F2C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 118A61F000FF;
	Sat, 12 Sep 2026 16:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230086;
	bh=k6WeDHymRuoF4VckHMo39lLBWXuwa4sJnjVtiTCYaqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dv9L8F2CLXI7dti0cX6q2Lavh36ENyVIQwphe+MHatnr4qplUn9XTlzVVYFclMJiK
	 Kzm0N7l4dBAyQCR6hm+pC1QHW95HT6d0vl8nPffQV38pR8GXKBAYVgvKIfzHN7rD3B
	 IBUY0nq9WAjZmPwmjJ8CnmoQfF893DkAcweWa+iM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Ian Rogers <irogers@google.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0721/1191] tools/build: Allow versioning of all LLVM tools defined in Makefile.include
Date: Sat, 12 Sep 2026 08:57:29 +0200
Message-ID: <20260912065604.474675119@linuxfoundation.org>
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

From: James Clark <james.clark@linaro.org>

[ Upstream commit d5a1d1270c898057afc5b51fb6d0f2defa89d56d ]

The version of LLVM tools can be given on the build command with
LLVM=-15, but this isn't applied to all tools. For example $(CC) gets
versioned, but $(CLANG) doesn't. This causes a Perf build with LTO=1 to
fail with an error about mixed clang versions:

 ld.lld: error: libperf/core.o: Unknown attribute kind (86)
   (Producer: 'LLVM18.1.8' Reader: 'LLVM 15.0.7')

This file has two "ifneq ($(LLVM),)" blocks adjacent to each other, so
merge these blocks making it obvious that all tools should be versioned
consistently and there is nothing special about each block.

This also reveals that ?= and "allow-override" are used inconsistently
between the blocks. "allow-override" is technically only required for
builtin variables, but isn't only used on them, and doesn't do any harm
if used on a non-builtin. Make them all "allow-override" for
consistency. The only functional difference this will cause is if there
is a file level definition of one of the variables followed by an
"#include of Makefile.include" which will now overwrite. But this isn't
done and in a later commit some of the duplicate definitions will be
removed for good measure.

There are also some other LLVM tools that are not defined here and will
be moved in a later commit.

Signed-off-by: James Clark <james.clark@linaro.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Fixes: e9c281928c24 ("kbuild: Make $(LLVM) more flexible")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/scripts/Makefile.include | 37 ++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 17 deletions(-)

diff --git a/tools/scripts/Makefile.include b/tools/scripts/Makefile.include
index 0a1b11e51fd69..aae5465d23d9b 100644
--- a/tools/scripts/Makefile.include
+++ b/tools/scripts/Makefile.include
@@ -59,10 +59,18 @@ LLVM_SUFFIX := $(LLVM)
 endif
 
 $(call allow-override,CC,$(LLVM_PREFIX)clang$(LLVM_SUFFIX))
+$(call allow-override,CLANG,$(LLVM_PREFIX)clang$(LLVM_SUFFIX))
+$(call allow-override,HOSTCC,$(LLVM_PREFIX)clang$(LLVM_SUFFIX))
 $(call allow-override,AR,$(LLVM_PREFIX)llvm-ar$(LLVM_SUFFIX))
+$(call allow-override,HOSTAR,$(LLVM_PREFIX)llvm-ar$(LLVM_SUFFIX))
 $(call allow-override,LD,$(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX))
+$(call allow-override,HOSTLD,$(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX))
 $(call allow-override,CXX,$(LLVM_PREFIX)clang++$(LLVM_SUFFIX))
 $(call allow-override,STRIP,$(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX))
+$(call allow-override,LLVM_STRIP,$(LLVM_PREFIX)llvm-strip$(LLVM_SUFFIX))
+$(call allow-override,LLC,$(LLVM_PREFIX)llc$(LLVM_SUFFIX))
+$(call allow-override,LLVM_CONFIG,$(LLVM_PREFIX)llvm-config$(LLVM_SUFFIX))
+$(call allow-override,LLVM_OBJCOPY,$(LLVM_PREFIX)llvm-objcopy$(LLVM_SUFFIX))
 else
 # Allow setting various cross-compile vars or setting CROSS_COMPILE as a prefix.
 $(call allow-override,CC,$(CROSS_COMPILE)gcc)
@@ -70,26 +78,21 @@ $(call allow-override,AR,$(CROSS_COMPILE)ar)
 $(call allow-override,LD,$(CROSS_COMPILE)ld)
 $(call allow-override,CXX,$(CROSS_COMPILE)g++)
 $(call allow-override,STRIP,$(CROSS_COMPILE)strip)
-endif
-
-CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
-ifneq ($(LLVM),)
-HOSTAR  ?= $(LLVM_PREFIX)llvm-ar$(LLVM_SUFFIX)
-HOSTCC  ?= $(LLVM_PREFIX)clang$(LLVM_SUFFIX)
-HOSTLD  ?= $(LLVM_PREFIX)ld.lld$(LLVM_SUFFIX)
-else
-HOSTAR  ?= ar
-HOSTCC  ?= gcc
-HOSTLD  ?= ld
+# Host versions aren't prefixed
+$(call allow-override,HOSTAR,ar)
+$(call allow-override,HOSTCC,gcc)
+$(call allow-override,HOSTLD,ld)
+
+# Some tools still require Clang, LLC and/or LLVM utils
+$(call allow-override,CLANG,clang)
+$(call allow-override,LLC,llc)
+$(call allow-override,LLVM_CONFIG,llvm-config)
+$(call allow-override,LLVM_OBJCOPY,llvm-objcopy)
+$(call allow-override,LLVM_STRIP,llvm-strip)
 endif
 
-# Some tools require Clang, LLC and/or LLVM utils
-CLANG		?= clang
-LLC		?= llc
-LLVM_CONFIG	?= llvm-config
-LLVM_OBJCOPY	?= llvm-objcopy
-LLVM_STRIP	?= llvm-strip
+CC_NO_CLANG := $(shell $(CC) -dM -E -x c /dev/null | grep -Fq "__clang__"; echo $$?)
 
 # Some tools require bpftool
 BPFTOOL		?= bpftool
-- 
2.53.0



