Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C879D85939;
	Mon,  8 Apr 2024 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583008; cv=none; b=IyUAkxPRJx3qvBMZ6rZiw2KlsLOZ0DbI5BrQ26/R8JQR6rzwQeQSGztWHNbTJFDzvUSQtGIa+ash19ciVArmwC91/1mhJsIPFbqO6W8x2q5JRBgupdd0Sf421qeveAswQzQIEj83fS9JTu0m2ASTlJwjzd/s+79vGaJ2R5Esc/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583008; c=relaxed/simple;
	bh=fXMIy29sDD2D9ohxeOdUp58mxc0vV7yQaOaG55d/Tz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tFqpgCdRqesxDi68XbrTkF22sA5O9aQ2VnMP2D5V1t5JHnwLaUCCZHM8IoZPcH4TjyfKNdS2a2dD+wXJAI2fZtMzOYEfzSkLSkh7PDM0nm/JTz2xNHX/MQxRF130l5uf/8HRPFx4Qq+J5v96VAL56FGlrwpNrb2qMmVMicVtVi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z6Lpljpu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z6Lpljpu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52206C433C7;
	Mon,  8 Apr 2024 13:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583008;
	bh=fXMIy29sDD2D9ohxeOdUp58mxc0vV7yQaOaG55d/Tz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z6LpljpurF1c6ROcuqYzPST5HaCPHiJzgnce43bTGFZBQjUc47iYz87Ul8N96KigD
	 EFeax8b2mEYss3Ost3CG9Nbnc1hF092rWg9ekF+t9MC9vgtrI+5McopKY0PhWDeK2G
	 +vzAUT56rLL4xHIlvyZMVkeOYDZxfMdHn2PSwodg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Wetzel <Alexander@wetzel-home.de>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 130/273] scsi: sg: Avoid sg device teardown race
Date: Mon,  8 Apr 2024 14:56:45 +0200
Message-ID: <20240408125313.328979478@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Wetzel <Alexander@wetzel-home.de>

[ Upstream commit 27f58c04a8f438078583041468ec60597841284d ]

sg_remove_sfp_usercontext() must not use sg_device_destroy() after calling
scsi_device_put().

sg_device_destroy() is accessing the parent scsi_device request_queue which
will already be set to NULL when the preceding call to scsi_device_put()
removed the last reference to the parent scsi_device.

The resulting NULL pointer exception will then crash the kernel.

Link: https://lore.kernel.org/r/20240305150509.23896-1-Alexander@wetzel-home.de
Fixes: db59133e9279 ("scsi: sg: fix blktrace debugfs entries leakage")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Wetzel <Alexander@wetzel-home.de>
Link: https://lore.kernel.org/r/20240320213032.18221-1-Alexander@wetzel-home.de
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/sg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 86210e4dd0d35..ff6894ce5404e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -2207,6 +2207,7 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 {
 	struct sg_fd *sfp = container_of(work, struct sg_fd, ew.work);
 	struct sg_device *sdp = sfp->parentdp;
+	struct scsi_device *device = sdp->device;
 	Sg_request *srp;
 	unsigned long iflags;
 
@@ -2232,8 +2233,9 @@ sg_remove_sfp_usercontext(struct work_struct *work)
 			"sg_remove_sfp: sfp=0x%p\n", sfp));
 	kfree(sfp);
 
-	scsi_device_put(sdp->device);
+	WARN_ON_ONCE(kref_read(&sdp->d_ref) != 1);
 	kref_put(&sdp->d_ref, sg_device_destroy);
+	scsi_device_put(device);
 	module_put(THIS_MODULE);
 }
 
-- 
2.43.0



