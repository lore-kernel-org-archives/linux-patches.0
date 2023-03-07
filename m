Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08D2BA3E
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:41:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37988C433EF;
	Tue,  7 Mar 2023 17:41:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210860;
	bh=zuNOdGvzLBnCU+FQG2keN40nn2lHeZhWBsiBou5Ia5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y/+EA734usEq3Uf7OxVPDcQ2R7VSRyIWTlJ0ZVWMlTsd0XoiAT4p6pWhwFin3/7y+
	 BUtCs22Tjj9oYSBs//m6ZxeWKrkmcMVnQ37+f92DNKGcQcvPHsPrNJsgVYsquSREn1
	 zvWpMC4fKSzobir2ZjiUvlJL4qTKajmIoaPSd9xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0677/1001] PM: EM: fix memory leak with using debugfs_lookup()
Date: Tue,  7 Mar 2023 17:57:29 +0100
Message-Id: <20230307170050.971889858@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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

[ Upstream commit a0e8c13ccd6a9a636d27353da62c2410c4eca337 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index f82111837b8d1..7b44f5b89fa15 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -87,10 +87,7 @@ static void em_debug_create_pd(struct device *dev)
 
 static void em_debug_remove_pd(struct device *dev)
 {
-	struct dentry *debug_dir;
-
-	debug_dir = debugfs_lookup(dev_name(dev), rootdir);
-	debugfs_remove_recursive(debug_dir);
+	debugfs_lookup_and_remove(dev_name(dev), rootdir);
 }
 
 static int __init em_debug_init(void)
-- 
2.39.2



