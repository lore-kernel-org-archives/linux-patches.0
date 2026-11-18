Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023328;
	b=sSUsk7kUPK4E+0dV+VdDxNN7OypnCMKYm49xlYxgLiu0bp9Q5ziSFckEMU853LAZpntA
	 15Ai4GjCmiP7/qwphKygSdJhX2zQfMrQQlTr6egNbZG6j/Nkgl+ffMov6pnPIXRxQFzSf
	 0qSHsXFMKZjnISsgGsHilpmgwPlPcXhF5l/oPxB1jghEjH9PF3BxmVZQVoExFDzU+n/jV
	 kGW4unGyTeIMc1q3AuEvRwDutYQHa8Fe7fz1x+ZXmObMQJRR2BMFiktHNKtaazQvrvqly
	 2Fik+K5NnrsFNLch2buSv0rRBtdbK4RJ+71y6xbSKFy5fCZ6nnFm/ueUdx20mlsbcVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023328;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=09ts6G9NK7CP333vS79/5T9ydEtXatx3mJC5C1BbIMo=;
	b=sg5/+APrF3/bMZm+wy5+YVwXAmNlqvgm+X2dOHujuKg2IqjfGa27lKG5PDhwoUHcLC/m
	 vexb+HnK/83xUZYdEBw7EQTjsjMaEpyo8OLrguyUHf49uv6Tou3Ksu9imveyyejBvnarm
	 du2r4ONvwGPH9iysKgCXqIijZUTrO5+f6BFsO8x9308oFAV86NZw9mb91PUdoDp0eut3d
	 9hf4cB8QsB8IwfHmEzsLkoCGiBkMIH0ZuurAGtHy5BBX5ZGoi6RqucZE/0Vx4vobS24nj
	 acZO2MCYiT3Pk845a6sE+mtwHNnXdzrCdqHEwuQ9jN3qdoDPV4olQUE8OrojDiNn0vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IeXC6OPE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AD6606A32F;
	Wed, 18 Nov 2026 17:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IeXC6OPE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724BC1F000C4;
	Wed, 18 Nov 2026 17:35:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023328;
	bh=09ts6G9NK7CP333vS79/5T9ydEtXatx3mJC5C1BbIMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IeXC6OPETO6LBM0nURgbDmhL76yCEKvorssq3dABcHbmzpjq2D6hN9/P8X2dMsIqI
	 FmYs3DRpAsvYmI+dLUKA3al7Kx5Z362/ItMg0traksOLVp5vceoeZ0HNSzF12xOPzy
	 Kw16Sk5Dz/zCkwL6UrmEAmPffwOBI8LN60tBPxTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0329/2151] scsi: mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 18 Nov 2026 15:34:24 +0100
Message-ID: <20261118150133.976529068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit f0ec04bdf6156ed2ae7d86a8819dafdd9383b705 ]

The target device lookup takes a reference, but it is only dropped inside a
branch that also requires the SCSI target data to be set up.  When it is
not, the reference is leaked.

Drop the reference whenever the lookup succeeded.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-5-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index b0b12b5b423a7..653844ab2aac4 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2745,10 +2745,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	}
 	if (block_io) {
 		tgtdev = mpi3mr_get_tgtdev_by_handle(mrioc, dev_handle);
-		if (tgtdev && tgtdev->starget && tgtdev->starget->hostdata) {
-			stgt_priv = (struct mpi3mr_stgt_priv_data *)
-			    tgtdev->starget->hostdata;
-			atomic_inc(&stgt_priv->block_io);
+		if (tgtdev) {
+			if (tgtdev->starget && tgtdev->starget->hostdata) {
+				stgt_priv = (struct mpi3mr_stgt_priv_data *)
+				    tgtdev->starget->hostdata;
+				atomic_inc(&stgt_priv->block_io);
+			}
 			mpi3mr_tgtdev_put(tgtdev);
 		}
 	}
-- 
2.53.0



