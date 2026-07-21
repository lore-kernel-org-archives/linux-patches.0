Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C8A43E073;
	Tue, 21 Jul 2026 22:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673852; cv=none; b=HiepNYb6h3Lwjq1JNBnXly1YPnFKK+gOXz4PFWLZeIcOj37q1ACoB4JsrY1+n+CNBptOE3lRPLJmfpSUHMbPKgehiLznMoOkCUH780YxVs6AhjIIMhfxeyoDf9ToTGdVuj2Cc24hbMTzkwrZGchz/Ruze1PFy59+t8GeLPPdHlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673852; c=relaxed/simple;
	bh=QB7UiWC/mF6/Q6JbJZMtvZ2cNEpY58ZXrn3Q9h1NX3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cg2RgGYIXuOdmIBiSsWhnwa8Z//25NpPmc/ZllYVgYenRLH0CQZWec9ef1LEUV7KM8dwIeYmi4i5mGyRKsauk5cMRnUI6HQKUMpm/p1KGOyinPxy9eJFtHLMb6LRQlu7bkEgkScAl7dd32VB3llxrWLSGiqrUxk3CdHuCqp/85Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0y94Rlv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0y94Rlv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD49B1F000E9;
	Tue, 21 Jul 2026 22:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673851;
	bh=l77FQMGrixaqVtNU9ny5DzdQTnTOUSok8ueOGxflhyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r0y94RlvWMzeUsuHtlXBdaMBOY6DrMXVwdRKX8fJJb2XpZPnJrO2sOekGSjcwGHuk
	 bYYBqRZ4PTP3xd6Y/iOtfE/tFOkK7zcs0aIXy1Jw906909drLa4+ToET9/VxiG4RWv
	 K9AsU2xPZu/nLojFTqA/pxx/zhaQ88VCrE8RTi1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 312/699] perf pmu: Fix perf_pmu__parse_scale/unit() OOB access on empty sysfs file
Date: Tue, 21 Jul 2026 17:21:11 +0200
Message-ID: <20260721152402.733088133@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d322305bc18281..914375179b00e8 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -158,7 +158,7 @@ static int perf_pmu__parse_scale(struct perf_pmu_alias *alias, char *dir, char *
 		goto error;
 
 	sret = read(fd, scale, sizeof(scale)-1);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	if (scale[sret - 1] == '\n')
@@ -185,7 +185,7 @@ static int perf_pmu__parse_unit(struct perf_pmu_alias *alias, char *dir, char *n
 		return -1;
 
 	sret = read(fd, alias->unit, UNIT_MAX_LEN);
-	if (sret < 0)
+	if (sret <= 0)
 		goto error;
 
 	close(fd);
-- 
2.53.0



