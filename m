Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7881734DB46;
	Wed, 20 May 2026 18:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300976; cv=none; b=VQD2kBgSyLNDt2j1ODKuw985whNRZI9OYCtimCTcFFr36yRjznjlsi7CbAescNAhHZ+Ym4JMXHdZyZPL/jmFGYJ3cE9UwX5gCqi/77dr5zxM/lmunDq2jgqFlCrKlXqoMFDq9n8YcjjLLx37yS9FCL3evUYEGORtBOrhUTOPLUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300976; c=relaxed/simple;
	bh=az1a5O8Ryf7lGDzAk1wzh+E249jm8nBN/4hAaTyAkSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=npyMcun345qf0sFazyVAXWLaP6vGIaCX9MVfnhta6prMtdZ6oA27i8txWr7g3ZizT59MBlF/8iXjyx/r2wDD2ntLd8V5omOEEiXvMQSATagGjilbJ6N8kpJpZrXjAAy2bZsv2Q+fNz/30uqMTlWUWH92bZD1v+xqsy0ifcVjxOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzeIUw+P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzeIUw+P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F4D21F000E9;
	Wed, 20 May 2026 18:16:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300975;
	bh=ZqlTYexCcirVvt9LB518PCp+W74Tx1TlrV8sZCNpGtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WzeIUw+PLMEConjUrInF9eqPT2p8LTN8H+89N+XZ3y9mgzGfR6n+Gfq+5YKxSu/04
	 jjHFe7qikPtzix0uIyvdZizBmUzjEI2wrbxEd7xI5yJ0DL6sf4NQVw3IyDJH7bhFri
	 qsQE48WF8k67nghf2OYjdE5Fh9T1nB7UOE1UUE/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 378/666] perf maps: Fix copy_from that can break sorted by name order
Date: Wed, 20 May 2026 18:19:49 +0200
Message-ID: <20260520162119.443770238@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f552b132e4d5248715828e7e5c2bf7889bf05b2e ]

When an parent is copied into a child the name array is populated in
address not name order. Make sure the name array isn't flagged as sorted.

Fixes: 659ad3492b91 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 67133b60b03cd..7b8f48677c318 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -989,16 +989,9 @@ int maps__copy_from(struct maps *dest, struct maps *parent)
 				map__put(new);
 		}
 		maps__set_maps_by_address_sorted(dest, maps__maps_by_address_sorted(parent));
-		if (!err) {
-			RC_CHK_ACCESS(dest)->last_search_by_name_idx =
-				RC_CHK_ACCESS(parent)->last_search_by_name_idx;
-			maps__set_maps_by_name_sorted(dest,
-						dest_maps_by_name &&
-						maps__maps_by_name_sorted(parent));
-		} else {
-			RC_CHK_ACCESS(dest)->last_search_by_name_idx = 0;
-			maps__set_maps_by_name_sorted(dest, false);
-		}
+		RC_CHK_ACCESS(dest)->last_search_by_name_idx = 0;
+		/* Values were copied into the name array in address order. */
+		maps__set_maps_by_name_sorted(dest, false);
 	} else {
 		/* Unexpected copying to a maps containing entries. */
 		for (unsigned int i = 0; !err && i < n; i++) {
-- 
2.53.0



