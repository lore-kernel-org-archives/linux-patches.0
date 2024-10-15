Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C271CFEA9;
	Tue, 15 Oct 2024 12:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993909; cv=none; b=U4EQWRojyYoNAyxAfOiqNFLJkG2PLOMdT1NJBGJNWfynQ3Nten+kpP4uMFh/kBHd9OT81YdN/gHAjGtIhaDJTzmWTKyZ8AOrf+3O68hfGNH7XunEs1Fy2C/lXE5vF0EC7n6KMNJTKMU7thBh2tCcTP0KOZ74zMuWqKkmbK++JOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993909; c=relaxed/simple;
	bh=3nhHmLfHAHINzo+OCbFdqhF5zZkuuxKh+WReQcdczNs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ku88ZrT0Gy5lS0gr60pFahxYS2O2GF3hf/lphLla58eEcz2mhUX3rG+R3xiL1ImLvFC+wowQ/pYVr0xteyWz9m3rGayD6zTX0y1dT2e760io8mjTKAjIlcVgnj97oCNmovnXeSa3E6WSCvUwHNZuGjZHCjawZVzMlcGWTQZIdig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A9wUB9Bw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A9wUB9Bw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61736C4CEC6;
	Tue, 15 Oct 2024 12:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993908;
	bh=3nhHmLfHAHINzo+OCbFdqhF5zZkuuxKh+WReQcdczNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A9wUB9BwdmcYmSRSyZ0EEkXcmA4MOcakmPYHgSjax9X+ipXO0erwzRn8/GmCo/spe
	 /Ro6AMZ4ufVC9A/mzBLbNk0KJjCNpEP35STzoLx7kXR2kRVdVnjSwOAJjwYzt24bb0
	 zYDInp6gXi7S5WiiPeX3Dh89QfXWLBisrr4VxMNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunzhao Li <yunzhao@cloudflare.com>,
	"Matt Fleming (Cloudflare)" <matt@readmodwrite.com>,
	Ian Rogers <irogers@google.com>,
	kernel-team@cloudflare.com,
	Namhyung Kim <namhyung@kernel.org>,
	Riccardo Mancini <rickyman7@gmail.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.15 519/691] perf hist: Update hist symbol when updating maps
Date: Tue, 15 Oct 2024 13:27:47 +0200
Message-ID: <20241015112500.942860246@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <matt@readmodwrite.com>

commit ac01c8c4246546fd8340a232f3ada1921dc0ee48 upstream.

AddressSanitizer found a use-after-free bug in the symbol code which
manifested as 'perf top' segfaulting.

  ==1238389==ERROR: AddressSanitizer: heap-use-after-free on address 0x60b00c48844b at pc 0x5650d8035961 bp 0x7f751aaecc90 sp 0x7f751aaecc80
  READ of size 1 at 0x60b00c48844b thread T193
      #0 0x5650d8035960 in _sort__sym_cmp util/sort.c:310
      #1 0x5650d8043744 in hist_entry__cmp util/hist.c:1286
      #2 0x5650d8043951 in hists__findnew_entry util/hist.c:614
      #3 0x5650d804568f in __hists__add_entry util/hist.c:754
      #4 0x5650d8045bf9 in hists__add_entry util/hist.c:772
      #5 0x5650d8045df1 in iter_add_single_normal_entry util/hist.c:997
      #6 0x5650d8043326 in hist_entry_iter__add util/hist.c:1242
      #7 0x5650d7ceeefe in perf_event__process_sample /home/matt/src/linux/tools/perf/builtin-top.c:845
      #8 0x5650d7ceeefe in deliver_event /home/matt/src/linux/tools/perf/builtin-top.c:1208
      #9 0x5650d7fdb51b in do_flush util/ordered-events.c:245
      #10 0x5650d7fdb51b in __ordered_events__flush util/ordered-events.c:324
      #11 0x5650d7ced743 in process_thread /home/matt/src/linux/tools/perf/builtin-top.c:1120
      #12 0x7f757ef1f133 in start_thread nptl/pthread_create.c:442
      #13 0x7f757ef9f7db in clone3 ../sysdeps/unix/sysv/linux/x86_64/clone3.S:81

When updating hist maps it's also necessary to update the hist symbol
reference because the old one gets freed in map__put().

While this bug was probably introduced with 5c24b67aae72f54c ("perf
tools: Replace map->referenced & maps->removed_maps with map->refcnt"),
the symbol objects were leaked until c087e9480cf33672 ("perf machine:
Fix refcount usage when processing PERF_RECORD_KSYMBOL") was merged so
the bug was masked.

Fixes: c087e9480cf33672 ("perf machine: Fix refcount usage when processing PERF_RECORD_KSYMBOL")
Reported-by: Yunzhao Li <yunzhao@cloudflare.com>
Signed-off-by: Matt Fleming (Cloudflare) <matt@readmodwrite.com>
Cc: Ian Rogers <irogers@google.com>
Cc: kernel-team@cloudflare.com
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Riccardo Mancini <rickyman7@gmail.com>
Cc: stable@vger.kernel.org # v5.13+
Link: https://lore.kernel.org/r/20240815142212.3834625-1-matt@readmodwrite.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/util/hist.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -629,6 +629,11 @@ static struct hist_entry *hists__findnew
 			 * the history counter to increment.
 			 */
 			if (he->ms.map != entry->ms.map) {
+				if (he->ms.sym) {
+					u64 addr = he->ms.sym->start;
+					he->ms.sym = map__find_symbol(entry->ms.map, addr);
+				}
+
 				map__put(he->ms.map);
 				he->ms.map = map__get(entry->ms.map);
 			}


