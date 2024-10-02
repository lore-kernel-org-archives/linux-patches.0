Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573F81D0955;
	Wed,  2 Oct 2024 14:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878094; cv=none; b=O6JLiZP71UeC/fv5j1NZ7XMDZXNH6sxVoM74aY6DAvoLzs7Q5r+7I7Pnn8Ss6BVgq4EpLIJGFhdENm5JIgkTfb538GQf2ZK2hOXBQJQ85zPtI7Zp0aCpyfCrIq1+Qoz8cxo5woTEUFyNfh9HZ9EgwiQy41SNOE229Bo5QyrHUpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878094; c=relaxed/simple;
	bh=FeKdLABkezkwQyp3tg4Swhpl/ni40p5gBtvBU2TYfXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jb1v/1KzEaQC/wpQzsczICO4zTtYjjX7gzY0Lj9PTtJFJZcl0wdhFYgRfGVy3c8YP821iKIz9mOzDNpgc/jjhwv3/rncA74YNdmbF220wInoW5Zp+MtOJbW6/Md7dCKR42uFlqvzcJLhPxOZg9dy6OnB6dTkpeJSMcB+OQuelGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGZKPnW0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGZKPnW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FA3C4CECD;
	Wed,  2 Oct 2024 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878094;
	bh=FeKdLABkezkwQyp3tg4Swhpl/ni40p5gBtvBU2TYfXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGZKPnW0PUCAhGr15a0sXtkLzUuVv1olaKa3MskDpRxNSodkVtZIbrrdwLB2kVVXP
	 vskbeg7V+MV5PJuzSS3Oum5H5E0RUH1Th2zyTg4B5aLEXhTioxm+PbLrUoNJT9GbJM
	 B8WPlc1rkTTYaN9RtT8thKz5Z9RIEsuhSZvHHC5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Andi Kleen <andi@firstfloor.org>,
	Changbin Du <changbin.du@huawei.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 298/634] perf build: Fix up broken capstone feature detection fast path
Date: Wed,  2 Oct 2024 14:56:38 +0200
Message-ID: <20241002125822.873731362@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4c55560f23d19051adc7e76818687a88448bef83 ]

The capstone devel headers define 'struct bpf_insn' in a way that clashes with
what is in the libbpf devel headers, so we so far need to avoid including both.

This is happening on the tools/build/feature/test-all.c file, where we try
building all the expected set of libraries to be normally available on a
system:

  ⬢[acme@toolbox perf-tools-next]$ cat /tmp/build/perf-tools-next/feature/test-all.make.output
  In file included from test-bpf.c:3,
                   from test-all.c:150:
  /home/acme/git/perf-tools-next/tools/include/uapi/linux/bpf.h:77:8: error: ‘bpf_insn’ defined as wrong kind of tag
     77 | struct bpf_insn {
        |        ^~~~~~~~
  ⬢[acme@toolbox perf-tools-next]$ cat /tmp/build/perf-tools-next/feature/test-all.make.output

When doing so there is a trick where we define main to be
main_test_libcapstone, then include the individual
tools/build/feture/test-libcapstone.c capability query test, and then we undef
'main' because we'll do it all over again with the next expected library to
be tested (at this time 'lzma').

To complete this mechanism we need to, in test-all.c 'main' routine, to
call main_test_libcapstone(), which isn't being done, so the effect of
adding references to capstone in test-all.c are not achieved.

The only thing that is happening is that test-all.c is failing to build and thus
all the tests will have to be done individually, which nullifies the test-all.c
single build speedup.

So lets remove references to capstone from test-all.c to see if this makes it
build again so that we get faster builds or go on fixing up whatever is
preventing us to get that benefit.

Nothing: after this fix we get a clean test-all.c build and get the build speedup back:

  ⬢[acme@toolbox perf-tools-next]$ cat /tmp/build/perf-tools-next/feature/test-all.make.output
  ⬢[acme@toolbox perf-tools-next]$ cat /tmp/build/perf-tools-next/feature/test-all.
  test-all.bin          test-all.d            test-all.make.output
  ⬢[acme@toolbox perf-tools-next]$ cat /tmp/build/perf-tools-next/feature/test-all.make.output
  ⬢[acme@toolbox perf-tools-next]$ ldd /tmp/build/perf-tools-next/feature/test-all.bin
  	linux-vdso.so.1 (0x00007f13277a1000)
  	libpython3.12.so.1.0 => /lib64/libpython3.12.so.1.0 (0x00007f1326e00000)
  	libm.so.6 => /lib64/libm.so.6 (0x00007f13274be000)
  	libtraceevent.so.1 => /lib64/libtraceevent.so.1 (0x00007f1327496000)
  	libtracefs.so.1 => /lib64/libtracefs.so.1 (0x00007f132746f000)
  	libcrypto.so.3 => /lib64/libcrypto.so.3 (0x00007f1326800000)
  	libunwind-x86_64.so.8 => /lib64/libunwind-x86_64.so.8 (0x00007f1327452000)
  	libunwind.so.8 => /lib64/libunwind.so.8 (0x00007f1327436000)
  	liblzma.so.5 => /lib64/liblzma.so.5 (0x00007f1327403000)
  	libdw.so.1 => /lib64/libdw.so.1 (0x00007f1326d6f000)
  	libz.so.1 => /lib64/libz.so.1 (0x00007f13273e2000)
  	libelf.so.1 => /lib64/libelf.so.1 (0x00007f1326d53000)
  	libnuma.so.1 => /lib64/libnuma.so.1 (0x00007f13273d4000)
  	libslang.so.2 => /lib64/libslang.so.2 (0x00007f1326400000)
  	libperl.so.5.38 => /lib64/libperl.so.5.38 (0x00007f1326000000)
  	libc.so.6 => /lib64/libc.so.6 (0x00007f1325e0f000)
  	libzstd.so.1 => /lib64/libzstd.so.1 (0x00007f1326741000)
  	/lib64/ld-linux-x86-64.so.2 (0x00007f13277a3000)
  	libbz2.so.1 => /lib64/libbz2.so.1 (0x00007f1326d3f000)
  	libcrypt.so.2 => /lib64/libcrypt.so.2 (0x00007f1326d07000)
  ⬢[acme@toolbox perf-tools-next]$

And when having capstone-devel installed we get it detected and linked with
perf, allowing us to benefit from the features that it enables:

  ⬢[acme@toolbox perf-tools-next]$ rpm -q capstone-devel
  capstone-devel-5.0.1-3.fc40.x86_64
  ⬢[acme@toolbox perf-tools-next]$ ldd /tmp/build/perf-tools-next/perf | grep capstone
  	libcapstone.so.5 => /lib64/libcapstone.so.5 (0x00007fe6a5c00000)
  ⬢[acme@toolbox perf-tools-next]$ /tmp/build/perf-tools-next/perf -vv | grep cap
             libcapstone: [ on  ]  # HAVE_LIBCAPSTONE_SUPPORT
  ⬢[acme@toolbox perf-tools-next]$

Fixes: 8b767db3309595a2 ("perf: build: introduce the libcapstone")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Changbin Du <changbin.du@huawei.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/Zry0sepD5Ppa5YKP@x1
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/build/feature/test-all.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/tools/build/feature/test-all.c b/tools/build/feature/test-all.c
index dd0a18c2ef8fc..6f4bf386a3b5c 100644
--- a/tools/build/feature/test-all.c
+++ b/tools/build/feature/test-all.c
@@ -134,10 +134,6 @@
 #undef main
 #endif
 
-#define main main_test_libcapstone
-# include "test-libcapstone.c"
-#undef main
-
 #define main main_test_lzma
 # include "test-lzma.c"
 #undef main
-- 
2.43.0



