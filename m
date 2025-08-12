Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1722921A43B;
	Tue, 12 Aug 2025 19:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026266; cv=none; b=K9O5NcSk91aEokA8pQoh4dbMrzwmHpoYMFjDgTon4NnCrPSZs3gX+AGByr9NkrO5sXBG9hzWeGM27uDOkBQVMDaQJTNIeS5ve9QCSaNchXruyr9A8GmI5nn8pevumFWcPLDqg4bN3OPpxNA24gURWBqI7q91cxd4bMjIL5OgwIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026266; c=relaxed/simple;
	bh=vPXKHBXb4NVYx+O3Yfn9wh06Wtr2DbZkCHuSwbFiQzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwXS7muv9pLIh7/AW85qJntRHSFSQUn3ezZmk2CpF6R+1KE/JCPjS6N2of0nHK9DwbrdSDZwCxx/S9CLBitVjPA8YqjbpAaMux/pMXeYzzGJosynUKxAI5umBW1huLclhHhFHula+z4wo1imV/1usgSnhLCaUd3oIRDxqAuQ148=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FF066Tz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FF066Tz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E605C4CEF0;
	Tue, 12 Aug 2025 19:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026265;
	bh=vPXKHBXb4NVYx+O3Yfn9wh06Wtr2DbZkCHuSwbFiQzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FF066TzipMKPvVpiIYSGUh0cce7FbbObCLbE4xLVkr/PlcHPSujkudNnxoJ/N0KN
	 V5EBa0MiftsvB1kowYFdClopLnFP88+uPpw614VEfKR9TULFQzmUllyuSVWLG7JuQT
	 bWAl+K4KEDZeUiu9KWwiSkSXkJHKztSQ4WJG0zM0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 259/480] perf sched: Free thread->priv using priv_destructor
Date: Tue, 12 Aug 2025 19:47:47 +0200
Message-ID: <20250812174408.125738072@linuxfoundation.org>
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

[ Upstream commit aa9fdd106bab8c478d37eba5703c0950ad5c0d4f ]

In many perf sched subcommand saves priv data structure in the thread
but it forgot to free them.  As it's an opaque type with 'void *', it
needs to register that knows how to free the data.  In this case, just
regular 'free()' is fine.

Fixes: 04cb4fc4d40a5bf1 ("perf thread: Allow tools to register a thread->priv destructor")
Reviewed-by: Ian Rogers <irogers@google.com>
Tested-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250703014942.1369397-3-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index b7bbfad0ed60..fa4052e04020 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -3898,6 +3898,8 @@ int cmd_sched(int argc, const char **argv)
 	if (!argc)
 		usage_with_options(sched_usage, sched_options);
 
+	thread__set_priv_destructor(free);
+
 	/*
 	 * Aliased to 'perf script' for now:
 	 */
-- 
2.39.5



