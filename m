Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04E90213E6F;
	Thu, 12 Dec 2024 17:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024916; cv=none; b=uWECmpzhR81oa96DqEiJMLbhQEftWRVMZJXvpPyX5CnL5+IB/fXm+TpNZRFewwzSbVY/UEBJFcxjtpjfGXkrOluTvXGz44fRYvmbVJAfYPu/eXqxekWGUlnPMrXh8RaymFxDuhQhoyBLxDyDDW1r0DvtyAu8C4iXkeN5VLKxGtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024916; c=relaxed/simple;
	bh=LsjLRtZqdLabuLEuho4Uk60bhK3ZpxTl7WqQwoQ2uuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IsrOlDrG5YNPAKPfM32GYjAwjMRH/cb50Xk07zLKHIt2A4Oa9DdzCcBzF/FrDpP16MUncMIizn79CdT+lJZd4P+jBh6D+Evot8xkffpdHXQCcAjB6t4B0i9+DTcEW80Y6Zp4bmOT7LPXlV0/btr3Bmg6D66Q/5rXkEI3E8iLrjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQCNitCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQCNitCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817CDC4CECE;
	Thu, 12 Dec 2024 17:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024915;
	bh=LsjLRtZqdLabuLEuho4Uk60bhK3ZpxTl7WqQwoQ2uuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQCNitCOUCf86FhKXuvbwL4NE6x13FZzRbozjhLHcYl5qGnCD+s11NUa6I7kwysx+
	 qpIfQPJzfa4954dcMgAjJh47PBYtLtdnTJ7reNRwy3QSqKuuDFWmNWCY9k71i0gsXo
	 smwGrTeuBPjsI1Dss/tzg3f16WAW5+pEZL0W9ejk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 455/459] scsi: core: Fix scsi_mode_select() buffer length handling
Date: Thu, 12 Dec 2024 16:03:13 +0100
Message-ID: <20241212144311.744465393@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Damien Le Moal <damien.lemoal@wdc.com>

commit a7d6840bed0c2b16ac3071b74b5fcf08fc488241 upstream.

The MODE SELECT(6) command allows handling mode page buffers that are up to
255 bytes, including the 4 byte header needed in front of the page
buffer. For requests larger than this limit, automatically use the MODE
SELECT(10) command.

In both cases, since scsi_mode_select() adds the mode select page header,
checks on the buffer length value must include this header size to avoid
overflows of the command CDB allocation length field.

While at it, use put_unaligned_be16() for setting the header block
descriptor length and CDB allocation length when using MODE SELECT(10).

[mkp: fix MODE SENSE vs. MODE SELECT confusion]

Link: https://lore.kernel.org/r/20210820070255.682775-3-damien.lemoal@wdc.com
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/scsi_lib.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2019,8 +2019,15 @@ scsi_mode_select(struct scsi_device *sde
 	memset(cmd, 0, sizeof(cmd));
 	cmd[1] = (pf ? 0x10 : 0) | (sp ? 0x01 : 0);
 
-	if (sdev->use_10_for_ms) {
-		if (len > 65535)
+	/*
+	 * Use MODE SELECT(10) if the device asked for it or if the mode page
+	 * and the mode select header cannot fit within the maximumm 255 bytes
+	 * of the MODE SELECT(6) command.
+	 */
+	if (sdev->use_10_for_ms ||
+	    len + 4 > 255 ||
+	    data->block_descriptor_length > 255) {
+		if (len > 65535 - 8)
 			return -EINVAL;
 		real_buffer = kmalloc(8 + len, GFP_KERNEL);
 		if (!real_buffer)
@@ -2033,15 +2040,13 @@ scsi_mode_select(struct scsi_device *sde
 		real_buffer[3] = data->device_specific;
 		real_buffer[4] = data->longlba ? 0x01 : 0;
 		real_buffer[5] = 0;
-		real_buffer[6] = data->block_descriptor_length >> 8;
-		real_buffer[7] = data->block_descriptor_length;
+		put_unaligned_be16(data->block_descriptor_length,
+				   &real_buffer[6]);
 
 		cmd[0] = MODE_SELECT_10;
-		cmd[7] = len >> 8;
-		cmd[8] = len;
+		put_unaligned_be16(len, &cmd[7]);
 	} else {
-		if (len > 255 || data->block_descriptor_length > 255 ||
-		    data->longlba)
+		if (data->longlba)
 			return -EINVAL;
 
 		real_buffer = kmalloc(4 + len, GFP_KERNEL);


