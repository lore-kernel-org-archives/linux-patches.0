Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D5634389C;
	Sat, 12 Sep 2026 07:41:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198890; cv=none; b=lZ5LtG/f4nGYMgFjwefMSsevIjwq9kbUtl4EglKWGVeaW84qcBtEzveV3YUWzjKTqucq2WbodHwWphpGL2o9VXg2JT40tZguqP87hNMW8CFBMx/Zs7hySeEuKukJQfrbGxxWKqkSBuak5lCJxU0D3bcxcQWuh2EzDipnvLHUdoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198890; c=relaxed/simple;
	bh=O5jKdJcyvSSebvEav4vQiPSUGFuA0t4M9wiZDqVWHkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oE/cmw5ka/jRyFJNtc5yRW4ciYnf+GRDqEfDqWOPyJDJulUcJqePZtOOi3fX05f61NnDXRgZ7ZIyVBqom+jmC88j161zMGNtfP6KCGcaFYMZ9K6Ilp8cPdZpxddz7PYepuMYO/KLBqmQoFMjDD4pjdiK4Yz9SnaFqf3qicqnBVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJvxOlk9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJvxOlk9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AA4B1F000FF;
	Sat, 12 Sep 2026 07:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198888;
	bh=IVcm3PY59GBr74Qv2cCykJ4TZ6Wo7i0O/XIkL6VZOdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NJvxOlk9PEMItZIoa8wqVvrnEXfJaBszi0mdBlrqn6IeunD3AjINdu+ieBZ9bXAlJ
	 OWyBJPoeI3j3sPfCwrhrNdilrjpTCBluHVakkmCTAbo2lTpdVOVCk+ISJUphQea0IU
	 8t8BGnEfhh3TfijkqieKUrxr1Kvc0QOMO9cF32Gc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Swapnil Sapkal <swapnil.sapkal@amd.com>
Subject: [PATCH 7.2 0456/1815] perf sched: Fix memory leaks in perf sched stats report
Date: Sat, 12 Sep 2026 08:36:46 +0200
Message-ID: <20260912065659.593931952@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 60de2c6561ae57b5f2c50efecc1fa1f0081f731a ]

The second pass data is not saved in the list and only used to calculate
delta from the first pass.  Let's free the data after use.

Fixes: 5a357ae6ad63 ("perf sched stats: Add support for report subcommand")
Reviewed-and-tested-by: Swapnil Sapkal <swapnil.sapkal@amd.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-sched.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a91921fb3b736..11db64ac1c122 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -4627,6 +4627,8 @@ static int perf_sched__process_schedstat(const struct perf_tool *tool __maybe_un
 			domain_second_pass = list_first_entry(&cpu_second_pass->domain_head,
 							      struct schedstat_domain, domain_list);
 			store_schedstat_cpu_diff(temp);
+			free(temp->cpu_data);
+			free(temp);
 		}
 	} else if (event->header.type == PERF_RECORD_SCHEDSTAT_DOMAIN) {
 		struct schedstat_cpu *cpu_tail;
@@ -4647,6 +4649,8 @@ static int perf_sched__process_schedstat(const struct perf_tool *tool __maybe_un
 		} else {
 			store_schedstat_domain_diff(temp);
 			domain_second_pass = list_next_entry(domain_second_pass, domain_list);
+			free(temp->domain_data);
+			free(temp);
 		}
 	}
 
-- 
2.53.0



