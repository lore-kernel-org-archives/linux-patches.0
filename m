Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06722F28FC;
	Sat, 12 Sep 2026 14:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221974; cv=none; b=Hq1VPFE0YstOt5t1Rg9XnfbLl0fgyb0i9slR7IOd3JsdlhUZt3RYsQstLey7gFW4UbSYHYsX3GycRj3faeHOTs2vkVbDAvX0vTcoRuuiUiPAuCbjufyQ/mbr/gSkozJCwsY8F/52xRfD+LepxOhQAM5YNDFto5DkI1uiJ1f5O2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221974; c=relaxed/simple;
	bh=n5nm3gK8BOIpMZ/F3GqqsaiDdEqS6q/806CBSKf5oDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hzo7yOHQYVX2MeXsDjS18BOBbSngfulCpNfYW5rlLneRDKDLO4g4IVvVjX9ayPJ03LQe+BjIWDKdHCpPYrgjp6QKEI3Qe21+iTvLSnS5HoruP9uILjjGFmTnBrsFWYCOgR75kymTwV61rrbDyvhZt23NaMsamsruHE8W7NcIPNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TGcq9sz0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TGcq9sz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C24C11F000FF;
	Sat, 12 Sep 2026 14:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221972;
	bh=9xlK1Ur30XnlFyaWKeGKsOhHnm3Eh4NQiy9VQhEivTI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TGcq9sz0Bnvv8DisADx7ijepyQ9ax4ODyfxYgZZiN1LZA7vWeVto+ulpYLZi1im8u
	 bP9NRiDR6JMtNjX1JPnnTLlTQXbpP8EO6/zczTzuzoX3d7pw+hht2pyoW0EV4gPhhp
	 osfrsN4ynhwYmmAYkrZKk0kQRxNFyZ7bTWsTutXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0493/1424] scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
Date: Sat, 12 Sep 2026 08:48:45 +0200
Message-ID: <20260912065618.329659336@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
@@ -3488,6 +3488,18 @@ qla2x00_status_entry(scsi_qla_host_t *vh
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


