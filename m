Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 122588820
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:53:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76874C433D2;
	Fri, 10 Mar 2023 14:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460038;
	bh=z5byOYg2JUv0S80SmWeFrKoymMaWdD9Irr6H9jZZMhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HvREKMkbWnYLrIdRYn2cyixAr3cErNYYLJYGl+2qwF4a8CK/ge6/hPXlyFjm7uOso
	 RqoGWfBR9y47Mbbfbd2Q8Zy1btxj7aexEcPOe+F2n0ptiFpST6tiEBLW9lBeJpu9Bq
	 MrJvYqcNEHKXUHgeG5aZWrEem9tZvJGbe+UtCEYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 202/529] scsi: mpt3sas: Fix a memory leak
Date: Fri, 10 Mar 2023 14:35:45 +0100
Message-Id: <20230310133814.365114560@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 54dd96015e8d7a2a07359e2dfebf05b529d1780c ]

Add a forgotten kfree().

Fixes: dbec4c9040ed ("scsi: mpt3sas: lockless command submission")
Link: https://lore.kernel.org/r/20230207152159.18627-1-thenzl@redhat.com
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index c1b76cda60dbc..2ad75c9a9088a 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -4905,6 +4905,9 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		}
 		dma_pool_destroy(ioc->pcie_sgl_dma_pool);
 	}
+	kfree(ioc->pcie_sg_lookup);
+	ioc->pcie_sg_lookup = NULL;
+
 	if (ioc->config_page) {
 		dexitprintk(ioc,
 			    ioc_info(ioc, "config_page(0x%p): free\n",
-- 
2.39.2



