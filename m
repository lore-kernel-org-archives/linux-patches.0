Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1EB57F735;
	Wed,  9 Sep 2026 14:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964207; cv=none; b=GHlTU6CWMW3o10gnsYMe7Kb1WS1NQsaiyhQ08b+nyjYwyHOFAdDFSj3e0q0KzSd/EGlCuiXz1Rrs8baB1xqLKcCKHha6bt09zTko9fdu7FC0vN+KvYmIEKIWLElmEy2Ukpz6mC42R4Dg81qKeR/z6jHHPEuXVFtv+1tQLxUfV4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964207; c=relaxed/simple;
	bh=RGZ37Ogs6/PDCeINSxfnSKQIlygCf4NTcOIipaJjH08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MEM0gH+vozD1LhI1O2HTZLdJw6UpfkfDVQ9DPFZBOOnr8w2ExtD5hfimBMEOLn8pEzZqD6om9h7RcoiaUyQP1Z/VOUsvhzeQYeN7/wNqnIL4CT9x3S/db4xG9fDG/UUQOpTctwNeEgFpm7InuWW1/HCAw4IskqBof8zR78zbgPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kntalsZ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kntalsZ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E2B1F00A3A;
	Wed,  9 Sep 2026 14:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964206;
	bh=VNkr6MJwDyzryWzYc1WRP3YlIktO16DKmWC5dZGSuio=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kntalsZ54pYSitmtkII+Y63f8GbweOXHtkQxrkjyAzo8YqAKCezXE0pxzO/ogUtQu
	 lADzv+xFmhw+4E5nbVVfeUGlnwGDdIgNi/Y3tL+JhrrDJuIhdbEHcg0+DNHKuFZ7Kw
	 faUtV3YVKDyTJpO04LkZPM4hSuqRuRrAAT7Or6PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 343/583] scsi: qla2xxx: Bound rsp_info_len to avoid OOB sense-data read
Date: Wed,  9 Sep 2026 15:40:28 +0200
Message-ID: <20260909134249.865411692@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3482,6 +3482,18 @@ qla2x00_status_entry(scsi_qla_host_t *vh
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


