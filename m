Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D245F47140C;
	Tue, 21 Jul 2026 20:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664670; cv=none; b=Z1KD9IiPFOoKRd8y8cbHhur5JOVm+EE/PlxwrBffaX/o4KRJEEu+Ln+xpAqX1UxV/IpXjRAgcvIgOkSBdolYAr+Fx9huBLqZb86hZpNntHtWpJiUuWki8VZ364CGhMvC5eGuV2c1x3nqyQVESKyRafHL7nDLWPTOJBrhsNjLV+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664670; c=relaxed/simple;
	bh=LpGptI4gTTNqYY83PgMA7+J2q8/GyYp/FJoKcCehcfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PzH5Lo/XY57AbvVy8Qr3V29deguHjmCC/r8coXSIrhbFwTXpD7qTP9+zQdfs8wM2lR/BOr3F7iKqUgwINAzWy5O/OgSSb/Q8ioUMknsxEM0p/b3/LxVDjqM4b4YIuVOPIMt0KiN9BIBGXYOQ4NAzEXZJaCO6dFQuBK0ZwRRhWog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rUTl8JfS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rUTl8JfS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42D881F000E9;
	Tue, 21 Jul 2026 20:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664669;
	bh=jd39xLY7+ouHBtW80AVnrRKuArklIC6+vI7rrZSIPjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rUTl8JfSHW955GSpT9ZWE0S0SKhZ07kzNZpW/Pzm6JvgxosiuHGR1WMJXTKN2POBj
	 rusp6GSm1gkSnmuhCsHrpbdGRBRsBhIQoTjrBBIvbWFBQqyTO/S3iSVIkl3m4YNwID
	 4qvtDBkL4dfnPOTRzacOsbjMEo+rknEusVtfnlus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0015/1266] perf: Fix dangling cgroup pointer in cpuctx backport
Date: Tue, 21 Jul 2026 17:07:32 +0200
Message-ID: <20260721152442.130874437@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

recently backport of ("perf: Fix dangling cgroup pointer in cpuctx")
use a middle version, so aligned with the upstream commit:
commit 3b7a34aebbdf ("perf: Fix dangling cgroup pointer in cpuctx")

This is a fix for stable v6.6.143 backport commit, so no upstream commit.

Link: https://lore.kernel.org/all/2026070200-uneaten-smock-4130@gregkh/
Fixes: ae1ada0af162 ("perf: Fix dangling cgroup pointer in cpuctx")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a4187dea6402a7..73a86db06cc9b1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2384,10 +2384,9 @@ __perf_remove_from_context(struct perf_event *event,
 	 */
 	if (flags & DETACH_EXIT)
 		state = PERF_EVENT_STATE_EXIT;
-	if (flags & DETACH_DEAD) {
-		event->pending_disable = 1;
+	if (flags & DETACH_DEAD)
 		state = PERF_EVENT_STATE_DEAD;
-	}
+
 	event_sched_out(event, ctx);
 
 	if (event->state > PERF_EVENT_STATE_OFF)
-- 
2.53.0



