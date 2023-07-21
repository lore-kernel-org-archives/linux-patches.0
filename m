Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3358420F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A60E8C433CA;
	Fri, 21 Jul 2023 19:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967130;
	bh=28DFqZumhXj6PElrtnYcnesCJS6wqiy5NaCrdQgJ0sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GK3UZmBbfos63NkJptcfuTx2ye2eMsFUNu5UQjZ6tVE6hvR1CiXm5Wc9kaKsSRnOD
	 FoSt2n2BJV0o8USc3aCsm5qu2LMhCZ53RCjd1rVrlF05M/GiqkCq56St8aC9cqj7A8
	 LVMrHAv+6oWX5NMSbzQTe9FLabm9KiNiizYFIDik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/223] wifi: airo: avoid uninitialized warning in airo_get_rate()
Date: Fri, 21 Jul 2023 18:05:08 +0200
Message-ID: <20230721160523.197809091@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
index fb2c35bd73bb1..f6362429b735b 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -6146,8 +6146,11 @@ static int airo_get_rate(struct net_device *dev,
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



