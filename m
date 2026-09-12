Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36FF1315D49;
	Sat, 12 Sep 2026 12:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217647; cv=none; b=omG21TANQ0zjn4s47uCgIdo9ZBCRQs2hlYSWdhcUVWTwFoF66Yo2bTqLBJYdLQY1drwRiUT3JT77NI6xpk7q3V5ul4opNrxXZHyhh3nuQTqxybOvbV3btejCVxcOkRN2QkpbjIIeLlTZ1gPJ+yZfFjkPDgDqGHg4Qgl502/YnGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217647; c=relaxed/simple;
	bh=Cy1RalddAhglnrl78YrljhHnJwE9gfExYf9rLfsr7Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gGVZSSNW9D8B78+Y3dMMQtsXpZC5sTeTb4dT3IV+XXbjbXzJ9K8mS9o5RbG5HFhZb9xXnBD6FJwzCbGzOko7VFHhTOuMXEleTqUnlUQDAA2c+z3z0rd0wbf8rs9HJGtfCq3ebAmxDxJsbSx3rVopdduOpiaUkjB+YoZi71pojiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mca05n0U; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mca05n0U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43A61F000FF;
	Sat, 12 Sep 2026 12:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217646;
	bh=HBB0hRc9dxJMs2diHkE882uJP5y+fBT6FwCT9HDQ/u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mca05n0UrfwCQomPqLFt3fLBxRjpBysEesiPv4iZWtBDt6Hcxq39iks9f1oIOf7lH
	 CtBWBajyv0CX1fE3Hz63x50kuOfzc7yFvrqAXF2048viJ0p0SPTwIVG8mvMSTf752+
	 mlkctVSvAbeW0OoudAYx4AfCvEDrEElTpzZ7knW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0983/1376] scsi: sd: Fix sd_done() sense handling condition
Date: Sat, 12 Sep 2026 08:56:49 +0200
Message-ID: <20260912065629.476831279@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 3edb2518a1852..3b32d9356b204 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2378,8 +2378,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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



