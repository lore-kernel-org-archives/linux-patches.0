Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05DF344AB60;
	Tue, 21 Jul 2026 21:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669389; cv=none; b=szOG3gxAb9/KqCgkyz3WvYq1/P5sFRPOK/BIMAB06uWqsK77fW/z6oADUDIAomE+w6/e+Tsn4dN4SanZKHnTB1mhwfc2/BPUpfyW4xbIl8UPGRtY9F4Qnww8tt+0SJCyb1ijX2V9iU1t2TLtqQTqzP3P/hYBkRWb4Rt8rItiu6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669389; c=relaxed/simple;
	bh=YOCBts/k3pgxB5yCp639RRYfiGWn6QdaW5Mt3j4komU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UJ3juH4DN396icD6fiXGsFkYBZyUTyuD1Lf4oqoM5i0/KTlAVnnl9knfjF5PhtOAI+Snuu+u/71lRCiOd4Gun+c6ucOzryfNCLI3SRebfK/OcQSZcmuaik8lmlLgBr8OkCiRKtzW2dIYbhktW+4U/PSOgtJOi0hHCCPyJsMYEMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kR6LcJ+J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kR6LcJ+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BDA61F000E9;
	Tue, 21 Jul 2026 21:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669387;
	bh=wXdL4PtCNcasJsnQSRSjAa+zcWAB3zpC9Y5+Andllxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kR6LcJ+JnPyth1lMMPTwQjqv1cZpfV+9QL9yuaIYXtf1wdHkcDfMcVV60fK8KbqQV
	 w9kdhpBgRnsLPhKCo7+L14BwIeSufv5unqmD5W/M0lkCtmIviElQKPXlTPt3LHLkwV
	 tG2q7r2U7dKJN7O+5nbExA1wmO4VDG5gk42xbx9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0536/1067] perf pmu: Fix pmu_id() heap underwrite on empty identifier file
Date: Tue, 21 Jul 2026 17:18:57 +0200
Message-ID: <20260721152436.596976702@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 836455e6dbd34eb3d12eeab5e2d2b9a7f1512459 ]

pmu_id() calls filename__read_str() then strips the trailing newline
via str[len - 1] = 0.  If the PMU identifier file is empty,
filename__read_str() succeeds with len = 0.  len - 1 underflows
size_t to SIZE_MAX, writing a null byte before the heap allocation.

Add a len == 0 check before the newline stripping.

Fixes: 51d548471510843e ("perf pmu: Add pmu_id()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: John Garry <john.g.garry@oracle.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 9a762c0cc53ce6..6761a208c0d9e9 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -666,6 +666,12 @@ static char *pmu_id(const char *name)
 	if (sysfs__read_str(path, &str, &len) < 0)
 		return NULL;
 
+	/* empty identifier file — nothing useful */
+	if (len == 0) {
+		free(str);
+		return NULL;
+	}
+
 	str[len - 1] = 0; /* remove line feed */
 
 	return str;
-- 
2.53.0



