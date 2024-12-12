Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E038223711;
	Thu, 12 Dec 2024 17:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025719; cv=none; b=CNv7SYQj4p7ptDwqVIy9Ymvfpt871qsdabLBnuI4BmyGn9gb0Fgy8jIKwj+Xr4suJBuS3Gkmv4+23KQ0vFFTO2tcSx173vyJnR0PBTHnyj5Z7mAZjAXcMjpAPoMU9k9jBCIOxXT5v2CtVDbMOOXBhqwcniq37GW46dJX4yU8gGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025719; c=relaxed/simple;
	bh=ccpCDN3QgRnBR4bm+fgXRaXtRBPz5UDE/t0StJl8vfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiWUvObzxxTROWw6tA+ZFXTt/TWptTPTu1dg0zWai9mmcn/8qXSxWkWbtYamwvJye03VfH+lFdVq0R+qrTthZ3j9B+i0YP05qGGcVJAZD0QCsxAOkllNGZbzhK64NOJjLQKlZpa7Hd9fFRxsw8yo2ovwCWHop2zaHHKX1A7gizc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lAhz717M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lAhz717M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C704AC4CECE;
	Thu, 12 Dec 2024 17:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025719;
	bh=ccpCDN3QgRnBR4bm+fgXRaXtRBPz5UDE/t0StJl8vfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAhz717MGSdBbotcC12Lv4kKPkHOhtq0RZY1Z/zcMgKQ+9d0eHD5kOyal6EViUwh5
	 WdRRc8xJq6q9gHjr5H2DIDl2QFT3wKosibE/psauQri5Aj6ZECFaJlfUwugWa+mmlv
	 rKAvAd0a2m+xFUNRyLLBCdgO5ok7h82AbxIK2OSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 264/321] s390/cpum_sf: Handle CPU hotplug remove during sampling
Date: Thu, 12 Dec 2024 16:03:02 +0100
Message-ID: <20241212144240.412214457@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit a0bd7dacbd51c632b8e2c0500b479af564afadf3 ]

CPU hotplug remove handling triggers the following function
call sequence:

   CPUHP_AP_PERF_S390_SF_ONLINE  --> s390_pmu_sf_offline_cpu()
   ...
   CPUHP_AP_PERF_ONLINE          --> perf_event_exit_cpu()

The s390 CPUMF sampling CPU hotplug handler invokes:

 s390_pmu_sf_offline_cpu()
 +-->  cpusf_pmu_setup()
       +--> setup_pmc_cpu()
            +--> deallocate_buffers()

This function de-allocates all sampling data buffers (SDBs) allocated
for that CPU at event initialization. It also clears the
PMU_F_RESERVED bit. The CPU is gone and can not be sampled.

With the event still being active on the removed CPU, the CPU event
hotplug support in kernel performance subsystem triggers the
following function calls on the removed CPU:

  perf_event_exit_cpu()
  +--> perf_event_exit_cpu_context()
       +--> __perf_event_exit_context()
	    +--> __perf_remove_from_context()
	         +--> event_sched_out()
	              +--> cpumsf_pmu_del()
	                   +--> cpumsf_pmu_stop()
                                +--> hw_perf_event_update()

to stop and remove the event. During removal of the event, the
sampling device driver tries to read out the remaining samples from
the sample data buffers (SDBs). But they have already been freed
(and may have been re-assigned). This may lead to a use after free
situation in which case the samples are most likely invalid. In the
best case the memory has not been reassigned and still contains
valid data.

Remedy this situation and check if the CPU is still in reserved
state (bit PMU_F_RESERVED set). In this case the SDBs have not been
released an contain valid data. This is always the case when
the event is removed (and no CPU hotplug off occured).
If the PMU_F_RESERVED bit is not set, the SDB buffers are gone.

Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Reviewed-by: Hendrik Brueckner <brueckner@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/s390/kernel/perf_cpum_sf.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/s390/kernel/perf_cpum_sf.c b/arch/s390/kernel/perf_cpum_sf.c
index 4f251cd624d7e..6047ccb6f8e26 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1862,7 +1862,9 @@ static void cpumsf_pmu_stop(struct perf_event *event, int flags)
 	event->hw.state |= PERF_HES_STOPPED;
 
 	if ((flags & PERF_EF_UPDATE) && !(event->hw.state & PERF_HES_UPTODATE)) {
-		hw_perf_event_update(event, 1);
+		/* CPU hotplug off removes SDBs. No samples to extract. */
+		if (cpuhw->flags & PMU_F_RESERVED)
+			hw_perf_event_update(event, 1);
 		event->hw.state |= PERF_HES_UPTODATE;
 	}
 	perf_pmu_enable(event->pmu);
-- 
2.43.0



