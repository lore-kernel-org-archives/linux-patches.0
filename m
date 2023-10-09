Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BABD6328DB
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ive980z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355D8C433C8;
	Mon,  9 Oct 2023 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859146;
	bh=tShjwuyCckBcrUTehFdkOCcfS7zi0pWls8kVlSJl6z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ive980z1bYRRiiwJ4hIFlMF6+JInVN/yLTCC57/xVP3J4Yjsx24ltdiOgyI/d4SI9
	 20tgcQH6scqrqcH+hESVJcnsF96h6keficC3OW5lopuHywLdpxAuvAZM+pztkePz3+
	 SH2oNBkG9ZytAEvia9qGJuyv1hcH7j+026enbuvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Hao <yhao016@ucr.edu>,
	Zhihao Cheng <chengzhihao1@huawei.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/226] ubi: Refuse attaching if mtds erasesize is 0
Date: Mon,  9 Oct 2023 15:02:27 +0200
Message-ID: <20231009130131.483401754@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 929ce489b0629..c689bed646287 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -889,6 +889,13 @@ int ubi_attach_mtd_dev(struct mtd_info *mtd, int ubi_num,
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



