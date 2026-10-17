Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCFAC3ACEE0;
	Sat, 17 Oct 2026 16:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256008; cv=none; b=RXlG2y4LGF5tspj9gqx2IDsEKFFr9qtjZIRrtDo6LsNulCORoOtjc/vyTLK6bviF7COsXq85jIOefSlmJumrZ20hSn76upltqntpI2KLa+vCVaJe0gYLb2EK8nNW+Y9s+UtkwhqooSPBeoQ7GQoyBlW94Diprq9NzPoPOxWerog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256008; c=relaxed/simple;
	bh=kmdPsbhVeM0/S1vCyHVrzTmGMgREchGgIcbYXyekGGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RGeZ1EDPSoSvuRuS2pSjVz5cJtr7fOY/Nvq5Hp/podhTQ9NKkNNb6zNQOx5K93607V2fwObhErvr7vguoNF8gEvWvBNZhqah2ATsYbKyt0piLUyiSFI3i2SguZhNG5de0K+XbRlLVWwNuK518odVFMPnPiSph9E/B9CAI71/V7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S9dgHZBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S9dgHZBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4D91F000C4;
	Sat, 17 Oct 2026 16:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256007;
	bh=jfRaVEeGIULJb1gQzlA4gEps68r+k5PeIN5DdUdc0Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S9dgHZBnMT/7HbroypNssti4Xmu71hBpuJMFHhaV63Kf1V2xF9uPrE4spDs5U1ZCk
	 RIwHvLcBqplXAp2/aiQK4GRENJ3A3sYdWaCqgBGsfOBuZpMIqFfxEgju1IMyLeXn4c
	 uZLD1W2NH7FlB3iJdoE8spAG3EyN7qmZMEizDHOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0094/1674] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Sat, 17 Oct 2026 17:39:26 +0200
Message-ID: <20261017160433.558752644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

[ Upstream commit 7e51b6d2d8f6b7f48d9cef1cf87471b55b12f6de ]

__qla2x00_alloc_iocbs() open-codes ring pointer selection and entry size
based on IS_QLA29XX(ha): 29xx reaches the slot via ring_ext_ptr and
zeroes REQUEST_ENTRY_SIZE_EXT bytes, while other adapters use ring_ptr
with REQUEST_ENTRY_SIZE bytes.

Replace the two branches with the qla_req_ring_slot() and
qla_req_entry_size() helpers, and initialise pkt at declaration.  The
IS_QLAFX00 register-mapped writes remain guarded because IS_QLAFX00 and
IS_QLA29XX cannot be true simultaneously.

No functional change: the bytes written to the firmware-visible IOCB are
identical.

Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-24-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>

Stable adaptation:
This tree has no QLA29xx support, extended request ring, or ring-slot
helpers. Provide file-local macro helpers mapping to req->ring_ptr and
REQUEST_ENTRY_SIZE, preserving the existing 64-byte ring behavior without
adding functions or importing the unrelated QLA29xx support series.

Retain the helper calls and declaration initialization from this change.
Use a multiline packet-preparation comment so commit 626e44f3d8a9
("scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot")
applies unchanged, including its leading context. That commit remains
responsible for changing the FX00 clearing operation to memset_io().

Stable-dep-of: 626e44f3d8a9 ("scsi: qla2xxx: Use memset_io() to clear QLAFX00 request ring slot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 0b41e8a066026..1a3a276925b82 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -11,6 +11,10 @@
 
 #include <scsi/scsi_tcq.h>
 
+/* All adapters supported by this tree use the 64-byte request ring. */
+#define qla_req_ring_slot(ha, req) ((req)->ring_ptr)
+#define qla_req_entry_size(ha) REQUEST_ENTRY_SIZE
+
 static int qla_start_scsi_type6(srb_t *sp);
 /**
  * qla2x00_get_cmd_direction() - Determine control_flag data direction.
@@ -2286,10 +2290,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t handle;
-	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	request_t *pkt = NULL;
 
-	pkt = NULL;
 	req_cnt = 1;
 	handle = 0;
 
@@ -2343,10 +2346,12 @@ __qla2x00_alloc_iocbs(struct qla_qpair *qpair, srb_t *sp)
 		sp->handle = handle;
 	}
 
-	/* Prep packet */
+	/*
+	 * Prep the current request-ring slot.
+	 */
 	req->cnt -= req_cnt;
-	pkt = req->ring_ptr;
-	memset(pkt, 0, REQUEST_ENTRY_SIZE);
+	pkt = qla_req_ring_slot(ha, req);
+	memset(pkt, 0, qla_req_entry_size(ha));
 	if (IS_QLAFX00(ha)) {
 		wrt_reg_byte((u8 __force __iomem *)&pkt->entry_count, req_cnt);
 		wrt_reg_dword((__le32 __force __iomem *)&pkt->handle, handle);
-- 
2.53.0



