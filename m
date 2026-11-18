Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029302;
	b=r3OVXBlkYYBOSA4WAEyNi654KcoRy2nIT5G4MEMRHlD6JlDLHMhVfzJd3gRrpxhO3YMM
	 0fEFoq/PfKq7x2H0wf1cJcQA7AVva+qaDCA8pjBkRb8iDjstzAt0HQBZ7332vEkYGwklJ
	 Anxwtwe25AvjUyCXEMJjkZBVTjosoZkEy03SnxjzFUTsX3KVKJ/taQz8Wps+j+WhQBvhh
	 UogTv/FQlrBfBQrERZS0Z0XqMCjCv9MxtBxMO1fJgID2oLJBvMHrVMCJ2cU0DQUK3ZK+2
	 408AHwhv5DcyEM9TifX9KdNGN6Jpe0fSaINsJXECTsPxerAElySqnSX4rb0L2x5tHQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AUacwDbazBeYJ/jrFn1/cpXlDPaLcDeQeQH2LwrMElI=;
	b=AC7ofE929Op5BAlceK9OsEY8DyuHwOikegF1OBR25RVz3Vug/vuwnnKyni+a2miv+6NH
	 aDFsXaEZv+5aXrB6yv35i01pbWHnO0MrBwZA/+8KVn5uMo74ddBHn7EH3RGmqhjIch0b9
	 TYSnpNZSuTk7jOwyCFToKbtHhlzoXde+8kJA1Evb0NmW3sNPASzWFT9uPBn+LhL19wWgj
	 Mtc4Dsc+/iv9OUGs329jw5+oGKhrSsiSuIE5hG9PSRPucbCXKJlTQVjVzSM6Pp28KqbPt
	 UCe++ySxdtPJnvbPw5yl6RSnjDBmP6gXKgNZD0209XF8qEWrw6Zbph/Lvvxdz0GeUVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1ha3Kee;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8897606A320;
	Wed, 18 Nov 2026 19:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V1ha3Kee
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6376D1F000C5;
	Wed, 18 Nov 2026 19:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029302;
	bh=AUacwDbazBeYJ/jrFn1/cpXlDPaLcDeQeQH2LwrMElI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V1ha3KeeGzKv1C+nrHeNsPzoAeGIsAG212JiDIm8425sNoXqijY2F/KryIdh4J/A3
	 /H8u4vKsOia1UxobU1VLXbxNsGTiDn5nKPeNEl80T+J8LOoXEWYFlSIlzERy0YqwhU
	 JtKGHjmLnym52M421LU334dkwJpx3mMRtcHi4w2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0301/1756] scsi: mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 18 Nov 2026 15:40:28 +0100
Message-ID: <20261118150020.334351824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f08f5f7cf5753..b51dbb4404565 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2660,10 +2660,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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



