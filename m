Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B6C1AB53B;
	Thu, 15 Aug 2024 14:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731401; cv=none; b=nm9SHz8/iw7fnP6FqhMdMWx3CmOFK+2JOBAP5ouPyHXbjVe7tKCI1w5PpU4G4jIIVEYT9GDbjxq5lW6KIYSvZd9X4lw3zv6j//Knhmhys3CFdc0se2v//Jygv5+3L98YWPsrYDewdiR7MJO687vIc/uXgRuSOjBOkM3M0LCV6hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731401; c=relaxed/simple;
	bh=jZyquXmtpN6+3N/vRQxrxh8tRCsOwPAWhu5ZYFomPCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ejtr1n0aNwGEXYHQKD+gu03Iyh4HlDLf2T2WdLSbpwSKKPPLnyawKFCUE3fc/ey44LeR0PFRGTnfyWI6d7lLxF+M26c6zepjLBMGp10NvLAEAsr/kQ6VATeCVZ/Foc6/eDYX7r0rGwj62u5GeZ5XS1GDg2OMLHN4rT9lcbAQCRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CURQQYbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CURQQYbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B12E5C32786;
	Thu, 15 Aug 2024 14:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731401;
	bh=jZyquXmtpN6+3N/vRQxrxh8tRCsOwPAWhu5ZYFomPCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CURQQYbIYAptXFvCkmREn1rC/BfGN0Mi1OFdRRJGRMhlnYh4NKY1WxSSt1+VnH/RV
	 1CuoJc8ueGLPYx/2waRMgCiWpGw5KKAwNYF93py5XQZO6UHOmn6Pakyfer9uHi/fDM
	 gYHQcu7dSpth6w9m4ogYVS7JKcVAsq/aGfvnIzDI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 117/259] scsi: qla2xxx: Fix for possible memory corruption
Date: Thu, 15 Aug 2024 15:24:10 +0200
Message-ID: <20240815131907.316636499@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit c03d740152f78e86945a75b2ad541bf972fab92a upstream.

Init Control Block is dereferenced incorrectly.  Correctly dereference ICB

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4436,7 +4436,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)


