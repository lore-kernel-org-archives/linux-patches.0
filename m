Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E544563FA1;
	Wed,  9 Sep 2026 14:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964166; cv=none; b=VCxSAoAF8OC60Xrz8HmYT9ZRWNWw7khbQ9wlkaa7v8ybyFpl39ajTue/a1f/v41CJDJGzU7Y7glPlb2R6PzO0IW0zGzXs47nnXVX7P6K4i8x5aBU5TylepgmZbDUQzKWGxJwpfjvCz8sr1NbNRAXXmxvib6/DnRj7TccrKC4bzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964166; c=relaxed/simple;
	bh=m8LRgwkDdZ3E6zRne2uR1cFwXPHk6hlYILt7cLRsPuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/HK5fOUkFXdSw9oX9dSNRaCg9ybF46Lv02lonrGa5Pz2ddXlMlG8WkZNGE4ptIZqilFfNX3IXYh3CLS7yZTrjzdZoppbmUiyjKJuItk+QPCbqYObXU6paDEitORM38tt8t955s5iiy+VlC5GyvB9r6oTeN5c7C588Kxuph2pvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnD0ZFnJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnD0ZFnJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7909D1F00A3D;
	Wed,  9 Sep 2026 14:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964165;
	bh=PG+Rn82cQlUECXPrbqDxz6MA9KlBsKy3OEI8hStTG9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vnD0ZFnJcQjh0ip0kPnzSrRDdQR+uT/alWchf/AYw1bg0jtOMN/yK2yYityLIJLmC
	 T92zsXGcC3aSzrqxd35E8tA4sIpd8GgDxAiTVn5FZ/H5dgA07zo7H6qEZ+AnzcjqK0
	 kM/+z97S3BnVjVGL1t114wdJL1K1HYsGWAGUzzfo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.18 330/583] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Wed,  9 Sep 2026 15:40:15 +0200
Message-ID: <20260909134249.431471860@linuxfoundation.org>
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


