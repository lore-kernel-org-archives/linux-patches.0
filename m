Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA2161802AB;
	Wed,  5 Feb 2025 14:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766678; cv=none; b=HCDJwpyVJoRZKJg5hPYlGsKum0KpewP00OA5HFrzQyIzY6FzLbrLmrPhw8vuBXPHg6wAPFCXxn/GKZUGjCItjKbzbFSCfSciKOp2x1UEOTuW4JopLAFGGakdHNW43Iz88tnbvT5K0zRHeefuVcFdRRBThIpc13Tbl7FkKKg0JYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766678; c=relaxed/simple;
	bh=ny5PBOklDAjrvF0lVhJyDBsQ49rCv+Oybk/gIuqRBgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvb8yb6xuQjU1+KP3+4daUNzZliMkeAMH5C3iGB0sKuF8htsbMY6f9OKO9kxBLgy7wKY82UmBe9KUF46cKPm09MKtGCzHLkuK7BiN15EI4/g6kLi+mF2f8tx5NOXj8j8lvxpzsB3bALtTsTLNwB8jSicH0xjIBs/v+YF0ruf5pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YDgzLwqo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YDgzLwqo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08981C4CED6;
	Wed,  5 Feb 2025 14:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766678;
	bh=ny5PBOklDAjrvF0lVhJyDBsQ49rCv+Oybk/gIuqRBgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YDgzLwqofqWXZnrLr+KiCcG+ZYa6HkCE81h05QCE8QuKkozUwsJDaUvbMTy78b25d
	 GqBrekIvI7RChHlEimeB23CfCMzx+SSGacA3hY2FRsdHWgtaAvEa9D1eLkWMMD3bPo
	 RnZF3Jt024TBiPk4nQN+PTQ1o9wh87iLWv7uXGPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 297/623] perf symbol: Prefer non-label symbols with same address
Date: Wed,  5 Feb 2025 14:40:39 +0100
Message-ID: <20250205134507.591365762@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 8c2eafbbfd782d6ad270ca2de21b529ac57de0f4 ]

When there are more than one symbols at the same address, it needs to
choose which one is better.  In choose_best_symbol() it didn't check the
type of symbols.  It's possible to have labels in other symbols and in
that case, it would be better to pick the actual symbol over the labels.
To minimize the possible impact on other symbols, I only check NOTYPE
symbols specifically.

  $ readelf -sW vmlinux | grep -e __do_softirq -e __softirqentry_text_start
  105089: ffffffff82000000   814 FUNC    GLOBAL DEFAULT    1 __do_softirq
  111954: ffffffff82000000     0 NOTYPE  GLOBAL DEFAULT    1 __softirqentry_text_start

The commit 77b004f4c5c3c90b tried to do the same by not giving the size
to the label symbols but it seems there's some label-only symbols in asm
code.  Let's restore the original code and choose the right symbol using
type of the symbols.

Fixes: 77b004f4c5c3c90b ("perf symbol: Do not fixup end address of labels")
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>
Cc: Ian Rogers <irogers@google.com>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Link: http://lore.kernel.org/lkml/Z3b-DqBMnNb4ucEm@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 0037f11639195..49b08adc6ee34 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -154,6 +154,13 @@ static int choose_best_symbol(struct symbol *syma, struct symbol *symb)
 	else if ((a == 0) && (b > 0))
 		return SYMBOL_B;
 
+	if (syma->type != symb->type) {
+		if (syma->type == STT_NOTYPE)
+			return SYMBOL_B;
+		if (symb->type == STT_NOTYPE)
+			return SYMBOL_A;
+	}
+
 	/* Prefer a non weak symbol over a weak one */
 	a = syma->binding == STB_WEAK;
 	b = symb->binding == STB_WEAK;
@@ -257,7 +264,7 @@ void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms)
 		 * like in:
 		 *   ffffffffc1937000 T hdmi_driver_init  [snd_hda_codec_hdmi]
 		 */
-		if (prev->end == prev->start && prev->type != STT_NOTYPE) {
+		if (prev->end == prev->start) {
 			const char *prev_mod;
 			const char *curr_mod;
 
-- 
2.39.5



