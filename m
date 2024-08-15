Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C241DFFB;
	Thu, 15 Aug 2024 14:38:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732683; cv=none; b=C4omKMmljUeiUy9jQahPBbRh/eDKTEE/fGlgLm+sP3ScLPhgo1mVGYoEtbnPQq8ga/q+B005ruClwBAZAsgJjwADbZDbSYYoczE18w0noFRKWZT54QLVAuC6dnO45JgpIMUcszIo8AYIpFc8ZZMd+oJwABNmVteqdECOPl1voTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732683; c=relaxed/simple;
	bh=mSJTekFY5JUnBJAP0HWXk22rDEYViO3jWswdq04DDu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGQQzftnUNpC5sZRitdHfp6AOaf/0eDF14ufBZWA3XXNlMzRdMuOi6Yua5UMToqYtaZB27Nj00Z6E86kLH8df5X6B31iD4/T9sibr9/6YbiRHHgAtCmb1ylfc9DH6TOrJWeii7Xvm6ZSPZ6jXg9iKWLof3JxHFH3qCGtPdv5zVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d6aUXihh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d6aUXihh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8042C32786;
	Thu, 15 Aug 2024 14:38:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732683;
	bh=mSJTekFY5JUnBJAP0HWXk22rDEYViO3jWswdq04DDu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6aUXihhVq4+J5+0pLg2nGdjHcYYS2bl+jMwiAqnMGW5z+llPk5pqWrqoQE1DormL
	 p50P6e3tLseGpx2EGWYIaX+3lmxvD3yXWEogUKtMu9oLQyt0tKlVXmDr5Yom9L+Egv
	 pF99PZzfRY9ACUJuXiGiCeoi6xjJFJ7dKtRABf2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jay Buddhabhatti <jay.buddhabhatti@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 223/352] drivers: soc: xilinx: check return status of get_api_version()
Date: Thu, 15 Aug 2024 15:24:49 +0200
Message-ID: <20240815131928.051333089@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jay Buddhabhatti <jay.buddhabhatti@amd.com>

[ Upstream commit 9b003e14801cf85a8cebeddc87bc9fc77100fdce ]

Currently return status is not getting checked for get_api_version
and because of that for x86 arch we are getting below smatch error.

    CC      drivers/soc/xilinx/zynqmp_power.o
drivers/soc/xilinx/zynqmp_power.c: In function 'zynqmp_pm_probe':
drivers/soc/xilinx/zynqmp_power.c:295:12: warning: 'pm_api_version' is
used uninitialized [-Wuninitialized]
    295 |         if (pm_api_version < ZYNQMP_PM_VERSION)
        |            ^
    CHECK   drivers/soc/xilinx/zynqmp_power.c
drivers/soc/xilinx/zynqmp_power.c:295 zynqmp_pm_probe() error:
uninitialized symbol 'pm_api_version'.

So, check return status of pm_get_api_version and return error in case
of failure to avoid checking uninitialized pm_api_version variable.

Fixes: b9b3a8be28b3 ("firmware: xilinx: Remove eemi ops for get_api_version")
Signed-off-by: Jay Buddhabhatti <jay.buddhabhatti@amd.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240515112345.24673-1-jay.buddhabhatti@amd.com
Signed-off-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/xilinx/zynqmp_power.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/xilinx/zynqmp_power.c b/drivers/soc/xilinx/zynqmp_power.c
index f8c301984d4f9..2653d29ba829b 100644
--- a/drivers/soc/xilinx/zynqmp_power.c
+++ b/drivers/soc/xilinx/zynqmp_power.c
@@ -178,7 +178,9 @@ static int zynqmp_pm_probe(struct platform_device *pdev)
 	u32 pm_api_version;
 	struct mbox_client *client;
 
-	zynqmp_pm_get_api_version(&pm_api_version);
+	ret = zynqmp_pm_get_api_version(&pm_api_version);
+	if (ret)
+		return ret;
 
 	/* Check PM API version number */
 	if (pm_api_version < ZYNQMP_PM_VERSION)
-- 
2.43.0



