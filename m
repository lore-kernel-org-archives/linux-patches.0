Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A751F1534;
	Sat, 12 Sep 2026 08:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201553; cv=none; b=PQ/8iHmyH8isdT1zeIlFU7GrnvD6J8yHkp6UIZhB3o0Wxxx9+aiTXdy6iS3fHBlH69fHevst/ryNGHIVBUTy4IkUdrEfMccyUHT0M8veH7nqhnubZJw540in+tSQ3ULwjIIlBXAsbdZneBHSKcGQ7Z8PXLvldCUx+o+rYW1maCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201553; c=relaxed/simple;
	bh=RZCKpcMjvMrhmNFu4KKm0hDpq2pzqsmcsj63yhNAg/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJm49rSLqSeoTOq/CSUyFJKEi2r1NZt1rEBpqKE8wM48kSz0TaXXDq6DX/dYS+87rY98MdDJRyc7U3xfDP2dHmPSe8I675RkNx4o4wqXdwuRLVs8U/fnb8pkyB74ZkmnQWRHVfHm9zfPptRzaNVZZzZkAvcvPtXiwLYiB9WD5AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fwz4/wmA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fwz4/wmA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E531F000FF;
	Sat, 12 Sep 2026 08:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201551;
	bh=PXOoglYr+cPgpyAotTdQN8RPiiLZ9DKAT8gWa7mkNls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Fwz4/wmA8f+wa7Ruyz/HGLgxCDc8AcCA3x9KyG4siXBHln4V/9gt9E4JmIcC+qykQ
	 56JEltYgXmqhAjj1rf3g2DxFVUhqiStFDkfQHfsVCAbti/tIJA/n1TXVJ0VijAwAbi
	 oSTfmgZtzwHzgEv8KGqbgZ60nR7Px93byHcGySyg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1020/1815] perf intel-pt: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:46:10 +0200
Message-ID: <20260912065712.959740439@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c4362d5e1a5ed4ce2098798f655a636c4340fa20 ]

min_sz is set to sizeof(u64) * INTEL_PT_PER_CPU_MMAPS, but the code
accesses auxtrace_info->priv[INTEL_PT_PER_CPU_MMAPS], which requires
at least INTEL_PT_PER_CPU_MMAPS + 1 elements.  A file with exactly
min_sz bytes of priv data passes the size check but the access reads
one u64 past the validated region.

Use (INTEL_PT_PER_CPU_MMAPS + 1) to ensure the highest accessed index
is within bounds.

Fixes: 90e457f7be087005 ("perf tools: Add Intel PT support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-pt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-pt.c b/tools/perf/util/intel-pt.c
index 56a9e439f5f8f..806cd173a0067 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -4430,7 +4430,7 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
 				   struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_PT_PER_CPU_MMAPS;
+	size_t min_sz = sizeof(u64) * (INTEL_PT_PER_CPU_MMAPS + 1);
 	struct intel_pt *pt;
 	void *info_end;
 	__u64 *info;
-- 
2.53.0



