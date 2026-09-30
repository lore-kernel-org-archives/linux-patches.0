Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE329534453;
	Wed, 30 Sep 2026 17:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790012; cv=none; b=J6gaGoZ9N7QDpYG2x9DFarxETSYc4Q6IiXqWhfTaUIhBVKCQUYHZO746YvANUQrwkBLh+H6B8XPoOJ7mODPI9Z67q4m7ylTo90uIZVIOcwcROd1q+2M0W2vWTn4BpFdivm886EI38bGoPhLY3jV7E4wx9g1r/M1JaYJz85Xhm24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790012; c=relaxed/simple;
	bh=2XClZohgG1BPHjvJJk5YIEiZ8NYuH+bJ78w+qQAvIE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ghp4z64qA5x9yIY0Tmx6JZckB3EjPCl+Fnw/Y1rp7fGSk4wznVpbg99lYT7WpessTFhQvTJ/KXMm2st6YhkwwdQROmmMd4jYQLEDbvbm9wQryTAzUFcttIExeClU0mm2I95VLHgGTdkwUb39/C+DYmj5kV8R/EFABQkUpsAsZl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aoQWAWgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aoQWAWgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FFC81F000FF;
	Wed, 30 Sep 2026 17:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790010;
	bh=0rhpYPGOvUxsIEKCIy6WtBSpvnRfMU+1Z+LpeXZ+BZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aoQWAWgFn4X0ODe9O0B9Ov8Yplnx/rBUfuGoT8rrHRu2LFALWWpOEz3JAjFn7zVi0
	 dwhLmL8G9yDUA29Fjqq1VGZEYe/9pyUaMSxMbMoprv5mhgT79fxqzNxUU2rbCqVY+g
	 cH8TH0sDaaKGIf61XrZKgV3L1+ljRYSppq77LA6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 677/877] scsi: qla2xxx: Use ring-slot helpers in __qla2x00_alloc_iocbs
Date: Wed, 30 Sep 2026 17:26:28 +0200
Message-ID: <20260930152429.281952636@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

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
@@ -2286,10 +2290,9 @@ __qla2x00_alloc_iocbs(struct qla_qpair *
 	struct req_que *req = qpair->req;
 	device_reg_t *reg = ISP_QUE_REG(ha, req->id);
 	uint32_t handle;
-	request_t *pkt;
 	uint16_t cnt, req_cnt;
+	request_t *pkt = NULL;
 
-	pkt = NULL;
 	req_cnt = 1;
 	handle = 0;
 
@@ -2343,10 +2346,12 @@ __qla2x00_alloc_iocbs(struct qla_qpair *
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


