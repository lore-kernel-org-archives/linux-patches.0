Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5131B1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:12:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C05EDC433C7;
	Fri, 21 Jul 2023 16:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955965;
	bh=72nkb3gk8CFk5s0X3YPVukfJvyz/V+gMgECs6DTFqBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jU6mviPSrn0b5OCTJAYpRjoAYcx2sRHrHZ78kSzscFueheDyHhhUlTxoh6ADBySX5
	 5DFuQapIq6j6jc9X58r1ler32zO4dz7AfufIhO0bIP0GWjgauh7c6iF5g/SCcGlI6W
	 74XxKi5RZ3pePdeLRUYda8C+/vLFek+dybplT6kQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 092/292] wifi: airo: avoid uninitialized warning in airo_get_rate()
Date: Fri, 21 Jul 2023 18:03:21 +0200
Message-ID: <20230721160532.751956983@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
index 7c4cc5f5e1eb4..dbd13f7aa3e6e 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -6157,8 +6157,11 @@ static int airo_get_rate(struct net_device *dev,
 	struct iw_param *vwrq = &wrqu->bitrate;
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



