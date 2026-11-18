Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039496;
	b=Gcs7bB44XVratxd6ixlfZHfAbCgPYpZsb3VqHECcH3HBdvjqpuSrsVrRWoWgdeDYq0DG
	 beHkofyzfhAvrjxNkAAOCiGhYIHdxBBpwKcDaQ2E7/I74P3z4bUx2Dqs8kYSLYD5GmDif
	 rpP3oayKWD8CpGEHezhRLQYF7+95NFDmpIwdK7uNWouP/ZOAJ7Y/Tg247yngzvInC5+7m
	 LVObrv0UhtvC5qfnPB7ZvwdXCC23IYezHrEktBdxA7nM57MPMtpJd8cjXeYd766bVCLK/
	 IyoywKHOwLHP2GryOZ+SZHjzZ90ZFddlsoZW7tbyKN+6E0exUP89R4VGhkfBv1Mrzmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039496;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tQTwgTC3PbpXfz3pWLw3j28L+JXTn7AcjKin/Y3sBfE=;
	b=PruVyzhWcB55i3NQHvMTZwMa7VNaHGOS3F8m6pHnyrIEBXdVjjZXRRUIMGeAudqOOZEw
	 6W1QkPEvzFseCHgGlZryJyxl4Hn5WqqsCQtMd+QpjlwdiEjpHZAbmvJK/RCp1h8COOHXK
	 Ge1clisCofi5RvJoQ99sqQIHG+BnG7pINao3HmRFX8Sl9v/Pklsq8pKJLQoAUJQ0Mi8yp
	 evNDmpEJhIB7uFhiFcjaILzYnA02qT9B5uZB3kvYrDZAu/9Hc627u6KEokN46CEDHeiB5
	 DiiQDrzN1DdW+WbaUUxjt+V2RdIQZfw4nZMTJBA5dpHW3eVgMW94SjVjNwTr9NXBuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qr3oSdWZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E966606A31C;
	Wed, 18 Nov 2026 22:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qr3oSdWZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B108B1F000C4;
	Wed, 18 Nov 2026 22:04:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039496;
	bh=tQTwgTC3PbpXfz3pWLw3j28L+JXTn7AcjKin/Y3sBfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qr3oSdWZS8iq4/TNl8WZciMd1ujhX/ZfW2d6NbdRKMhX8bOjKmcYJwLIJhjKNpyXJ
	 /EwLzVf6j7lzpbCeP9w7UME3GSpl+dzWU6aZtvSzZ/LkxmP2E3hDgXj17PTLgq/w0L
	 p7q6MFGnxV5zGKZvqaQEr/fGUx8kQQ1AtUovoVSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2121/3318] scsi: mpi3mr: Fix target device reference leak in BSG task management
Date: Wed, 18 Nov 2026 15:45:43 +0100
Message-ID: <20261118150425.690661074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b1f4e11d66089..cbe3c6f04b353 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1258,10 +1258,12 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
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



