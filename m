Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE86C31A7EA;
	Fri,  9 Jan 2026 11:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959876; cv=none; b=RLy0JLx0Xvhaq2nNAPqHINmLcKy2EX/UivJY3fO5w66PdwQTHYxkYQh5naTJm7XWi+ReIbnxXt8YSGz+RHL1UbTCDvLhObN03XGJvhS1Apw3csoSilWEaCLoXaa6KyKRzHHLDQyq5mv6lNvWLD7HWbtAazxO1yaqXFUbsa5IisA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959876; c=relaxed/simple;
	bh=iw+xVwBNsaZYuRGBDyJhXImT1EEkuX0IDgWxlyQVX1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4MckzzPmKr8LTWZ01DXnvvIG3E0CLD4MuQ8DAIGPntBcStFaQvqJoVeBQNohQ6mEG/esWBFjh6xBBiZHcZ2w4sFMwv5Srorq0ngKsiSVAv1Le3+O/X8wkwnHY7xYPK4ibHZZuTn0bdsvCvYG4yapm2TP7Qj8Hoky0eJQSvSTng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skkRcjSl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skkRcjSl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B2A5C4CEF1;
	Fri,  9 Jan 2026 11:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959876;
	bh=iw+xVwBNsaZYuRGBDyJhXImT1EEkuX0IDgWxlyQVX1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=skkRcjSl+00HwRWhqb/6IU5+G21ZH6fcMOZ0gmBk1Wpu9BJA5tRCxzUwQIf3Ofgk+
	 G6H/Cqmb4iSbs91lYjSEj/x10Hy6cZh1iF/FOVevqcXyQbDJiUzWIEC2xyVHXc6qwc
	 Y6Hxqcz4yTccX8Fg3Ju9tAg//qjS+/wg4mTzPzm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 179/737] scsi: qla2xxx: Fix improper freeing of purex item
Date: Fri,  9 Jan 2026 12:35:18 +0100
Message-ID: <20260109112140.727394248@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 78b1a242fe612a755f2158fd206ee6bb577d18ca ]

In qla2xxx_process_purls_iocb(), an item is allocated via
qla27xx_copy_multiple_pkt(), which internally calls
qla24xx_alloc_purex_item().

The qla24xx_alloc_purex_item() function may return a pre-allocated item
from a per-adapter pool for small allocations, instead of dynamically
allocating memory with kzalloc().

An error handling path in qla2xxx_process_purls_iocb() incorrectly uses
kfree() to release the item. If the item was from the pre-allocated
pool, calling kfree() on it is a bug that can lead to memory corruption.

Fix this by using the correct deallocation function,
qla24xx_free_purex_item(), which properly handles both dynamically
allocated and pre-allocated items.

Fixes: 875386b98857 ("scsi: qla2xxx: Add Unsolicited LS Request and Response Support for NVMe")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Himanshu Madhani <hmadhani2024@gmail.com>
Link: https://patch.msgid.link/20251113151246.762510-1-zilin@seu.edu.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla2xxx/qla_nvme.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
index 080670cb2aa51..38cb3281c6350 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1293,7 +1293,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 		a.reason = FCNVME_RJT_RC_LOGIC;
 		a.explanation = FCNVME_RJT_EXP_NONE;
 		xmt_reject = true;
-		kfree(item);
+		qla24xx_free_purex_item(item);
 		goto out;
 	}
 
-- 
2.51.0



