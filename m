Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B1D1DE3AF;
	Tue,  8 Oct 2024 12:12:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389529; cv=none; b=rm6+N1mIJdHwje3C3Cc6uxJWtgCvUMzr+gGIt95k/d8ynkKovKJwISE7HzRHEHOGwooTBB7nXXb576AZkiUNWx1myIRpli03o2OqqfJg7O5W+1cxgV/RPFCkJ9u3XuW2wS0unTP9nrgHYKfzQggEmaMOD8wK+/heI4YGT7luhgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389529; c=relaxed/simple;
	bh=qFVZwXtP7Tny8KDORDICvCkMM2RH8x1K6/5Mn9gwqEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MViWHPkiU49EEtAFj5wkVcNKprjuzf5B0RM2/aNZTucZS7tujdsoTn52ehbnqwWsYgKsTkdjc0fLTr5k8K5CculQ/hrroF7viQLyIcoxRhkgliU06aBn7NhGo30cPc8nkJOj9AqaRXLJTM3YRy8Icv/mX8oqOK3f7HTwe7GGv9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rd4rTDdJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rd4rTDdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42EA5C4CECE;
	Tue,  8 Oct 2024 12:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389528;
	bh=qFVZwXtP7Tny8KDORDICvCkMM2RH8x1K6/5Mn9gwqEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rd4rTDdJIwM+ckqhYohkZlDa1bsi9t6FVkozAUlIS1+FIBo0V5GGGj9gN7U5fZiU5
	 NA++M672JprBzu8SUNRTSQMiEPvSci3N2b2S80HYOqg1KYz6HyPUEjyf+AiEiyHwPE
	 bm9EIu0POGjtbT20UyyRm2tmKGziDyMfCuW27riI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Rocha <rrochavi@fnal.gov>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 005/482] scsi: st: Fix input/output error on empty drive reset
Date: Tue,  8 Oct 2024 14:01:08 +0200
Message-ID: <20241008115648.506201941@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0d8ce1a92168c..d50bad3a2ce92 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -834,6 +834,9 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	int backspace, result;
 	struct st_partstat *STps;
 
+	if (STp->ready != ST_READY)
+		return 0;
+
 	/*
 	 * If there was a bus reset, block further access
 	 * to this device.
@@ -841,8 +844,6 @@ static int flush_buffer(struct scsi_tape *STp, int seek_next)
 	if (STp->pos_unknown)
 		return (-EIO);
 
-	if (STp->ready != ST_READY)
-		return 0;
 	STps = &(STp->ps[STp->partition]);
 	if (STps->rw == ST_WRITING)	/* Writing */
 		return st_flush_write_buffer(STp);
-- 
2.43.0



