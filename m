Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D744F3FF8AD;
	Thu, 12 Mar 2026 20:12:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346334; cv=none; b=GrRktwtOB5UgdpVvO+2wlVjACnu4nTlq7rbwOj09ljOuahwfoLF0ais4bDHXffJ/8Ni77xmtY3zJ9eT7wbemQjMn/2jtfEFcATsIOb3GMaw/NujSh0Co/KxJTgHih59DTMjyDeTdxkIjeeczB3YQU5DozdrZwOh0FnHJFPS0Zfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346334; c=relaxed/simple;
	bh=7Fxl7dA6uT7V2BSVPi9y90JwdzzF9W+s0Mzz5pHRUPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVK+QFminOmSFHHTQngTteRJVJLhAs+ak1AvpfOgdYLDA+nvLvpvwSepfzqn90Zb0f/HDNJEYriKyxS28p+jMPTm3xmzctUixCsHeUIFhDffGjJTL5s1lJpqaH+Dw+BxZkIy6ysVVOcCbAOFUBNxou/+Fv1CnWccMcujCN3SERw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4u0sKdR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4u0sKdR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3B5C4CEF7;
	Thu, 12 Mar 2026 20:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346334;
	bh=7Fxl7dA6uT7V2BSVPi9y90JwdzzF9W+s0Mzz5pHRUPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4u0sKdRETXsWeAcuW8f1AJ5romjpDXhxr5kXNLe86+KRtFVofYe0ZYR3kXT0k7Az
	 WWUnLZeVTh6YHtF1q+gQ+3FdVmSM4Q3coEe4omDYTcV0tjwi4tI4lWxgDl5UO2859l
	 SL9xwiSqwr5owb7CNK2IdzaFeO0BwF6OcTfNg9yA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salomon Dushimirimana <salomondush@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/265] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
Date: Thu, 12 Mar 2026 21:06:35 +0100
Message-ID: <20260312201018.454970353@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 4daab8b6d6752..0f911228cb2f1 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -476,8 +476,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
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



