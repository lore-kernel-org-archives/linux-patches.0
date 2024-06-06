Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33A2E19644F;
	Thu,  6 Jun 2024 14:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682971; cv=none; b=kz4ha+eE/PSjTj1+y/hFrktHshSTcZs1C0x7VTD2HmD78/Hilhm0o8uYSU2NGWA2ktQFZ/DhI2z2ORU2IQOUqoeckvmaKAXTns2yGT5hFMz0CHLnTPOsnLh5Axvo0Cy+8PEIvSYa9KYj/9ofJVlqyFB+Z1mZ9kE6BVHOQ+PMb2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682971; c=relaxed/simple;
	bh=wYvIbb2BLPGr+h26wN83ld/DtcpE1Tdd9F7DyqC7ELo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezXp56M1+qMf+ITFWWY/wL7SeGTILo4AceOzdBuQkWBeTHIhdJKtE71ldiZKzvRQjl1C9JM6pkJhM6XSufo2GXdQV7C/AD6Bxf9tiR/XwK4+s+eVZCNQBJiFEw59TXeA4Cxc66GhmONGOnd6uV7hEygv8hohADvIDQPLP3lv8+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdHnYG1L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdHnYG1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BB1C2BD10;
	Thu,  6 Jun 2024 14:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682971;
	bh=wYvIbb2BLPGr+h26wN83ld/DtcpE1Tdd9F7DyqC7ELo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdHnYG1LRwGoE02XwI9zCbI+0I+X2AEDOfo1zr5ZLsH5YpGhkbaWWeQ1YwWj6Wbf7
	 3mzgbGLDcqq0iEFP6hn6ADMOxPLC5qtZVXkPX5+GiQ0egBoAc8Ls3eWxzY9UzaDpeb
	 tQavzahn3GT5wMBQ0VMmz0xLlSLmt7U7wHSLqa7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Athira Rajeev <atrajeev@linux.vnet.ibm.com>,
	Ben Gainey <ben.gainey@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kajol Jain <kjain@linux.ibm.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Li Dong <lidong@vivo.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paran Lee <p4ranlee@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sun Haiyong <sunhaiyong@loongson.cn>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Yanteng Si <siyanteng@loongson.cn>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 093/374] perf annotate: Fix memory leak in annotated_source
Date: Thu,  6 Jun 2024 16:01:12 +0200
Message-ID: <20240606131655.008469034@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit a3f7768bcf48281df14d98715f076c5656571527 ]

Freeing hash map doesn't free the entries added to the hashmap, add
the missing free().

Fixes: d3e7cad6f36d9e80 ("perf annotate: Add a hashmap for symbol histogram")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Athira Rajeev <atrajeev@linux.vnet.ibm.com>
Cc: Ben Gainey <ben.gainey@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kajol Jain <kjain@linux.ibm.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Li Dong <lidong@vivo.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Paran Lee <p4ranlee@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Bangoria <ravi.bangoria@amd.com>
Cc: Sun Haiyong <sunhaiyong@loongson.cn>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Yanteng Si <siyanteng@loongson.cn>
Cc: Yicong Yang <yangyicong@hisilicon.com>
Link: https://lore.kernel.org/r/20240507183545.1236093-3-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 2ebe2fe92a10b..617b98da377e5 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -887,9 +887,15 @@ static struct annotated_source *annotated_source__new(void)
 
 static __maybe_unused void annotated_source__delete(struct annotated_source *src)
 {
+	struct hashmap_entry *cur;
+	size_t bkt;
+
 	if (src == NULL)
 		return;
 
+	hashmap__for_each_entry(src->samples, cur, bkt)
+		zfree(&cur->pvalue);
+
 	hashmap__free(src->samples);
 	zfree(&src->histograms);
 	free(src);
-- 
2.43.0



