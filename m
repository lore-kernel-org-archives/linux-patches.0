Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007E22F234A;
	Tue, 17 Jun 2025 15:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175662; cv=none; b=heQq8DEcVQp8vBmN4TtPuWRIEQhAq1W7ck0AeNZpbFD6eL6ZuG23MSIY70uiJlECpjEY26NjpFdEAOlCEn0xUD2quTTJRSAVFHKRYuqGdn2j/IZceKpzp7bpOiLm0CG6QMhJnGa5BGr8OTvI0FSbVd4hlaoOfwyxvMFlpxL4ses=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175662; c=relaxed/simple;
	bh=Hq6KtSl9l/J3BcgjTil37GGihq86X5C/ajwQceSCe3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tEp8rfUlp/iCzv95h8DDHmDIiVbm6k/EyiuqUakhwhzVLWThluDQWDmrTu6+uNbdPwDlyOYQ9Nlj4ipMMWquZpiaWbTEDuSQlUIEX0GmbyD2alhSAmkljchdo58/ssNc5B3tqgSCMtAw+Hl1LGCauWLecd0YVrwiqFkWfMj3CSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BA3cd/7l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BA3cd/7l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C8CC4CEE3;
	Tue, 17 Jun 2025 15:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175661;
	bh=Hq6KtSl9l/J3BcgjTil37GGihq86X5C/ajwQceSCe3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BA3cd/7lGF0NPFD2yoTgJVcM0bDXSxNPk8w1IKdN9xJTcK2xtjD47M9OdtzYosEne
	 Ni71BcGFhz+D3yvbaF+3B30Lt5a/rW+S1+dfItwkKJRql1F457VXZFB/bpVIyu1QoK
	 5AcyK78C4TXT8KrTXeABKYokiX0aVBHC/JoE9CIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Dmitriy Vyukov <dvyukov@google.com>,
	Howard Chu <howardchu95@gmail.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 198/356] perf build: Warn when libdebuginfod devel files are not available
Date: Tue, 17 Jun 2025 17:25:13 +0200
Message-ID: <20250617152346.186829288@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 4fce4b91fd1aabb326c46e237eb4b19ab72598f8 ]

While working on 'perf version --build-options' I noticed that:

  $ perf version --build-options
  perf version 6.15.rc1.g312a07a00d31
                   aio: [ on  ]  # HAVE_AIO_SUPPORT
                   bpf: [ on  ]  # HAVE_LIBBPF_SUPPORT
         bpf_skeletons: [ on  ]  # HAVE_BPF_SKEL
            debuginfod: [ OFF ]  # HAVE_DEBUGINFOD_SUPPORT
  <SNIP>

And looking at tools/perf/Makefile.config I also noticed that it is not
opt-in, meaning we will attempt to build with it in all normal cases.

So add the usual warning at build time to let the user know that
something recommended is missing, now we see:

  Makefile.config:563: No elfutils/debuginfod.h found, no debuginfo server support, please install elfutils-debuginfod-client-devel or equivalent

And after following the recommendation:

  $ perf check feature debuginfod
            debuginfod: [ on  ]  # HAVE_DEBUGINFOD_SUPPORT
  $ ldd ~/bin/perf | grep debuginfo
	libdebuginfod.so.1 => /lib64/libdebuginfod.so.1 (0x00007fee5cf5f000)
  $

With this feature on several perf tools will fetch what is needed and
not require all the contents of the debuginfo packages, for instance:

  # rpm -qa | grep kernel-debuginfo
  # pahole --running_kernel_vmlinux
  pahole: couldn't find a vmlinux that matches the running kernel
  HINT: Maybe you're inside a container or missing a debuginfo package?
  #
  # perf trace -e open* perf probe --vars icmp_rcv
      0.000 ( 0.005 ms): perf/97391 openat(dfd: CWD, filename: "/etc/ld.so.cache", flags: RDONLY|CLOEXEC) = 3
      0.014 ( 0.004 ms): perf/97391 openat(dfd: CWD, filename: "/lib64/libm.so.6", flags: RDONLY|CLOEXEC) = 3
  <SNIP>
  32130.100 ( 0.008 ms): perf/97391 openat(dfd: CWD, filename: "/root/.cache/debuginfod_client/aa3c82b4a13f9c0e0301bebb20fe958c4db6f362/debuginfo") = 3
  <SNIP>
  Available variables at icmp_rcv
        @<icmp_rcv+0>
                struct sk_buff* skb
  <SNIP>
  #
  # pahole --running_kernel_vmlinux
  /root/.cache/debuginfod_client/aa3c82b4a13f9c0e0301bebb20fe958c4db6f362/debuginfo
  # file /root/.cache/debuginfod_client/aa3c82b4a13f9c0e0301bebb20fe958c4db6f362/debuginfo
  /root/.cache/debuginfod_client/aa3c82b4a13f9c0e0301bebb20fe958c4db6f362/debuginfo: ELF 64-bit LSB executable, x86-64, version 1 (SYSV), statically linked, BuildID[sha1]=aa3c82b4a13f9c0e0301bebb20fe958c4db6f362, with debug_info, not stripped
  # ls -la /root/.cache/debuginfod_client/aa3c82b4a13f9c0e0301bebb20fe958c4db6f362/debuginfo
  -r--------. 1 root root 475401512 Mar 27 21:00 /root/.cache/debuginfod_client/aa3c82b4a13f9c0e0301bebb20fe958c4db6f362/debuginfo
  #

Then, cached:

  # perf stat --null perf probe --vars icmp_rcv
  Available variables at icmp_rcv
        @<icmp_rcv+0>
                struct sk_buff* skb

   Performance counter stats for 'perf probe --vars icmp_rcv':

       0.671389041 seconds time elapsed

       0.519176000 seconds user
       0.150860000 seconds sys

Fixes: c7a14fdcb3fa7736 ("perf build-ids: Fall back to debuginfod query if debuginfo not found")
Tested-by: Ingo Molnar <mingo@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Dmitriy Vyukov <dvyukov@google.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Frank Ch. Eigler <fche@redhat.com>
Link: https://lore.kernel.org/r/Z_dkNDj9EPFwPqq1@gmail.com
[ Folded patch from Ingo to have the debian/ubuntu devel package added build warning message ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.config | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/Makefile.config b/tools/perf/Makefile.config
index d66b52407e19c..9da9f878f50f7 100644
--- a/tools/perf/Makefile.config
+++ b/tools/perf/Makefile.config
@@ -554,6 +554,8 @@ ifndef NO_LIBELF
     ifeq ($(feature-libdebuginfod), 1)
       CFLAGS += -DHAVE_DEBUGINFOD_SUPPORT
       EXTLIBS += -ldebuginfod
+    else
+      $(warning No elfutils/debuginfod.h found, no debuginfo server support, please install libdebuginfod-dev/elfutils-debuginfod-client-devel or equivalent)
     endif
   endif
 
-- 
2.39.5



