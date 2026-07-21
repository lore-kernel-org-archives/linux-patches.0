Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD04C43C7D6;
	Tue, 21 Jul 2026 22:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671873; cv=none; b=JHZVclwIACIPluM3e96g7ELGwPGAgezqq52NYw6wT+u6fvHvnU+FqkSXR+fZccSbFvSapuGyVdhKIaAk7p994V43d1cSrzPpji+/Md6UyWRe3ghOKatMBcLEAtRwZnLoVrNDAf4yuR0N8ueYuJFavAM1tiN1oU+Pe5TJaKMwDjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671873; c=relaxed/simple;
	bh=pTx/IVBUuJ1b49/ene75QxHHIF0abfJakJxOEH5I09o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d1qtTndFjEXmbFVMNWSaZAO214+wQvC7XEqhpFRFotCICs2QvU0/iBKOw8ID+/YXINkjzlKk5nhwIHigWUmjm3cBMYH9lrIMFqpuE5R2Pmz1+CRaf6YgWVFYSfkZn/oVk8XICPeDpMqdJrNuulFUxVizypSX+RPx4AEFK9LERLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xEX/w9k7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xEX/w9k7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFE51F000E9;
	Tue, 21 Jul 2026 22:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671872;
	bh=q+9mxK2k7eNUxIe+MgJDD5btDbM/ydyDIQXK4hH3DyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xEX/w9k7uiZyapbtDJyRKnw1zaIro87vO1IZ5JILkQtaV1MjmV44FoD9Z9Z6BFaSB
	 cKDl61WFGNa6xOKxQZXnyRRmxVi4GvTzMGL4u508Qn/4DIlCDnsMr750S8y8h2vR8n
	 CpwJpDdE5NKGnLsAaQS58kdh/5EdUZaWpV/PAbnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/843] perf pmu: Fix pmu_id() heap underwrite on empty identifier file
Date: Tue, 21 Jul 2026 17:20:47 +0200
Message-ID: <20260721152415.305565779@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index eafd80be66076c..ce577e5393f92f 100644
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



