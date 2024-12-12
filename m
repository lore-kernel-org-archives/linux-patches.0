Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D046353365;
	Thu, 12 Dec 2024 17:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023557; cv=none; b=nb5BCwskDeF9y1KX8Imqj99j8K03LxwwD43XSDwGSKSt63vMBvNMeB2b0uA1/sCr5YeK3AuxbEhhnONXY0Lgdi1EnzGwqrNT/+kW+ioh3O1m8GO/karGMHLVDLpCj0MxEcCbjcGVeTA0repnQaaC/9+IvY70XO1bvEJr4vgjFwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023557; c=relaxed/simple;
	bh=7ugiDzyqmtymFq5Q80d12FBNkHrb0qy9jYJqHvtgOT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nrd7vajnWlmrvgeAOGKNzBvZHLBpkkOwXVGFJjE1VxcWVqfmCQ+/aPK2b/CxBS4g4SJ6EzkVQUnMvFAf3jWqNuaNs5fyRYqhvVbdOlCI+WBsrmXtnaWnYJwtFS+VFK2TeZE0erwPhMu69/ziCKpQf4bDlhBpQZkLClC6brkY5b4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qAJIDiPf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qAJIDiPf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53EDCC4CED4;
	Thu, 12 Dec 2024 17:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023557;
	bh=7ugiDzyqmtymFq5Q80d12FBNkHrb0qy9jYJqHvtgOT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qAJIDiPfnhvt5p+lEGlJWFqQ8vaK4MQGXTje7hZOcHdJJ2RjDAeCNftT5pLOINcuP
	 RZXdQDp119vIuSjHfk8939Zs8emqx3Hn/8xF6XtysL20TRoZ5z6f+SU2CkxfuxPEtn
	 5tj6UZd9W6Sz3wy5xOfuBDOX/4erqT+a6+NmbiFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@wdc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 554/565] scsi: core: Fix scsi_mode_select() buffer length handling
Date: Thu, 12 Dec 2024 16:02:29 +0100
Message-ID: <20241212144333.762072965@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2044,8 +2044,15 @@ scsi_mode_select(struct scsi_device *sde
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
@@ -2058,15 +2065,13 @@ scsi_mode_select(struct scsi_device *sde
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


