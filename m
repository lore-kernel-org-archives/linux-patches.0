Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61D2183CD2;
	Sun,  1 Sep 2024 17:00:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210004; cv=none; b=JiRttlljvsTQns0SMWIJtO09VRgZVfEuCjBrWn4Jn864sjbT5J22ENvyaegBECSlwH9k0q3xlkPet1sl/ckd6CKc3QpK/CYfJH6zbcuVKARTzhDOlk3KBWPTf9AZSfNLHr1fN7qWBps1wEFCA15fQ8OGd+uBsBhsH0aGFQxKeGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210004; c=relaxed/simple;
	bh=M46+lpSvrXcGTsry/0UkBwXs9jC4fNdh6ERcuIZTZyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=En6hOyCEWfKMJyZNCxGRAPkyErKtAg8HavdvoQqMS8mP7+4qIoP+WdvdLthM5VmZkP7rKKb1mER7jE9tQvFkWIjfPXzR58S53EiDXo+o4XEhHwrk41br2Z06oU3jK0T2rW1dYmOcgJ42M+szuKPHRBtWPFcE5W7Ncmr/+vMtqBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vZrzNCVF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vZrzNCVF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 584A7C4CEC3;
	Sun,  1 Sep 2024 17:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210003;
	bh=M46+lpSvrXcGTsry/0UkBwXs9jC4fNdh6ERcuIZTZyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vZrzNCVFAgLiLvj+2oeEqDM+QKbJpXrRocR9h/BlEchazkfqolEQTMOhX2187Z3F6
	 WtqQTANuQMkAp952pac3vXGqhBqZ+ieShAjKOSrdqminRlCs/j9wpQhwajiNiBQ38h
	 AWG/Jb+nVbwJ43gKkkn2hsQwiLyPC3F1CRM2ix9w=
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
Subject: [PATCH 5.15 058/215] scsi: spi: Fix sshdr use
Date: Sun,  1 Sep 2024 18:16:10 +0200
Message-ID: <20240901160825.550262880@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
index bd72c38d7bfc4..5c43d0ec95a77 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -677,10 +677,10 @@ spi_dv_device_echo_buffer(struct scsi_device *sdev, u8 *buffer,
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



