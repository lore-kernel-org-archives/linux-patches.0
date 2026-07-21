Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4E246EC8E;
	Tue, 21 Jul 2026 18:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657288; cv=none; b=lSLzCyc2ftmFw5l9WQCLwmQDerTia332s2/67vNsg0KMHvJwmATSKcpcRXb3pByBXBsy6vFPTCJdMvgalBlcT4gGu2SJrzMD3jPi+i1dM95XNQmxwztvIkob8mkA+YURQMA6ea77555HJ1hNNbeC+edEWJmT/bBKirBhplbhrig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657288; c=relaxed/simple;
	bh=etHPoKcBEFG4mktnLGlwOT+JOifYxFyl5TtE1WjTABA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dkDOih0tz4Y0PAXabWTJJTLJZE/YCFmgxU3svnMB/jVRmqDAhVAnO4gqgyKfjWIadmW8ZEZib2AloosDBT0eYjn5ZWJQ3PvU+dgvZnArBR49n+090fGN19jiIR9ODsxzBuYqvKcyBW7cXgz+dsO/x4kAX+VNEPgGEjHfi4F+iFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tbp5VZgH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tbp5VZgH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7A2A1F000E9;
	Tue, 21 Jul 2026 18:08:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657285;
	bh=bflGM35I60UJWtGJ/pBlZa81smeWOFBce3n+A/qo9Iw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tbp5VZgHjPiCNyBqwpP5YF5FN2feOd0sKOQ5BWFt5v56RjcoXR897MOkkpd8Cn1ro
	 5eMWrYAqBau0IeL+I5ubNlGnzhJWaJ5HmRbMbPb2sK2EXTiR0Xh9ENUVgl17KtfJHq
	 utCh/sDHb2vuxQgjKPgCn3gbuw27L+0CXeWJP1hQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0708/1611] perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs file
Date: Tue, 21 Jul 2026 17:13:44 +0200
Message-ID: <20260721152531.304010086@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0e65025ef9c2ba..bcdbbaadcbb3ad 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -328,7 +328,7 @@ static int perf_pmu__parse_scale(struct perf_pmu *pmu, struct perf_pmu_alias *al
 		goto error;
 
 	sret = read(fd, scale, sizeof(scale)-1);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	if (scale[sret - 1] == '\n')
@@ -360,7 +360,7 @@ static int perf_pmu__parse_unit(struct perf_pmu *pmu, struct perf_pmu_alias *ali
 		return -1;
 
 	sret = read(fd, alias->unit, UNIT_MAX_LEN);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	close(fd);
-- 
2.53.0



