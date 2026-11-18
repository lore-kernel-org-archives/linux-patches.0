Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029319;
	b=opXt8gBRjhDiEMq8QEt0HT9bx3KonpzlMa+SGRR+6fX3aMX1BOClD5ZYRIuxNOkQtpnu
	 O/SlkvWxlyWvUPW4NTVzP6AN8SdXIjPrss/jpjKdoDH2A7H6lqCqW1alnG5qdl83yR1ap
	 S9gzqPLx2Acofo6kvLM1xjO912OSqK7r3ntobE1256Ut7KhTx1Z0ILx+eQaOE9m0BaOkt
	 qVONNXSyz0FzE1o5cVBxyG2t62nzqOlyoQD3Qn/77uRg1+dR4S9tGJYYBK6uX3dwWaw3o
	 QjDyqQoOcdeFwPRfxOCvYdbuNLyIDi4dimGExAWOr39l0V92ft2Qh+YGTBhgekTC14A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029319;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3g74nzSpIrIsquTmdbGRYCxU7BElndTy3QxJjX/GKKE=;
	b=kYwvcWXLM/jtIScR8wUtzrF8hiJEWFACKsl66jDrcaKGaPIl/yQbNChbdjJ3fyQ2l7oP
	 Jw7x03UCZr7TLL3DFn9rjSrUlHNbb1WZ39aREjFDforstvlJVZVHP0Imzjh1w7dFC/zbi
	 nfHrYOP3cTJFBvcyUORbbk2hZDXffeTdRdYvaBF7T7WhETU4UJTiRWP9CkMbuMgi4KcLh
	 jAXr282iVOh/TPLY5tiAeq06EwtUaRTtlv4915TTcj7uBQ28AtwbsmHrk2x9GNE6HPMH8
	 uo2YQyV97bxsKlD2JjRsiW057y5nvUJr0sWIYar/KHU8tPz3rohktrUtunwlZsXx0OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXqTNg6y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4108606A332;
	Wed, 18 Nov 2026 19:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sXqTNg6y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1AF61F0089E;
	Wed, 18 Nov 2026 19:15:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029319;
	bh=3g74nzSpIrIsquTmdbGRYCxU7BElndTy3QxJjX/GKKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sXqTNg6y+rTNJVjkNgxHJmqWES50x2uujsWxlRsUkOLBo9RgwOGgAuELsaiAWNSEO
	 vwMVeEL+pZk/0mIHAWAsxLMh54xl7itRcdafZRUbfvByseT9DcprC3HqhE1/SHTAlv
	 KoL15uiyBxGjzqpgbFgxSdUGjk9c4b+Oe+YkZYJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0306/1756] scsi: mpi3mr: Fix target device reference leak in device removal handshake
Date: Wed, 18 Nov 2026 15:40:33 +0100
Message-ID: <20261118150020.525859486@linuxfoundation.org>
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
index eb9477d70e681..b92026b350819 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2420,6 +2420,9 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
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



