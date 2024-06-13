Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2A61459EA;
	Thu, 13 Jun 2024 12:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280039; cv=none; b=BW/jlpmyLjhtlNiV5viLVtP3ZwczThyJVO540AUboowHzC1xV4X/LogyjhkPktzHWYRcfM+8AjoYteBjPCK7kA+NYNeagzeIhoSIfzWh1JYR05T/SDIdprkGS6ang6Z4PN1c/nUQ3XJ7gDKgVy7eZK4hns7EsyJamQ6ucDE0JHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280039; c=relaxed/simple;
	bh=SODg0cmYqFPckc0CPjwLjdedbPYS97sGQVYbPJ0s28A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BUJjCYR89c7lATR2Yi5wtgVV+qGiP0xK0y3fS1jlysEx2gasonfJ54UL5LZOsXwFEqGzFAOb/CKnnuiYJjqznYhcpFar9pRBzrOhOuflCmtTe7tccTzIPGaEsMxLEYlnqQYYkNzwPDwKOmHz9QdPtySpG9D8M6fp9PwxKzUR6f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4P3Lc0q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4P3Lc0q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32522C2BBFC;
	Thu, 13 Jun 2024 12:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280038;
	bh=SODg0cmYqFPckc0CPjwLjdedbPYS97sGQVYbPJ0s28A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4P3Lc0q9TSw5eVZoIVniQsY1gjlth4jB0hf/uL20sksQh0q/d3fKbDVR4r8Bcw4i
	 CnghRQF7uQmqOKXeToM02ZDqmR/V+li/ULpnkfXrwIiBKrT7d25F4wSYZqYnRvSQrz
	 UT3smV+y1Qc2fMc+aIKDHraI3q7Jt4IQ/B7srx98=
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
Subject: [PATCH 5.4 091/202] sched/topology: Dont set SD_BALANCE_WAKE on cpuset domain relax
Date: Thu, 13 Jun 2024 13:33:09 +0200
Message-ID: <20240613113231.280669407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.759341286@linuxfoundation.org>
References: <20240613113227.759341286@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index e5ebaffc4fef5..844dc30fc5593 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1201,16 +1201,13 @@ static void set_domain_attribute(struct sched_domain *sd,
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



