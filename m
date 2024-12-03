Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E4B1E009A;
	Tue,  3 Dec 2024 16:01:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241667; cv=none; b=ch0Gd8iaum/wfzcY7+NkI1Jwwa4/cuZelTorGfTLN9ThiSoG7m8db6DeI6eE3ImdmRXP89thzTnSaSeCXfqlCozIr6jLmonwytyYYnYopKsS/Y4sH4h/a1DlvrDuC7Vz2G3Vy8gdDZDxQ5dKQ0dkFNrieF2Z1Gtq5098/MazRMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241667; c=relaxed/simple;
	bh=Txo/HfmfYBf8D8H/X15x3IiEZHVBNY0wZnthoGDJAsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhpuqejtUj60/SgWTSEcaj6w4QNpTqvavSdTOBkJTGnHLScoWsPRHCQd+GTGbJKoWqr5D6l+TbTwFZyZIJK98pTz7aH09Zm5y3VLjkhXjBsrqgj6EM01CTl1/Xsw4q1KFHORwzysCxhqYqa8HWYuEclzEMwGaj2E10dGiA46f2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WAMoGTu8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WAMoGTu8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83290C4CECF;
	Tue,  3 Dec 2024 16:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241667;
	bh=Txo/HfmfYBf8D8H/X15x3IiEZHVBNY0wZnthoGDJAsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAMoGTu8UQGd3fFHRa5LQAOe1RmNTdxJQQoB6WTmNW29AbCQtXmP7SNrvX4aP457z
	 eWvy2LBZnCen7X3CRzQXXvMFf8UtuzzqK2ZsNYoSmcnBZL1hSNZ39KFMKzM1ZWOMb+
	 7jvpjy4Baw7639++PIaf0DReEvTFLVfFSp+LReZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 476/826] perf stat: Fix affinity memory leaks on error path
Date: Tue,  3 Dec 2024 15:43:23 +0100
Message-ID: <20241203144802.329998361@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2c46bdbd9914d..4933efdfee76f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -827,6 +827,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 		}
 	}
 	affinity__cleanup(affinity);
+	affinity = NULL;
 
 	evlist__for_each_entry(evsel_list, counter) {
 		if (!counter->supported) {
@@ -965,6 +966,7 @@ static int __run_perf_stat(int argc, const char **argv, int run_idx)
 	if (forks)
 		evlist__cancel_workload(evsel_list);
 
+	affinity__cleanup(affinity);
 	return err;
 }
 
-- 
2.43.0



