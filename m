Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30487461
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:47:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7DF8C433C8;
	Sun, 17 Sep 2023 19:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980032;
	bh=4RzKRA7bhnJMf5sP0LLX0+v1qZc9xNw7MlDSr0PT03E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ys4Xp2o+8eypHmKTujBAzNJTSxyIIRZ3kre39SNIRid78i0X65RDvWyr5v8kL9gVJ
	 H9zc0+AVaX4eYm+wnwVfd1WkrjxbJXX1+puimDFDw62iWXlAg5z5SruDwDKjiK/3zN
	 uRPQobsP+BTSuitkshvPytS5c+epPtZoHCTkCjas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mohamed Mahmoud <mmahmoud@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Dave Tucker <datucker@redhat.com>,
	Derek Barbosa <debarbos@redhat.com>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 078/285] perf annotate bpf: Dont enclose non-debug code with an assert()
Date: Sun, 17 Sep 2023 21:11:18 +0200
Message-ID: <20230917191054.415823345@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 979e9c9fc9c2a761303585e07fe2699bdd88182f ]

In 616b14b47a86d880 ("perf build: Conditionally define NDEBUG") we
started using NDEBUG=1 when DEBUG=1 isn't present, so code that is
enclosed with assert() is not called.

In dd317df072071903 ("perf build: Make binutil libraries opt in") we
stopped linking against binutils-devel, for licensing reasons.

Recently people asked me why annotation of BPF programs wasn't working,
i.e. this:

  $ perf annotate bpf_prog_5280546344e3f45c_kfree_skb

was returning:

  case SYMBOL_ANNOTATE_ERRNO__NO_LIBOPCODES_FOR_BPF:
     scnprintf(buf, buflen, "Please link with binutils's libopcode to enable BPF annotation");

This was on a fedora rpm, so its new enough that I had to try to test by
rebuilding using BUILD_NONDISTRO=1, only to get it segfaulting on me.

This combination made this libopcode function not to be called:

        assert(bfd_check_format(bfdf, bfd_object));

Changing it to:

	if (!bfd_check_format(bfdf, bfd_object))
		abort();

Made it work, looking at this "check" function made me realize it
changes the 'bfdf' internal state, i.e. we better call it.

So stop using assert() on it, just call it and abort if it fails.

Probably it is better to propagate the error, etc, but it seems it is
unlikely to fail from the usage done so far and we really need to stop
using libopcodes, so do the quick fix above and move on.

With it we have BPF annotation back working when built with
BUILD_NONDISTRO=1:

  ⬢[acme@toolbox perf-tools-next]$ perf annotate --stdio2 bpf_prog_5280546344e3f45c_kfree_skb   | head
  No kallsyms or vmlinux with build-id 939bc71a1a51cdc434e60af93c7e734f7d5c0e7e was found
  Samples: 12  of event 'cpu-clock:ppp', 4000 Hz, Event count (approx.): 3000000, [percent: local period]
  bpf_prog_5280546344e3f45c_kfree_skb() bpf_prog_5280546344e3f45c_kfree_skb
  Percent      int kfree_skb(struct trace_event_raw_kfree_skb *args) {
                 nop
   33.33         xchg   %ax,%ax
                 push   %rbp
                 mov    %rsp,%rbp
                 sub    $0x180,%rsp
                 push   %rbx
                 push   %r13
  ⬢[acme@toolbox perf-tools-next]$

Fixes: 6987561c9e86eace ("perf annotate: Enable annotation of BPF programs")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mohamed Mahmoud <mmahmoud@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Dave Tucker <datucker@redhat.com>
Cc: Derek Barbosa <debarbos@redhat.com>
Cc: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/lkml/ZMrMzoQBe0yqMek1@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index ba988a13dacb6..82956adf99632 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1846,8 +1846,11 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 	perf_exe(tpath, sizeof(tpath));
 
 	bfdf = bfd_openr(tpath, NULL);
-	assert(bfdf);
-	assert(bfd_check_format(bfdf, bfd_object));
+	if (bfdf == NULL)
+		abort();
+
+	if (!bfd_check_format(bfdf, bfd_object))
+		abort();
 
 	s = open_memstream(&buf, &buf_size);
 	if (!s) {
@@ -1895,7 +1898,8 @@ static int symbol__disassemble_bpf(struct symbol *sym,
 #else
 	disassemble = disassembler(bfdf);
 #endif
-	assert(disassemble);
+	if (disassemble == NULL)
+		abort();
 
 	fflush(s);
 	do {
-- 
2.40.1



