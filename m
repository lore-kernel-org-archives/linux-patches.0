Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE77330B0F;
	Fri, 17 Oct 2025 15:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716267; cv=none; b=e7YHuC+juvGHbTh+FFERehX7vEWwtXNUkA7Cb24Bm1QiZbUK1J/pR65nbIaxPDAVGrqaX4l9+d6TC/7W2XQqPLrAOCBKOAXiyQZ2M2puCsTdFLOizKrdxpn0OPQ+WeUtqBgbYzVokpqu0dacf0lOIUm7Mh4IjVIdxt3TQhLLHnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716267; c=relaxed/simple;
	bh=vi24S4r00seo+yxu3h2z3uA9n2v8HfMe1RARODEk554=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kFX6ZvY2OR5UF1AdBo1eIznLG4SvJPD9RYiaWxR2lErMr1RkVMM7kMmGPHdj5DqyzJWzS5oGr6ZeE7CcN0MCLRSY/AApW2fUh54jExj6xVwZZt8Ch3om0iyX26AjmNtzAqT2iroKUZUtd6M4L2rRuFnsqvpcAnOePkxDU3McaNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lwqLUWHP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lwqLUWHP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E0DC4CEE7;
	Fri, 17 Oct 2025 15:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716267;
	bh=vi24S4r00seo+yxu3h2z3uA9n2v8HfMe1RARODEk554=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lwqLUWHPc6RT3GYtFMs4FjdKFb25bSqGshROxdDCSU4eD66Mv4YDwjtdE0C9UBh4n
	 mYsqt3TpG9buFGZ6ZWKzCSKwZ3WCmLRqVSDX40j/vYEE3+JSvJlQ5QGIA3pIjWn98g
	 E3L1Fq4nercJx+pYUy/dT+s4d0sD8zlI44uDTIUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ali Saidi <alisaidi@amazon.com>,
	Leo Yan <leo.yan@linaro.org>,
	Jing Zhang <renyu.zj@linux.alibaba.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	German Gomez <german.gomez@arm.com>,
	Ingo Molnar <mingo@redhat.com>,
	James Clark <james.clark@arm.com>,
	Jiri Olsa <jolsa@kernel.org>,
	John Garry <john.garry@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	Mark Rutland <mark.rutland@arm.com>,
	Mike Leach <mike.leach@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Shuai Xue <xueshuai@linux.alibaba.com>,
	Timothy Hayes <timothy.hayes@arm.com>,
	Will Deacon <will@kernel.org>,
	Zhuo Song <zhuo.song@linux.alibaba.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/276] perf arm-spe: augment the data source type with neoverse_spe list
Date: Fri, 17 Oct 2025 16:53:44 +0200
Message-ID: <20251017145147.264329126@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jing Zhang <renyu.zj@linux.alibaba.com>

[ Upstream commit 74a61d53a6d1ca1172d85964d15c83c2cc3670b3 ]

When synthesizing event with SPE data source, commit 4e6430cbb1a9("perf
arm-spe: Use SPE data source for neoverse cores") augment the type with
source information by MIDR. However, is_midr_in_range only compares the
first entry in neoverse_spe.

Change is_midr_in_range to is_midr_in_range_list to traverse the
neoverse_spe array so that all neoverse cores synthesize event with data
source packet.

Fixes: 4e6430cbb1a9f1dc ("perf arm-spe: Use SPE data source for neoverse cores")
Reviewed-by: Ali Saidi <alisaidi@amazon.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Jing Zhang <renyu.zj@linux.alibaba.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ali Saidi <alisaidi@amazon.com>
Cc: German Gomez <german.gomez@arm.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: James Clark <james.clark@arm.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: John Garry <john.garry@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mike Leach <mike.leach@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Shuai Xue <xueshuai@linux.alibaba.com>
Cc: Timothy Hayes <timothy.hayes@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Zhuo Song <zhuo.song@linux.alibaba.com>
Link: https://lore.kernel.org/r/1664197396-42672-1-git-send-email-renyu.zj@linux.alibaba.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: cb300e351505 ("perf arm_spe: Correct memory level for remote access")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index 9e7e56596c60e..2d7fc2b01f36b 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -423,7 +423,7 @@ static void arm_spe__synth_data_source_generic(const struct arm_spe_record *reco
 static u64 arm_spe__synth_data_source(const struct arm_spe_record *record, u64 midr)
 {
 	union perf_mem_data_src	data_src = { 0 };
-	bool is_neoverse = is_midr_in_range(midr, neoverse_spe);
+	bool is_neoverse = is_midr_in_range_list(midr, neoverse_spe);
 
 	if (record->op == ARM_SPE_LD)
 		data_src.mem_op = PERF_MEM_OP_LOAD;
-- 
2.51.0



