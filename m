Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7C83382CB;
	Sat, 12 Sep 2026 19:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242156; cv=none; b=Mwn+KFZea0IesQYLjJBOrS/a0yhtuVPdNWQ+30YZrXs+S6F9kyptX7K2Nd6yMg3rG26wbAL2h5O7ujE/IRhSPf0pehRko0A0uwgyVjel5cKFVDTc3+fT/39gmUqzGFTMvbrQxYSo5umFbhCpVZMqb8Ec4zqTgiO9zK4XJ963S0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242156; c=relaxed/simple;
	bh=IGeg8OJl7iH8JLEsKoA+9F9QMIIowC7sWUZIYeFaXvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dyAWID12prwyyeQcmqWl6PuTAjut0ASVj43rCksIO2KsgoCXK036usMGoxiBdAWv3iymQ/E0HpO4q6iQsqr1ruevJqmOiWJ4LUb9r1aT/8myugtcbOItAeRxolPNFIVbGaDnkHc1HRxTU4EG1e3Utx7w+gMf/EJNF8NYwj1vZyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6M7nZ/r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6M7nZ/r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA5C41F000FF;
	Sat, 12 Sep 2026 19:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242155;
	bh=p9SmMlLG0oUktHHGUshXzqn/bLq7PM36qEltE15e/ww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6M7nZ/rmRWbnhun0N68hQhkXvihZg08qZrgkyy8LPaPC7ZkO84PNdr6TiDtzJyQ6
	 +fOA7tucVpi0VjUP/3wYPisLOnrfaO/AFP3IateQZ2tFgRUr6eBH4Z9S5Y9rG/F4it
	 p7qbwnYNzAepzDzYmk8z14Rr929jihsLXZwHi1dM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 305/798] scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
Date: Sat, 12 Sep 2026 08:58:53 +0200
Message-ID: <20260912065524.150904788@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit ca6d880d6c70cb7946e7b3e05d7285f271b6d99e upstream.

In qla2x00_status_entry(), the FWI2 status path advances sense_data and
shrinks par_sense_len by rsp_info_len:

	if (IS_FWI2_CAPABLE(ha)) {
		sense_data += rsp_info_len;
		par_sense_len -= rsp_info_len;
	}

rsp_info_len is a 32-bit value taken directly from the target's FCP
response (sf.rsp_data_len), while par_sense_len is the IOCB data area
size (28 bytes for 24xx, 60 bytes for 29xx). A hostile or buggy target
reporting an rsp_info_len larger than par_sense_len makes the unsigned
subtraction underflow to a huge value and advances sense_data out of
bounds.

The underflowed par_sense_len then defeats the cap in
qla2x00_handle_sense():

	if (sense_len > par_sense_len)
		sense_len = par_sense_len;
	memcpy(cp->sense_buffer, sense_data, sense_len);

so the memcpy reads up to SCSI_SENSE_BUFFERSIZE bytes from the
out-of-bounds sense_data pointer, leaking adjacent response-ring/heap
memory into the command's sense buffer.

Clamp rsp_info_len to par_sense_len before the subtraction so
par_sense_len can never underflow and sense_data stays within the IOCB
data area. The fix sits before the comp_status switch, covering both
qla2x00_handle_sense() call sites.

Fixes: 5544213be7b4 ("[SCSI] qla2xxx: Correct extended sense-data handling.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-16-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3006,6 +3006,18 @@ qla2x00_status_entry(scsi_qla_host_t *vh
 	if (scsi_status & SS_RESPONSE_INFO_LEN_VALID) {
 		/* Sense data lies beyond any FCP RESPONSE data. */
 		if (IS_FWI2_CAPABLE(ha)) {
+			/*
+			 * A hostile or buggy target may report an
+			 * rsp_info_len larger than the IOCB data area.
+			 * Clamp it so the par_sense_len subtraction cannot
+			 * underflow and walk sense_data out of bounds.
+			 */
+			if (rsp_info_len > par_sense_len) {
+				ql_log(ql_log_warn, fcport->vha, 0x3107,
+				       "Truncating bogus rsp_info_len 0x%x to 0x%x.\n",
+				       rsp_info_len, par_sense_len);
+				rsp_info_len = par_sense_len;
+			}
 			sense_data += rsp_info_len;
 			par_sense_len -= rsp_info_len;
 		}


