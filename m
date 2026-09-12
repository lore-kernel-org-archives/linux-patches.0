Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29B7455181;
	Sat, 12 Sep 2026 10:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210308; cv=none; b=pEjvy67QEz5AlIohMQXDJsHylZu4olz7uNTrMi7nNTK1pT6hHso2mTprRh7GFQuOw2mXrJkE0D+PN1+OO2Ocq2Ec6zpQ8eX5aFw2lUN938Vwdwlxvt1D9q9B94ks/sByFgj5fyrT1cbxRVT1T0XnXoK6bYZ/wySIC1nBfS9nsCM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210308; c=relaxed/simple;
	bh=skG5rgvRgGpS8Qq7OWsnFJsgC/slngxEIoyUYTYsVQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rAPqpOtK19MoCrFprwQXB9y159Rwg5uWsTS+x/woVQEFkwySI6uhf7EoCw9uczZZh2OaFpt6IMrYBMre4e24F4t7dspCQxgX+DGkc35zLLQIvg/B5BrxDtvbRYVSalD7Xd+NXfuh8Ojyjud7SMOoelC0wUs2WDY11Zerr0vGqpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iOWwEQnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iOWwEQnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5BD11F000FF;
	Sat, 12 Sep 2026 10:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210307;
	bh=+o9xWH78qGKeHdrA6KIYqTW8uU7OiS5q7i/1SWj5BU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iOWwEQnSGuApRfgcc8SHd4moPUMCKYb8QWEm8nYH3kSDq4A/YXWQsZE+HluZZwCym
	 RsgKk1KsEnLqxAxRiePnbFrP7PmXDshcYNBTycE3NV42Ettp52Ou7Ftp9/hFLEiXmx
	 H2a67KJLRfzhk/4NslXE43VsPzM2XQ04M899P+1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0998/1518] scsi: sd: Fix sd_done() sense handling condition
Date: Sat, 12 Sep 2026 08:52:47 +0200
Message-ID: <20260912065646.032056508@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yang Xiuwei <yangxiuwei@kylinos.cn>

[ Upstream commit a640d4546b11be5709a82bdc63d7dafd8ddc6c9e ]

Only enter the sense_key switch when the command returned CHECK
CONDITION with valid, non-deferred sense. The old condition let deferred
or invalid sense fall through and mis-handle the I/O.

Fixes: 03aba2f79594 ("[SCSI] sd/scsi_lib simplify sd_rw_intr and scsi_io_completion")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Yang Xiuwei <yangxiuwei@kylinos.cn>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Link: https://patch.msgid.link/20260707030333.22245-4-yangxiuwei@kylinos.cn
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d44cb802a2621..ff6b953da68a7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2384,8 +2384,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	}
 	sdkp->medium_access_timed_out = 0;
 
-	if (!scsi_status_is_check_condition(result) &&
-	    (!sense_valid || sense_deferred))
+	if (!scsi_status_is_check_condition(result) ||
+	    !sense_valid || sense_deferred)
 		goto out;
 
 	switch (sshdr.sense_key) {
-- 
2.53.0



