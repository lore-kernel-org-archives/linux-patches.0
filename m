Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B01D340A6F;
	Sat, 12 Sep 2026 18:30:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237846; cv=none; b=KqlhWEQX5l3APcvV373t7IskJb6sWiLP5NCYjFNpFGpNZKiIwQW71DODkXRJf7zT1m78GIZTtVSiBPLu5ykpF+1aBITuPwbqgL3rV9hfN9CyBcho33qZsRTVorsyKpYH0NVPwVIWt6YY8qEaKqhvZdQmKifkGSPyVXn7f+sxfoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237846; c=relaxed/simple;
	bh=2VoDuhStVnksa7HmBHSLEqK0bMs720lTaesGPZUYQn0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gHGexzEMne7rog55iKCEHXvpxCh5XhbQOO3vD3mPS3qtIsaEMPMJijV1NATm4TMlHEUvILXvYEeTuA6OxJWxb4uMPsa3P2nJ/HzjiLa5Ujhz1i2JBwmpFAMH3QqNZm9RDPXgqQEYYWaYDSkiUdVI3g7lxT/HcNi4bNo7WxTAxH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jd3CyfM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jd3CyfM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9D431F000FF;
	Sat, 12 Sep 2026 18:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237844;
	bh=Bc4GigSkssmP52IwIKmfNeHYWFhm2lNqfkz4LKypOOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jd3CyfM08RQxwwTahHIcLrmmB6hMIsqGA87K2ugT8DbFO6KlNLYcDHmf5vga8AIx2
	 qguleAnZkugSLu5mRtAPQcGIPRb1Nb2X1ZU63eyAo3TuwYClUzxZYAUopCnEkOebw3
	 GpK924QcsAYrF8BPnTW1XA5D2nGtNpxNzZzhIlR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 340/935] scsi: qla2xxx: Clamp MSI-X derived queue counts to avoid truncation
Date: Sat, 12 Sep 2026 08:56:10 +0200
Message-ID: <20260912065534.603616522@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit ebfd35c64433821bd5619a6d07ccc2df8b5b1de3 upstream.

ha->msix_count is u16, but ha->max_req_queues, ha->max_rsp_queues and
ha->max_qpairs are u8. Deriving the queue count as
"ha->max_req_queues = ha->msix_count - 1" therefore truncates: a board
(or a misconfigured/malicious hot-plugged device) advertising 257 MSI-X
vectors yields msix_count - 1 == 256, which truncates to 0. An MSI-X
count of 1 zeroes it as well, and in target mode the subsequent
"ha->max_req_queues--" then underflows 0 to 255.

When the count is 0, qla2x00_alloc_queues() calls
kzalloc_objs(struct req_que *, 0), which returns ZERO_SIZE_PTR. That is
not NULL, so the allocation check passes and the following
"ha->req_q_map[0] = req" dereferences ZERO_SIZE_PTR, corrupting memory
or crashing the kernel.

Add qla_calc_queue_count() to clamp the derived value into
[1, QLA_MAX_QUEUES - 1] so it always fits in u8 and is never zero, and
use it at all three derivation sites (qla25xx_iospace_config(),
qla83xx_iospace_config() and qla24xx_enable_msix()). Also guard the
target-mode decrement so it cannot reintroduce a zero (which would in
turn underflow max_qpairs).

Fixes: d74595278f4a ("scsi: qla2xxx: Add multiple queue pair functionality.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-2-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_inline.h |   13 +++++++++++++
 drivers/scsi/qla2xxx/qla_isr.c    |    4 ++--
 drivers/scsi/qla2xxx/qla_os.c     |    6 +++---
 3 files changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/scsi/qla2xxx/qla_inline.h
+++ b/drivers/scsi/qla2xxx/qla_inline.h
@@ -54,6 +54,19 @@ qla2x00_debounce_register(volatile __le1
 	return (first);
 }
 
+static inline u8
+qla_calc_queue_count(u16 msix_count)
+{
+	/*
+	 * Request/response queues are bounded by the MSI-X vector count less
+	 * the mailbox vector.  These counters are u8, so a board advertising
+	 * e.g. 257 vectors would truncate msix_count - 1 (256) to 0 and hand
+	 * kzalloc_objs() a zero count (ZERO_SIZE_PTR), faulting on the first
+	 * ha->req_q_map[0] store.  Clamp into [1, QLA_MAX_QUEUES - 1].
+	 */
+	return clamp_t(u16, msix_count - 1, 1, QLA_MAX_QUEUES - 1);
+}
+
 static inline void
 qla2x00_poll(struct rsp_que *rsp)
 {
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -4358,10 +4358,10 @@ qla24xx_enable_msix(struct qla_hw_data *
 		ha->msix_count = ret;
 		/* Recalculate queue values */
 		if (ha->mqiobase && (ql2xmqsupport || ql2xnvmeenable)) {
-			ha->max_req_queues = ha->msix_count - 1;
+			ha->max_req_queues = qla_calc_queue_count(ha->msix_count);
 
 			/* ATIOQ needs 1 vector. That's 1 less QPair */
-			if (QLA_TGT_MODE_ENABLED())
+			if (QLA_TGT_MODE_ENABLED() && ha->max_req_queues > 1)
 				ha->max_req_queues--;
 
 			ha->max_rsp_queues = ha->max_req_queues;
--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -2113,7 +2113,7 @@ skip_pio:
 		ha->msix_count = msix + 1;
 		/* Max queues are bounded by available msix vectors */
 		/* MB interrupt uses 1 vector */
-		ha->max_req_queues = ha->msix_count - 1;
+		ha->max_req_queues = qla_calc_queue_count(ha->msix_count);
 		ha->max_rsp_queues = ha->max_req_queues;
 		/* Queue pairs is the max value minus the base queue pair */
 		ha->max_qpairs = ha->max_rsp_queues - 1;
@@ -2199,10 +2199,10 @@ qla83xx_iospace_config(struct qla_hw_dat
 		 */
 		if (ql2xmqsupport || ql2xnvmeenable) {
 			/* MB interrupt uses 1 vector */
-			ha->max_req_queues = ha->msix_count - 1;
+			ha->max_req_queues = qla_calc_queue_count(ha->msix_count);
 
 			/* ATIOQ needs 1 vector. That's 1 less QPair */
-			if (QLA_TGT_MODE_ENABLED())
+			if (QLA_TGT_MODE_ENABLED() && ha->max_req_queues > 1)
 				ha->max_req_queues--;
 
 			ha->max_rsp_queues = ha->max_req_queues;


