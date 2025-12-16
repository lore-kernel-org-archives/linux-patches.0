Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B686364EBB;
	Tue, 16 Dec 2025 12:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887139; cv=none; b=VGMcoWIHHM0HhHIEZa8ZJQVEVFB7AGLLYSmi4nHkzYR23j0nLQPBmdemqsXyRxT1zuyaFSa5GKNZ6+lUZqTrm3+PyVXsOwmZyJyj0bu2jZIl2PwsZhm/wnqGqzdO5cNSzoF55SEWgOVG05fugfmIhZKP2zdrYGWTL+K9funn/48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887139; c=relaxed/simple;
	bh=qUxEiObG25LZgaLdwCRDk+XLiaF7t+pGqls9oYK8J8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+Ms+1eqhYsBK4wVOeE8wcejWo2A5x6lEmt2MhK0PE8m9QXWAslp8PCMxspisR74z5DAXrbPhEwAd6tZaLLzdzDwRGazLbhxySr3Zc8P4/jvtwlJiaCK7IDKM8MAh9EyonzsYr/8sOf535IgKi+3A7048ROmLOZZdluN08M9mLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEdvQteq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEdvQteq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9781FC4CEF1;
	Tue, 16 Dec 2025 12:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887139;
	bh=qUxEiObG25LZgaLdwCRDk+XLiaF7t+pGqls9oYK8J8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEdvQteqjoJHsjZfRMA/sh4DeRuEyuDxLmaMVwJBmF0NSVggNQuLYywANbFeUQv/9
	 nHZNm8mXrS1SMyfp6FlP817NHpXpffAkdvkS3MTB9zN0Fu87XCAsOTkZ6EPgh8MbfB
	 G6sxtjouyJM3Gk1ipjN5VQ/sUxXVDFwCnrO4dOgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Tkalcec <andrej.tkalcec@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 095/614] tools/power turbostat: Regression fix Uncore MHz printed in hex
Date: Tue, 16 Dec 2025 12:07:42 +0100
Message-ID: <20251216111404.762190786@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Len Brown <len.brown@intel.com>

[ Upstream commit 92664f2e6ab2228a3330734fc72dabeaf8a49ee1 ]

A patch to allow specifying FORMAT_AVERAGE to added counters...
broke the internally added counter for Cluster Uncore MHz -- printing it in HEX.

Fixes: dcd1c379b0f1 ("tools/power turbostat: add format "average" for external attributes")
Reported-by: Andrej Tkalcec <andrej.tkalcec@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index f2512d78bcbd8..1b5ca2f4e92ff 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3285,13 +3285,13 @@ int format_counters(PER_THREAD_PARAMS)
 
 	/* Added counters */
 	for (i = 0, mp = sys.tp; mp; i++, mp = mp->next) {
-		if (mp->format == FORMAT_RAW || mp->format == FORMAT_AVERAGE) {
+		if (mp->format == FORMAT_RAW) {
 			if (mp->width == 32)
 				outp +=
 				    sprintf(outp, "%s0x%08x", (printed++ ? delim : ""), (unsigned int)t->counter[i]);
 			else
 				outp += sprintf(outp, "%s0x%016llx", (printed++ ? delim : ""), t->counter[i]);
-		} else if (mp->format == FORMAT_DELTA) {
+		} else if (mp->format == FORMAT_DELTA || mp->format == FORMAT_AVERAGE) {
 			if ((mp->type == COUNTER_ITEMS) && sums_need_wide_columns)
 				outp += sprintf(outp, "%s%8lld", (printed++ ? delim : ""), t->counter[i]);
 			else
@@ -3382,13 +3382,13 @@ int format_counters(PER_THREAD_PARAMS)
 		outp += sprintf(outp, "%s%lld", (printed++ ? delim : ""), c->core_throt_cnt);
 
 	for (i = 0, mp = sys.cp; mp; i++, mp = mp->next) {
-		if (mp->format == FORMAT_RAW || mp->format == FORMAT_AVERAGE) {
+		if (mp->format == FORMAT_RAW) {
 			if (mp->width == 32)
 				outp +=
 				    sprintf(outp, "%s0x%08x", (printed++ ? delim : ""), (unsigned int)c->counter[i]);
 			else
 				outp += sprintf(outp, "%s0x%016llx", (printed++ ? delim : ""), c->counter[i]);
-		} else if (mp->format == FORMAT_DELTA) {
+		} else if (mp->format == FORMAT_DELTA || mp->format == FORMAT_AVERAGE) {
 			if ((mp->type == COUNTER_ITEMS) && sums_need_wide_columns)
 				outp += sprintf(outp, "%s%8lld", (printed++ ? delim : ""), c->counter[i]);
 			else
@@ -3581,7 +3581,7 @@ int format_counters(PER_THREAD_PARAMS)
 		outp += sprintf(outp, "%s%d", (printed++ ? delim : ""), p->uncore_mhz);
 
 	for (i = 0, mp = sys.pp; mp; i++, mp = mp->next) {
-		if (mp->format == FORMAT_RAW || mp->format == FORMAT_AVERAGE) {
+		if (mp->format == FORMAT_RAW) {
 			if (mp->width == 32)
 				outp +=
 				    sprintf(outp, "%s0x%08x", (printed++ ? delim : ""), (unsigned int)p->counter[i]);
@@ -3758,7 +3758,7 @@ int delta_package(struct pkg_data *new, struct pkg_data *old)
 	    new->rapl_dram_perf_status.raw_value - old->rapl_dram_perf_status.raw_value;
 
 	for (i = 0, mp = sys.pp; mp; i++, mp = mp->next) {
-		if (mp->format == FORMAT_RAW || mp->format == FORMAT_AVERAGE)
+		if (mp->format == FORMAT_RAW)
 			old->counter[i] = new->counter[i];
 		else if (mp->format == FORMAT_AVERAGE)
 			old->counter[i] = new->counter[i];
-- 
2.51.0



