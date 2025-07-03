Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823C02ED168;
	Thu,  3 Jul 2025 15:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554963; cv=none; b=oY5L0OGBk4ymdAI1G/DtWCkQtrtfKreQjm3SLKNVuMqs0tv8JM+MEQ+GQpHmQqxuiSv5nkyJQQfK+qe2gwGCuJA2zDB6FaeX1LVDuiuTcN7rWt03DyegrztiD4qbCAl9HzhExMQVzIyXLs7dKJ3m08s8RItIshrHtyRzO+ivc4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554963; c=relaxed/simple;
	bh=gigfUWBxpO3LcZ5nvkDfogiG9nDSY6vIvMio+b15dD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpwB+6tcsMmCwgiMHq2sFUCzhG+gCxeF0nSpe+mAxGyv3Fcr61SV+QVBO1S73lEWFfRcpGPW/Imho06MdugjSRAgX+pZ6cmOvqoQOBnNp0VfMzja9SHvGBbjD+mlEfkvaHkvulQWBqPDatGC8EivfjtG98SRW8dwzEFbUiNg+o4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cKSYj1bS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cKSYj1bS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5E2DC4CEE3;
	Thu,  3 Jul 2025 15:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554963;
	bh=gigfUWBxpO3LcZ5nvkDfogiG9nDSY6vIvMio+b15dD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cKSYj1bSrdcWSejPd0OVR2sqmCUrAXQsjPOvcc40ACUTlw+eARYR+WWa6dpDLeHNB
	 PpV2crxbGuzfuop+2wJdC+rzv72Iaumk7tw8aWJMp6VNOMg8V964jv8V6Vy7dbVghK
	 XTtOLPEzEaey9LSFYuvYv0uRsSwlDNKvlc+cYR1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	John Menghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 134/263] scsi: fnic: Fix missing DMA mapping error in fnic_send_frame()
Date: Thu,  3 Jul 2025 16:40:54 +0200
Message-ID: <20250703144009.736106329@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 85d6fbc47c3087c5d048e6734926b0c36af34fe9 ]

dma_map_XXX() can fail and should be tested for errors with
dma_mapping_error().

Fixes: a63e78eb2b0f ("scsi: fnic: Add support for fabric based solicited requests and responses")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250618065715.14740-2-fourier.thomas@gmail.com
Reviewed-by: Karan Tilak Kumar <kartilak@cisco.com>
Reviewed-by: John Menghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/fnic/fnic_fcs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/fnic/fnic_fcs.c b/drivers/scsi/fnic/fnic_fcs.c
index 1e8cd64f9a5c5..103ab6f1f7cd1 100644
--- a/drivers/scsi/fnic/fnic_fcs.c
+++ b/drivers/scsi/fnic/fnic_fcs.c
@@ -636,6 +636,8 @@ static int fnic_send_frame(struct fnic *fnic, void *frame, int frame_len)
 	unsigned long flags;
 
 	pa = dma_map_single(&fnic->pdev->dev, frame, frame_len, DMA_TO_DEVICE);
+	if (dma_mapping_error(&fnic->pdev->dev, pa))
+		return -ENOMEM;
 
 	if ((fnic_fc_trace_set_data(fnic->fnic_num,
 				FNIC_FC_SEND | 0x80, (char *) frame,
-- 
2.39.5



