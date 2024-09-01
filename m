Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5879F183CBC;
	Sun,  1 Sep 2024 16:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207629; cv=none; b=b4HPmjwO7sbKcOTdT5yEOqekW8OCunp7FiNmDbPHKxm2XXDr78+LjxGIKVYHw++uK1zhfnFiJLlWUdwnJ3/GV2LThmyZ6C2Tv3tPgMJ2BoiPP9nWJE8wxA2lRZgNBURJZuAMlIOmvwjxG+hHiswyc56O2gZY9oZUwQ7oviQ+87A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207629; c=relaxed/simple;
	bh=iIb4fAgg7xgZAoPuBKnDig42jkO5LZuq1WixVcFmFdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSGIQtTb8aQkG1ZSQxdJdcF9n4czEAFY52CzqEf6sYqnIDQm7wVAgoFbNVpmxyKEOh0LKtTR7F3J0NULdag2XtYZ9S6ZevxbkWJkUx48Rfx+vzRxu43HDD5QS0o+LkKRMFAdrGLUSteJUvLS7+GXfpZeVEnhYU39xrwJoWOuYb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UVh6iOHj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UVh6iOHj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3144C4CEC3;
	Sun,  1 Sep 2024 16:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207629;
	bh=iIb4fAgg7xgZAoPuBKnDig42jkO5LZuq1WixVcFmFdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UVh6iOHjJdfc+YwCpzrKD1SgqHL/wKBG4cRdUd+DkqhGxCir43L+6aPB/lSJPOTjJ
	 wfyUlVx3wnIkP2U2Z7TQ9mh6dii5sJPNO/iVrPiO4+L6itAG8d9MPR8EJ768wk9ikt
	 15A2OeVVq2uX+B3e44QnVycCN5yRQ/9sZAM/4ZFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Christie <michael.christie@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	Martin Wilck <mwilck@suse.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 22/98] scsi: spi: Fix sshdr use
Date: Sun,  1 Sep 2024 18:15:52 +0200
Message-ID: <20240901160804.529286438@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 0b149cee836aa53989ea089af1cb9d90d7c6ac9e ]

If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
shouldn't access the sshdr. If it returns 0, then the cmd executed
successfully, so there is no need to check the sshdr. This has us access
the sshdr when we get a return value > 0.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Link: https://lore.kernel.org/r/20231004210013.5601-7-michael.christie@oracle.com
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_transport_spi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index efb9c3d902133..adbe9b07f3d0b 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -690,10 +690,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
 	for (r = 0; r < retries; r++) {
 		result = spi_execute(sdev, spi_write_buffer, DMA_TO_DEVICE,
 				     buffer, len, &sshdr);
-		if(result || !scsi_device_online(sdev)) {
+		if (result || !scsi_device_online(sdev)) {
 
 			scsi_device_set_state(sdev, SDEV_QUIESCE);
-			if (scsi_sense_valid(&sshdr)
+			if (result > 0 && scsi_sense_valid(&sshdr)
 			    && sshdr.sense_key == ILLEGAL_REQUEST
 			    /* INVALID FIELD IN CDB */
 			    && sshdr.asc == 0x24 && sshdr.ascq == 0x00)
-- 
2.43.0



