Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CD939FEF;
	Fri, 24 Nov 2023 18:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IXDPa/aM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9074BC433C7;
	Fri, 24 Nov 2023 18:10:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849458;
	bh=8nY95ApDnNhGyBxjNszLhYcpsFjfzZQa3oougXNL5PY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IXDPa/aMuP9qEx+HcZEzfuMFjSYkg2vQRXvlQVazf1soAqkwn0ae02auoQxm1UAGw
	 i1cSR4Lj5k8c/7HL5DG5x+8R09SlYaPBugEN75augIZmQnxzBCmcIE0a4cLSZoY6kQ
	 W+zVRZbVNzyrW8UM1lJSebhDwCFXO5dL0VWgSDSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Yang <yiyang13@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/530] mtd: rawnand: meson: check return value of devm_kasprintf()
Date: Fri, 24 Nov 2023 17:45:31 +0000
Message-ID: <20231124172033.100829887@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yi Yang <yiyang13@huawei.com>

[ Upstream commit 5a985960a4dd041c21dbe9956958c1633d2da706 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful by
checking the pointer validity.

Fixes: 1e4d3ba66888 ("mtd: rawnand: meson: fix the clock")
Signed-off-by: Yi Yang <yiyang13@huawei.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20231019065548.318443-1-yiyang13@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 25e3c1cb605e7..a506e658d4624 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -1134,6 +1134,9 @@ static int meson_nfc_clk_init(struct meson_nfc *nfc)
 	init.name = devm_kasprintf(nfc->dev,
 				   GFP_KERNEL, "%s#div",
 				   dev_name(nfc->dev));
+	if (!init.name)
+		return -ENOMEM;
+
 	init.ops = &clk_divider_ops;
 	nfc_divider_parent_data[0].fw_name = "device";
 	init.parent_data = nfc_divider_parent_data;
-- 
2.42.0



