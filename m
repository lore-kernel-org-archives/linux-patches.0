Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A2A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:07:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC95C433EF;
	Mon, 16 Jan 2023 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888875;
	bh=Q47DhHufZjz2yw8LsqEMABxE3v4eeNVt/zGIx7XhVF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX4MnP2pG7AWG00PrwVXCSbmDdFp/ylp2L2+4NU5KnNKUbXJ3iXZiscwZhthQ4eAp
	 gDEfo474y6g8RwA9g1DAMMt1RlggL45r5exjskI70O2VDj0+uLb6lKO/qmTJSxzK/r
	 FhuIWCyTN08JmBN20KS3HK6nsKFzR6oWM94X4ORQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 172/338] drivers: mcb: fix resource leak in mcb_probe()
Date: Mon, 16 Jan 2023 16:50:45 +0100
Message-Id: <20230116154828.396164819@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit d7237462561fcd224fa687c56ccb68629f50fc0d ]

When probe hook function failed in mcb_probe(), it doesn't put the device.
Compiled test only.

Fixes: 7bc364097a89 ("mcb: Acquire reference to device in probe")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/9f87de36bfb85158b506cb78c6fc9db3f6a3bad1.1669624063.git.johannes.thumshirn@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mcb/mcb-core.c b/drivers/mcb/mcb-core.c
index 118d27ee31c2..7fd32b0183dc 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -74,8 +74,10 @@ static int mcb_probe(struct device *dev)
 
 	get_device(dev);
 	ret = mdrv->probe(mdev, found_id);
-	if (ret)
+	if (ret) {
 		module_put(carrier_mod);
+		put_device(dev);
+	}
 
 	return ret;
 }
-- 
2.35.1



