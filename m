Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75EA247ACE2;
	Sat, 12 Sep 2026 18:30:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237817; cv=none; b=FOKY7/+1tj/x456ZH4DniJjdxrNo/n1mf/w2dBEqQQC7G0nK1jX7E8kvwbX021tV3LnNvPtBMBdI3jnXHp/CVJYYUJcO3Zjz1Lf4bmytEzJSCmIDNZ5HinGz/pRkRiHQ0IB9seLcrzf1nD6aJ0nODiiCs5RlDA6HhkctaHNkySk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237817; c=relaxed/simple;
	bh=BN7KKBFTPqZ/Lxu4FvDRy8vPNqJQwwDIa79b2chCn0c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQmFikoo0Ckp+YnupVRgvkAQcpm6ePSpkJPWnLfPoLpGKnNQe6oO/frjlLgzvsx7cavLzI4StVSdesHIajgp2uMN0XI2ym5sEwsQ6FqZ7ApyYg3Us8/1G+S1Ujq4c59ozwLiy3K77FRbOy7aQsuyBJ2YLHqJphpOF2KBi7yFURQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlxv4dYu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlxv4dYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF321F000FF;
	Sat, 12 Sep 2026 18:30:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237816;
	bh=fntxl1yOC9gsbss2tsZwfzEPCUqpT4eymx+6A2OZwkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zlxv4dYu5q0/KYac0I/NE6fKRzOlF4f5KxBqiJLkibM8wxAQVY6psPvpZNPpLV9tN
	 c6GY45ZhUe+x1BHYbT1ABXp57ImZ7knep0UJQU+zurYuNMgCI/hxP5hMUopFRYlddB
	 fh1qz5qlhVbCOdTeapDkivWBbVfIpPUALML/+QKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 334/935] scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
Date: Sat, 12 Sep 2026 08:56:04 +0200
Message-ID: <20260912065534.465778270@linuxfoundation.org>
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

commit 0918ee2c0eeb4d7f45b82b3dc11e65c2d9b7ad59 upstream.

struct qla_i2c_access carries a 16-bit length field alongside a fixed
64-byte buffer:

	struct qla_i2c_access {
		uint16_t device, offset, option, length;
		uint8_t  buffer[0x40];
	} __packed;

qla2x00_write_i2c() and qla2x00_read_i2c() use the user-supplied
i2c->length without any bounds check. i2c is overlaid on a 256-byte
on-stack buffer and sfp is a 256-byte DMA-pool buffer, so a length up to
65535 overruns both:

  - write: memcpy(sfp, i2c->buffer, i2c->length) over-reads the stack and
    over-writes the sfp heap buffer, and qla2x00_write_sfp() then DMAs
    i2c->length bytes out of the 256-byte buffer.
  - read: qla2x00_read_sfp() DMAs i2c->length bytes into the 256-byte sfp,
    then memcpy(i2c->buffer, sfp, i2c->length) overflows the 64-byte
    buffer inside the on-stack array.

A caller holding CAP_SYS_RAWIO can use this to corrupt the heap and the
kernel stack. Reject requests whose length exceeds the buffer before any
copy or DMA transfer in both handlers.

Fixes: 9ebb5d9c69f1 ("[SCSI] qla2xxx: Add I2C BSG interface.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-33-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1725,6 +1725,12 @@ qla2x00_write_i2c(struct bsg_job *bsg_jo
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
 
+	if (i2c->length > sizeof(i2c->buffer)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	memcpy(sfp, i2c->buffer, i2c->length);
 	rval = qla2x00_write_sfp(vha, sfp_dma, sfp,
 	    i2c->device, i2c->offset, i2c->length, i2c->option);
@@ -1771,6 +1777,12 @@ qla2x00_read_i2c(struct bsg_job *bsg_job
 	sg_copy_to_buffer(bsg_job->request_payload.sg_list,
 	    bsg_job->request_payload.sg_cnt, i2c, sizeof(*i2c));
 
+	if (i2c->length > sizeof(i2c->buffer)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	rval = qla2x00_read_sfp(vha, sfp_dma, sfp,
 		i2c->device, i2c->offset, i2c->length, i2c->option);
 


