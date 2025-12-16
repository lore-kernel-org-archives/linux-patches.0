Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F1234D3AD;
	Tue, 16 Dec 2025 12:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886525; cv=none; b=JoezbBPiEPqDGWQQNhoO0GImT5ghoN4B94mVioLnb5ujERdJTEjrPmVlPQe213J4VE90F3rSdOv376XUqjr1wUUfPHnJfCCtU3o8JIDILjVDVtiJes/zahvImdTL4NEACkBNHhGpGjpoe2WMHkuZmUq730+5yFYlml+XRO6pmyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886525; c=relaxed/simple;
	bh=qdfR87J9NIdRTfaGoL+RYr0Q830FXBxc5th4BX4ceKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLQF3lTuLOS3lzg9DZFUBvEaLUobjc99JlPC2xXrrQPDdfylDYSYliVgySlemzqAKEgv7Ep8/ySxLICpV6m7vM324EHsJtcNQxP8H1LZD8h5KufHMiMv2jo4seoTnw4Piux9AWkJNkwn5HQLj87erToJjYU3F9pLghXxl3XbuUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=duH0A05l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="duH0A05l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32629C4CEF1;
	Tue, 16 Dec 2025 12:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886525;
	bh=qdfR87J9NIdRTfaGoL+RYr0Q830FXBxc5th4BX4ceKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=duH0A05l2XVg1x6X3U37Qg6OD4wujODFqHeSV9RCvikLwckN2aFg3ih7IwGTrMZ99
	 rQq8GWECn5Oi2gscEYACG2x5/xmSSU1T1ffcqH8VhQjwM9U/8dRyiQLA7j+WMgf5UP
	 GlyMKFmVoA70xj5nULjEMu5pGNEqlKR2JjN/LRvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 429/507] perf hist: In init, ensure mem_info is put on error paths
Date: Tue, 16 Dec 2025 12:14:30 +0100
Message-ID: <20251216111401.002682827@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f60efb4454b24cc944ff3eac164bb9dce9169f71 ]

Rather than exit the internal map_symbols directly, put the mem-info
that does this and also lowers the reference count on the mem-info
itself otherwise the mem-info is being leaked.

Fixes: 56e144fe98260a0f ("perf mem_info: Add and use map_symbol__exit and addr_map_symbol__exit")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hist.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 64ff427040c34..ef4b569f7df46 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -608,10 +608,8 @@ static int hist_entry__init(struct hist_entry *he,
 		map_symbol__exit(&he->branch_info->to.ms);
 		zfree(&he->branch_info);
 	}
-	if (he->mem_info) {
-		map_symbol__exit(&mem_info__iaddr(he->mem_info)->ms);
-		map_symbol__exit(&mem_info__daddr(he->mem_info)->ms);
-	}
+	if (he->mem_info)
+		mem_info__zput(he->mem_info);
 err:
 	map_symbol__exit(&he->ms);
 	zfree(&he->stat_acc);
-- 
2.51.0



