Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03EF8E548;
	Mon, 11 Dec 2023 18:57:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seHoOax2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAE0C433C7;
	Mon, 11 Dec 2023 18:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702321072;
	bh=imJxDkv/OBoOAQGdpRU+GoKR5ZkM+u3TsKbjzWR/5fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seHoOax2WdMiZijP+mptL4EdvjKqnriSEtFrjHs+rFNW4Py74z+mxZDKBh36tvXlf
	 0d6XWIw1m/pOeZ7shemBM/f7beXj5BEbQZJbkQ/6EiqtjaNLnrSU+Wgi9GuvuXZE69
	 kLtz+jQuTSdJ/2G4X4Ci3hYTYuCb1wHerDp4KWBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/141] scsi: be2iscsi: Fix a memleak in beiscsi_init_wrb_handle()
Date: Mon, 11 Dec 2023 19:22:08 +0100
Message-ID: <20231211182029.549732598@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 235f2b548d7f4ac5931d834f05d3f7f5166a2e72 ]

When an error occurs in the for loop of beiscsi_init_wrb_handle(), we
should free phwi_ctxt->be_wrbq before returning an error code to prevent
potential memleak.

Fixes: a7909b396ba7 ("[SCSI] be2iscsi: Fix dynamic CID allocation Mechanism in driver")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20231123081941.24854-1-dinghao.liu@zju.edu.cn
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 7974c1326d461..27e73cd54beaa 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2691,6 +2691,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 		kfree(pwrb_context->pwrb_handle_base);
 		kfree(pwrb_context->pwrb_handle_basestd);
 	}
+	kfree(phwi_ctxt->be_wrbq);
 	return -ENOMEM;
 }
 
-- 
2.42.0



