Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 673C4288B9;
	Sat, 12 Sep 2026 16:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231294; cv=none; b=TsA02tmJU3gtS4IxXto2ztb+bssjPmeQhWxtQoO8arCdqwDSRoBzEYf4QC3NI2BJuY5B/3lLPNIVRhK+mWATQZRBLmEJjapYjQWe4hkufvuDDAKNYJDtwVex5aRw5sNYOIhp+haOEh4L2fHLy2R++YMhFoytobLN7dFNwfh8m+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231294; c=relaxed/simple;
	bh=44c5xN4Qr8sxcRWMfA5bTxfIx8kDwTUly71NLeSv3yE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qd2KUvsNghJWN40oKxoHAmtLM8TwgHiLi0cQKsP9ywwJJff3d01/7INB7dI9L84xl8abFPEIiNiHxIwUVpYLOZ4aoR5n8wOH+k4mL+UP3EjSpnC0SrTIKGQ0b0qUJVWNyQTNSGjYGz3zW1p+AcmW2HrWBb9MxaYsJ0B5fURQrK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ytdYw79M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ytdYw79M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423EC1F000FF;
	Sat, 12 Sep 2026 16:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231293;
	bh=zIk7vuHn4BgCEHivLs4oIiuj3VnDhBnOMSreibeQCz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ytdYw79MdrXESwzoGNbSI8g5a9t5eEnkJ08Fbm3t2wiM8bJ+gH7Vhi7vROZIgoyvU
	 kQnt/UFrS59xgAbeXjkN3muv6xmeQC/Ab9GrkVsiguKnIl+4z4NipF/fvB8ulVQMVg
	 9Cfv2AE8XBirdoZbybi0glH0LcgMfgmAW6u7Hxpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Yang Xiuwei <yangxiuwei@kylinos.cn>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0926/1191] scsi: sd: Fix sd_done() sense handling condition
Date: Sat, 12 Sep 2026 09:00:54 +0200
Message-ID: <20260912065609.029637385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 544b6693ff181..5e6e5753387d1 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2053,8 +2053,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
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



