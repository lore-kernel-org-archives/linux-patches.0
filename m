Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C4A2364021;
	Tue, 16 Dec 2025 12:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887763; cv=none; b=o2X1L4FDYaHTNpQHguJ6hWHEzmABzqw/QKJPZgKKb2d37Hj1JIIRC8N20u4315/92yNfBZx7sBAzeZX2kzDWBYI31qN8TKHJlMJADBEY6WquBLsjQYDwjPH2LH/WdakQf3T2ILJOPFZuWbhrs80ZjYJ5qDlWstfSQD3D6A/f2ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887763; c=relaxed/simple;
	bh=2oxMnqPSgM+Wuhx+wjhDJT+3hSLWlMnCX9IuwFGt57M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHCeAPO9ckhPRhBLHG6BMW6vxGHla4qbPcIMhilruC/bMj4dHVeP6E0n7L//9PR9Pe6z8jyTbUOJqk6RNLSJjdgmNCPmudqcbBo8A0PatRnEweSrHBoG7LSOFSTM3etqhUCTU6jKSha3dwgZvidJjkeJLtRI7szAY+ZyaWJodS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ3ZHAjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ3ZHAjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FF3C4CEF1;
	Tue, 16 Dec 2025 12:22:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887763;
	bh=2oxMnqPSgM+Wuhx+wjhDJT+3hSLWlMnCX9IuwFGt57M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ3ZHAjciKGyTkd91+ht1e7kify2yOcYlilZTVh2WuU8+U2vAyvIdVT5D6ya3F+C2
	 P1Rl7ISrlLhiKteU2pOgR18jc3c57HyKZeqtMA4gY40Zp/IBeH6oGE/Ks7L27jleI0
	 CK8inTiwbCxTfJcpon9sG02ObuuwnMJdCtYMOc90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Himanshu Madhani <hmadhani2024@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 330/614] scsi: qla2xxx: Fix improper freeing of purex item
Date: Tue, 16 Dec 2025 12:11:37 +0100
Message-ID: <20251216111413.321851525@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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
index 316594aa40cc5..42eb65a62f1f3 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -1292,7 +1292,7 @@ void qla2xxx_process_purls_iocb(void **pkt, struct rsp_que **rsp)
 		a.reason = FCNVME_RJT_RC_LOGIC;
 		a.explanation = FCNVME_RJT_EXP_NONE;
 		xmt_reject = true;
-		kfree(item);
+		qla24xx_free_purex_item(item);
 		goto out;
 	}
 
-- 
2.51.0



