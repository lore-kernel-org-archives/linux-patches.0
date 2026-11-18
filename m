Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015893;
	b=0Z9uUFD4DKyK6eou+FowN65pwlrhjDIVN5wB3jZbOevrk30Ix/yhjf5MSL8tKW+UMYft
	 F6kL3035tAyWV3d1+aJohBszHbZ2Nw+MITo3rWtCMumTaQGMoje+o8wdyaZYABZXg7MDN
	 sqR36CRtfvURTw1BUIev614trzy+F1M5ru9gwuCcru6hDKQXCcA04d/9RtFXStMP50Jjz
	 ax9h9jJ0PdmPg67+qQDlpiKi1b6lNM61e5SzxBpNQVIltf7HhETyKn/aPF+w7P5Y8htrn
	 ZIOSmcsVIjPWqURX+570bZin0eMmWAbpB4L3wmZbwOUWopbJGKBszIeKuCZSVRtDsNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8oXyBnmcaOEhi0OQVz4EdjdpA6LM/6HfI+Povu+oWeM=;
	b=eEe2AXoOmHER152YvvHxLlzjP+hLzLoV3ffASpT+evFo08f0loKEP3G8BlkNcTTk7sSj
	 RLHVQU7b/N0X95dnFUaQDS4mMyChdAis9MBA5Y4pn2BQKvCpXPj6eqR6757qNM+nk1xtt
	 DB21Sy8SiB0qaUBgdk3N/dJYfoc+336nQz3GeRJ83FCbVkw3f1ao0mZ4rt6i8TbsaJ8Er
	 JxqJERUdknwjjTHC2mZ+LCzyDIBlk9wXyetd4T0sjUMpUtWASlacbcMH2GX//E+SXAttL
	 4dNE913Ctxj8ButQh5qfwQSNO6SHpLBjbi5T0Gl0v7rr7S9ourxwdPhE+yi9oVxBYPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SL+fSyR0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4D6606A33D;
	Wed, 18 Nov 2026 15:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SL+fSyR0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936171F000C5;
	Wed, 18 Nov 2026 15:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015893;
	bh=8oXyBnmcaOEhi0OQVz4EdjdpA6LM/6HfI+Povu+oWeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SL+fSyR06HAwADG5CsohJukqoc1mDfGgDRtcGW57CEmovwOD9su7U5p/seidcQQg2
	 2yi/3CSEM/+0wuHs1dYONEAePI0usUuF3R3G+hvfDntx3wJnNWcsdFHQ+GVS/xkGlw
	 vpHdChYpUheS4dnSC6DOZVIhkp0xfecLUBNQdfeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0333/2651] scsi: mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 18 Nov 2026 15:26:13 +0100
Message-ID: <20261118150259.848713420@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 461c488c8029c..c3c0469593d6b 100644
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



