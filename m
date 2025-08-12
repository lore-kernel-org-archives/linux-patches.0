Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7255260583;
	Tue, 12 Aug 2025 19:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026093; cv=none; b=Pe19KYwcF+o85aaykq+6pBGER5zTLztapaA49aQCOMEhJGWvBMk/Cxbf2srwNb3IjCA74wNM5CT8K28AJXdQx1kGNmyJX2v2nbeN4y2JZlspa6+Ibptfo+Ci1Twn1H6zBOsokbBv8T28VwOawOoXb7qC87YG66gyfEzAeOklkdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026093; c=relaxed/simple;
	bh=bzcWIZl0krGGAHMiteEtJZ1HT/ScKKHgVlQGmKW8cDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dmkGFmjUevIY30i5gH5MxcBmdGjeJAy5PYQSxvZew/4keHt8k9JXTI1zXJBEMBbXd6jqykFiqE9Fgb62bcvxbAv31e+Hu1/HqVHsbMJs71RqTAb0m/pq+fxj9OtRVdCb+3ZEfelZl37t+0dxWDuvEa6I0Ila2Hg4XsVXDKO59Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nccz5IMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nccz5IMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AAEC4CEF0;
	Tue, 12 Aug 2025 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026093;
	bh=bzcWIZl0krGGAHMiteEtJZ1HT/ScKKHgVlQGmKW8cDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nccz5IMN+Pp5t6arJXmmfCCHVUpIk2q9uG+i/5H8Y4mjOcPyN3V+unJaUzaQK8FhA
	 dDTHrCqWj7nzah0zbQ227lTTs5ZSGinTCrBeTOU3opCWTGs01GW4RxJcYS9QlyHKor
	 3Jybg1CqKpdbH/7XCc/GvO5TBTT9gjXkrHAHn5Ro=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 235/480] perf parse-events: Set default GH modifier properly
Date: Tue, 12 Aug 2025 19:47:23 +0200
Message-ID: <20250812174407.141263593@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit dcbe6e51a0bb80a40f9a8c87750c291c2364573d ]

Commit 7b100989b4f6bce7 ("perf evlist: Remove __evlist__add_default")
changed to use "cycles:P" as a default event.  But the problem is it
cannot set other default modifiers correctly.

perf kvm needs to set attr.exclude_host by default but it didn't work
because of the logic in the parse_events__modifier_list().  Also the
exclude_GH_default was applied only if ":u" modifier was specified -
which is strange.  Move it out after handling the ":GH" and check
perf_host and perf_guest properly.

Before:
  $ ./perf kvm record -vv true |& grep exclude
  (nothing)

But specifying an event (without a modifier) works:

  $ ./perf kvm record -vv -e cycles true |& grep exclude
    exclude_host                     1

After:
It now works for the both cases:

  $ ./perf kvm record -vv true |& grep exclude
    exclude_host                     1

  $ ./perf kvm record -vv -e cycles true |& grep exclude
    exclude_host                     1

Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250606225431.2109754-1-namhyung@kernel.org
Fixes: 35c8d21371e9b342 ("perf tools: Don't set attr.exclude_guest by default")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/parse-events.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 5152fd5a6ead..7ed3c3cadd6a 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -1733,13 +1733,11 @@ static int parse_events__modifier_list(struct parse_events_state *parse_state,
 		int eH = group ? evsel->core.attr.exclude_host : 0;
 		int eG = group ? evsel->core.attr.exclude_guest : 0;
 		int exclude = eu | ek | eh;
-		int exclude_GH = group ? evsel->exclude_GH : 0;
+		int exclude_GH = eG | eH;
 
 		if (mod.user) {
 			if (!exclude)
 				exclude = eu = ek = eh = 1;
-			if (!exclude_GH && !perf_guest && exclude_GH_default)
-				eG = 1;
 			eu = 0;
 		}
 		if (mod.kernel) {
@@ -1762,6 +1760,13 @@ static int parse_events__modifier_list(struct parse_events_state *parse_state,
 				exclude_GH = eG = eH = 1;
 			eH = 0;
 		}
+		if (!exclude_GH && exclude_GH_default) {
+			if (perf_host)
+				eG = 1;
+			else if (perf_guest)
+				eH = 1;
+		}
+
 		evsel->core.attr.exclude_user   = eu;
 		evsel->core.attr.exclude_kernel = ek;
 		evsel->core.attr.exclude_hv     = eh;
-- 
2.39.5



