Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3F3050E5B3;
	Wed, 30 Sep 2026 16:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785703; cv=none; b=hpAmH4BrbGLQayRu/SZLlZMS7NXyWQjzHBCeu4eLSs6/AYOSp6XOUq02HC1rESLHTu7QkodLos5TmWyNHv59v6LCW9pVTzFA8kns78CpDBmZrxHnrsYeSoMrKSJfuBv00t3R4AqiNOopR0aam/qviWHZz6knl8UCEKOQHB9gsJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785703; c=relaxed/simple;
	bh=WlGzzTmq0l+GMxFLo1LzntuqZMXYTxGXQ9ra00tYWrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ue8T5GKozxfp2Ix7hI9WVL/XnU5HaSNHQQGuWGS+Bkv4iSjcobmrj0AEcd8WI24f4GD19GrI5fus0u5FH1QFt8Wk4kNoC4paoryp+OAfGLGpoSVsIg07pEPSyMLRLJJItihqiZlWe0THmKn2U2rsEgP/yBqzqCu9bYrEBisHIV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iE2tgMI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iE2tgMI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CCB1F000FF;
	Wed, 30 Sep 2026 16:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785696;
	bh=ht8dZhXASdYjWfn7Nk1FHq29aZd/mTsNwYI6T0bjMQ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1iE2tgMIWH3RAAYCMXpiVX7nC7KeOo0gYT7XlwirwdK/XlQQtkLKfz2Bbf4Bde57n
	 URtK0yadEnG9nhii8Dqz3gAfE1GMJzYCWSY2sCt2OCmjioHnI6yTheXKpNWrPdC85y
	 yqxKnuquSSUvNQZYUHKEiAbULBD5CESWQS7fg2d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 601/982] net: devlink: move port_type_warn_schedule() call to __devlink_port_type_set()
Date: Wed, 30 Sep 2026 17:22:17 +0200
Message-ID: <20260930152429.689979189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 8573a04404ddacb2d966eef09bf38b2ad6dbe86f ]

As __devlink_port_type_set() is going to be called directly from netdevice
notifier event handle in one of the follow-up patches, move the
port_type_warn_schedule() call there.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: ef9fbe1b93f3 ("RDMA/core: Reject unregistering netdevs in ib_get_eth_speed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/leftover.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/devlink/leftover.c b/net/devlink/leftover.c
index d9e13f1836bb6..ab9a8534904ce 100644
--- a/net/devlink/leftover.c
+++ b/net/devlink/leftover.c
@@ -9989,7 +9989,11 @@ static void __devlink_port_type_set(struct devlink_port *devlink_port,
 {
 	ASSERT_DEVLINK_PORT_REGISTERED(devlink_port);
 
-	devlink_port_type_warn_cancel(devlink_port);
+	if (type == DEVLINK_PORT_TYPE_NOTSET)
+		devlink_port_type_warn_schedule(devlink_port);
+	else
+		devlink_port_type_warn_cancel(devlink_port);
+
 	spin_lock_bh(&devlink_port->type_lock);
 	devlink_port->type = type;
 	switch (type) {
@@ -10084,7 +10088,6 @@ EXPORT_SYMBOL_GPL(devlink_port_type_ib_set);
 void devlink_port_type_clear(struct devlink_port *devlink_port)
 {
 	__devlink_port_type_set(devlink_port, DEVLINK_PORT_TYPE_NOTSET, NULL);
-	devlink_port_type_warn_schedule(devlink_port);
 }
 EXPORT_SYMBOL_GPL(devlink_port_type_clear);
 
-- 
2.53.0



