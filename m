Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D64937CD3E;
	Sat, 12 Sep 2026 19:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242241; cv=none; b=YwpvbPmFgm/UKIkp40nZtFfrZevYs8qD6pdWwUAKKtO22wH3yAA2jwHQQA9DtPsoAYhSF2WSx+9ud+v8itWsXhM8yp6rVWAxQeF1wyF+M6J0x9hMEkXDnzk+No5a6pOonHXvjM4WT9IpzeZunvv6C7pn+BxahomUEjpv5JixFXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242241; c=relaxed/simple;
	bh=QjBPeCzrhgKa/BZL7UBJKLIMXV9Ns8uA6ycbIj5ONjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDx9xL/cGaCne0tSyZC9sf+5rUIjNjFPkkGRq+vOLWmMtggkPkQWA+lKDrqV2r8SoKY7Xn2LZ/RqDJ6kYSE+LZoGDL7HgrYlSbkMCJeES3cwis1QE9NVl0YO1ubU25W/FEiGEMEQ+ZHxK97+pbRLHuzC/n12sfclhq/MGuKUqH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvBZWs63; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvBZWs63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A094C1F00893;
	Sat, 12 Sep 2026 19:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242240;
	bh=IqShI1qUB2YGFsgZBaMD7ZQwHShRYKfeVFwZ52XcZYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvBZWs63TTeaI6BaCtJwK2lXaCabvhXBGiYnP/VO9QstTCz0/NsOftybzxmwhNsbJ
	 9+MF3sqAaRkwI0ovdBiMFkAIPNZjus71UCVzjwJid2ETrY/3r4DP+R5IKlA3volDCI
	 EdWXjwj2MQxLSSrDRtAg0tn/1a8nz4BcHwmwSATk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 292/798] scsi: qla2xxx: Bound i2c->length in I2C bsg handlers
Date: Sat, 12 Sep 2026 08:58:40 +0200
Message-ID: <20260912065523.857033381@linuxfoundation.org>
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
@@ -1702,6 +1702,12 @@ qla2x00_write_i2c(struct bsg_job *bsg_jo
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
@@ -1748,6 +1754,12 @@ qla2x00_read_i2c(struct bsg_job *bsg_job
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
 


