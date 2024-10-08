Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C9F1DA60C;
	Tue,  8 Oct 2024 12:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391178; cv=none; b=PwEddYreadmqg6IxlfN8r+rbpu58zti8wT/4KTnWFJK2BYcuu3FkDuqn+i8XsZFU4/4yRncAIFZ0LUsg9t664TmQoiB01pdby5X/W9kPezb0jAdFg2DDfH3wHAO85gmi21+e4q9Ri5vx+biilT6EmaUx6ZvMvz2pM8+WmXmcrkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391178; c=relaxed/simple;
	bh=LKAnu5NWEVGoLXGO+Lzck34prbi0IKvwiF0yEqluYo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fb9G+w/i/a/m0oKrEEtV9kXMpErCvgQmvVZzaPp9jGkAcuhfX0d+c1FIUJLFHo/fR1NgRMddfakcCPCkVw8nxFIHZmm9vgMVHHZp5rxXI387WKpyXaiCFt5l9U8nKjenZVnyoGDVm6BP8hnLJQ2GddyKId4p+iL3OnwrwZAsoN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wOEbMCCe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wOEbMCCe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C1D2C4CEC7;
	Tue,  8 Oct 2024 12:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391177;
	bh=LKAnu5NWEVGoLXGO+Lzck34prbi0IKvwiF0yEqluYo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wOEbMCCe5Wj/FldeQyv8IC5elDBUR7YEN4eTqsUXU/EC6LWektm/3ZjTKgzssfDAS
	 hri4BTZzvBDNCwIrXq0RBq2kyjNwA8tWepm7fRy7s9nAcdUUlYX4GlSkBCSRLp89uk
	 CYKkwbuId6O0Et6+BO+spRXgRmYmk5Mrp8ibkVD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rafael Rocha <rrochavi@fnal.gov>,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <kai.makisara@kolumbus.fi>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 004/558] scsi: st: Fix input/output error on empty drive reset
Date: Tue,  8 Oct 2024 14:00:34 +0200
Message-ID: <20241008115702.394795074@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



