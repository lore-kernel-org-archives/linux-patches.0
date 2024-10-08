Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1598E1C32EB;
	Tue,  8 Oct 2024 13:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392999; cv=none; b=qq1RolxvfT2YbR2AoI1tSP3/c/c8WjNr8ODBSpsSbhLc0ALnyl3CyJ0o6KtpgNvBgLt6eIFYAjK/2D+/+UuRFB9hRvc3HX7TUlP2779LKWiAQWJhZiUkd2sur3+bCCkqU5TyiQcPSqhtIu45bM65MzdXctb0Cv2Mvc3G3a3fCHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392999; c=relaxed/simple;
	bh=xQzooaX1KHJEjozG3imatkKCu8BNt4ZkkaPZhOC2mRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=G8HnuH/wbl2stpCEJRl0+3UbMH/RpzaBjfPmtFlFS8zEe0/obsy1x5itZ6dCOu13mdwI1FCPTNUQkR2XZmsDbOU33W/mj8XMi1Q9H1fCUyEkcQ8Il7wKHS/UkRQRCSNM2FqX4GAaQca9DbLwRdPQN615KDFiH4liNqg+yz/Cz38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YssGvg5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YssGvg5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D8F1C4CEC7;
	Tue,  8 Oct 2024 13:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392998;
	bh=xQzooaX1KHJEjozG3imatkKCu8BNt4ZkkaPZhOC2mRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YssGvg5kt0fRON1uCTOymp9vvLAH1TOyoUQGCYEAJchKRM7WSB8azqtLBqCcDwGPn
	 sqlqfMzUUrJT6NrjHsPOw+h4ynM6SRI99dx+RbGM893FMHVzodJlJ06C2dsuYscM+/
	 7U6qbjVXAwGNMUfYSJAAQmQP7wykGUC1WRMFgUK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Rocha <rrochavi@fnal.gov>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/386] scsi: st: Fix input/output error on empty drive reset
Date: Tue,  8 Oct 2024 14:04:10 +0200
Message-ID: <20241008115629.529143339@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael Rocha <rrochavi@fnal.gov>

[ Upstream commit 3d882cca73be830549833517ddccb3ac4668c04e ]

A previous change was introduced to prevent data loss during a power-on
reset when a tape is present inside the drive. This commit set the
"pos_unknown" flag to true to avoid operations that could compromise data
by performing actions from an untracked position. The relevant change is
commit 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")

As a consequence of this change, a new issue has surfaced: the driver now
returns an "Input/output error" even for empty drives when the drive, host,
or bus is reset. This issue stems from the "flush_buffer" function, which
first checks whether the "pos_unknown" flag is set. If the flag is set, the
user will encounter an "Input/output error" until the tape position is
known again. This behavior differs from the previous implementation, where
empty drives were not affected at system start up time, allowing tape
software to send commands to the driver to retrieve the drive's status and
other information.

The current behavior prioritizes the "pos_unknown" flag over the
"ST_NO_TAPE" status, leading to issues for software that detects drives
during system startup. This software will receive an "Input/output error"
until a tape is loaded and its position is known.

To resolve this, the "ST_NO_TAPE" status should take priority when the
drive is empty, allowing communication with the drive following a power-on
reset. At the same time, the change should continue to protect data by
maintaining the "pos_unknown" flag when the drive contains a tape and its
position is unknown.

Signed-off-by: Rafael Rocha <rrochavi@fnal.gov>
Link: https://lore.kernel.org/r/20240905173921.10944-1-rrochavi@fnal.gov
Fixes: 9604eea5bd3a ("scsi: st: Add third party poweron reset handling")
Acked-by: Kai Mäkisara <kai.makisara@kolumbus.fi>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 338aa8c429682..212a402e75358 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -835,6 +835,9 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	int backspace, result;
 	struct st_partstat *STps;
 
+	if (STp->ready != ST_READY)
+		return 0;
+
 	/*
 	 * If there was a bus reset, block further access
 	 * to this device.
@@ -842,8 +845,6 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	if (STp->pos_unknown)
 		return (-EIO);
 
-	if (STp->ready != ST_READY)
-		return 0;
 	STps = &(STp->ps[STp->partition]);
 	if (STps->rw == ST_WRITING)	/* Writing */
 		return st_flush_write_buffer(STp);
-- 
2.43.0



