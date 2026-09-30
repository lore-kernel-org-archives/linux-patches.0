Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C4A850C29B;
	Wed, 30 Sep 2026 15:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782388; cv=none; b=uhclwub9yqK5z/SZ74awT+6zd32kK5Shd7h8bS04QsNBZT8rJ8jqFKxhgYksIOTm1ZfQS47L7xuMmcSNulw1cIi8+ECR7Ld0sDSsSAZpZuMPpJNfSJptZ6PDyg5DCniZaqh0Pqc/5QbjNGGHQkLGV0hI9A594d0x5c8w0j4oFeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782388; c=relaxed/simple;
	bh=NcATRM4sbtDwGKsVrKgpCJmimuyr2IzkGOHnNFvKDnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j9+2DkppZIqTRKg2wAb+KlSyEYpxKzgCEFdBKDGgm7BPd33Ve2cbvIp4NPH7rAdSFyJVPxkv3F3v3wJpYAnwk1auMgTlsQcxY1sM5VRtZcNm24vThCxqxfN7pU03QRZQ0RGZmmsuC0q/XJbFsKtKhaKIjgYj42FIAzqQnTrXjTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxFlvsyF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxFlvsyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6DFC1F00899;
	Wed, 30 Sep 2026 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782374;
	bh=Ys01xNvMlmfhuwdfn8u7mrl4vTNg6cCGWgxLhvgVHEA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxFlvsyFdxDxJjPjfIb1XizBjIFeUv62KrmKo5jZVnyNvPZA1Ln1MtrEqk0ru5AQU
	 5eS8DEenz3Lh2OTuV5c/6d6esQo13umGgMjoTyoKpxAENpglgkqs/CvXw4x8x2aR0M
	 5I93SwN9B/6ViCpwbtFVkRWhiTpAJCQs/9928ayw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Meiyappan <kumar.meiyappan@microchip.com>,
	Sagar Biradar <sagar.biradar@microchip.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 025/595] scsi: pm8001: Reject non-fatal dump when controller is crashed
Date: Wed, 30 Sep 2026 17:18:38 +0200
Message-ID: <20260930152348.265875859@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Meiyappan <kumar.meiyappan@microchip.com>

[ Upstream commit aa3b8f56ef27ed72394a752820abdec4608b731c ]

pm80xx_get_non_fatal_dump() can be called even after the controller has
entered a fatal error state. In that case the forensic memory contents
are not safe to access for a non-fatal dump request, and attempting to
do so can trigger a call trace.

Check controller_fatal_error before reading the non-fatal dump buffer
and return -EINVAL when the controller is already in a crashed state.

This prevents non-fatal dump collection from running in an invalid
controller state.

Signed-off-by: Kumar Meiyappan <kumar.meiyappan@microchip.com>
Signed-off-by: Sagar Biradar <sagar.biradar@microchip.com>
Link: https://patch.msgid.link/20260416154650.415624-1-sagar.biradar@microchip.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 89051722e04d6..64db45d24d803 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -400,6 +400,13 @@ ssize_t pm80xx_get_non_fatal_dump(struct device *cdev,
 	char *buf_copy = buf;
 
 	temp = (u32 *)pm8001_ha->memoryMap.region[FORENSIC_MEM].virt_ptr;
+
+	if (pm8001_ha->controller_fatal_error) {
+		pm8001_dbg(pm8001_ha, FAIL,
+			   "non-fatal dump not available in fatal error state\n");
+		return -EINVAL;
+	}
+
 	if (++pm8001_ha->non_fatal_count == 1) {
 		if (pm8001_ha->chip_id == chip_8001) {
 			snprintf(pm8001_ha->forensic_info.data_buf.direct_data,
-- 
2.53.0



