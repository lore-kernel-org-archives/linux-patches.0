Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F49A4E1D8;
	Tue, 23 Jan 2024 00:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969997; cv=none; b=uN3ax+cby0quKzpE4auZ/vbG+CEvgcM8F1qpbghc4zgMgdBbWuGTA8PtaOQcIAoNOUKV7oCCOp8gNk3qn5r5I1amYq5HOpHeOTEqqeplISUJnoiRWt2WrNdK2Elw8VB1+cS1SEQ2ahdpm6zVgNsPZy01TtIVEL+KdqxSNs8bE5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969997; c=relaxed/simple;
	bh=uRdk2SjVigecFue9NNIYsBpKdJ53n5EaoPp6zJSlEMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uot6r+hrioB6wOGWWoWobqfqlK2e8v5lePFkh6gg/1IZLX0QzhqzBjmK2SjWD5YNJVgjy7nzwPp92shjHEA2Qj0KKp4y6Ab6KrvRE5YpnBxgxNUIGg40pNEdc5nVkp8Sa3jbZ/pjJSVVMeLUhVu85sSsHGySjEIsJE8baw7jJXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdHj/JWB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdHj/JWB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06C07C433F1;
	Tue, 23 Jan 2024 00:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969997;
	bh=uRdk2SjVigecFue9NNIYsBpKdJ53n5EaoPp6zJSlEMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdHj/JWBPQXmNfUZX66vNzcwj0jOnts0yspniY0qkEOSMKx1VLRB2uHj9G64zaEps
	 7Ev/WNKCMUance4ZvAv6IdmeKBdZf4MX0Zpe91krV/DwHswQQxNY5+MwdayeoGJzRs
	 u7oP7TQ8tKzXxqmrfHXE7TIfKXLaZvwe1XQSUToM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Namhyung Kim <Namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Junhao He <hejunhao3@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Qi Liu <liuqi115@huawei.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 533/641] perf hisi-ptt: Fix one memory leakage in hisi_ptt_process_auxtrace_event()
Date: Mon, 22 Jan 2024 15:57:17 -0800
Message-ID: <20240122235834.794703799@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yicong Yang <yangyicong@hisilicon.com>

[ Upstream commit 1bc479d665bc25a9a4e8168d5b400a47491511f9 ]

ASan complains a memory leakage in hisi_ptt_process_auxtrace_event()
that the data buffer is not freed. Since currently we only support the
raw dump trace mode, the data buffer is used only within this function.
So fix this by freeing the data buffer before going out.

Fixes: 5e91e57e68090c0e ("perf auxtrace arm64: Add support for parsing HiSilicon PCIe Trace packet")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
Acked-by: Namhyung Kim <Namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: Junhao He <hejunhao3@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Qi Liu <liuqi115@huawei.com>
Link: https://lore.kernel.org/r/20231207081635.8427-3-yangyicong@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/hisi-ptt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/hisi-ptt.c b/tools/perf/util/hisi-ptt.c
index 43bd1ca62d58..52d0ce302ca0 100644
--- a/tools/perf/util/hisi-ptt.c
+++ b/tools/perf/util/hisi-ptt.c
@@ -123,6 +123,7 @@ static int hisi_ptt_process_auxtrace_event(struct perf_session *session,
 	if (dump_trace)
 		hisi_ptt_dump_event(ptt, data, size);
 
+	free(data);
 	return 0;
 }
 
-- 
2.43.0



