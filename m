Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADB80221543;
	Mon, 23 Jun 2025 22:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717555; cv=none; b=k3doLxEoKh4dalGvl71PgS8XL0AYrjzWYmQPs6ioyoIVdKljEk0l+JNauoAIZwD84Zm4bm84/rex9B5nCC+FdNkkdk0rJ36KeRsSq8bmDlN+uumKfXGO0cI88khLXSC/Klnfu2xYCGdYn7nJt++Px9efK2yFTcSuBi7IB8BMaKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717555; c=relaxed/simple;
	bh=O+0b+KHuu/oR3Ucc2A/h20xGhjQco6tgn74ZBqheV0s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UnzML8JAA6pzWlaN5Jc4g35N2A40blB5laWdEmJzFFTCYXYCmf6BB4G47VsswCBk7DTFAaQIkquwQylKaxgK1+aOQJX6Uce7Vgqn/FgCEJoa9CXjvnzm4/PDoyDjqD1x7+aX2HP48O2VE/MElNpsH93cUegAE38P8kFMAMd3oHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MBEuPMtV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MBEuPMtV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A4DC4CEEA;
	Mon, 23 Jun 2025 22:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717555;
	bh=O+0b+KHuu/oR3Ucc2A/h20xGhjQco6tgn74ZBqheV0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MBEuPMtVCeiAmkwCyM5syNfbAteP6yy4Zp4mfdnGPUknU7e6TpZkak7euQaLdW72J
	 8kPJPnNfatiAxO64MENMMbIOw3PPh3QgDBayH6OvGNbhe74su2MWJkmBVv3Zo/Eg8R
	 Vpw9RMBy3aAPtgzZj8EZpC4NyNz6EQJnC9InDvoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Michael Petlan <mpetlan@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Tiezhu Yang <yangtiezhu@loongson.cn>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 412/414] perf test: Directory file descriptor leak
Date: Mon, 23 Jun 2025 15:09:09 +0200
Message-ID: <20250623130652.251135478@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 19f4422d485b2d0a935117a1a16015328f99be25 ]

Add missed close when iterating over the script directories.

Fixes: f3295f5b067d3c26 ("perf tests: Use scandirat for shell script finding")
Signed-off-by: Ian Rogers <irogers@google.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Tiezhu Yang <yangtiezhu@loongson.cn>
Link: https://lore.kernel.org/r/20250614004108.1650988-1-irogers@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/tests-scripts.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/tests/tests-scripts.c b/tools/perf/tests/tests-scripts.c
index ed114b0442936..b6986d50dde6c 100644
--- a/tools/perf/tests/tests-scripts.c
+++ b/tools/perf/tests/tests-scripts.c
@@ -255,6 +255,7 @@ static void append_scripts_in_dir(int dir_fd,
 			continue; /* Skip scripts that have a separate driver. */
 		fd = openat(dir_fd, ent->d_name, O_PATH);
 		append_scripts_in_dir(fd, result, result_sz);
+		close(fd);
 	}
 	for (i = 0; i < n_dirs; i++) /* Clean up */
 		zfree(&entlist[i]);
-- 
2.39.5



