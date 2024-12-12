Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D21D222D58;
	Thu, 12 Dec 2024 16:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020839; cv=none; b=bFylyr2SghPC0ayopRuXU/V4rJQU11E6jTUDQc1C57dSycxhDEPKGL/feETr0mXEbL+n0zEMEvoztvUdRET+pKViHcKKSYbXbWD5Yt/tlVbr1blKvmgQ6VXgQYP3BZffX+XoIA3+z4uUAkUd64a8iEBrlU2EMurN/DtPoBqx+7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020839; c=relaxed/simple;
	bh=lgRHe730NQfeJHyOSEq93pwpZmuohzxKMrJxYnmgZIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NYwrKHU1Iv4o87Z8mUwgCxq0drNfQXinBDHMxnYLL1dH/2ABFKccMtt81X3Bik3WzZg5fzagncOU8ujtynh16qqZb2V5rYB3Sui41UpKkRWpUHgfUX7qNmrPWU5rk85RIayc6C45C7gewpl+/PPQcXcpfpp96uV9iyf9154ldUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=15dAAMgo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="15dAAMgo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC30C4CED3;
	Thu, 12 Dec 2024 16:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020839;
	bh=lgRHe730NQfeJHyOSEq93pwpZmuohzxKMrJxYnmgZIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=15dAAMgoP/ORfWZPtDqLaoKywZnkzxvwEsh9V0qHNtTyFr6Iofzsr+14aOhiMygM/
	 jfm228LSNcDtSOhjABXp/2GXnYEY9Ms/hm7oX6ppkmYr6Xj0lQ9LS8Mye8r3Qwn6OA
	 d+33+3i8Cd/sQwic8YwfFNHSjQnnh31rFrYNKzS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 573/772] i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter
Date: Thu, 12 Dec 2024 15:58:38 +0100
Message-ID: <20241212144413.633984061@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 25bc99be5fe53853053ceeaa328068c49dc1e799 ]

Fix issue where disabling IBI on one device disables the entire IBI
interrupt. Modify bit 7:0 of enabled_events to serve as an IBI enable
counter, ensuring that the system IBI interrupt is disabled only when all
I3C devices have IBI disabled.

Cc: stable@kernel.org
Fixes: 7ff730ca458e ("i3c: master: svc: enable the interrupt in the enable ibi function")
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Link: https://lore.kernel.org/r/20241101165002.2479794-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index 3dc34b31767d9..8f0da6e2d9d82 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -128,8 +128,8 @@
 /* This parameter depends on the implementation and may be tuned */
 #define SVC_I3C_FIFO_SIZE 16
 
-#define SVC_I3C_EVENT_IBI	BIT(0)
-#define SVC_I3C_EVENT_HOTJOIN	BIT(1)
+#define SVC_I3C_EVENT_IBI	GENMASK(7, 0)
+#define SVC_I3C_EVENT_HOTJOIN	BIT(31)
 
 struct svc_i3c_cmd {
 	u8 addr;
@@ -204,7 +204,7 @@ struct svc_i3c_master {
 		spinlock_t lock;
 	} ibi;
 	struct mutex lock;
-	int enabled_events;
+	u32 enabled_events;
 	u32 mctrl_config;
 };
 
@@ -1541,7 +1541,7 @@ static int svc_i3c_master_enable_ibi(struct i3c_dev_desc *dev)
 		return ret;
 	}
 
-	master->enabled_events |= SVC_I3C_EVENT_IBI;
+	master->enabled_events++;
 	svc_i3c_master_enable_interrupts(master, SVC_I3C_MINT_SLVSTART);
 
 	return i3c_master_enec_locked(m, dev->info.dyn_addr, I3C_CCC_EVENT_SIR);
@@ -1553,7 +1553,7 @@ static int svc_i3c_master_disable_ibi(struct i3c_dev_desc *dev)
 	struct svc_i3c_master *master = to_svc_i3c_master(m);
 	int ret;
 
-	master->enabled_events &= ~SVC_I3C_EVENT_IBI;
+	master->enabled_events--;
 	if (!master->enabled_events)
 		svc_i3c_master_disable_interrupts(master);
 
-- 
2.43.0



