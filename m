Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DF1342C8F;
	Tue, 16 Dec 2025 12:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888532; cv=none; b=kOqLvyDmLk+rLa1dFm7u5lA2SxWVZxs5dN7Le8aXuwYJSg9QPf6wlLEOSVxukC1ORZyvOpZSN42KqFU5RCGAFL0mgP++SYWjD0lLtW8GO4SPclzI1TPksBCMmLZ6Lv63dRxmPhNmWHcjNFtGX1prWaKK5LhKk5LZe4kWaTZvOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888532; c=relaxed/simple;
	bh=MVuMmjOWEbMOfNZg5T1CK9NvKaS6ZUCC8wpO5PSw5lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9WycfIEJmrxsfruPQh9ZOn+GL4OV6hfxVZy1evfz8DTWzhqQ2Rpr07ctk46KYWkMQQ3+wFBadKly8iKwkWoH5ECDAqQNDl958NX6BB+Jso49CHX9C9/aejwLA9/PEFh5oLauJM3CjCKghaLp46P4gQwbWvZCQhC4rhMr0wLrio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZJLV0GJL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZJLV0GJL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09180C4CEF1;
	Tue, 16 Dec 2025 12:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888532;
	bh=MVuMmjOWEbMOfNZg5T1CK9NvKaS6ZUCC8wpO5PSw5lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZJLV0GJL9hhJzX26FLNZD89+NLaYxna+5afZGCjSifto/INJxQfJxcIisw2+FOh4q
	 DvMEwpUDy6AG15fqkE4WSCXIg5dH/rgzXY56WBJ0x0IgrBKYoEfeY7mMg4QiwAHH4c
	 1iG4Vu8r9NUh3a998TNCl/YBHAFxfj5Tbf3eJc4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 529/614] perf hist: In init, ensure mem_info is put on error paths
Date: Tue, 16 Dec 2025 12:14:56 +0100
Message-ID: <20251216111420.544605607@linuxfoundation.org>
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



