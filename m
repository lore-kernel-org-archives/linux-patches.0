Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3A934D3B8;
	Tue, 16 Dec 2025 11:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885302; cv=none; b=H4JUbyQAsU3QlQv9VX29haYBdneGwxik8ya1EulSdMCToSodDp0+q3K5JDi1ni5MhcMzjhG5FSlTYzQ37DgLd3wfohRDAqPoQhP6vX4M2jDJIoYubUu9fNbcbcl4d+48l+HWJ9+tXrCGmE7HJpWHOM6ocOZb3SLa5WDZ4WgQbn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885302; c=relaxed/simple;
	bh=BdImmlOFTUYUIu+7HaeJzcwZbV/p4QNEs6a32R4jzDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ORGSuuziSr+AzRO61mofe1LLFHpouwPtyZ7TIvMplI5pNr58cQ6t8MmvJMQxa7lwQEzqQUOdpAnze9NXCUBrqfL7KkRFJGrbLkLJ8yAMMjnuxKT8ktqdvCUK+hHOR2t05WAb/ZAUqKXqr959yrB8NpIoNc8G7zZEWbsEL92Qg1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RvWwLDVM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RvWwLDVM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3F0C4CEF1;
	Tue, 16 Dec 2025 11:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885302;
	bh=BdImmlOFTUYUIu+7HaeJzcwZbV/p4QNEs6a32R4jzDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvWwLDVMziMvfJxHFOKLudbVZgKGchFFGk7ab72QwVILLzPnP+ohp+fyddtJoBEM+
	 lFcZk0rNKK4k5VbkZtDXCzVB+YrM+rboMVNqEIQSwouPvYIduEKLhFtkjLgzKUU0A7
	 QS/m6hn/PVETi6KVbyWzebrprGaB2pZGc6H6/QdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Tianyou Li <tianyou.li@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 065/507] perf annotate: Check return value of evsel__get_arch() properly
Date: Tue, 16 Dec 2025 12:08:26 +0100
Message-ID: <20251216111347.898576596@linuxfoundation.org>
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

From: Tianyou Li <tianyou.li@intel.com>

[ Upstream commit f1204e5846d22fb2fffbd1164eeb19535f306797 ]

Check the error code of evsel__get_arch() in the symbol__annotate().
Previously it checked non-zero value but after the refactoring it does
only for negative values.

Fixes: 0669729eb0afb0cf ("perf annotate: Factor out evsel__get_arch()")
Suggested-by: James Clark <james.clark@linaro.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Tianyou Li <tianyou.li@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/annotate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index 0dd475a744b6d..3c3fb8c2a36d8 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -1020,7 +1020,7 @@ int symbol__annotate(struct map_symbol *ms, struct evsel *evsel,
 	int err, nr;
 
 	err = evsel__get_arch(evsel, &arch);
-	if (err < 0)
+	if (err)
 		return err;
 
 	if (parch)
-- 
2.51.0



