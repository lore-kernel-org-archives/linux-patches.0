Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 119842857CD;
	Wed, 28 Jan 2026 15:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615722; cv=none; b=FuV1B5m+GuS+CtEwl6Ah9s3Xixl1BXqvslRst+UPE9DT32ST4UF822JZqEoD5rNomin27fdZMi0DCmTGlgxnbg5OnIv0592eg6fFF+w+SWSbs1wpyuN7QxPjz13ndolJ2r9+Md8TSFphS7Vj4wwZGX8P4UK3DWba+2I07xDhm4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615722; c=relaxed/simple;
	bh=h1pA0hebeSUnsT2twIn1AuvJf+P3/EqBU5i1sTubSjw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLMJO2fftG7LiuTH5wd0mb9giCxR0BqylnBSuQfHKAC6Becjrn4iaATZYTotgSZ8m10kgCJl7Icgj78Su4mbWh2jYqNZq2cHmzMReedu3Mf1WcVHx/L6MPVWTEIiTlVQLIPo9SONIQK9D1HFVI2CYRvAmuEcdgDruSTEOFBR4J4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdgWj3TD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdgWj3TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9149DC4CEF1;
	Wed, 28 Jan 2026 15:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615722;
	bh=h1pA0hebeSUnsT2twIn1AuvJf+P3/EqBU5i1sTubSjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VdgWj3TDLeY2myxi2DZG3sYcuov/ZltrC8qlQJJJ1xwQ59AYAlCZzieo3MHc/ZZpa
	 KHKic7q3mpr3TS2tVS+Jvd9GBgvtdRTzsKI4xzDzrp85jC9+7rQR4voPHq/M4vqsSe
	 qyQvgV9lXuC4MVyWzu1WUeCtT6TsfOMbKu+K1S2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 093/227] scsi: qla2xxx: Sanitize payload size to prevent member overflow
Date: Wed, 28 Jan 2026 16:22:18 +0100
Message-ID: <20260128145347.680480100@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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
index a3971afc2dd1e..a04a5aa0d0057 100644
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



