Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015950;
	b=a5R7h6rQyyJFuueg4gWZ66t8bPhsaLKWFl+YKFLusdAraSoRKbK5igg+6DakV63DxUDr
	 vBFVnScGW5FOAZYu3Oq3qSNT3JvQupeeHY+JFu+KTW5gwARMyD1B5Bd7fBv+a4+Jrrp3Y
	 ObgQumrO1KdfWd+R44WbNjzOqItyHGDH1s8k/ahINDw8lkdnt6VR/06SUVZ/qjtVSt+3q
	 448d+0LJ4tpB4bvJI1FEOl4BiNs+2ckWr6QKGPkK5B0m29GL20KLzimFf+3+wfX6NjB2t
	 Ev1SokezwTQFqKNY6Lq3ID58y61t2qi7ddkrDrhn412Liu4koHxHrAjVjsBOc71FyYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015950;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YoJQdLYMQZjx98X8+P1ETRHqOtKdYCF7nOrC6EjxpBM=;
	b=QSnJLDuID+hOhrcLtJRQRdwIievYPWRl5fZJ/VxnrsVRva5gsuLejreAv0G92lFHZvm0
	 CnzwvPVK8a6LKOghb3sXXEJtyOqaq/ProFi5HPSUfhivSFcDNrwxPfHed8a/UxSpPvJbs
	 62GJ6nwqf2x6RB750GMo7i22pgpvgd2yPkX9ZlX3SMmGCA98WyEw46XXDV3czRygriMAi
	 cZvFaWiTqtds+WFYsriG19AY8pOG7BAbfnRddRZB8fA/z0eMovVHr5DDWpX5FOfV4YnVj
	 HZbZKciWYBoykojbMJ6b8iPqonsJIWq6GSw5LvZmZZJ0B21OG15WPiwy2I7L9q4V6Nw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UV07UQao;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8CDA606A330;
	Wed, 18 Nov 2026 15:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UV07UQao
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4464F1F000C4;
	Wed, 18 Nov 2026 15:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015949;
	bh=YoJQdLYMQZjx98X8+P1ETRHqOtKdYCF7nOrC6EjxpBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UV07UQao0LOXjVyWb4XCmqxlpL2a7J/hXYQ+x1qxxcvOFGUp+zPgvH3G3gp3W/6ae
	 KRnQ/joQ3jWa/RDRPgjhEamE7hOIrLv+QlhPC271C8giowaNm3gdT66AFCRu0pDTG+
	 cQROd2gZspfvrtBR6pG+9nf/j1zAE/y7VYnLrWkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0338/2651] scsi: mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 18 Nov 2026 15:26:18 +0100
Message-ID: <20261118150300.020241058@linuxfoundation.org>
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

[ Upstream commit a04b0f3a17e32aa449fd896163a7b40efc29c4f5 ]

The device removal handshake looks up the target device to update its state
but never drops the reference that the lookup takes.

Drop it once the state has been updated.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-10-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f146c1b7bf8d5..6cfec6ae82f22 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2561,6 +2561,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 		tgtdev->state = MPI3MR_DEV_REMOVE_HS_STARTED;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
+	if (tgtdev)
+		mpi3mr_tgtdev_put(tgtdev);
+
 	if (drv_cmd)
 		goto issue_cmd;
 	do {
-- 
2.53.0



