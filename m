Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4982C237E;
	Wed, 28 Jan 2026 15:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614518; cv=none; b=OY2b6NccD2q3U7l+Mf6sjk/WL7joKseVMOwYPeZvgIbpNk9Px/YK6vTOQL6K0WzdkL/8L2cH49HEdRtliJ6sGA0iErvNmyTus+ixLaAI7Dx2Mex46fbMvlB7zKhmkP7NxbeAkc3MjPiYtVdBLSwtSXG5R6ViXz4lF8a+2pfnXm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614518; c=relaxed/simple;
	bh=BUF4jHEYV0108bEFMUwOC7RPnYt5ou0gd53lKs/iAD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JzXsZdHZYI3c1WcPmzQpjOGl2+wMShytJ73SszTwBjYErydiwTk4f4mNyrK/r++dyeRXTnz21sNYIXeGMAFpr9jDP8y0NooUrdrFtaLJ/EuqZ3X2Hgd8YZWPYYgTmqjdqHQtHLNh3QVRDnTdxsBTQBZJZQpe5mCfUWf+dZco/uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aMyYjlCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aMyYjlCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2B6C4CEF1;
	Wed, 28 Jan 2026 15:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614518;
	bh=BUF4jHEYV0108bEFMUwOC7RPnYt5ou0gd53lKs/iAD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aMyYjlCx0lISTnsA0YbYCHEuFy/y9V/7bNQUSR7Uc7LYRMsast5pijgDQseCaw80a
	 3zFPK+g0nFgwqfLdqAfVR2cTYWVTP0aZ4G3RyTXcI9Z9KMVRVjZJvyL1fXFkGq0MKE
	 QRX/TGaoVMy26BT7hFwITRgwRjlntKRcooSu65jk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 161/254] scsi: qla2xxx: Sanitize payload size to prevent member overflow
Date: Wed, 28 Jan 2026 16:22:17 +0100
Message-ID: <20260128145350.603840664@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

From: Jiasheng Jiang <jiashengjiangcool@gmail.com>

[ Upstream commit 19bc5f2a6962dfaa0e32d0e0bc2271993d85d414 ]

In qla27xx_copy_fpin_pkt() and qla27xx_copy_multiple_pkt(), the frame_size
reported by firmware is used to calculate the copy length into
item->iocb. However, the iocb member is defined as a fixed-size 64-byte
array within struct purex_item.

If the reported frame_size exceeds 64 bytes, subsequent memcpy calls will
overflow the iocb member boundary. While extra memory might be allocated,
this cross-member write is unsafe and triggers warnings under
CONFIG_FORTIFY_SOURCE.

Fix this by capping total_bytes to the size of the iocb member (64 bytes)
before allocation and copying. This ensures all copies remain within the
bounds of the destination structure member.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20260106205344.18031-1-jiashengjiangcool@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_isr.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index a85d3a40ee490..ae2bea27a18a6 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -878,6 +878,9 @@ qla27xx_copy_multiple_pkt(struct scsi_qla_host *vha, void **pkt,
 		payload_size = sizeof(purex->els_frame_payload);
 	}
 
+	if (total_bytes > sizeof(item->iocb.iocb))
+		total_bytes = sizeof(item->iocb.iocb);
+
 	pending_bytes = total_bytes;
 	no_bytes = (pending_bytes > payload_size) ? payload_size :
 		   pending_bytes;
@@ -1163,6 +1166,10 @@ qla27xx_copy_fpin_pkt(struct scsi_qla_host *vha, void **pkt,
 
 	total_bytes = (le16_to_cpu(purex->frame_size) & 0x0FFF)
 	    - PURX_ELS_HEADER_SIZE;
+
+	if (total_bytes > sizeof(item->iocb.iocb))
+		total_bytes = sizeof(item->iocb.iocb);
+
 	pending_bytes = total_bytes;
 	entry_count = entry_count_remaining = purex->entry_count;
 	no_bytes = (pending_bytes > sizeof(purex->els_frame_payload))  ?
-- 
2.51.0



