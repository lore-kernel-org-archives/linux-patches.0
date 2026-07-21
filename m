Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703D03B42CB;
	Tue, 21 Jul 2026 22:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672027; cv=none; b=sp1HlC+awbfNdjxph28LCOkxeceWsTk8QEA3For7eJeEmilhbDyRp00PipGzZZMxwib+hsfsWAn0lRzVk0oWD0zh/1oudouEy+sUgiQAZ9/XmNJJO+l5B/EjeIq4uH2fs1eLLrMfv3QGcYvYsTjE70QxDIAxyY6O3Fz2xGzozxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672027; c=relaxed/simple;
	bh=7gKLNc9yORe++I4fW3NGc5dcPLlZO5KKRC5EGtZiH9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VLrwmjURI1n2FrUGJYk1iRDIsxczdI2CGZ0fuvDzCF44pRI03qYyQqQ+99zh2dt3qtRWMqoQbuYLLAI2cZhndvdGuwOGKG72An76RAeuNfk5tgmnUkcggoGaFFzivEapjzIv5UzMDxziIES7Y6hiyogbO6A0YBvmYpKBoOKKOkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S3RD+71Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S3RD+71Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA751F000E9;
	Tue, 21 Jul 2026 22:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672026;
	bh=S1solwS4Xl+vEIiAJLjrKp4y4ad/mEF8gFwhYevTOEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S3RD+71YGQDWCVJevM/HPnq+jMuOe9qxsXykxUlqt/ba13tSsnart/gVZ3IKQ76p1
	 xMBrzWoD1uqJ0TXg+nAuhJf0MEPk19IAtkEHZrSxet9Fqdob2BXP/vnc/P6vVCZITK
	 /qdSeFx9hctAhXH1/fsexSgWTg4Yo5R8dbCdAF9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Frank Li <Frank.Li@nxp.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 469/843] NTB: epf: Make db_valid_mask cover only real doorbell bits
Date: Tue, 21 Jul 2026 17:21:44 +0200
Message-ID: <20260721152416.587374569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 6eb7e28f1f24a28234add38755687a7ed8bc2654 ]

ndev->db_count includes an unused doorbell slot due to the legacy extra
offset in the peer doorbell path. db_valid_mask must cover only the real
doorbell bits and exclude the unused slot.

Set db_valid_mask to BIT_ULL(db_count - 1) - 1.

Fixes: 812ce2f8d14e ("NTB: Add support for EPF PCI Non-Transparent Bridge")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260513024923.451765-10-den@valinux.co.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/epf/ntb_hw_epf.c b/drivers/ntb/hw/epf/ntb_hw_epf.c
index febe548ed47690..9c26f405c3382a 100644
--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -554,7 +554,11 @@ static int ntb_epf_init_dev(struct ntb_epf_dev *ndev)
 		return ret;
 	}
 
-	ndev->db_valid_mask = BIT_ULL(ndev->db_count) - 1;
+	/*
+	 * ndev->db_count includes an extra skipped slot due to the legacy
+	 * doorbell layout, hence -1.
+	 */
+	ndev->db_valid_mask = BIT_ULL(ndev->db_count - 1) - 1;
 	ndev->mw_count = readl(ndev->ctrl_reg + NTB_EPF_MW_COUNT);
 	ndev->spad_count = readl(ndev->ctrl_reg + NTB_EPF_SPAD_COUNT);
 
-- 
2.53.0



