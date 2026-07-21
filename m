Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA8746EC86;
	Tue, 21 Jul 2026 19:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660509; cv=none; b=TjQFrjp5Tl5cu9FmpUQtm3K7BahL3rvOhvazzmz1pQQY+55wkIluWwVM63uVurYK/8XpFDr+DQ8v9QMBamnnmIDQ3cOp6yQHHsbpVY1yRxJWPUbU5DkS9zl9qX/yJ5gjal6gZm/yWXn0zdKOBYGupdpcM9wlimQkXA1VU/eK9Vs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660509; c=relaxed/simple;
	bh=PVdNAF5xDE5VTkq51lHFhSojS2Ponjm8TkCO7PKqCN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rMpR/hxtinecNzmBCOOMgdeEby1QbwKCiesqcavnfdFXtstaiTUVjgiyPWT5JuQWGVE8owC3osiO1z9Kh8MgClcQW6YkxwPkh/l5ycQm+YbXLJVOke3XcQ/u3mWj/fuZbXIVRU+RI47S6DOpS7yb5kdK2xcMEYNosIAAi5Kj/pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IoIsHWBx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IoIsHWBx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0176E1F000E9;
	Tue, 21 Jul 2026 19:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660507;
	bh=if6yMBDQ0qEUSX2YvEuSIH2bHdiaf/L3t6jA3qQYAQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IoIsHWBxje79UO4zxhgfxugxF8PcQXJZ8LBd+06xPR/5ttLC1niYBm8y3a0d+syTv
	 e0xrAtCVZxQpPCywtkmYjzD/GjX47XFfTGQxm3ndScZfYh9V5+OHl7prxkjCmg5BL0
	 wbbc/9GzaLhEDFcv02DSR1tCajhuwSF95zHazvgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	John Garry <john.g.garry@oracle.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1004/2077] perf pmu: Fix pmu_id() heap underwrite on empty identifier file
Date: Tue, 21 Jul 2026 17:11:17 +0200
Message-ID: <20260721152616.497732125@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 23337d2fa28199..dc12e39ceb5fc8 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -865,6 +865,12 @@ static char *pmu_id(const char *name)
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



