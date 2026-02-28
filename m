Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BD5D33FE26
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300943; cv=none; b=LeEpGpfTFaDGxo57lVlv05trSP8Z9GAn8ywEm1zP0F/BLgtWfbOENcIJcPj4+G2AuD/E8NNdWCeKcuLpK3FTQeWs84Ww8iPdq2cLuWBBUaNZKb9yMGKa7FApsY9+Tk30umymn3wuASaBe7mDydQPh/LIVrUHMpgPoynKMQmna8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300943; c=relaxed/simple;
	bh=z/qLpE3cWPf3xZOstwUNl8MbfrnjusOc8qr44jPmR/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f8Q/2ClFji8kPH3FU5cdU3BnofSxtgq+QDnnjAsOKexNsDYnRELsUU/a/QVHOcWqLAVI1T2xQa2iv4oNaSKzFyu/SkvC8iy+9vQIl8RHtIOFTRCI0aBuosF4h/0r7qJqPgAl3Pq/wJxGNN5eMSOW9icASL4ya+tRdzrbU5mhxSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VTvpxeDH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VTvpxeDH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3D5C116D0;
	Sat, 28 Feb 2026 17:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300943;
	bh=z/qLpE3cWPf3xZOstwUNl8MbfrnjusOc8qr44jPmR/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTvpxeDHkgPdxei9KSvKV0IhQnjkO3sMAp4QFUVVkyufVQvhw1ajm3A8CAe8wwbiW
	 v/QOOarUrOoJ+By4LxrnqUl+EDP7IkWz9G1oKo/lhEB5N+LxZ2+ItY5/Q+dNq2hv18
	 wMIQ9NlZ1usQUhA0tzedHfa27OEsNl6JLr3cb7hIaD+xqQsgWjO6ZArzA3qkrVlWty
	 CMhh+nwE09dOzHSJwQMWamRuseFBDJHAnTMzt0kTO6Z4STkiqq2oIsKvvDtstlIzKZ
	 WrPaULfKqHufqJ6sEvJ6A/U1EHbFmdRlVWbTA8zFsGk74jQPn0QajwVxpEMfrQh4/q
	 ya4/4l8xy7WlQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Thomas Richter <tmricht@linux.ibm.com>,
	Jan Polensky <japo@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 065/752] s390/perf: Disable register readout on sampling events
Date: Sat, 28 Feb 2026 12:36:16 -0500
Message-ID: <20260228174750.1542406-65-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit b2c04fc1239062b39ddfdd8731ee1a10810dfb74 ]

Running commands
 # ./perf record  -IR0,R1 -a sleep 1
extracts and displays register value of general purpose register r1 and r0.
However the value displayed of any register is random and does not
reflect the register value recorded at the time of the sample interrupt.

The sampling device driver on s390 creates a very large buffer
for the hardware to store the samples. Only when that large buffer
gets full an interrupt is generated and many hundreds of sample
entries are processed and copied to the kernel ring buffer and
eventually get copied to the perf tool. It is during the copy
to the kernel ring buffer that each sample is processed (on s390)
and at that time the register values are extracted.
This is not the original goal, the register values should be read
when the samples are created not when the samples are copied to the
kernel ring buffer.

Prevent this event from being installed in the first place and
return -EOPNOTSUPP. This is already the case for PERF_SAMPLE_REGS_USER.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Jan Polensky <japo@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index f432869f89213..9af7228d2d792 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -842,7 +842,7 @@ static bool is_callchain_event(struct perf_event *event)
 	u64 sample_type = event->attr.sample_type;
 
 	return sample_type & (PERF_SAMPLE_CALLCHAIN | PERF_SAMPLE_REGS_USER |
-			      PERF_SAMPLE_STACK_USER);
+			      PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_STACK_USER);
 }
 
 static int cpumsf_pmu_event_init(struct perf_event *event)
-- 
2.51.0

