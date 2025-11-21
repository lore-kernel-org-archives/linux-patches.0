Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2881F09B3;
	Fri, 21 Nov 2025 13:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731213; cv=none; b=ib6bl4xAfF2d7yovDyZB7+2nFhvze2xORWa+ly6iKWyUvKrWSaaOYtLJqY/SL5/73Qf+h/wSePapUCKCZTaRVvrqvqNO4QqQkyGvuMfiEhi1KW5DvGVaLEQuZZAvnQ/CpGL4yuWxo02nVmMg4e125y+4WcejkHMfpSI60+aUEb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731213; c=relaxed/simple;
	bh=Nqu9GgO/QliyMDtuL9cek70DlYbVuTj2OD3dY1WLBRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HI4QcavwboNrnOjz2kOj5TSD9Y6Dp7O9gl0oG+MKMypEa2R7QeiDS59w6L00ZaO3zHkH6m8apotAsG7aLF1CXWrmZ3Pfky0fKxMDysU01RKIxgv9HO89UQHudFFCRiPUVewu1GZrQih8txCVxbG6Sw5ERjfW0yfKhS0nEiY/hYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0BGWhDG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0BGWhDG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76F34C4CEF1;
	Fri, 21 Nov 2025 13:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731213;
	bh=Nqu9GgO/QliyMDtuL9cek70DlYbVuTj2OD3dY1WLBRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z0BGWhDGYI/iJlLXoK/2/3BGAoTFgm88QRrbN1AZEV1sMpUXJZyZj2HOtHjcIOMni
	 JmOWYWL+mEIVKIk4Lt0jdSpEPLALwXLkIkZUYF3q1C3LfI0C/0tgAEecefmkxxIRVu
	 VJPbN//U/K6ET4qRq5lAsioh8rk7kqsNdLLTrU4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Thomas Falcon <thomas.falcon@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 130/247] perf header: Write bpf_prog (infos|btfs)_cnt to data file
Date: Fri, 21 Nov 2025 14:11:17 +0100
Message-ID: <20251121130159.392849036@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

From: Thomas Falcon <thomas.falcon@intel.com>

[ Upstream commit 85c894a80ac46aa177df04e0a33bcad409b7d64f ]

With commit f0d0f978f3f5830a ("perf header: Don't write empty BPF/BTF
info"), the write_bpf_( prog_info() | btf() ) functions exit without
writing anything if env->bpf_prog.(infos| btfs)_cnt is zero.

process_bpf_( prog_info() | btf() ), however, still expect a "count"
value to exist in the data file. If btf information is empty, for
example, process_bpf_btf will read garbage or some other data as the
number of btf nodes in the data file. As a result, the data file will
not be processed correctly.

Instead, write the count to the data file and exit if it is zero.

Fixes: f0d0f978f3f5830a ("perf header: Don't write empty BPF/BTF info")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Thomas Falcon <thomas.falcon@intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/header.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 4f2a6e10ed5cc..4e12be579140a 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1022,12 +1022,9 @@ static int write_bpf_prog_info(struct feat_fd *ff,
 
 	down_read(&env->bpf_progs.lock);
 
-	if (env->bpf_progs.infos_cnt == 0)
-		goto out;
-
 	ret = do_write(ff, &env->bpf_progs.infos_cnt,
 		       sizeof(env->bpf_progs.infos_cnt));
-	if (ret < 0)
+	if (ret < 0 || env->bpf_progs.infos_cnt == 0)
 		goto out;
 
 	root = &env->bpf_progs.infos;
@@ -1067,13 +1064,10 @@ static int write_bpf_btf(struct feat_fd *ff,
 
 	down_read(&env->bpf_progs.lock);
 
-	if (env->bpf_progs.btfs_cnt == 0)
-		goto out;
-
 	ret = do_write(ff, &env->bpf_progs.btfs_cnt,
 		       sizeof(env->bpf_progs.btfs_cnt));
 
-	if (ret < 0)
+	if (ret < 0 || env->bpf_progs.btfs_cnt == 0)
 		goto out;
 
 	root = &env->bpf_progs.btfs;
-- 
2.51.0



