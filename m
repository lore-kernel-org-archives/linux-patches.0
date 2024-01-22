Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3363277F23;
	Tue, 23 Jan 2024 02:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975534; cv=none; b=ZZrxYX1NagpNHFjUK676hUCXFL/hmeGEKBQNjvy0nn3xqKLTNPwiAAaqDIMVof3vxJV1sx3XZuxHWu0jATocaJgUpq6RGFx/3KJCaGPBAKrwcKg2wEG1XUMAtqeBV07+Ci3FpV9H2u/dEsadz2VOEa4wdHidQ7p64GZOuyjx6Vw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975534; c=relaxed/simple;
	bh=k8SrcaUi8yz025xytcjJu2TNcXoc5JEBpyl985XPKJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3izmusBdOdVZE30FEhZgWy1k1szPrKYxiUVOj4iZC0MFmP7FH76sHbwwTS1KS8oCy3dsdTl3/4gxLMsl6R+6bBJ7o4tEV4mauuV1Q7kfwbpfTfKdeliapN9PxT7AX3RsKmw3mp5TJdMsRk/hPZXTDv9hgT1cnpPuhRDBgobnG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QEQuAHF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QEQuAHF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8098C43399;
	Tue, 23 Jan 2024 02:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975534;
	bh=k8SrcaUi8yz025xytcjJu2TNcXoc5JEBpyl985XPKJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEQuAHF3uRMxhl/vaRvhpKy5E7RdCOBMtPVrNs/8PQyBz1hDz99xTW3+aH1+6rwT6
	 pS/tWPYreTv9Ktj0EwgZdDumfb9Ym26EsELB+qNYsIvbgR/kMsw6xsVaL1AjODjfW4
	 vPnnRariop/A1lJvyLG2fj7e/2tGqW/4pXJQs5G0=
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
Subject: [PATCH 6.6 484/583] perf hisi-ptt: Fix one memory leakage in hisi_ptt_process_auxtrace_event()
Date: Mon, 22 Jan 2024 15:58:55 -0800
Message-ID: <20240122235826.816023919@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 45b614bb73bf..764d660d30e2 100644
--- a/tools/perf/util/hisi-ptt.c
+++ b/tools/perf/util/hisi-ptt.c
@@ -121,6 +121,7 @@ static int hisi_ptt_process_auxtrace_event(struct perf_session *session,
 	if (dump_trace)
 		hisi_ptt_dump_event(ptt, data, size);
 
+	free(data);
 	return 0;
 }
 
-- 
2.43.0



