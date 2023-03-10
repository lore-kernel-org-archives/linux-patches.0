Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB68E8481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:13:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C85C433A0;
	Fri, 10 Mar 2023 14:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457593;
	bh=ENlRig7qxIZqwpN/qXepTWkVpECOpKSodtH0h5/Rp70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d5BTV+2zG8CZfhht7nO+Fj/9VbKKt63w/t9c28DsYn3xtjOnvLcVAiv5O3RczbTQZ
	 B9vCqg6XA7ONSNb1hORHQ3s923F5HtGpcYUPxz8pxtJpGIQx+sBsqAOS/J0R0iaSHR
	 EE8ADOeSVdq/wke8+aQmpEHmJ4pw0OsQ9gSe9a5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nadav Amit <namit@vmware.com>,
	VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 164/200] misc: vmw_balloon: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:39:31 +0100
Message-Id: <20230310133722.145212482@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 209cdbd07cfaa4b7385bad4eeb47e5ec1887d33d ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic at
once.

Cc: Nadav Amit <namit@vmware.com>
Cc: VMware PV-Drivers Reviewers <pv-drivers@vmware.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20230202141100.2291188-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/vmw_balloon.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_balloon.c b/drivers/misc/vmw_balloon.c
index 61a2be712bf7b..9ce9b9e0e9b63 100644
--- a/drivers/misc/vmw_balloon.c
+++ b/drivers/misc/vmw_balloon.c
@@ -1709,7 +1709,7 @@ static void __init vmballoon_debugfs_init(struct vmballoon *b)
 static void __exit vmballoon_debugfs_exit(struct vmballoon *b)
 {
 	static_key_disable(&balloon_stat_enabled.key);
-	debugfs_remove(debugfs_lookup("vmmemctl", NULL));
+	debugfs_lookup_and_remove("vmmemctl", NULL);
 	kfree(b->stats);
 	b->stats = NULL;
 }
-- 
2.39.2



