Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949025101A;
	Mon, 11 Dec 2023 18:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ai9MGJ6G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17AA4C433C8;
	Mon, 11 Dec 2023 18:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702318962;
	bh=JEpqpOlTgzvQBYhjIBhWsuI71qDakNYaD+TZUamwVYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ai9MGJ6GEgW/xnejblHW5n1SsX+ZP/V5b5ecPbT4EUDiOaHnKh0TSxP0PdpDMJmMv
	 jJJOJvPkNamRhBO+xwoseiWgjMY2LUvxcItTa2DHpoQh6MBdfi2tPuk5k+ZZAz/r+h
	 Ea4MZz8ySfuGGMFypI1RdKhAsz29p3qdMGIzrlHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Mike Christie <michael.christie@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 09/25] scsi: be2iscsi: Fix a memleak in beiscsi_init_wrb_handle()
Date: Mon, 11 Dec 2023 19:21:00 +0100
Message-ID: <20231211182009.043362952@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182008.665944227@linuxfoundation.org>
References: <20231211182008.665944227@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
index a1fd8a7fa48c3..ddaf2b57d9349 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2687,6 +2687,7 @@ static int beiscsi_init_wrb_handle(struct beiscsi_hba *phba)
 		kfree(pwrb_context->pwrb_handle_base);
 		kfree(pwrb_context->pwrb_handle_basestd);
 	}
+	kfree(phwi_ctxt->be_wrbq);
 	return -ENOMEM;
 }
 
-- 
2.42.0



