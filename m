Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A0532C936;
	Tue, 16 Dec 2025 12:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888539; cv=none; b=uNyjwPGBybvizv+3dScwrWBzoOslLJYA2P4NBQyD+OOV3Nov2bKrXoAIVkNUnxBqUpAnDRkRIAd/WZTeEVMtjoyPC+Q34i2d5W3+IaEkPf/7h5OpptNWltnjTX1LJzjgiplRmUD9Kb9K2oQtoxy3kZxoaREUFrHdFke8E3Thhow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888539; c=relaxed/simple;
	bh=ObKOp+VHz4kCn83+3E73rqlQB0eQgiqE84jGh9ximIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyq9IiY/D0pwVncyaXGT7btbQvwd5CKo6/0xBgaP/qxRTUd8l37cyFKfQLcVyD/SP2x8f64EYmGzPPHk1fS8m3GTfVumAJDal9aDw/Hnc2f8e7eynrnEc8YqZvlGbeXzslmoVUx06uJ1sNrKZ0pQESCoOlyTdUjiF4kxAeSzmto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JKZpF9NU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JKZpF9NU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C0E2C4CEF1;
	Tue, 16 Dec 2025 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888539;
	bh=ObKOp+VHz4kCn83+3E73rqlQB0eQgiqE84jGh9ximIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JKZpF9NURKOaxxQPacceb3clSctNbQLzuVToKn0xJcMkFQghtfalxn5e5+UdYDLvK
	 bpM4lpda6TBiJ3FUPx06R+pl/mrlt21URzGgS8bkIWQFdxySConOVeUhXVQq6QFtRq
	 xgIYxOIS3NtfAl/hKC8YyAtW+9idTCTnmcWvEHfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ingo Molnar <mingo@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 531/614] perf stat: Allow no events to open if this is a "--null" run
Date: Tue, 16 Dec 2025 12:14:58 +0100
Message-ID: <20251216111420.617019945@linuxfoundation.org>
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

[ Upstream commit 6744c0b182c1f371135bc3f4e62b96ad884c9f89 ]

It is intended that a "--null" run doesn't open any events.

Fixes: 2cc7aa995ce9 ("perf stat: Refactor retry/skip/fatal error handling")
Tested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Tested-by: Thomas Richter <tmricht@linux.ibm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f1c9d6c94fc50..b6533dcf5465b 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -856,7 +856,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 			goto err_out;
 		}
 	}
-	if (!has_supported_counters) {
+	if (!has_supported_counters && !stat_config.null_run) {
 		evsel__open_strerror(evlist__first(evsel_list), &target, open_err,
 				     msg, sizeof(msg));
 		ui__error("No supported events found.\n%s\n", msg);
-- 
2.51.0



