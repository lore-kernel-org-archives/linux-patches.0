Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3015823392B;
	Sat, 30 May 2026 18:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164305; cv=none; b=sFgF4D5/Gzol0p+RSefXTwnoIq4Ki9SGbELRmxS3TnNjpfR86s1rWwTbQpYicAjlWdcmJtgNnF2Y5+P5QigxEjyUqPqKQ3iuPLcqbPu7ZF6OROQHqdvr8ljRo1lcpxtkZxeMhGZKyE2rUQ1S/9Dem4TY3//ND3f8lHJ3gBVO6r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164305; c=relaxed/simple;
	bh=bBqW3qF2z93zWu9xAjwgJWAgEhHuEXY0F3RpvD2I2gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g1vHO6U4GKb+wWNynpMTrcpgKgI1XUUQ8ACTXKji4DkwIKiHQEj6rtUEoej+ucTjC9gAh7yuW1UK0400xY4egqq1C0DrkcYjM3z+VHqDw3Q6Weasm08SlMVNmridqoSIXwV/KgwFLK5sjyKmACM8C9IIv+Mg2Uj0Z6VkxEDz6C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ieUNJjkO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ieUNJjkO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72DAD1F00898;
	Sat, 30 May 2026 18:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164304;
	bh=4hTXQMGTYhFevgAqm1IXL715zeHNcHuh6jCeoPRCv8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieUNJjkOREDNSN6P94ElzrAsdvFjSaiNYw3x/woG3yYRcHk775jinkmPdssDJXHek
	 4VBeXOmJGaUnD1CWcp7lh2HYLNpCjNPfRPNPOdUY8Mo9zwjCe4kctFLNrClaxkf1XZ
	 f2Ds3bgLFIj4mhgvGdNTmpTOmVSY346Vl8kgMliE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 514/776] perf branch: Avoid incrementing NULL
Date: Sat, 30 May 2026 18:03:48 +0200
Message-ID: <20260530160253.535189922@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit c969a9d7bbf46f983c4a48566b3b2f7340b02296 ]

If the entry is NULL the value is meaningless so early return NULL to
avoid an increment of NULL. This was happening in calls from
has_stitched_lbr when running the "perf record LBR tests". The return
value isn't used in that case, so returning NULL as no effect.

Fixes: 42bbabed09ce ("perf tools: Add hw_idx in struct branch_stack")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/branch.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/branch.h b/tools/perf/util/branch.h
index 17b2ccc61094b..9a20b6fc8dda2 100644
--- a/tools/perf/util/branch.h
+++ b/tools/perf/util/branch.h
@@ -63,6 +63,9 @@ static inline struct branch_entry *perf_sample__branch_entries(struct perf_sampl
 {
 	u64 *entry = (u64 *)sample->branch_stack;
 
+	if (entry == NULL)
+		return NULL;
+
 	entry++;
 	if (sample->no_hw_idx)
 		return (struct branch_entry *)entry;
-- 
2.53.0



