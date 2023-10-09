Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DCC919448
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CV5ZGWMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5F41C433CA;
	Mon,  9 Oct 2023 13:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696856990;
	bh=zUwyncZNnV2dl/Q5y9410g6hTkP/wzH5kB7T9oNTdaA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CV5ZGWMoaz2SkrXkteFAL9jHvluRcA5sBzDMxx36ZaOC/dWV+/CgAPqcg9BiRpHIj
	 Xf+0tCoTPHC+qrSkBYtrQa8Y8/TWrEF5huQhoPTo1KoMazgWt4PNsbto487yKcTnJd
	 ErgSFQVshjS9E6Wm/X0QIaaTOdb5b+Ib7z18NHgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 058/163] ubi: Refuse attaching if mtds erasesize is 0
Date: Mon,  9 Oct 2023 15:00:22 +0200
Message-ID: <20231009130125.638018914@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhihao Cheng <chengzhihao1@huawei.com>

[ Upstream commit 017c73a34a661a861712f7cc1393a123e5b2208c ]

There exists mtd devices with zero erasesize, which will trigger a
divide-by-zero exception while attaching ubi device.
Fix it by refusing attaching if mtd's erasesize is 0.

Fixes: 801c135ce73d ("UBI: Unsorted Block Images")
Reported-by: Yu Hao <yhao016@ucr.edu>
Link: https://lore.kernel.org/lkml/977347543.226888.1682011999468.JavaMail.zimbra@nod.at/T/
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ubi/build.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 8b91a55ec0d28..8ee51e49fced5 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -894,6 +894,13 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
 		return -EINVAL;
 	}
 
+	/* UBI cannot work on flashes with zero erasesize. */
+	if (!mtd->erasesize) {
+		pr_err("ubi: refuse attaching mtd%d - zero erasesize flash is not supported\n",
+			mtd->index);
+		return -EINVAL;
+	}
+
 	if (ubi_num == UBI_DEV_NUM_AUTO) {
 		/* Search for an empty slot in the @ubi_devices array */
 		for (ubi_num = 0; ubi_num < UBI_MAX_DEVICES; ubi_num++)
-- 
2.40.1



