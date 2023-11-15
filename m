Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08FCA2FC52
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pGSkpc0k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE409C433CC;
	Wed, 15 Nov 2023 19:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077577;
	bh=YmiP1PslUl4BXvAQOKL/bPHukjjXK8/ydlkWIBPVWzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pGSkpc0kFkwncxj0gvKgSQvd4dFJxSueuivPKb21ZyvSN3KwDm2EiSsAWSQ8yjBPS
	 P9f1H4nwtwS1rpgvLu4sVd1Frlu2ndyVyXR0zXKwUPa0hlQTRKTgg5ENWfQCswIq6v
	 zks/HDzdByfi6OQyio+8olUlcjSKMPUIAJYnG49s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 388/603] RDMA/hfi1: Workaround truncation compilation error
Date: Wed, 15 Nov 2023 14:15:33 -0500
Message-ID: <20231115191640.062452867@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit d4b2d165714c0ce8777d5131f6e0aad617b7adc4 ]

Increase name array to be large enough to overcome the following
compilation error.

drivers/infiniband/hw/hfi1/efivar.c: In function ‘read_hfi1_efi_var’:
drivers/infiniband/hw/hfi1/efivar.c:124:44: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
  124 |         snprintf(name, sizeof(name), "%s-%s", prefix_name, kind);
      |                                            ^
drivers/infiniband/hw/hfi1/efivar.c:124:9: note: ‘snprintf’ output 2 or more bytes (assuming 65) into a destination of size 64
  124 |         snprintf(name, sizeof(name), "%s-%s", prefix_name, kind);
      |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/infiniband/hw/hfi1/efivar.c:133:52: error: ‘snprintf’ output may be truncated before the last format character [-Werror=format-truncation=]
  133 |                 snprintf(name, sizeof(name), "%s-%s", prefix_name, kind);
      |                                                    ^
drivers/infiniband/hw/hfi1/efivar.c:133:17: note: ‘snprintf’ output 2 or more bytes (assuming 65) into a destination of size 64
  133 |                 snprintf(name, sizeof(name), "%s-%s", prefix_name, kind);
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
cc1: all warnings being treated as errors
make[6]: *** [scripts/Makefile.build:243: drivers/infiniband/hw/hfi1/efivar.o] Error 1

Fixes: c03c08d50b3d ("IB/hfi1: Check upper-case EFI variables")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Link: https://lore.kernel.org/r/238fa39a8fd60e87a5ad7e1ca6584fcdf32e9519.1698159993.git.leonro@nvidia.com
Acked-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/efivar.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/efivar.c b/drivers/infiniband/hw/hfi1/efivar.c
index 7741a1d69097c..2b5d264f41e51 100644
--- a/drivers/infiniband/hw/hfi1/efivar.c
+++ b/drivers/infiniband/hw/hfi1/efivar.c
@@ -112,7 +112,7 @@ int read_hfi1_efi_var(struct hfi1_devdata *dd, const char *kind,
 		      unsigned long *size, void **return_data)
 {
 	char prefix_name[64];
-	char name[64];
+	char name[128];
 	int result;
 
 	/* create a common prefix */
-- 
2.42.0



