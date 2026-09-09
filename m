Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2827E576EA8;
	Wed,  9 Sep 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962833; cv=none; b=Yr0PYkiiFmxWC86iBPfja4P3+TC43CY2sflrCQPkJd7cy10Wa12jHrnEdwj6vwLHbuFD1+iXSrNcvJHn3jfcpaGo2MGT2ILN/2CtfYx+fs6IKoqUuDUVevVXFhe+Cn4ypM59Ok6oqjwkIC84J/cRf6cN0qj2hA6oaO4qZCAIQQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962833; c=relaxed/simple;
	bh=D4oMT78tw+wDM/hWBEWJIur1BC+6yKE74auM27j8jNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ql2wyKHztO8nknn1KCOHREzIvmzhii2iBqkNF9JC9gs9AhPlr0mL2EYtt2e4yoCXh99Lvy1iGvmF25hkbBPuIu7NyYwT3SI0fqzOjduxQaagdwwqG9vjIsY++S9XY+Z3fJjo0wjKpwUAZmr7yLbhaychIWtg+2BFNk8x9U4wg3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEFlF9hX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEFlF9hX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 579F21F00A3A;
	Wed,  9 Sep 2026 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962832;
	bh=98plJHPxd0xhehzN7hd6PYR19uuOW1K3HLJDh1nnD9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UEFlF9hXJWVKN3iPz+imDThjv8nFWcvP5sleWatFYa8bGOjRHwjT3bCTGt3OFsoIM
	 uq9Aatste3ZfrGwVvRTvAZueT1wimZRu1r1s4fOc0N55STSDwxrGp7AkoKBdAfUlYa
	 htCRxM+rNGUlW1fBQi1oNcmFJ53sG9NPEf5aTRxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nilesh Javali <njavali@marvell.com>,
	Hannes Reinecke <hare@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 7.2 425/556] scsi: qla2xxx: Bound image count in qla2x00_update_fru_versions()
Date: Wed,  9 Sep 2026 15:41:45 +0200
Message-ID: <20260909134245.549897138@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1580,6 +1580,13 @@ qla2x00_update_fru_versions(struct bsg_j
 
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


