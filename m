Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC2D01ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F44AC433C9;
	Tue, 25 Jul 2023 11:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285570;
	bh=YzM4i7EbBBJ2ybTExN5AtqhXJxnmAqoQHrylUURBI6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DdZVDJk4JtIw3qOzDkCzNm0t6hFqdupgFI5s92R10h+KN3PYDKCiawA+mK7Z+uiMT
	 i90EzIP33mvX3jgM2Yo86oZNfVfNPhB6YiF5DoAK9zmwEMLe15RIyew/U9QoKaIVx7
	 tOWfpuCKXSywBlFUE/5E9WtH8s6LaAXJ1QlPLE70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 223/313] wifi: airo: avoid uninitialized warning in airo_get_rate()
Date: Tue, 25 Jul 2023 12:46:16 +0200
Message-ID: <20230725104530.688159604@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Randy Dunlap <rdunlap@infradead.org>

[ Upstream commit 9373771aaed17f5c2c38485f785568abe3a9f8c1 ]

Quieten a gcc (11.3.0) build error or warning by checking the function
call status and returning -EBUSY if the function call failed.
This is similar to what several other wireless drivers do for the
SIOCGIWRATE ioctl call when there is a locking problem.

drivers/net/wireless/cisco/airo.c: error: 'status_rid.currentXmitRate' is used uninitialized [-Werror=uninitialized]

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Link: https://lore.kernel.org/r/39abf2c7-24a-f167-91da-ed4c5435d1c4@linux-m68k.org
Link: https://lore.kernel.org/r/20230709133154.26206-1-rdunlap@infradead.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/cisco/airo.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index da0d3834b5f01..ebf0d3072290e 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -6104,8 +6104,11 @@ static int airo_get_rate(struct net_device *dev,
 {
 	struct airo_info *local = dev->ml_priv;
 	StatusRid status_rid;		/* Card status info */
+	int ret;
 
-	readStatusRid(local, &status_rid, 1);
+	ret = readStatusRid(local, &status_rid, 1);
+	if (ret)
+		return -EBUSY;
 
 	vwrq->value = le16_to_cpu(status_rid.currentXmitRate) * 500000;
 	/* If more than one rate, set auto */
-- 
2.39.2



