Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6F623370FB;
	Fri, 17 Oct 2025 15:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714919; cv=none; b=fTf4gaylL9sbBQH5CDfD9mnIEp1HMdA0mUl9OQgD5C9eJPWhK7tRTVtoxoX57/SwM3Isr2ZDBTCQrtECrX/M4kDG/XIz4pCiHYK0Qj2mFUwHUbZy5nzBzFJuBzbNGiURffjat0Y270jQECUZ0KEED/n15IqGCDE1gWJLNudBnUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714919; c=relaxed/simple;
	bh=cvQYpDCxVtBCCG2Nj3pmOSmVQi37eZ2LJU9YRclrfsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mHcaYGzBS126foHFWjsmf3PRD4U3FZCZLozL/c83B+zDLdKDNyHE5lKLsNuCBOouw5cbOF24bFXPYC/B6pYNJoyDpcel6OFKj+XK9GmDLNuUHJZQJXP5kD7H60AtmwUPWvMsA+uV/j4XgTisVTrrygMgopGYPw5+TdtxkuaIRu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=swhpwiIt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="swhpwiIt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 371A0C113D0;
	Fri, 17 Oct 2025 15:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714919;
	bh=cvQYpDCxVtBCCG2Nj3pmOSmVQi37eZ2LJU9YRclrfsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=swhpwiItW32Zl2UQV7UKpG+vMZkUVRN5MiITgJSqwxP24vs88PrR1XvUhc1y5F1sS
	 I8eHC+yjICpxeBG6GBI7qkbC62yqcFDlgAEod1yd6jqVgAmS0sYHJgmnzyo2YRZOzC
	 Yrnwm/WinQoXtJgbn3ymp1d9ktat9TPbAZ8RpP44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Markus Elfring <Markus.Elfring@web.de>,
	Namhyung Kim <namhyung@kernel.org>,
	GuoHan Zhao <zhaoguohan@kylinos.cn>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 035/371] perf drm_pmu: Fix fd_dir leaks in for_each_drm_fdinfo_in_dir()
Date: Fri, 17 Oct 2025 16:50:10 +0200
Message-ID: <20251017145203.070884701@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

From: GuoHan Zhao <zhaoguohan@kylinos.cn>

[ Upstream commit baa03483fdf3545f2b223a4ca775e1938d956284 ]

Fix file descriptor leak when callback function returns error. The
function was directly returning without closing fdinfo_dir_fd and
fd_dir when cb() returned non-zero value.

Fixes: 28917cb17f9df9c2 ("perf drm_pmu: Add a tool like PMU to expose DRM information")
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Markus Elfring <Markus.Elfring@web.de>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250908065203.22187-1-zhaoguohan@kylinos.cn
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/drm_pmu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/drm_pmu.c b/tools/perf/util/drm_pmu.c
index 988890f37ba7a..98d4d2b556d4e 100644
--- a/tools/perf/util/drm_pmu.c
+++ b/tools/perf/util/drm_pmu.c
@@ -458,8 +458,10 @@ static int for_each_drm_fdinfo_in_dir(int (*cb)(void *args, int fdinfo_dir_fd, c
 		}
 		ret = cb(args, fdinfo_dir_fd, fd_entry->d_name);
 		if (ret)
-			return ret;
+			goto close_fdinfo;
 	}
+
+close_fdinfo:
 	if (fdinfo_dir_fd != -1)
 		close(fdinfo_dir_fd);
 	closedir(fd_dir);
-- 
2.51.0



