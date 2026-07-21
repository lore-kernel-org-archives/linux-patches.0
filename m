Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26072D8376;
	Tue, 21 Jul 2026 20:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666433; cv=none; b=NOhTSjcPsOgod7oWkJCHxa87gSN+xcTGzOANA5p6KbY2M91LFPwGS1WB15Qii7ISH47DFXbgabk/NC83ERJqMENHh3hcBOdzRuVFxc0fTf4uWV2WbYxn2/SNxDyAwCQ/nelo0CdrFfqWc3HarH6UjeI7ZcPYxWuYamJwklDvj9g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666433; c=relaxed/simple;
	bh=pAqWi/cY4++lk1d3dHVH0DqXgxfK79xWL24sOh29fAc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TlfLVmDPYGcAd05chsjB2TOesNTo5VIVZEG+4lDjYJ+PTJQhdGQYj8YQPHe6eS57t2P+aQidTT1zIne/YIFW0fMAZedexVVnvSoMPIddUhVGtt+Zl92rW5ceZrWGdf7hgQZffkRRV/hh7Gb78nFAih6xiPwGlkRPIukkr4XLYgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrzGi8cA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrzGi8cA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3424A1F000E9;
	Tue, 21 Jul 2026 20:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666432;
	bh=T2fr6pMRMKUWL2T8nrovfEDBs8h+M4CCI/dFblbE8qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrzGi8cAzHJlFUFCgN8PNNmbNTmNi1MOenIoKLL7eKlIVGCGox7RdF0swtJFr1ij4
	 O8tYVGWsUqmcJX7dkx8UWeAbUMKFuo5Dynw/7k0jiDRjaRrp7XQEE1C0lmp/va3kW6
	 cWnRKticI548bilTYU9rrnBp56ooLAj3tKLua+hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0680/1266] perf pmu: Fix pmu_id() heap underwrite on empty identifier file
Date: Tue, 21 Jul 2026 17:18:37 +0200
Message-ID: <20260721152457.074650931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2587c4b463fa88..e05dff925aa069 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -774,6 +774,12 @@ static char *pmu_id(const char *name)
 	if (filename__read_str(path, &str, &len) < 0)
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



