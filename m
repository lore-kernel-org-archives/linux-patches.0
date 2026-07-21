Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56A0B43D4EE;
	Tue, 21 Jul 2026 22:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671876; cv=none; b=hr+wxLLJuXWTrsE+O1xo+WorLIZj5Kegl2ZyyVKVkofoYr4JQFDOTQAhyjlgnBrDGWUuC9sru4AC08A+vILYwdi8VG0HzPlzDc3y3gtR6VHo3LSVNPSNk7bfNJeGnwOq/WH8YOks3zTvM9VwMfhps7zAIxO/V83W7Rmx3IisITc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671876; c=relaxed/simple;
	bh=sI65VPzYAGwDB4puMGBOCX+WRf/+PPHmwEx4KgXr51w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sjuWemybE7e0KdN4HLDLcJDwN7q5xixG5i/FhtD5PnHBNr3FfWOAFkEZsDl50F6g5Mj0Z6ICTJKLvPG0M+94Z/pBLBWSdcD5DaqsUINMCWUjqv/GUB+coP3H4XQ/ujp2NYB0OJLWP700g//XArp4X+eUzMBmelfAYr4sjC7Js1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJTd5rwy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJTd5rwy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE411F000E9;
	Tue, 21 Jul 2026 22:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671875;
	bh=9KYXpDSs2sjqfDh3Ro/d2OswrlhXpWhBib7sh5Metcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJTd5rwys+ykJnUxPbuenQ3i7KqQ0+MStIw19E+8Gd8+KC2khJrdKetbX91MOZ7JN
	 8vrvgVK4rWwnMSIj3ioSMy4fjVnpJI/hNDCIws/uybRuv3/EO2n+r2U4HUPtriVKC1
	 uaTxw0y7S7gVZYLU1UuNHYdJaItWk2I06P3Dl6TY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 413/843] perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs file
Date: Tue, 21 Jul 2026 17:20:48 +0200
Message-ID: <20260721152415.326483124@linuxfoundation.org>
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
index ce577e5393f92f..4cc27aa8aec723 100644
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



