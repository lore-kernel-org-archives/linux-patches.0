Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9552C6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:08:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B859C433EF;
	Mon, 16 Jan 2023 17:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673888880;
	bh=kCSbU/WXbEcN7zzbpxVHttZZYBUzc3PiP6ADFwywilw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aC7fiyCKvXZe4RLk5h2vFybaOaDMHr3+AvIaQPRw+/gxlV5BFEJWigM0MN4KMTn9Q
	 jDSOlgwXNNWJcj+TZy/2bPKK/vrpI39lKQgYt9e1TthtvQHzGSgLX0xV2FQs69T/ju
	 KgKSCgEhxpsA+1rBTdv1X9h7UPla4/0Wa+hyjDGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <jth@kernel.org>,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 173/338] mcb: mcb-parse: fix error handing in chameleon_parse_gdd()
Date: Mon, 16 Jan 2023 16:50:46 +0100
Message-Id: <20230116154828.437736271@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 728ac3389296caf68638628c987aeae6c8851e2d ]

If mcb_device_register() returns error in chameleon_parse_gdd(), the refcount
of bus and device name are leaked. Fix this by calling put_device() to give up
the reference, so they can be released in mcb_release_dev() and kobject_cleanup().

Fixes: 3764e82e5150 ("drivers: Introduce MEN Chameleon Bus")
Reviewed-by: Johannes Thumshirn <jth@kernel.org>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Johannes Thumshirn <jth@kernel.org>
Link: https://lore.kernel.org/r/ebfb06e39b19272f0197fa9136b5e4b6f34ad732.1669624063.git.johannes.thumshirn@wdc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mcb/mcb-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mcb/mcb-parse.c b/drivers/mcb/mcb-parse.c
index 7369bda3442f..3636349648b4 100644
--- a/drivers/mcb/mcb-parse.c
+++ b/drivers/mcb/mcb-parse.c
@@ -107,7 +107,7 @@ static int chameleon_parse_gdd(struct mcb_bus *bus,
 	return 0;
 
 err:
-	mcb_free_dev(mdev);
+	put_device(&mdev->dev);
 
 	return ret;
 }
-- 
2.35.1



