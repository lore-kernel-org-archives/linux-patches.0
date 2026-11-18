Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029351;
	b=xoK0/sSlep/K0rBJWKliYynvLw3G4uTd5H75LPwG6cXCRRiUercYc91B61fyQEFkCVmQ
	 sJT6petbvHmjhZ9rlAeJE/1bf3rhoMQ1Lr/zyd8Vb62qUmJVNR29bUXiGm4Y5hc+xekNH
	 DsnarlsfWgqi5u+O8G7aNTZyN02h5MgY6HQ3/JMz12d5w46lMYB+B/5M5wCxc043Dcyq4
	 5HEChjD3fCAtdg9fUXN0mcO3rFkuMIVFc9hagouk37GBtMAmTh5dQcWC92BNEMTHOUa6Z
	 EwL3IJRdGc3KDvzEp4QtYJqTFlFexUP5FGMykxsgm7ry8x2K9CJSIbJqFYOxLDoYJrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kjyXrQLTWFEFa0r3u3d121QF8+MdeG6DOnFsT9+Tuyg=;
	b=2PuaM6tJQYPzwNnPAYTaWbznj5lCOjD8grZMIGd/2KCmXul9zXSMhoYLeWigT+xtnDUS
	 VKxaYSfpwjpbDSLmVI7c85noMEBDP0bzktAvfxXyyOcsW0zv9smmGIdLgRW6CQnSDtYXF
	 uWPXh+VTpdWtAEFh2owdstD2xWVTgoYENziBGugNg5cPdFtLeAh5bmR1YVPI1WwhPBJwV
	 HQZQa9CNCVR9guv1V9xfpGFnug257MDsn7RfEzrxz7+7zCDZBJNvKMxL4NnU1uHMah7Ok
	 aYX7mBxRhQROs44XCL+jmgyYzZ0UcAa0ePnLky4DwuqCfq+2pI/UIO3Ga9hiNZYyb3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmpc3yy7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55F3606A325;
	Wed, 18 Nov 2026 19:15:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hmpc3yy7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E721F000C6;
	Wed, 18 Nov 2026 19:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029350;
	bh=kjyXrQLTWFEFa0r3u3d121QF8+MdeG6DOnFsT9+Tuyg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hmpc3yy77TAy+laNcC/tg6xe49mcilQAFLNU1y34UKO1pTiKOs8jgFiTSFzIaWqXr
	 JDcVHvsWaBo9mOF9itfLeWrTfJHaZCB/ZSihjp6UoUVv5Uu58TQSxqF7mYzK4gaGQ+
	 C5zrUJglxaqeau0NUhTiQLVwz/pCegvkC47t/Ya4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0316/1756] scsi: mpi3mr: Fix use-after-free of the firmware event workqueue
Date: Wed, 18 Nov 2026 15:40:43 +0100
Message-ID: <20261118150020.888266944@linuxfoundation.org>
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

[ Upstream commit c94c746e6c80439a4a9a0e1e20f2dae62a4d57ef ]

The enqueue path reads the workqueue pointer before taking the event lock,
while the remove path clears that pointer and destroys the workqueue while
holding it. The enqueue can therefore reach queue_work() after the
workqueue is gone.

Move the check inside the lock.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-17-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 3bb0d96f58f8a..852849d42ea99 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -233,10 +233,11 @@ static void mpi3mr_fwevt_add_to_list(struct mpi3mr_ioc *mrioc,
 {
 	unsigned long flags;
 
-	if (!mrioc->fwevt_worker_thread)
-		return;
-
 	spin_lock_irqsave(&mrioc->fwevt_lock, flags);
+	if (!mrioc->fwevt_worker_thread) {
+		spin_unlock_irqrestore(&mrioc->fwevt_lock, flags);
+		return;
+	}
 	/* get fwevt reference count while adding it to fwevt_list */
 	mpi3mr_fwevt_get(fwevt);
 	INIT_LIST_HEAD(&fwevt->list);
-- 
2.53.0



