Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245E138944D;
	Wed, 30 Sep 2026 17:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787835; cv=none; b=A6ECAcVd7YjWwnbb4PsOG1MqBOu5zt7BIjw1/WNHKA+gcyyXL0YXlImaCfncw8lq58LBkWg2sTF2zD2d837emjp4z6esGGc8IsVEcsomY4bhjCWJfm1sPF/x/1pwuz+tFOAql1SriZvJkyoZencOqOUeJ1uGwuTG063D1VOfBr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787835; c=relaxed/simple;
	bh=g1KBby1GI63AGaKT1Ans51KfLFzs+maMdV6IgynC5ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/qbRiDhmuMFpe4gQ1nFvtupuG6BCMzZA/IHo7dJuIp6gK+wxWFp5cJzXqxd3jOAcShoC96JNHKjFyTKmwVQRn/QR6WpDfMm62rLtZOtj32Y0b65tnmkK3fZmwqod6W5o1qvw17+xzwQjN1x61tngdrTvO5yjwWAQgTWnV1bd4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oKksPMc4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oKksPMc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F4E01F000FF;
	Wed, 30 Sep 2026 17:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787834;
	bh=lxnhrNHK0Y3puJs8IYciC7smesECU58EjxdyCXJ+Pyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oKksPMc4SJ2S4HBGep4nFUlviBfJPOMVZUhzJy8ofvskektnNTE+siewAiZqqhohv
	 aiPZLkmr9WGlskpgMUNir+hxuxndY3VN0PDMhSBKna1SKMS2OWhmnsP4fgoPkU66tI
	 Uld1PxGvPIFoaU60k5PnGkABK3Mx26HOqGDcP2rY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 7.2 370/457] perf/x86/intel: Constrain Panther Cove UOPS_DISPATCHED events to PMCs 0-3
Date: Wed, 30 Sep 2026 17:27:55 +0200
Message-ID: <20260930152353.992337923@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

commit 04a7ef3b7aa3af34202285043e3423a2e3983595 upstream.

Per the latest Panther Cove event definitions, the following events are
only supported on PMCs 0-3:

- UOPS_DISPATCHED.INT_EU_ALL (0x1b2)
- UOPS_DISPATCHED.ALU (0x2b2)

Add explicit event constraints for these two events so scheduling does
not place them on unsupported counters.

Fixes: d345b6bb8860 ("perf/x86/intel: Add core PMU support for DMR")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: <stable@vger.kernel.org> # v7.0+
Link: https://patch.msgid.link/20260917015234.981153-10-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/events/intel/core.c b/arch/x86/events/intel/core.c
index a7dbbed8f94e..ecf6d6325dfe 100644
--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -506,6 +506,8 @@ static struct event_constraint intel_pnc_event_constraints[] = {
 	INTEL_EVENT_CONSTRAINT(0xce, 0x1),
 
 	INTEL_UEVENT_CONSTRAINT(0x01b1, 0x8),
+	INTEL_UEVENT_CONSTRAINT(0x01b2, 0xf),
+	INTEL_UEVENT_CONSTRAINT(0x02b2, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x0847, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x0446, 0xf),
 	INTEL_UEVENT_CONSTRAINT(0x0846, 0xf),
-- 
2.55.0



