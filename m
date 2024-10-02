Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10181D0E02;
	Wed,  2 Oct 2024 13:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876339; cv=none; b=uL6APP+VD86FBklyTBCd8hWem7e9+98eVVjZ9IcZWyIIATj53tkRKZ74SOlwcOxxNPqqNAe8AekQGp2h65MVpkJh1+9EmnOKBANUVGtbiBxkI/QICCK4PKnhluKrFh70bqF3BVlsOzTYTN928NQcYsOZt3xjfINfZh2uTAyqnDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876339; c=relaxed/simple;
	bh=Ydy+FRQ9Ga9zNkhNOPR2EeCtXTlW0QhTNfmAc+dtQgk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uD6hmDaeJMVQ5Sh9XmjzzNy3sgcjgr44vcaihFO9erGr0o/FVScesrD2KwqTuePgxbyp3cU1A1Dbq71/1OamUUUy5V264jiOJ8JuNL6Olwr6nh6AOJbLXmK5KxLL+Xmqw6je8ULsOiemyxeIdV83d2c8B0ZVvUFUpQeWXqC+hSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zl4GzkZC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zl4GzkZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45AF6C4CEC5;
	Wed,  2 Oct 2024 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876339;
	bh=Ydy+FRQ9Ga9zNkhNOPR2EeCtXTlW0QhTNfmAc+dtQgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zl4GzkZCYsvljPR2q2jZY71Fdv5JThzQ/oQTR60zp5abERp/kk6DfXWh1vHFmeX4w
	 kyslHenmhIp7dbOvY7/hfJAOKlVns4/Rat+JySuBSJD4lPJHmn6+oBEVfGHSeWcYmD
	 Rs7/2wRhB6tqBqR5XxZv/QMnIRwcp7wOf3HCmqUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 410/695] RDMA/hns: Dont modify rq next block addr in HIP09 QPC
Date: Wed,  2 Oct 2024 14:56:48 +0200
Message-ID: <20241002125838.820273316@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junxian Huang <huangjunxian6@hisilicon.com>

[ Upstream commit 6928d264e328e0cb5ee7663003a6e46e4cba0a7e ]

The field 'rq next block addr' in QPC can be updated by driver only
on HIP08. On HIP09 HW updates this field while driver is not allowed.

Fixes: 926a01dc000d ("RDMA/hns: Add QP operations support for hip08 SoC")
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-2-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
index 621b057fb9daa..a166b476977f1 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v2.c
@@ -4423,12 +4423,14 @@ static int config_qp_rq_buf(struct hns_roce_dev *hr_dev,
 		     upper_32_bits(to_hr_hw_page_addr(mtts[0])));
 	hr_reg_clear(qpc_mask, QPC_RQ_CUR_BLK_ADDR_H);
 
-	context->rq_nxt_blk_addr = cpu_to_le32(to_hr_hw_page_addr(mtts[1]));
-	qpc_mask->rq_nxt_blk_addr = 0;
-
-	hr_reg_write(context, QPC_RQ_NXT_BLK_ADDR_H,
-		     upper_32_bits(to_hr_hw_page_addr(mtts[1])));
-	hr_reg_clear(qpc_mask, QPC_RQ_NXT_BLK_ADDR_H);
+	if (hr_dev->pci_dev->revision == PCI_REVISION_ID_HIP08) {
+		context->rq_nxt_blk_addr =
+				cpu_to_le32(to_hr_hw_page_addr(mtts[1]));
+		qpc_mask->rq_nxt_blk_addr = 0;
+		hr_reg_write(context, QPC_RQ_NXT_BLK_ADDR_H,
+			     upper_32_bits(to_hr_hw_page_addr(mtts[1])));
+		hr_reg_clear(qpc_mask, QPC_RQ_NXT_BLK_ADDR_H);
+	}
 
 	return 0;
 }
-- 
2.43.0



