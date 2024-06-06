Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A063C1C7D84;
	Thu,  6 Jun 2024 14:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683705; cv=none; b=oIT1XDYx1c7OPR4olzboMDtiOZM8eKm6t32F0Hy8rrqVuo0wW2COFP3yWdKGPnJ7QM6mAbHWrz5KIAQtmhlRufNICj/F7geoxkzZ0wXySbTmitEdcsOwofTaH/VXzaFi4R7HJfRJdzjPL7DKIkH1ma38QjxHuj1uWdS9enge+qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683705; c=relaxed/simple;
	bh=zUw36MjbRnt2rX48gJhOf2sBFJv0vMpthjyUopGeuJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEWFEu9vyBQfxItABjOEpiDo8dy6dAjeBNm6cM3bBjvfjmyeSUPj+qRxxxRVkEQ2QabDWFdRePmg6MNO3L2CTSmDs8PNjgvMfIVoE4z87i/ImGno+oj1ytlu/2BUEyAh8l4v2i6ra/2wMS72mVh72c2RmXl/ctRwyTb8EgscLDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okrXdOM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okrXdOM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8033AC32781;
	Thu,  6 Jun 2024 14:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683705;
	bh=zUw36MjbRnt2rX48gJhOf2sBFJv0vMpthjyUopGeuJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okrXdOM+UIppv6WKSOLv8/88wm5t9v3fqJdZdOOu50KxSayTpiuRejceNTgjdaKR0
	 6APiM7Zl/l/JX4141CODqVnEKBVSOR0+O1y5endztu2WW3LPPBIjIxSqxoCzIB9RHT
	 CGQFm6WEeBOv/NNZ7/GqPHAYE+jzQcNAgKhTtN+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Greg Thelen <gthelen@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Tuan Phan <tuanphan@os.amperecomputing.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 631/744] perf/arm-dmc620: Fix lockdep assert in ->event_init()
Date: Thu,  6 Jun 2024 16:05:03 +0200
Message-ID: <20240606131752.717274566@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit a4c5a457c6107dfe9dc65a104af1634811396bac ]

for_each_sibling_event() checks leader's ctx but it doesn't have the ctx
yet if it's the leader.  Like in perf_event_validate_size(), we should
skip checking siblings in that case.

Acked-by: Mark Rutland <mark.rutland@arm.com>
Fixes: f3c0eba28704 ("perf: Add a few assertions")
Reported-by: Greg Thelen <gthelen@google.com>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: Tuan Phan <tuanphan@os.amperecomputing.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/20240514180050.182454-1-namhyung@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_dmc620_pmu.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/perf/arm_dmc620_pmu.c b/drivers/perf/arm_dmc620_pmu.c
index 30cea68595747..b6a677224d682 100644
--- a/drivers/perf/arm_dmc620_pmu.c
+++ b/drivers/perf/arm_dmc620_pmu.c
@@ -542,12 +542,16 @@ static int dmc620_pmu_event_init(struct perf_event *event)
 	if (event->cpu < 0)
 		return -EINVAL;
 
+	hwc->idx = -1;
+
+	if (event->group_leader == event)
+		return 0;
+
 	/*
 	 * We can't atomically disable all HW counters so only one event allowed,
 	 * although software events are acceptable.
 	 */
-	if (event->group_leader != event &&
-			!is_software_event(event->group_leader))
+	if (!is_software_event(event->group_leader))
 		return -EINVAL;
 
 	for_each_sibling_event(sibling, event->group_leader) {
@@ -556,7 +560,6 @@ static int dmc620_pmu_event_init(struct perf_event *event)
 			return -EINVAL;
 	}
 
-	hwc->idx = -1;
 	return 0;
 }
 
-- 
2.43.0



