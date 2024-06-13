Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D926143871;
	Thu, 13 Jun 2024 11:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278923; cv=none; b=WEq1DvF2Qe/756J0HyQGawYdtRSt+zePf+8jbaS4meEjzOLL3Oh+32f82mKB5jrmVOEbDCqL+ccaofin0x4cxHqVCuC9GBYjh9FpyRrtXQ/a0icdeAfSSNsStC3KqmYJTxlsXezxXy0Vz2l/qN6B/WLC8bb6qGHfHU6cPZ+Dx+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278923; c=relaxed/simple;
	bh=U067fcDEO4Gxbwq2GnzfUnzP4f0HLDZE/TM/0I/CeAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N7hZq5FFrfDlEHZR7fStxjSPT982K1NX1K0CvZHnelkFI60qIR+zdm/fDGQPZxYoBBW0MLeHQn2CE9fXAE20djRHaim/ya792xkS7mH84kFr9q86LzTENB8Th0tCPRrVPLYYyR9e7/e78bE9HX9NfngxCtW0z30/azqZQQdVYXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRJSeeeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRJSeeeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3578C2BBFC;
	Thu, 13 Jun 2024 11:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278923;
	bh=U067fcDEO4Gxbwq2GnzfUnzP4f0HLDZE/TM/0I/CeAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KRJSeeeofgszIDs1xjH6ym76gRz5ArnfzCGzovpxg/yAI/yyCCaTHIaHwbFGZRu6v
	 moK4RDuT9Yr414hWAPMiFxIBA/1pL0S99PTKpPPuBzq0/RIevCy/+U6b279+Dsoa3F
	 IzY5XvK3eb/OjouZ3SDxz9mnDyS/6LdalcGBI/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <valentin.schneider@arm.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	mingo@kernel.org,
	vincent.guittot@linaro.org,
	juri.lelli@redhat.com,
	seto.hidetoshi@jp.fujitsu.com,
	qperret@google.com,
	Dietmar.Eggemann@arm.com,
	morten.rasmussen@arm.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 085/213] sched/topology: Dont set SD_BALANCE_WAKE on cpuset domain relax
Date: Thu, 13 Jun 2024 13:32:13 +0200
Message-ID: <20240613113231.289434048@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 9ae7ab20b4835dbea0e5fc6a5c70171dc354a72e ]

As pointed out in commit

  182a85f8a119 ("sched: Disable wakeup balancing")

SD_BALANCE_WAKE is a tad too aggressive, and is usually left unset.

However, it turns out cpuset domain relaxation will unconditionally set it
on domains below the relaxation level. This made sense back when
SD_BALANCE_WAKE was set unconditionally, but it no longer is the case.

We can improve things slightly by noticing that set_domain_attribute() is
always called after sd_init(), so rather than setting flags we can rely on
whatever sd_init() is doing and only clear certain flags when above the
relaxation level.

While at it, slightly clean up the function and flip the relax level
check to be more human readable.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: mingo@kernel.org
Cc: vincent.guittot@linaro.org
Cc: juri.lelli@redhat.com
Cc: seto.hidetoshi@jp.fujitsu.com
Cc: qperret@google.com
Cc: Dietmar.Eggemann@arm.com
Cc: morten.rasmussen@arm.com
Link: https://lkml.kernel.org/r/20191014164408.32596-1-valentin.schneider@arm.com
Stable-dep-of: a1fd0b9d751f ("sched/fair: Allow disabling sched_balance_newidle with sched_relax_domain_level")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/topology.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 02e85cd233d42..c171783bda0cf 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -965,16 +965,13 @@ static void set_domain_attribute(struct sched_domain *sd,
 	if (!attr || attr->relax_domain_level < 0) {
 		if (default_relax_domain_level < 0)
 			return;
-		else
-			request = default_relax_domain_level;
+		request = default_relax_domain_level;
 	} else
 		request = attr->relax_domain_level;
-	if (request < sd->level) {
+
+	if (sd->level > request) {
 		/* Turn off idle balance on this domain: */
 		sd->flags &= ~(SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
-	} else {
-		/* Turn on idle balance on this domain: */
-		sd->flags |= (SD_BALANCE_WAKE|SD_BALANCE_NEWIDLE);
 	}
 }
 
-- 
2.43.0



