Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DA651FBEA6;
	Sat, 12 Sep 2026 16:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230689; cv=none; b=add73mVY9Gl8i/0AhMnkSgvNs4JTTcQRq1NHL7lH+Xfmmgu6Bdcx775KEUZ076ERDJe3GUeoi1DMXQhwqwhrrA7ahhb8RAHHyRiMOVAH/CDoQwPI5EcvUgQMRnoWjykQkb54wrcV9mOt1rAAze1YpIjtKErqkLS4WtvKO22InTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230689; c=relaxed/simple;
	bh=WkEN/s1VAHxXoZEubjhZk+6i5dpZaLnC5GMo/AlyYmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0STbBjVpfxzNJFjwPjQMPuzrcsGVMn1G5iIUl6+3rlqVcyW+qE2V9x5hEqJk2VjwDaVo4AQDzTjQOP43iZf5iY9KQNCUzPjT9v8o+r24bTepPFkHX9/7pCBljSxAmDqskjfgo4kvWfo9ZtwYl8Oc+w+CgjGYyty4R7NEy4wJmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uOstJcio; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uOstJcio"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146951F000FF;
	Sat, 12 Sep 2026 16:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230688;
	bh=6AmZ486+dqyyO3o9lcbj/7pGWQ/JYz4IMxFRfVrQf2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uOstJcio+pM0FLmvMO2ZU+WAeWEU1vKgc7HKoVshVsjvXx94DjNF+QHzQzpN1XUpm
	 ksa02FM65b0985fQIge85eseGjD/QgcreCM+A8neDrVhdbf8MKurNsHvpJ5hv9GCNr
	 lehGqCNrk+FTTdtMwyh75NLao/j5ArL02dmITKOY=
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
Subject: [PATCH 6.1 0846/1191] perf intel-bts: Fix off-by-one in auxtrace_info minimum size check
Date: Sat, 12 Sep 2026 08:59:34 +0200
Message-ID: <20260912065607.258195146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b9fb8225951ce27e62a2235a71f3ab01137aaec3 ]

Same pattern as the Intel PT fix: min_sz is set to
sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE, but the code accesses
auxtrace_info->priv[INTEL_BTS_SNAPSHOT_MODE], which requires at least
INTEL_BTS_SNAPSHOT_MODE + 1 elements.

Use (INTEL_BTS_SNAPSHOT_MODE + 1) to ensure the highest accessed index
is within bounds.

Fixes: d0170af7004dce9c ("perf tools: Add Intel BTS support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/intel-bts.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/intel-bts.c b/tools/perf/util/intel-bts.c
index 2c8147a622033..2a860e46e712d 100644
--- a/tools/perf/util/intel-bts.c
+++ b/tools/perf/util/intel-bts.c
@@ -858,7 +858,7 @@ int intel_bts_process_auxtrace_info(union perf_event *event,
 				    struct perf_session *session)
 {
 	struct perf_record_auxtrace_info *auxtrace_info = &event->auxtrace_info;
-	size_t min_sz = sizeof(u64) * INTEL_BTS_SNAPSHOT_MODE;
+	size_t min_sz = sizeof(u64) * (INTEL_BTS_SNAPSHOT_MODE + 1);
 	struct intel_bts *bts;
 	int err;
 
-- 
2.53.0



