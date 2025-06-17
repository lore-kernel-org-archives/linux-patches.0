Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400EE2ED15A;
	Tue, 17 Jun 2025 15:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175575; cv=none; b=MSu84gXn0d2q/FyH2CRXW26xD0E4cbJyJltrT+6s6BHxU4+V5fPNCwYKYiOrLXt+qdEfKMO80SU3puaOcAI+0+9bHitJZgVBUC0NH5FzN71F/V8xKEiYax3RmCxQA/EkYIJkJgqEEOleRqcOJsk8/sik8FyznhuUvk5+lXEXGYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175575; c=relaxed/simple;
	bh=/A8T1tYqtR83Jl8fIkwTvFFhi7k0h0Dn0zkxPO53t64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TO8LpLhEQA+J0gv6BF3kH+wsqkHId6ECz1nN8T+J2CXyF55V6ekcFZqcBcmQtw7DNL1RQhhWDiQ6TXBrznpSj0SzomzYhvyy4YerqgY3PH5V3AeOzsssoDj9XIvF9gYIPrL6RCtynMC5qgSBP8gPoMsMB+02zkomUQiiVEs3iYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkbTkz+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkbTkz+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A44F7C4CEE3;
	Tue, 17 Jun 2025 15:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175575;
	bh=/A8T1tYqtR83Jl8fIkwTvFFhi7k0h0Dn0zkxPO53t64=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkbTkz+JEnSJ+DEkgQqJR+co+Y2o5VuJWTHCRGAaurzTsxR2BdVrF0ZhL1atPNlZr
	 CvFVvTgLrhVqDiJ3O5O8NOkP1axKJQvEJkjPpGA7V996OFEZ54np1d0wwNDu6CcXnY
	 zZoRjMLkUstWkhuOTjvExhBGAPlzEOHFL6RekZu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Benesh <scott.benesh@microchip.com>,
	Mike McGowen <mike.mcgowen@microchip.com>,
	Don Brace <don.brace@microchip.com>,
	Yi Zhang <yi.zhang@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/512] scsi: smartpqi: Fix smp_processor_id() call trace for preemptible kernels
Date: Tue, 17 Jun 2025 17:21:49 +0200
Message-ID: <20250617152425.395128030@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yi Zhang <yi.zhang@redhat.com>

[ Upstream commit 42d033cf4b517e91c187ad2fbd7b30fdc6d2d62c ]

Correct kernel call trace when calling smp_processor_id() when called in
preemptible kernels by using raw_smp_processor_id().

smp_processor_id() checks to see if preemption is disabled and if not,
issue an error message followed by a call to dump_stack().

Brief example of call trace:
kernel:  check_preemption_disabled: 436 callbacks suppressed
kernel:  BUG: using smp_processor_id() in preemptible [00000000]
         code: kworker/u1025:0/2354
kernel:  caller is pqi_scsi_queue_command+0x183/0x310 [smartpqi]
kernel:  CPU: 129 PID: 2354 Comm: kworker/u1025:0
kernel:  ...
kernel:  Workqueue: writeback wb_workfn (flush-253:0)
kernel:  Call Trace:
kernel:   <TASK>
kernel:   dump_stack_lvl+0x34/0x48
kernel:   check_preemption_disabled+0xdd/0xe0
kernel:   pqi_scsi_queue_command+0x183/0x310 [smartpqi]
kernel:  ...

Fixes: 283dcc1b142e ("scsi: smartpqi: add counter for parity write stream requests")
Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
Tested-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Don Brace <don.brace@microchip.com>
Link: https://lore.kernel.org/r/20250423183229.538572-5-don.brace@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/smartpqi/smartpqi_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index d919a74746a05..8cc9f924a8ae6 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -5990,7 +5990,7 @@ static bool pqi_is_parity_write_stream(struct pqi_ctrl_info *ctrl_info,
 			pqi_stream_data->next_lba = rmd.first_block +
 				rmd.block_cnt;
 			pqi_stream_data->last_accessed = jiffies;
-			per_cpu_ptr(device->raid_io_stats, smp_processor_id())->write_stream_cnt++;
+				per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id())->write_stream_cnt++;
 			return true;
 		}
 
@@ -6069,7 +6069,7 @@ static int pqi_scsi_queue_command(struct Scsi_Host *shost, struct scsi_cmnd *scm
 			rc = pqi_raid_bypass_submit_scsi_cmd(ctrl_info, device, scmd, queue_group);
 			if (rc == 0 || rc == SCSI_MLQUEUE_HOST_BUSY) {
 				raid_bypassed = true;
-				per_cpu_ptr(device->raid_io_stats, smp_processor_id())->raid_bypass_cnt++;
+				per_cpu_ptr(device->raid_io_stats, raw_smp_processor_id())->raid_bypass_cnt++;
 			}
 		}
 		if (!raid_bypassed)
-- 
2.39.5



