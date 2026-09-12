Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6329311967;
	Sat, 12 Sep 2026 14:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221891; cv=none; b=ZpdvQXDrOfyKSxcp7MuN7saF/lUCWwxE+c4RvhjV/HgV3Xsje88qigDdJBZI0FyOI1BBC/pR7oSbj0d4/jjhsQdZyM/jgTRdb9uPtg+hAmGCWogkxscfCs7pbozCEK8WTPxSplyz5448d2XbDTqTyhXTtHTq2V0OFHrEQnSuPrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221891; c=relaxed/simple;
	bh=3c+fkpe/VZaeNjZ4xn6kwiqBixwAj6+dfrySVTBxSrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvFVIk4maQXNGDMn4luntmWbZvyXq5J9kwcGRlwZ//7qoFPGlpLcmqxv8Oy71rct/LKLJDSf//V0Gr6ya4OeOYtQWUazP5rhsIFHofT1GK2Qd7ojdoq26xu5CRCW8kSmPTMhGxJSRlPfqoWP6EvjtL17vPwTuxnxGFqe7mAbjJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OV+Hszzn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OV+Hszzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C7641F000FF;
	Sat, 12 Sep 2026 14:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221889;
	bh=KOIbGttaszymLxxMTNvhuSE54k7upDuTkQFwIyCJ6eQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OV+Hszzn46KDpmsna/jaTrYJcgQ77mMmsLWtPgDEz3hIsU4D9gKf/ESfpwGESz4RX
	 70AttUSKuus+j3gBOOVdWO/MU/cg64jjzjqUcZXumlbjdzzRtnhJkzGSvVvxoRcJa8
	 OTRHbBaEYn6LATonEHYOubHUmRUpjO7EsQaUg5L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0474/1424] scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
Date: Sat, 12 Sep 2026 08:48:26 +0200
Message-ID: <20260912065617.899965551@linuxfoundation.org>
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
 


