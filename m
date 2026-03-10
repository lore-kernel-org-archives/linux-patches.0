Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0EBF3806B8;
	Tue, 10 Mar 2026 11:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141646; cv=none; b=jFcM5Wmyj+hY9rLUdVeryAW/YB0/G0BLlxnk6a2RlYKrG4fVO4R9oEzj20FTJNGKwU/5Wfw+3cekLct3RBCzZL+38PWNzqmGARDjsKyc1qA2W5830crvrBxR70cRx1LkHH5bGvbMP+M88FXU7OQECgvtT+FDu8QVfxl6zqzGiso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141646; c=relaxed/simple;
	bh=zEpG4X6XLZuVfaa85S/7W5U/aas4ZoOAF74RmANNKlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uft1zFKrFa/7U4EYwmSVyJbDcmGnxYIu6PdSYfSxtkIKTGR94Aq0OvBG4hLLx/zvEw+3932FkhCR0qvdxD29zlCHsRzRFLAfrW7MR69/6bU7Erh6S4aVKqmTSSi40dQLhtfyutQvcQtvQT4zsihnChdCceFsxkgw3PvQQUPO0ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AADrt4wm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AADrt4wm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F035CC2BCAF;
	Tue, 10 Mar 2026 11:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141646;
	bh=zEpG4X6XLZuVfaa85S/7W5U/aas4ZoOAF74RmANNKlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AADrt4wm4sGXTDkbj1CdNMKaDrcyEHTJfulNwnGq0pUBMtRSyQOInyLzfds+UZ4J2
	 SR0jOvZOH/LukJidL1XKTfzJFVmT0UyP7MhLrjclFqjb0d1v1FColiUHWszERWLodj
	 uSNWx2E5Nsd9BM50e+w0eaSAfzNC6HnEuBCz323sIgWjP0FIqEmZe2DV93UC2K73lk
	 0WhSNZBSRQjZR8F1aBuyZ40hJC6AZgOkFgpDX8m0nzHiCvPM8CATF8MWBJG0cErixG
	 WXd1xF/tfIA/G+gehMXizEWzzFcufm4fBPkiY2vcNRI33CIIaR6XMKrgEG79sDIMEr
	 ksG+yorzxobIw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Salomon Dushimirimana <salomondush@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 012/314] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
Date: Tue, 10 Mar 2026 07:14:31 -0400
Message-ID: <3951d20c3d2b91b27b70371a1f6ad70367a2380c.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Salomon Dushimirimana <salomondush@google.com>

[ Upstream commit 38353c26db28efd984f51d426eac2396d299cca7 ]

Commit e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()") refactors
pm8001_queue_command(), however it introduces a potential cause of a double
free scenario when it changes the function to return -ENODEV in case of phy
down/device gone state.

In this path, pm8001_queue_command() updates task status and calls
task_done to indicate to upper layer that the task has been handled.
However, this also frees the underlying SAS task. A -ENODEV is then
returned to the caller. When libsas sas_ata_qc_issue() receives this error
value, it assumes the task wasn't handled/queued by LLDD and proceeds to
clean up and free the task again, resulting in a double free.

Since pm8001_queue_command() handles the SAS task in this case, it should
return 0 to the caller indicating that the task has been handled.

Fixes: e29c47fe8946 ("scsi: pm8001: Simplify pm8001_task_exec()")
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260213192806.439432-1-salomondush@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 6a8d35aea93a5..645524f3fe2d0 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -525,8 +525,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
 		} else {
 			task->task_done(task);
 		}
-		rc = -ENODEV;
-		goto err_out;
+		spin_unlock_irqrestore(&pm8001_ha->lock, flags);
+		pm8001_dbg(pm8001_ha, IO, "pm8001_task_exec device gone\n");
+		return 0;
 	}
 
 	ccb = pm8001_ccb_alloc(pm8001_ha, pm8001_dev, task);
-- 
2.51.0

