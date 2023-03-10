Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D57882C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:16:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C885C4339C;
	Fri, 10 Mar 2023 15:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678461374;
	bh=FsuHxiNnkMRJzz+GyhI0Wl6VftsEvMm5IV1r/r4jh5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ubjy8jRNiv/vdZqyM0fN1npcrwh8PgykkWYA5A/Pde6WiQJZYyyWRshGp+QZcmU72
	 9L0r0VWhXV228VOA8DgwMf7yuRT7h3bu0ikhnqkFSJugmv//YfQb4ZeqILpZArf1G2
	 8uiRrSK6QlMgzAY6bMZ5k1oEDxIenM/AzCP4lSNk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/136] drivers: base: component: fix memory leak with using debugfs_lookup()
Date: Fri, 10 Mar 2023 14:43:58 +0100
Message-Id: <20230310133710.723110618@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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

[ Upstream commit 8deb87b1e810dd558371e88ffd44339fbef27870 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Link: https://lore.kernel.org/r/20230202141621.2296458-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/component.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index 870485cbbb87c..058f1a2cb2a9a 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -130,7 +130,7 @@ static void component_master_debugfs_add(struct master *m)
 
 static void component_master_debugfs_del(struct master *m)
 {
-	debugfs_remove(debugfs_lookup(dev_name(m->parent), component_debugfs_dir));
+	debugfs_lookup_and_remove(dev_name(m->parent), component_debugfs_dir);
 }
 
 #else
-- 
2.39.2



