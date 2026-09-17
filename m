Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78BD051AEE9;
	Thu, 17 Sep 2026 17:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666599; cv=none; b=bgtklyOCwMjoUecRtZ2DcINn6MI8om5+0AQZMB1AtLKPuNaCN8Doa2Mz6f4jQlon90UEnnRT6yvcgt80xw2TKzlPBfdcaWXfwYKd80WGJkngxzTZWf3tOFRITz1Q9J1XTGcka5vhbM/3oAj3UT4f53vrrAPqkEG0p8Sx/yrgQzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666599; c=relaxed/simple;
	bh=+TylFsf8U4U0XP0oRc/xAjGesodfay4cXQwiryF5s+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ac/AT6gYtabTM3PQ1kCuUzmLtFcQFrE7nuSXPCIWuoKSYHOqNC5i82Jk6zsAh+ivcB0TbfpUSDcMg/JinFzV2tG0Hpzuh/RngTRFTJWECLGTv+bOzXH30fPGuzXNKLHHRBcE2hmEpbpSB9/4FWOoRqky/s5bJ+3B55Ie7EARabw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMzy2OU5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMzy2OU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF21F1F000FF;
	Thu, 17 Sep 2026 17:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666598;
	bh=WZpypwwJXdF4wkxYHCYy3LEM6UwrXeB6hFb7Sk+8eBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MMzy2OU5a45WD2xBvpS6sptEkh4+sajdPd/aNpyhIudjjE2abXSRDWT6ACY6MmXi4
	 9zaQ5RVWm61YS5ekvj8s069H9olEn7wS6gryVvlTfIra7Ft1H55/lW0kXFI9moTh2j
	 dSL979e89XH2eIareC2d+KkY5gcfqWlJs6kF75yM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cmaiolino@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Carlos Maiolino <cem@kernel.org>
Subject: [PATCH 6.18 1091/1250] xfs: snapshot scrub stats when rendering them
Date: Thu, 17 Sep 2026 16:14:46 +0100
Message-ID: <20260917151621.732030464@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Darrick J. Wong <djwong@kernel.org>

commit 568a1588b906780dc3e9be56a61217afb4f7800e upstream.

LOLLM complains about concurrency problems in the scrub stats code
because xchk_stats_format doesn't synchronize in any way with updates.
These stats are only reported through debugfs so I don't think it really
matters, but I guess I exist to make bots happy now.

Note: We snapshot the entire stats object with a spinlock so that we
don't have to worry about users seeing slightly weird numbers (e.g.
invocations has incremented but none of the outcomes have been yet) if
we race with xchk_stats_merge_one.  This isn't a hot path.

Cc: stable@vger.kernel.org # v6.6
Fixes: d7a74cad8f4513 ("xfs: track usage statistics of online fsck")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Assisted-by: LOLLM # finding obvious bugs
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Carlos Maiolino <cem@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/xfs/scrub/stats.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

--- a/fs/xfs/scrub/stats.c
+++ b/fs/xfs/scrub/stats.c
@@ -99,25 +99,31 @@ xchk_stats_format(
 	int			ret = 0;
 
 	for (i = 0; i < XFS_SCRUB_TYPE_NR; i++, css++) {
+		struct xchk_scrub_stats	fss;
+
 		if (!name_map[i])
 			continue;
 
+		spin_lock(&css->css_lock);
+		memcpy(&fss, css, offsetof(struct xchk_scrub_stats, css_lock));
+		spin_unlock(&css->css_lock);
+
 		ret = scnprintf(buf, remaining,
  "%s %u %u %u %u %u %u %u %u %u %llu %u %u %llu\n",
 				name_map[i],
-				(unsigned int)css->invocations,
-				(unsigned int)css->clean,
-				(unsigned int)css->corrupt,
-				(unsigned int)css->preen,
-				(unsigned int)css->xfail,
-				(unsigned int)css->xcorrupt,
-				(unsigned int)css->incomplete,
-				(unsigned int)css->warning,
-				(unsigned int)css->retries,
-				(unsigned long long)css->checktime_us,
-				(unsigned int)css->repair_invocations,
-				(unsigned int)css->repair_success,
-				(unsigned long long)css->repairtime_us);
+				(unsigned int)fss.invocations,
+				(unsigned int)fss.clean,
+				(unsigned int)fss.corrupt,
+				(unsigned int)fss.preen,
+				(unsigned int)fss.xfail,
+				(unsigned int)fss.xcorrupt,
+				(unsigned int)fss.incomplete,
+				(unsigned int)fss.warning,
+				(unsigned int)fss.retries,
+				(unsigned long long)fss.checktime_us,
+				(unsigned int)fss.repair_invocations,
+				(unsigned int)fss.repair_success,
+				(unsigned long long)fss.repairtime_us);
 		if (ret <= 0)
 			break;
 


