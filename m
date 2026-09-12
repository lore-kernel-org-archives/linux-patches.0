Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC8BC383C88;
	Sat, 12 Sep 2026 19:04:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239869; cv=none; b=ilN5fQkISkZq+I4z/Zrq3c5IkBbNXGze9Lqi2By7FoIuhlXSRNxXK2oyQOosS1ObK+oMpu1nYk8vm8f7ZGkt8dgIYk5V34I/Q5A/ouli0i/1vnBhYJGFDoi1bqBmAoYXNM9FNr3LNQOCi+7I7m6t2nF+ShaCZNFcl294T1hwrOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239869; c=relaxed/simple;
	bh=U6uFOnClMI6kzhDNDPp3sGoHJSkVVN5vKrXO1Qptjio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qoBMEGpIiLSxc9hvcY9njSL1yqQXR7Vjq0vz2N8rWJbJr4JLsnFMf3HC63VvQC/A0gYfx1C59/CPC1q1UG96w18UGgFjRn9vRcPAROo7qijfvbPh7428UQOIua+YUVfOQo3MZsHSDLz/ho3l9F2RX6DJ/bwFFF6cvzml8WeA8b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMOmUDN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMOmUDN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F38701F000FF;
	Sat, 12 Sep 2026 19:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239867;
	bh=DvsAlohJ4UgaFPqSt9KXXRa8Y1jfm8lUMW8Evqjmfgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMOmUDN+MIppEwvUQzv9Nzu21YGaN7ouT/GFa0jEhOBU+K12GwM0DiiS5gJsUNArD
	 larFmWAgS6irRodhecag8QYZ2q/sFbwnRpU3sHShDDsHTawa2MZdozpYGaCrP+PySD
	 QyuCN46M5icEYTIkUD5s3tYZbQydSG3bM8A01Dq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 751/935] scsi: sd: Fix sd_done() sense handling condition
Date: Sat, 12 Sep 2026 09:03:01 +0200
Message-ID: <20260912065544.057979599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 1e887c11e83d0..d83d4a876ce72 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2042,8 +2042,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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



