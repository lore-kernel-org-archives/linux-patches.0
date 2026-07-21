Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E2B35C6B0;
	Tue, 21 Jul 2026 21:29:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669391; cv=none; b=UGWw2AQcNjHylcrcaScXc2bdtlqgmWIbUWIRn5fuq6bn1LM9fDSohEolT5tNnW/ScpNyH2CHsP4mGjzkvQ/GfbUqme1UmcQhSS/8VsQJYwPlJL84UYdY0rnCdLHEsn9exootz16826NMQjEDDN1cuYclzgVoKsleb0V0lJPXgkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669391; c=relaxed/simple;
	bh=TBRufquj9S5Q+mjtB+nwTYW4uW4a5SyMRcGVslkd7EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bXoV29RQIqQM0H0FQovP0+aMHpLiszKP1UsAhehKOh5whq/G6r3NUV13fS2eAX906hqFBwlD2g6iZ021HsW/SPKN/iwjtPX+WOCPUYjWTXYpBKBTrw/zSZC/iLNdXCpjuDkik/4kTqR+PRRJyFFu05KB9MIzWi04P7LCFG3Oqds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+NIUPg9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+NIUPg9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1456E1F000E9;
	Tue, 21 Jul 2026 21:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669390;
	bh=PAdmzIZLTsjgMZjfRmKLgZ7p3B87V+ImokJAk1BZvYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+NIUPg9Or40+QFeETKucCpX4BviThVEQBZua01iW8lktl2iflU4n6qyfd7GV3YWY
	 CDv1rE2YvM5pvsWE5j940auyeYb5/Iln73gkab9AUqG9rOahhF6wt4iCqkrypcKVck
	 W8B07VOajqFgSlDp73UJfAKP23oKuijbkfngEDNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0537/1067] perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs file
Date: Tue, 21 Jul 2026 17:18:58 +0200
Message-ID: <20260721152436.619622069@linuxfoundation.org>
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

[ Upstream commit 33035f7dd4e49f3f117e70c5e36c8c1ae88d37f2 ]

perf_pmu__parse_scale() reads a PMU scale file then accesses
scale[sret - 1] to strip a trailing newline.  Only sret < 0 is
guarded, so an empty file (sret == 0) causes scale[-1] — a stack
buffer underflow that reads and potentially writes out of bounds.

perf_pmu__parse_unit() has the same pattern: alias->unit[sret - 1]
with sret == 0 accesses the byte before the struct member, which
may corrupt the adjacent pmu_name pointer field.

Change both guards from sret < 0 to sret <= 0 so that empty files
are treated as read errors.

Fixes: 410136f5dd96b601 ("tools/perf/stat: Add event unit and scale support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 6761a208c0d9e9..db1418c9369651 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -162,7 +162,7 @@ static int perf_pmu__parse_scale(struct perf_pmu_alias *alias, char *dir, char *
 		goto error;
 
 	sret = read(fd, scale, sizeof(scale)-1);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	if (scale[sret - 1] == '\n')
@@ -189,7 +189,7 @@ static int perf_pmu__parse_unit(struct perf_pmu_alias *alias, char *dir, char *n
 		return -1;
 
 	sret = read(fd, alias->unit, UNIT_MAX_LEN);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	close(fd);
-- 
2.53.0



