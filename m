Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1EF6EED8;
	Sat, 12 Sep 2026 14:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224611; cv=none; b=S9gh0V+EgV8zAXREUDHhK3V0pRKjCwEBxsrts3LJx24iv+KhphMmLftiecOxBc+z/Tq4iZ/K55lZ6DaUK0FD13dB2PDfOFAYEG3IBBJtZiDPPMUw2EwJaBAt4ZVSk7QQQE5oVWuyIr/EZSXFBtbW3HzsJoB/yBNcMqjSjHYcNn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224611; c=relaxed/simple;
	bh=Ncfj9/VyblD7i4yTYjSVebuPnj1g+MnMaa4lqECePe0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XJlahnigQwMeSxhkwWu0mSFzvluwQegMzafneGSrbiHRyvy7m0oikMM9xpX0fmC1OYtXc2KDxWeB4hkElw1bOP4Sz2We5pJs5tfjDbhbrnrtEg3+ctq04gl/wOz4Gg1TT7rVruL7Po994mKQ9zlyc56iuJVsAp9E6Hbljv+9J7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oqkNHfdv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oqkNHfdv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C70D11F000FF;
	Sat, 12 Sep 2026 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224610;
	bh=DFqetv2sZKn1P9Rox62ONx8q2M7bFvTLnVxhlRMH0VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oqkNHfdvBl93k/Koi4xTupx9Z7Mh5N+XCpQX9l/tbpX/natBNjm9mH75qicYAx2/8
	 B8pIUMkEwQNNDEfUYfIkPVpTf6qPlWj7fioO+S7URQiNvungbV9hQh49D9zYPB+VQy
	 Qr3P8NfX2TJRuDiIx+qghoeZF+wuMYYODubrUfws=
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
Subject: [PATCH 6.6 1027/1424] perf intel-pt: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:57:39 +0200
Message-ID: <20260912065630.312591244@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e9f97c0c33582..4b68c301ce729 100644
--- a/tools/perf/util/intel-pt.c
+++ b/tools/perf/util/intel-pt.c
@@ -4381,7 +4381,7 @@ int intel_pt_process_auxtrace_info(union perf_event *event,
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



