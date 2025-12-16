Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6605E3563D7;
	Tue, 16 Dec 2025 12:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886520; cv=none; b=ENJviuC2LiGWR/dB+uT70+mGuSZP0jID7xuTIysbddc+Q5X0WuWsEMtVKyspzLlv7JOokAboccdOQ1BHLfD2B8ia+Q1VRIfOStOLB47tqlEluH6MWqvY1Khoq5bYEicRVoVHrWr0WxBe7w6skHNZZtcYdXyWzQhlxS0oTPU2x/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886520; c=relaxed/simple;
	bh=b7k8OZRtY5yg9oCssVCDB3/fvqKa45ae9jVK/ziCwVU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c7co+3T2ZR5cZBAKTQn15VpXlQT0ZQlc2i4L2EPrL8r1FUUcUC/DkwqDMwViGql3DVhOMY+HyxgvYtyKdkLdQ0UID2+sg3PvgfFbPkIGof+/1wPJlwHq204lAr2WIqkLNCpIHCRLW+WSsfDMBaQOPahll92nyPs98P7Cg4cGCic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6F2ee1n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6F2ee1n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7194AC4CEF5;
	Tue, 16 Dec 2025 12:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886518;
	bh=b7k8OZRtY5yg9oCssVCDB3/fvqKa45ae9jVK/ziCwVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6F2ee1n9WJ+diNck+zlTdhnJMrAmH/G7SB2MmkkTtmUt409kLEtsmvX+fLZXqAvz
	 uhHeiOO3NJ2c2Ki3wFTx5Soy0AHmmwJsKhskMupejcrz++Aa1vlNkThbqj45x6H1H6
	 K9fQ3ubigBZn6d7atYOzr+An9fBDi/hnLxzh9XaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 427/507] perf tools: Mark split kallsyms DSOs as loaded
Date: Tue, 16 Dec 2025 12:14:28 +0100
Message-ID: <20251216111400.931059745@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 7da4d60db33cccd8f4c445ab20bba71531435ee5 ]

The maps__split_kallsyms() will split symbols to module DSOs if it comes
from a module.  It also handled some unusual kernel symbols after modules
by creating new kernel maps like "[kernel].0".

But they are pseudo DSOs to have those unexpected symbols.  They should
not be considered as unloaded kernel DSOs.  Otherwise the dso__load()
for them will end up calling dso__load_kallsyms() and then
maps__split_kallsyms() again and again.

Reviewed-by: Ian Rogers <irogers@google.com>
Fixes: 2e538c4a1847291cf ("perf tools: Improve kernel/modules symbol lookup")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 3fed54de54016..93c81c65b6c40 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -967,6 +967,7 @@ static int maps__split_kallsyms(struct maps *kmaps, struct dso *dso, u64 delta,
 				return -1;
 
 			dso__set_kernel(ndso, dso__kernel(dso));
+			dso__set_loaded(ndso);
 
 			curr_map = map__new2(pos->start, ndso);
 			if (curr_map == NULL) {
-- 
2.51.0



