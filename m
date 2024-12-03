Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C4AD2D7BF;
	Tue,  3 Dec 2024 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239062; cv=none; b=FFdVWQPeVbJn1iNKu1kXgxs1BrBdn/T45DRy+IryN28CQ8lAxqX4/ag8cFNCw7CgSpK2dyEc5l5EF/qzuN74Mn3Xo4PTAmoWvZZywmBKHrlKbBMde+jnj7dmnx99eDUU6Wq7BHR1NoEHnLShsGfKeWPbA/z2ROuAHJ16TYMce9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239062; c=relaxed/simple;
	bh=GQAxnlGMvwWouBkpTmR0R1r0GiSDMj89rEtIduTw7wo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BnpiiZJgQsneRC3wlp84IBamwzgDNKx4pkLYLgEDXQlGOsnrLbBHbneIG5Af34URihNgBy9BSx5usm6XjotbTNyZIyiksF/yQ0GC/mzDRhX8vRd2nAHyWACjmUo6rw/7c3Dq5eHFcDoR0tmPSx80DKyhAdzovnasuLPkGUFAexw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsAXBSm6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsAXBSm6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5415C4CECF;
	Tue,  3 Dec 2024 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239062;
	bh=GQAxnlGMvwWouBkpTmR0R1r0GiSDMj89rEtIduTw7wo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsAXBSm6KVtevC1GIXmD98nXE7y8l7FpJIfKes+kIlauFxdfQ+8K06uHjTbrGQbSL
	 Jw/1oOHDttjN3KPppH23nfCn6XqwG4jOhnAba+d3nVngOWHyaccUk2LNzx3b7o+fe3
	 0o70itmb+m+gHpFXizMjOSs290cxJJQpa4Ilb/tM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 490/817] perf stat: Fix affinity memory leaks on error path
Date: Tue,  3 Dec 2024 15:41:02 +0100
Message-ID: <20241203144014.999371803@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 7f6ccb70e465bd8c9cf8973aee1c01224e4bdb3c ]

Missed cleanup when an error occurs.

Fixes: 49de179577e7 ("perf stat: No need to setup affinities when starting a workload")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20241001052327.7052-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-stat.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index d0cbd1477dfcc..668a8ad2bf604 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -823,6 +823,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		}
 	}
 	affinity__cleanup(affinity);
+	affinity = NULL;
 
 	evlist__for_each_entry(evsel_list, counter) {
 		if (!counter->supported) {
@@ -961,6 +962,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__cancel_workload(evsel_list);
 
+	affinity__cleanup(affinity);
 	return err;
 }
 
-- 
2.43.0



