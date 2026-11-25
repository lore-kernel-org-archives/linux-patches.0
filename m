Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621854;
	b=xAO/I9s3VB+SDLAm4nB2VzkGisF10a34BzPSF6TUYOV9quLhrFfWb/6dWeWaHH+oQNu3
	 2G2ygOtV9vrF1p0xrbUgdCEcgpCwsZU+ZdQHcr8Okx1UZac/8gg6Lw4AwSdYqKeskdkSC
	 nZIP9fBzqX5T5C4lCljXeCTcsdQ3FuRRKY5BAk6K2B+lyTLMpMxMZDPHB3982ejtyI5cU
	 wbl6UnRC1rLkZciTWb1IPBCxLR7qaNfAi14wjv1mR3ifpi6nejUQEhwgqHcGjYLLSpskn
	 PN1b/JiHiWlJe3wX6dJC15wwxEY3Rijdi/FbNjRXSOk3X6ApNKppNzkeLqs3KUV3hIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621854;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dJb442yRLIPlAewEtuLlF1mD/hV04uTgDA9oigYmBps=;
	b=gbpwM+/n9F51ox6utbzrWgRajsIkX4PSJ9ProLy+W3amg8ybFqGv7bb/md0YckD6LaWp
	 mM0dcK1JGapHoN+LYBwMHwcNGUI81kdGZwJhMW514wgJeF1WVm8Xf/TGeP6lAbDwJVgic
	 yYRDt2uGXh2Dct/aHy1li5KDMIdm9r5sFJGJEaRTlcOH34XoxU3O1hhhckMVea3zdBdh1
	 qWsF1qEJaDgLp9pi6kxAlr52DevBcbn0q+tNulEfx3xei37HDYXgUPgV29jHwDdiIK28r
	 RipumIxnAKWdLFg0p++cI53wDdbF2TDbDLY82uWaZ+U00C/VwylfMBP4aTHnoYGdztg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boBQunk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42BE7606A326;
	Wed, 25 Nov 2026 15:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=boBQunk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED571F000C4;
	Wed, 25 Nov 2026 15:50:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621854;
	bh=dJb442yRLIPlAewEtuLlF1mD/hV04uTgDA9oigYmBps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=boBQunk0JqsrePP7D67WElTQWrV5Jb9D0WpWLlgIaexnp6Ya5sdpXbHpn19fQk4QX
	 pgjTjah31XAnt0A9oi5L3MGj3aQoIDsybUtUiskXC3y7glJQB3vc01oB/Ka1GrvrSY
	 7XyXd7HgjI+JwQWdi5pesiWteTbWf/vym3dea1Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kan Liang <kan.liang@linux.intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 310/990] perf: Move and enhance has_extended_regs() for arch-specific use
Date: Wed, 25 Nov 2026 15:27:57 +0100
Message-ID: <20261125143829.351360583@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kan Liang <kan.liang@linux.intel.com>

[ Upstream commit 05fe8825796e6b5557656c6c984486f0e66154fe ]

Move has_extended_regs() to include/linux/perf_event.h so it can be used
by arch-specific code.

While moving it, enhance the check logic and rename it to
event_has_extended_regs() to match existing perf event helper naming.

Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260824082731.1013973-9-dapeng1.mi@linux.intel.com
Stable-dep-of: b61c12527223 ("perf/amd/ibs: Fix kernel address leak via REGS_USER and REGS_INTR")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h | 10 ++++++++++
 kernel/events/core.c       |  8 +-------
 2 files changed, 11 insertions(+), 7 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 5fb17c4f52f12..b822fa661d11a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1528,6 +1528,16 @@ perf_event__output_id_sample(struct perf_event *event,
 extern void
 perf_log_lost_samples(struct perf_event *event, u64 lost);
 
+static inline bool event_has_extended_regs(struct perf_event *event)
+{
+	struct perf_event_attr *attr = &event->attr;
+
+	return ((attr->sample_type & PERF_SAMPLE_REGS_USER) &&
+		(attr->sample_regs_user & PERF_REG_EXTENDED_MASK)) ||
+	       ((attr->sample_type & PERF_SAMPLE_REGS_INTR) &&
+		(attr->sample_regs_intr & PERF_REG_EXTENDED_MASK));
+}
+
 static inline bool event_has_any_exclude_flag(struct perf_event *event)
 {
 	struct perf_event_attr *attr = &event->attr;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e7e052f62204b..a2f1cb4478263 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12792,12 +12792,6 @@ int perf_pmu_unregister(struct pmu *pmu)
 }
 EXPORT_SYMBOL_GPL(perf_pmu_unregister);
 
-static inline bool has_extended_regs(struct perf_event *event)
-{
-	return (event->attr.sample_regs_user & PERF_REG_EXTENDED_MASK) ||
-	       (event->attr.sample_regs_intr & PERF_REG_EXTENDED_MASK);
-}
-
 static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
 {
 	struct perf_event_context *ctx = NULL;
@@ -12832,7 +12826,7 @@ static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
 		goto err_pmu;
 
 	if (!(pmu->capabilities & PERF_PMU_CAP_EXTENDED_REGS) &&
-	    has_extended_regs(event)) {
+	    event_has_extended_regs(event)) {
 		ret = -EOPNOTSUPP;
 		goto err_destroy;
 	}
-- 
2.53.0



