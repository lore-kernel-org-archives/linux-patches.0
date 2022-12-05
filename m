Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AFCD15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:33:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC2AC433C1;
	Mon,  5 Dec 2022 19:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268826;
	bh=7byHlP5ufhy761TVqmwuLgFBxPP3Cgr0AZESwIy16cc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KNh+xQTDYDUYDV9eB0JhpESScdBmTK9BeVUI1PicOwcl2cX6vW+He2sNX1TktXE7o
	 AYtzLFPPnDzaqqrjfQBeNGfkkft4Jk/Uzsf4qbU6F6ccpKQ8YHyhCVwZBLNHHKkVEj
	 J6flWdXy/8IFVdLOjXYi9nVq6V0s0LM3Y6SN8HTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Nicolas Saenz Julienne <nsaenzjulienne@suse.de>,
	Wei Yongjun <weiyongjun1@huawei.com>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/120] nvmem: rmem: Fix return value check in rmem_read()
Date: Mon,  5 Dec 2022 20:09:26 +0100
Message-Id: <20221205190807.355487488@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 58e92c4a496b27156020a59a98c7f4a92c2b1533 ]

In case of error, the function memremap() returns NULL pointer
not ERR_PTR(). The IS_ERR() test in the return value check
should be replaced with NULL test.

Fixes: 5a3fa75a4d9c ("nvmem: Add driver to expose reserved memory as nvmem")
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Cc: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Acked-by: Nicolas Saenz Julienne <nsaenzjulienne@suse.de>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20221118063840.6357-3-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/rmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvmem/rmem.c b/drivers/nvmem/rmem.c
index b11c3c974b3d..80cb187f1481 100644
--- a/drivers/nvmem/rmem.c
+++ b/drivers/nvmem/rmem.c
@@ -37,9 +37,9 @@ static int rmem_read(void *context, unsigned int offset,
 	 * but as of Dec 2020 this isn't possible on arm64.
 	 */
 	addr = memremap(priv->mem->base, available, MEMREMAP_WB);
-	if (IS_ERR(addr)) {
+	if (!addr) {
 		dev_err(priv->dev, "Failed to remap memory region\n");
-		return PTR_ERR(addr);
+		return -ENOMEM;
 	}
 
 	count = memory_read_from_buffer(val, bytes, &off, addr, available);
-- 
2.35.1



