Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5834D1DF271;
	Tue, 17 Jun 2025 16:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178174; cv=none; b=cWWop3mE7C4ALIwzsawOc8LEdq5ZY8r0iP+boTUPkm1RQeLeSQBLmwg/oAqLGagj+w5440f/jf/3v44oXOybXQoIsDc8d9+YJl3eRSeAQxymPofxQHKbYefjDLEke1Rnfq6hKDM2vP679t2fu0tonJs7Wr8z3nCioRHW4dK5RRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178174; c=relaxed/simple;
	bh=l4n9LwSjZGaJt291lJrXaLqnYNZquCZ1uWlrNRKBbqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WnMWSeHceVIL2UMJKuwV8+xf6Vk9teXcRtKQdtfHZDV2ZuhkQcHfMMGLEBE5DX6I568nOUw7zGZaznKxpA8N39CHl0y61AZ2qW6hoYpauIpggtj4BSAHGMjpGHRzx0TqMgBqQV6a62PIfSpLW37VgP5NoYwUQV7flaIR8OYnHSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A4yVex8c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A4yVex8c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99139C4CEE7;
	Tue, 17 Jun 2025 16:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178174;
	bh=l4n9LwSjZGaJt291lJrXaLqnYNZquCZ1uWlrNRKBbqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4yVex8cgEEkRy8iLQx9FLWICPY/WsvVWVoSHyjLIj+LkbdBBB2ZhxET2KsIpkWta
	 Dflo5ECPDc8BG/4uK7J1WYDwnn1ZukZfkmhUEtmYE6SkyG06BKzh/+h+7EJw+/DZwb
	 l7Wb6tc6rFE3ROcr1OFDHrX4GP8CFPTBEz0l/9Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 420/780] tools build: Dont set libunwind as available if test-all.c build succeeds
Date: Tue, 17 Jun 2025 17:22:08 +0200
Message-ID: <20250617152508.576153672@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 6559b83e4e71ba77461c8d6e6af7b89693c8e677 ]

The tools/build/feature/test-all.c file tries to detect the expected,
most common set of libraries/features we expect to have available to
build perf with.

At some point libunwind was deemed not to be part of that set of
libries, but the patches making it to be opt-in ended up forgetting some
details, fix one more.

Testing it:

  $ rm -rf /tmp/build/$(basename $PWD)/ ; mkdir -p /tmp/build/$(basename $PWD)/
  $ rpm -q libunwind-devel
  libunwind-devel-1.8.0-3.fc40.x86_64
  $ make -k LIBUNWIND=1 CORESIGHT=1 O=/tmp/build/$(basename $PWD)/ -C tools/perf install-bin |& grep unwind && ldd ~/bin/perf | grep unwind
  ...                               libunwind: [ on  ]
    CC      /tmp/build/perf-tools-next/arch/x86/tests/dwarf-unwind.o
    CC      /tmp/build/perf-tools-next/arch/x86/util/unwind-libunwind.o
    CC      /tmp/build/perf-tools-next/util/arm64-frame-pointer-unwind-support.o
    CC      /tmp/build/perf-tools-next/tests/dwarf-unwind.o
    CC      /tmp/build/perf-tools-next/util/unwind-libunwind-local.o
    CC      /tmp/build/perf-tools-next/util/unwind-libunwind.o
	  libunwind-x86_64.so.8 => /lib64/libunwind-x86_64.so.8 (0x00007f615a549000)
	  libunwind.so.8 => /lib64/libunwind.so.8 (0x00007f615a52f000)
  $ sudo rpm -e libunwind-devel
  $ rm -rf /tmp/build/$(basename $PWD)/ ; mkdir -p /tmp/build/$(basename $PWD)/
  $ make -k LIBUNWIND=1 CORESIGHT=1 O=/tmp/build/$(basename $PWD)/ -C tools/perf install-bin |& grep unwind && ldd ~/bin/perf | grep unwind
  Makefile.config:653: No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR
  ...                               libunwind: [ OFF ]
    CC      /tmp/build/perf-tools-next/arch/x86/tests/dwarf-unwind.o
    CC      /tmp/build/perf-tools-next/arch/x86/util/unwind-libdw.o
    CC      /tmp/build/perf-tools-next/util/arm64-frame-pointer-unwind-support.o
    CC      /tmp/build/perf-tools-next/tests/dwarf-unwind.o
    CC      /tmp/build/perf-tools-next/util/unwind-libdw.o
  $

Should be in a separate patch, but tired now, so also adding a message
about the need to use LIBUNWIND=1 in the output when its not available,
so done here as well.

So, now when the devel files are not available we get:

  $ make -k LIBUNWIND=1 CORESIGHT=1 O=/tmp/build/$(basename $PWD)/ -C tools/perf install-bin |& grep unwind && ldd ~/bin/perf | grep unwind
  Makefile.config:653: No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR and set LIBUNWIND=1 in the make command line as it is opt-in now
  ...                               libunwind: [ OFF ]
  $

Fixes: 13e17c9ff49119aa ("perf build: Make libunwind opt-in rather than opt-out")
Reported-by: Ingo Molnar <mingo@kernel.org>
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/Z_AnsW9oJzFbhIFC@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/Makefile.feature | 1 -
 tools/perf/Makefile.config   | 4 +++-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/tools/build/Makefile.feature b/tools/build/Makefile.feature
index 1f44ca677ad3d..48e3f124b98ac 100644
--- a/tools/build/Makefile.feature
+++ b/tools/build/Makefile.feature
@@ -87,7 +87,6 @@ FEATURE_TESTS_BASIC :=                  \
         libtracefs                      \
         libcpupower                     \
         libcrypto                       \
-        libunwind                       \
         pthread-attr-setaffinity-np     \
         pthread-barrier     		\
         reallocarray                    \
diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index b7769a22fe1af..e0c20a5c19cfe 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -625,6 +625,8 @@ endif
 ifndef NO_LIBUNWIND
   have_libunwind :=
 
+  $(call feature_check,libunwind)
+
   $(call feature_check,libunwind-x86)
   ifeq ($(feature-libunwind-x86), 1)
     $(call detected,CONFIG_LIBUNWIND_X86)
@@ -649,7 +651,7 @@ ifndef NO_LIBUNWIND
   endif
 
   ifneq ($(feature-libunwind), 1)
-    $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR)
+    $(warning No libunwind found. Please install libunwind-dev[el] >= 1.1 and/or set LIBUNWIND_DIR and set LIBUNWIND=1 in the make command line as it is opt-in now)
     NO_LOCAL_LIBUNWIND := 1
   else
     have_libunwind := 1
-- 
2.39.5



