Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B30D343D9B;
	Tue, 16 Dec 2025 12:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887387; cv=none; b=JHuGhy+bHA1OV55vmxDk0njKGTPi6uvUHYDBbmG3y1KrNdkRGduOqNVtxCMnsNTu8xrrCXgdxC2OQLfOP8J2UBazlykYi+VlireTCAQgdGAtKJOXW1O/W2/IDfI6r6LrNedOjIuQvh5794Vu16mfQ9eYkbbe+Shkh2enKsexuks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887387; c=relaxed/simple;
	bh=pW+b8Mp74PCgbvJvm/3SzhrcpNCKNCRCa0XL7bPbqS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENaBwOfbJ2I6bT38t7Z68FXiFSRJxkv9POtHPJKuogm4W8TIE8Xz99eokkd7bE/tfNXhAVGg3tDIyIXY9/mE5+7dCeWwFAR65yTHa2suDHq45Yk/+DvyYcZyjIm59q2RxZw8VUlcM4CJ+KYqg/KDgK+oY0Vgg4vwA+Wm+rceazA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axw7/jnv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axw7/jnv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE02EC4CEF1;
	Tue, 16 Dec 2025 12:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887387;
	bh=pW+b8Mp74PCgbvJvm/3SzhrcpNCKNCRCa0XL7bPbqS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Axw7/jnvuuDIxIYRXaTjPDquwZ8Pl4Ut1wNaLZX01LJJepWaSj763S1LVuasUywob
	 vC6Z8zIgqEzrVjTLypLWg55wdSc96CUXaOMXvQtze+4MHToybh8B9C4nnYPeIur9TD
	 yX56WWvnmXKUXtwlIfrZHudze5Imgx9W1ItoH4GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianyou Li <tianyou.li@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 215/614] perf annotate: Fix build with NO_SLANG=1
Date: Tue, 16 Dec 2025 12:09:42 +0100
Message-ID: <20251216111409.165603959@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 0e6c07a3c30cdc4509fc5e7dc490d4cc6e5c241a ]

The recent change for perf c2c annotate broke build without slang
support like below.

  builtin-annotate.c: In function 'hists__find_annotations':
  builtin-annotate.c:522:73: error: 'NO_ADDR' undeclared (first use in this function); did you mean 'NR_ADDR'?
    522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
        |                                                                         ^~~~~~~
        |                                                                         NR_ADDR
  builtin-annotate.c:522:73: note: each undeclared identifier is reported only once for each function it appears in

  builtin-annotate.c:522:31: error: too many arguments to function 'hist_entry__tui_annotate'
    522 |                         key = hist_entry__tui_annotate(he, evsel, NULL, NO_ADDR);
        |                               ^~~~~~~~~~~~~~~~~~~~~~~~
  In file included from util/sort.h:6,
                   from builtin-annotate.c:28:
  util/hist.h:756:19: note: declared here
    756 | static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
        |                   ^~~~~~~~~~~~~~~~~~~~~~~~

And I noticed that it missed to update the other side of #ifdef
HAVE_SLANG_SUPPORT.  Let's fix it.

Cc: Tianyou Li <tianyou.li@intel.com>
Fixes: cd3466cd2639783d ("perf c2c: Add annotation support to perf c2c report")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.h | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c64005278687c..a4f244a046866 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -709,6 +709,8 @@ struct block_hist {
 	struct hist_entry	he;
 };
 
+#define NO_ADDR 0
+
 #ifdef HAVE_SLANG_SUPPORT
 #include "../ui/keysyms.h"
 void attr_to_script(char *buf, struct perf_event_attr *attr);
@@ -746,14 +748,16 @@ int evlist__tui_browse_hists(struct evlist *evlist __maybe_unused,
 static inline int __hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
 					     struct map_symbol *ms __maybe_unused,
 					     struct evsel *evsel __maybe_unused,
-					     struct hist_browser_timer *hbt __maybe_unused)
+					     struct hist_browser_timer *hbt __maybe_unused,
+					     u64 al_addr __maybe_unused)
 {
 	return 0;
 }
 
 static inline int hist_entry__tui_annotate(struct hist_entry *he __maybe_unused,
 					   struct evsel *evsel __maybe_unused,
-					   struct hist_browser_timer *hbt __maybe_unused)
+					   struct hist_browser_timer *hbt __maybe_unused,
+					   u64 al_addr __maybe_unused)
 {
 	return 0;
 }
-- 
2.51.0



