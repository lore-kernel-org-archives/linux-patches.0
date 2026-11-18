Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048031;
	b=TEGUy1tNIqSCKTgU9WHlj9pVvVk8T1mJj0gFrQww85etcUz/gAAHeWW7amacGzxuYRKB
	 DFGQCr0GPcB1YKL8Qc5TMij/ZsbFOzKXCUp/fYRbt1neqw/rur/0jgvdOeMxPP44QDe7H
	 MnDCkpzdgAPnhRO/x3bLd51a98vOV+ee5zdPps9vEdxosmj2Xw9M8SApB8M5NyTIaHM5N
	 kK2AkbTYu5JcchHGqGusTPw506fHvkdN7AXLTdvJRJY4+Rxw3pv6plo+X0hrGlQSPnz2r
	 vVrn4iuATxMBMCY28Ak52uwO09lbh0Tova+kWDCAf7vucHCAaBDVwlahquYWjJSZO/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048031;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mBz0YvcffpA6Y99+LMMpZEAGJDxJ9NjvCl/pGtD41fo=;
	b=TItmlPBakYNutZgcmWKXXXg5AuFF5q+Yvnt1i5s9Cg9bw5srLLL89NWIIMX8cGHlfHMk
	 0jCzToCb1RhJMeKI5SmTVWBmvkrdWefcmK9lbMgPIJatZsgifFsBSQ8I9lhhdKEgTq9TW
	 WQIPaTLXgD+waA+W9f1QQ6MZg54ThsEgCfgjrzGaQvp4Fm7pqzGRxUxFlc6oEUsfuSLYd
	 DkU+5w6epcwCabC5Eb9408dG85HwnxHOECb2S1ADzDneNXO3VBAwgw7rNlVHV68Rm2tuh
	 8+qaPJzj8anvCdbdg+o0Yk74khMyUNZQaGmztdlVNDMqvYiB7DrGYWLkaEHQYs06l5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MT9BvRwd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CD74606A31C;
	Thu, 19 Nov 2026 00:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MT9BvRwd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3D921F000C4;
	Thu, 19 Nov 2026 00:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048031;
	bh=mBz0YvcffpA6Y99+LMMpZEAGJDxJ9NjvCl/pGtD41fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MT9BvRwdHYT/RSq0lY7D/gQabu1z87a9HGY7HGdVNW7nTE75qEPENgn96gHDDwwhi
	 DUYFfFjyxQ5CZc4IuPDtk546M+Sozab89Ui2VY1J/X8+/GF7HvJXz+JoqfB88woWNt
	 oJ4TJyrmH42tdPaXs9w4E3JshUMN4Zef7ghyG3lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1849/2857] scsi: mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 18 Nov 2026 15:48:03 +0100
Message-ID: <20261118150307.819704800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 10f37058403ec..68d4d9b42f297 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1257,10 +1257,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
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



