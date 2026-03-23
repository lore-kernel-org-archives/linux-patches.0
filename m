Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B83E3AF66E;
	Mon, 23 Mar 2026 14:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275156; cv=none; b=F9Uvjm1n9o5P8lD3z9IFfW3ulI2D8Nuj9hbYo04Qx4ypwYlMnNAa2a/MiNoAGlCyfBECDiztzX5EaqTOR8SxSmsPk7DS+VgLL79Q53d63FVrAMZ3CsEBFnyTfYOa9w0DUacZn2yBbef/gWwsUHG3/tpt6XICOvLyyJLjMwc0ITI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275156; c=relaxed/simple;
	bh=MKHx/V7XYpdVorn9KndU5N5xWvdZ2OBY6+v13spQGvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWUsmcZqrBSzlUkyfV2L1nONT+MjZkMs/DVrS6OR06PNmDEnn6woSBPVWSNRS5ehKPKlZrqytEnJ+7Nmk7tILBhseOZe8RFIQAA49zphLE4BVbfX0Me5x0KdLSZ8j7KLOYHQh9TJHh2ripOkAbf949rSybE8iadd8bPdeZg2hFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQjwhFK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQjwhFK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0074DC4CEF7;
	Mon, 23 Mar 2026 14:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275156;
	bh=MKHx/V7XYpdVorn9KndU5N5xWvdZ2OBY6+v13spQGvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQjwhFK/+TCpb4cjQTTod+MEXkC7+Qx7zVNRQ+K08a71hT52rfMXX72GTmc+osZIA
	 p298P/4edgV/eCgFFrmn+YADi1Nsrn429eXviycVN1ZyWYOg6yl05U1gg0nQvey+4d
	 AXe1qp6tTyKhXU+2YQ5cOB4b1uZK/55lwRxNXJyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salomon Dushimirimana <salomondush@google.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/481] scsi: pm8001: Fix use-after-free in pm8001_queue_command()
Date: Mon, 23 Mar 2026 14:39:48 +0100
Message-ID: <20260323134525.413598844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 4cd648be68dde..e416cabbea4a2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -467,8 +467,9 @@ int pm8001_queue_command(struct sas_task *task, gfp_t gfp_flags)
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



