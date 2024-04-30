Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474481E50A;
	Tue, 30 Apr 2024 11:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475449; cv=none; b=n0k9ssMO64NqjELzq0Hj5UhsS1yKjgPs4ggbT0GiQhNhQ3JfuPYa6R5sEte5zl73NlpG8jrKZePvi00Yic25oai+ltC+kFjnFMKZDqLigS50BQePDWYMxIQmGe7JvwxButXQp7rdlc9n5cgYD1hPRmPNLzYdsoC3w62D+Q29Eq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475449; c=relaxed/simple;
	bh=ZKBntvXSi1pPgzavQVSpJLGRgyy8XPStHkITlX771t4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LhbBajtF3Ply9TLTbV8vTh13zYhkBM8fOKT+X2alfTYfDjtjYcgHGaZxWHwiEUYAoHIu9FuRDtcsSV0v34JKvvJsJvR8Rk9OkesT7qyqHw6kltZg6m0qSH/I6EitkEECjJJnju9YsI0QbrSWxhRKFnjoZIdOif2vBu44QVaBIwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbdAU84I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbdAU84I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49242C2BBFC;
	Tue, 30 Apr 2024 11:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475449;
	bh=ZKBntvXSi1pPgzavQVSpJLGRgyy8XPStHkITlX771t4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbdAU84IAiprAfDDta7MWKEe2F99G9LWZ21K0BZjhizSfyCLdrQ6ax6fz9d8j82gQ
	 83foWdrXE27VXZ9zyEAkIyRe9lWeYcvhGSSJszrxHFVOcpVCPMcoDPoE831YhyBM/h
	 OVY4Nb4G0rGZFm/azZZKe8y+s8b+BMEaBV3Ateqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Hubbard <jhubbard@nvidia.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 098/186] mm/gup: explicitly define and check internal GUP flags, disallow FOLL_TOUCH
Date: Tue, 30 Apr 2024 12:39:10 +0200
Message-ID: <20240430103100.878616217@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 0f20bba1688bdf3b32df0162511a67d4eda15790 ]

Rather than open-coding a list of internal GUP flags in
is_valid_gup_args(), define which ones are internal.

In addition, explicitly check to see if the user passed in FOLL_TOUCH
somehow, as this appears to have been accidentally excluded.

Link: https://lkml.kernel.org/r/971e013dfe20915612ea8b704e801d7aef9a66b6.1696288092.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 631426ba1d45 ("mm/madvise: make MADV_POPULATE_(READ|WRITE) handle VM_FAULT_RETRY properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c      | 5 ++---
 mm/internal.h | 3 +++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 2f8a2d89fde19..b21b33d1787e1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2227,12 +2227,11 @@ static bool is_valid_gup_args(struct page **pages, int *locked,
 	/*
 	 * These flags not allowed to be specified externally to the gup
 	 * interfaces:
-	 * - FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
+	 * - FOLL_TOUCH/FOLL_PIN/FOLL_TRIED/FOLL_FAST_ONLY are internal only
 	 * - FOLL_REMOTE is internal only and used on follow_page()
 	 * - FOLL_UNLOCKABLE is internal only and used if locked is !NULL
 	 */
-	if (WARN_ON_ONCE(gup_flags & (FOLL_PIN | FOLL_TRIED | FOLL_UNLOCKABLE |
-				      FOLL_REMOTE | FOLL_FAST_ONLY)))
+	if (WARN_ON_ONCE(gup_flags & INTERNAL_GUP_FLAGS))
 		return false;
 
 	gup_flags |= to_set;
diff --git a/mm/internal.h b/mm/internal.h
index 30cf724ddbce3..50cf76d30a88f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -964,6 +964,9 @@ enum {
 	FOLL_UNLOCKABLE = 1 << 21,
 };
 
+#define INTERNAL_GUP_FLAGS (FOLL_TOUCH | FOLL_TRIED | FOLL_REMOTE | FOLL_PIN | \
+			    FOLL_FAST_ONLY | FOLL_UNLOCKABLE)
+
 /*
  * Indicates for which pages that are write-protected in the page table,
  * whether GUP has to trigger unsharing via FAULT_FLAG_UNSHARE such that the
-- 
2.43.0



