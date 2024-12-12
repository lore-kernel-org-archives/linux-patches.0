Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A145222D68;
	Thu, 12 Dec 2024 15:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016505; cv=none; b=J413lHf2yyj1smLCiEe7m9RmunNr22H9BEiukJ17a95QZa7rAs6EhosjKxJWkFcJD/Mj02aXy+NC4nU80+fi0chlGcQtCw0mlt9V6PGc2/aYbx8KlPk6Epc+yhgFD+tcxmnUn+yMLMav2SyFfY2wTUeY1A4MjE3qjA9ckR5KK3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016505; c=relaxed/simple;
	bh=I2oz1gYxnUPjAkLjH69w87Gus9oPJLSpl60urc0pZfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hECmjAchDIdhA9s0IZUiBlnHcDOpD7FeA42wB1R9w5StlyjsIH/rIwlI7dgNYi6rHUF+5+4x79fwpxlXIJUpiqTym76v5DVk2hsPi7e0tg+IO5HKIXGZcEGMXcgNE0LwDgZHmVt7acbukSfRO+IIz5S3lUgFO4lLI/h7RFQViJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOxR0w6L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOxR0w6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91693C4CED0;
	Thu, 12 Dec 2024 15:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016505;
	bh=I2oz1gYxnUPjAkLjH69w87Gus9oPJLSpl60urc0pZfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOxR0w6LSobWc6HIuDevDSwZjDpuxnXjtt7PDnYe9UTRGVa/+P0b13l+TTflNb4Lb
	 7cU/Ll3ZAQTpt46MSu0YhPqlcyBXUc/CDmBDp5x1DHJRCUEjbxMABx/m1S0H2TkwER
	 URcUIWPYmJLaqenv9dZiOPlrGz04FUNY5J/moWK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Hendrik Brueckner <brueckner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 217/466] s390/cpum_sf: Handle CPU hotplug remove during sampling
Date: Thu, 12 Dec 2024 15:56:26 +0100
Message-ID: <20241212144315.360018008@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3317f4878eaa7..331e0654d61d7 100644
--- a/arch/s390/kernel/perf_cpum_sf.c
+++ b/arch/s390/kernel/perf_cpum_sf.c
@@ -1780,7 +1780,9 @@ static void cpumsf_pmu_stop(struct perf_event *event, int flags)
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



