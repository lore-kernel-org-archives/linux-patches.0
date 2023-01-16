Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A39946B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93DB5C433EF;
	Mon, 16 Jan 2023 16:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673886103;
	bh=vrcDQKhxxedJe/GkQp5x08wBHgIum1+JAR6+zMRSZE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ek5XOTPNrcyE7yq15wsO/x+TJuTIwsaSpOwfHkqkPp5lLv91O0UxSQBjc/mNioUAt
	 B1kYQqNrHU78CneULaIaCoMGkgonxstaNv1KsbeeQ0EWEaZ3cWNJoUbA5grtWzdX0O
	 I6tSdSUtc1Tq4VWuT9zSrcM5xYJw2hIcDTRR/x3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Johannes Thumshirn <jth@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 303/658] drivers: mcb: fix resource leak in mcb_probe()
Date: Mon, 16 Jan 2023 16:46:31 +0100
Message-Id: <20230116154923.451522844@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index c799bb81ab03..2df3ab3b76e4 100644
--- a/drivers/mcb/mcb-core.c
+++ b/drivers/mcb/mcb-core.c
@@ -71,8 +71,10 @@ static int mcb_probe(struct device *dev)
 
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



