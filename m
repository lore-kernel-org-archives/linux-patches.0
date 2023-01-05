Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E238494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 12:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612A6C433EF;
	Thu,  5 Jan 2023 12:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923589;
	bh=8G5P1bKONHYNybXA3AXzV2jmMQt9ANoBvwiZugq9a4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mqFbnnaOlTql5oy2tLAAEFgoZMLJ1ZO2eIGUZi4+v1a4BnUhlGeeFRVbIMsK9++1Y
	 g1BTlR/NI2+6eJGFh6QfcOTCpsTCsHwav75iJt8hIFFvCAkX+Wg01YkZMMc2gOYeZc
	 vJSGJbDwNrOVmpAHeIkfd9iEMmVKhIPczQX+wiBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangPeng <zhangpeng362@huawei.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 069/251] pinctrl: pinconf-generic: add missing of_node_put()
Date: Thu,  5 Jan 2023 13:53:26 +0100
Message-Id: <20230105125337.929831928@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: ZhangPeng <zhangpeng362@huawei.com>

[ Upstream commit 5ead93289815a075d43c415e35c8beafafb801c9 ]

of_node_put() needs to be called when jumping out of the loop, since
for_each_available_child_of_node() will increase the refcount of node.

Fixes: c7289500e29d ("pinctrl: pinconf-generic: scan also referenced phandle node")
Signed-off-by: ZhangPeng <zhangpeng362@huawei.com>
Link: https://lore.kernel.org/r/20221125070156.3535855-1-zhangpeng362@huawei.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinconf-generic.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinconf-generic.c b/drivers/pinctrl/pinconf-generic.c
index 074a7e044e25..b0e41fb3623d 100644
--- a/drivers/pinctrl/pinconf-generic.c
+++ b/drivers/pinctrl/pinconf-generic.c
@@ -384,8 +384,10 @@ int pinconf_generic_dt_node_to_map(struct pinctrl_dev *pctldev,
 	for_each_child_of_node(np_config, np) {
 		ret = pinconf_generic_dt_subnode_to_map(pctldev, np, map,
 					&reserved_maps, num_maps, type);
-		if (ret < 0)
+		if (ret < 0) {
+			of_node_put(np);
 			goto exit;
+		}
 	}
 	return 0;
 
-- 
2.35.1



