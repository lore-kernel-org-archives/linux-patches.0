Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45AC44E67F;
	Sat, 12 Sep 2026 08:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202783; cv=none; b=XBCA7h1Ef16NKhXQ85QX1vLiOfX2ZDYOxtyBfGAgEe093mIuNBaEWSLtscQXr4vrcyNxrR45+9OtQjmVBIfUp0zYe+ENS4UZnwwsw3YoMMlbvfTK2pW5JYzF8ovtoc8HWVJbs/TXv6T36/E46Kln3G/janhBkQW37VRBFaMZlzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202783; c=relaxed/simple;
	bh=8B9OVyUYeKuJdnQypN18JjIvXes/M+c0eYRst0e8XLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mN0JL1RKIAqTKtR8+PJ2qVsR777fVDBEtN9826CqCsSFMpFc3LelZbi1tbvLvYAlBpl27ndurENQcwL41IEWrdNXRSzlsBvkhyaz/RfiB/ysONE2ulekkHYROVyy/knzL/C3A2Hf0X09avXfsjNC+VzsqedGg3mHjCYUf1p4dp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qoxCLL9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qoxCLL9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50B71F000FF;
	Sat, 12 Sep 2026 08:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202781;
	bh=dtxBB+abEjwP1iZhoz+++3ybx1UA4BHKviuV0ZuHzE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qoxCLL9J1/u8Ns9GmgeZsb2mxqKzEvnnJ1uoSRp6mE9MFaomcXR4SqhKEnLpjlX5p
	 XOcpC5ShwZF7QTM4K8BQvB+uEiVrCiXI1EPQJguuhOAHMN/L9wIWHbQPEy8jzyt/Aj
	 wE4ldBBkuhgpyg+tcg7hqzJYxBKj+pobtAFfgk4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1272/1815] perf script: Fix metric_evlist leak in script_find_metrics
Date: Sat, 12 Sep 2026 08:50:22 +0200
Message-ID: <20260912065718.880406214@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit d4171c774070e9d1c45324e3667d7dcba9be7749 ]

Fix a memory leak in script_find_metrics() where metric_evlist is leaked
when returning early on error paths.

Assisted-by: Antigravity:gemini-3.1-pro
Fixes: 3622990efaab ("perf script: Change metric format to use json metrics")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index f91d8b1fbd011..ad8ca08ceb5f2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -2276,8 +2276,8 @@ static int script_find_metrics(const struct pmu_metric *pm,
 	}
 	pr_debug("Found metric '%s' whose evsels match those of in the perf data\n",
 		 pm->metric_name);
-	evlist__put(metric_evlist);
 out:
+	evlist__put(metric_evlist);
 	return 0;
 }
 
-- 
2.53.0



