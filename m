Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B5A29DB64;
	Sat, 12 Sep 2026 15:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228482; cv=none; b=Cim3thyhKwd3E8p5Vs2oHD0OPad7Vb9CQOxcUQE8jsN5hZEGOmZg4ztTAAxXpzYzYLbExjBPuMEM4d3Dlrts5Wog5JCntnVRxFRJMtApQj6oEQWlXY5EB0qKjko0StwMh4gJLDeJ8qsLfs5VWEbE2bZMcqK7qz8ERYGBTHR6Fi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228482; c=relaxed/simple;
	bh=4zeBYJT9Si4kxn3DHQ2qah8C/xIUkEsa23BpIu0UQgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hf6L/mqRcn0JRzJlGuyKncs3kexmRFjEvmzjrtTgMGI+Vy2vV7mG76snRDSdPbVWlq84UtW1jpT85vgoLdMqmOPmP4BjvcoUK6XWVwqAuH//KwPf6YgELSJgy7pCy03VEs3pB/8/0h1qKLtCel7OZ1ODFbtZ207kcebYlpP3hRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BkRkk3VZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BkRkk3VZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD821F000FF;
	Sat, 12 Sep 2026 15:54:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228481;
	bh=TwuLAeQ4Y1uP4vKwacmP5H5/6YjGtBjEPrXGNhaJW74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BkRkk3VZA6m9PHHu3R4U9WYtbWclwWuGhdO4ubtgyFmwDqOBVBVhPjsnmJZhymQil
	 OCYqNMr4O/vlb/h+RXnULQzot++xe+mHyyVKyIM6M9BlUaMy9yho+UlDWRp3vSXHrr
	 00+RTtFX9RBYF2x7G8ss+niEhYMXB/nzAauwXNfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0394/1191] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Sat, 12 Sep 2026 08:52:02 +0200
Message-ID: <20260912065557.087247091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit de62cf265dbe309f34f144a6cdbca9240317727e upstream.

qla2x00_update_fru_versions() copies the user-supplied BSG request into
a fixed 256-byte stack buffer (bsg[DMA_POOL_SIZE]) and then iterates
list->count times over the qla_image_version array embedded in that
buffer, advancing the image pointer each iteration. count is taken
directly from user input with no upper bound, while only (DMA_POOL_SIZE
- sizeof(list->count)) / sizeof(struct qla_image_version) = 6 entries
actually fit. A larger count walks the image pointer off the end of the
stack buffer, reading adjacent kernel stack memory and sending it to the
device via qla2x00_write_sfp().

Reject requests whose declared count does not fit in the buffer.

Fixes: 697a4bc69159 ("[SCSI] qla2xxx: Provide method for updating I2C attached VPD.")
Cc: stable@vger.kernel.org
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Link: https://patch.msgid.link/20260723050413.3897522-56-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_bsg.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/scsi/qla2xxx/qla_bsg.c
+++ b/drivers/scsi/qla2xxx/qla_bsg.c
@@ -1578,6 +1578,13 @@ qla2x00_update_fru_versions(struct bsg_j
 
 	image = list->version;
 	count = list->count;
+
+	if (struct_size(list, version, count) > sizeof(bsg)) {
+		bsg_reply->reply_data.vendor_reply.vendor_rsp[0] =
+		    EXT_STATUS_INVALID_PARAM;
+		goto dealloc;
+	}
+
 	while (count--) {
 		memcpy(sfp, &image->field_info, sizeof(image->field_info));
 		rval = qla2x00_write_sfp(vha, sfp_dma, sfp,


