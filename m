Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45883B1ECC;
	Tue, 21 Jul 2026 20:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666436; cv=none; b=iU4ueIBix2SJTKOx6/51o2+Zx3zlPUWGlGLWapw07wlufhOtq6TSSjRt1a3gHjTPLMD+E8ngXuoo+sMcgtM0xMHcMgya5mumqm7qG7kgiCcYyjH00RSqZiB58DTcGljDqwCavm4seweOsguCe9kfbaRi6g2b/dl6wfHQBPsQuXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666436; c=relaxed/simple;
	bh=bk6C4E4/H5m/ahBM0AuwY73Yt2cHYd8+WiPDR4fMy3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BcHog5HyaVy4gK65NwSndT4TRo2NNpjwfFWVRubcqDNRJinf2WEG9EOR98D6MKLdG+Mjpjp+NEDzEE6iR1tyj1+eY8FhismdCaDrQV3gkYykKd2YXRjfiE5T9WWs4brpdryNKEmSgN3LkFnVe/FYDIQPf2nSapGBmk15IAujL+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDCvfaj5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDCvfaj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDD131F000E9;
	Tue, 21 Jul 2026 20:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666435;
	bh=8fP/dToPHqmy9+wlB3pD550kwpCPdjTOjfvo2DxR+Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dDCvfaj5zAWsR2z8B14YlW1hgdruKiJ2P55W/qDJGplKCypGNodLCP3Yz3c05EGlV
	 sWrfdTzAI1fSm2pU9+PlDFVj/QcejFijzLA9lpKeqt65juz7Gp07R0GE8f9d84cOIV
	 mymlFGAaaqDb9SCuGZMI4uWTq6KtQi1EUIgHnlic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0681/1266] perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs file
Date: Tue, 21 Jul 2026 17:18:38 +0200
Message-ID: <20260721152457.095423469@linuxfoundation.org>
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
index e05dff925aa069..d5daa6e43522db 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -318,7 +318,7 @@ static int perf_pmu__parse_scale(struct perf_pmu *pmu, struct perf_pmu_alias *al
 		goto error;
 
 	sret = read(fd, scale, sizeof(scale)-1);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	if (scale[sret - 1] == '\n')
@@ -350,7 +350,7 @@ static int perf_pmu__parse_unit(struct perf_pmu *pmu, struct perf_pmu_alias *ali
 		return -1;
 
 	sret = read(fd, alias->unit, UNIT_MAX_LEN);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	close(fd);
-- 
2.53.0



