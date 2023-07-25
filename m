Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90EA14270
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:53:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242D2C433C8;
	Tue, 25 Jul 2023 10:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282407;
	bh=tPlnrUOB44ixW+YBquQhtPmxhbOHRKsLyCXO3Ctx5n8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUAh2P+qJXxmbrqhF+JUUlggLtRm2q8QcArFRUxZIyK2qToLVjjVcJK9LYWMl6xu/
	 FlT2b909R6ecALphPzBCl18IvKjkGfQty38m+ueZGA+Mn+VL9iU+nSqMKCZZQ7GtSR
	 ysVrn3MfaYsULhtTL+JlcCiatK2CWoOL22KVQMFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 118/227] devlink: make health report on unregistered instance warn just once
Date: Tue, 25 Jul 2023 12:44:45 +0200
Message-ID: <20230725104519.689852286@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 6f4b98147b8dfcabacb19b5c6abd087af66d0049 ]

Devlink health is involved in error recovery. Machines in bad
state tend to be fairly unreliable, and occasionally get stuck
in error loops. Even with a reasonable grace period devlink health
may get a thousand reports in an hour.

In case of reporting on an unregistered devlink instance
the subsequent reports don't add much value. Switch to
WARN_ON_ONCE() to avoid flooding dmesg and fleet monitoring
dashboards.

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20230531015523.48961-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/health.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/devlink/health.c b/net/devlink/health.c
index 0839706d5741a..194340a8bb863 100644
--- a/net/devlink/health.c
+++ b/net/devlink/health.c
@@ -480,7 +480,7 @@ static void devlink_recover_notify(struct devlink_health_reporter *reporter,
 	int err;
 
 	WARN_ON(cmd != DEVLINK_CMD_HEALTH_REPORTER_RECOVER);
-	WARN_ON(!xa_get_mark(&devlinks, devlink->index, DEVLINK_REGISTERED));
+	ASSERT_DEVLINK_REGISTERED(devlink);
 
 	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
 	if (!msg)
-- 
2.39.2



