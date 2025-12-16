Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5534B434;
	Tue, 16 Dec 2025 11:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885262; cv=none; b=G8fX+LOTYlE96bjC9HUZl9iXhWNOrhYTm1fre4dl0i//2rBeqFuQZmgfsICfqjou9mRyEKj6jB+DPNUITe3oNu7Zgvh61/cI9WDm3JW5tLTj468oGFZm9Zgq6NcZtrdQqmVt7oXdPVwRe3++OLg3ABw0ZwTy88bNXOXdaAKbIso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885262; c=relaxed/simple;
	bh=mAX2t1LpXlYXBWxvdOE2MCz4qpD5/4WIRSk4INdNXCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5Q8aoO/U08XGD9wDiHwtbcj/Iyw9bXMVbjGgsq6drDboZTdMivzkIBl2Kwuyb1LJZmoePsaUY86sXa75hHSvBzLj+fhaxyFHuvzSFLG//spL6EI3a9qr+EwI+0zauk0+yc0Pe3npuh+7e64rIMGS5ByeYLkstXrmJcMW9p4LPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtG2d45p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtG2d45p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165B4C4CEF1;
	Tue, 16 Dec 2025 11:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885262;
	bh=mAX2t1LpXlYXBWxvdOE2MCz4qpD5/4WIRSk4INdNXCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OtG2d45p5dQd4OJR5zmvuUS/dbO428fhThaxgiw24E7i5S27m1gVaWga1hR6GZ9+Q
	 ZOU0Vzp2daYFvjO+bjLsuBbm1dw1nDcVOwlESz0k2iuZ895yNzS+/YocinSznBQaMr
	 aFoQnyi24fECNrkDcUe+FD6fMKagyzj7zACdRrRU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrej Tkalcec <andrej.tkalcec@intel.com>,
	Len Brown <len.brown@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 086/507] tools/power turbostat: Regression fix Uncore MHz printed in hex
Date: Tue, 16 Dec 2025 12:08:47 +0100
Message-ID: <20251216111348.654695240@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 931bad99277fe..405b13b690ba5 100644
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



