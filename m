Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2AD1C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:11:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111EBC433D2;
	Wed, 28 Dec 2022 16:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243901;
	bh=EIj8sJGijWRFsfgtNCgCcLWUcJjmrtfZbMz2oLgw5qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1ItS8efH9eUAAPoLTn7xEc9zdqhzHeMwW0uFuqVc021NXtKaEuhENJoIFigWRoxS
	 iNkwelcytkj0y55/Y5tFTR6ZO0yrYiNJ8sweKXlHAoSoijO0Zsw4T8NxHTTgvJLZOk
	 Cv4n3LtN7U5g6qO6iUSc2vlVG/hUCtOWSqF/0u2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0576/1073] apparmor: Fix memleak in alloc_ns()
Date: Wed, 28 Dec 2022 15:36:04 +0100
Message-Id: <20221228144343.697015764@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit e9e6fa49dbab6d84c676666f3fe7d360497fd65b ]

After changes in commit a1bd627b46d1 ("apparmor: share profile name on
replacement"), the hname member of struct aa_policy is not valid slab
object, but a subset of that, it can not be freed by kfree_sensitive(),
use aa_policy_destroy() to fix it.

Fixes: a1bd627b46d1 ("apparmor: share profile name on replacement")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/policy_ns.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/security/apparmor/policy_ns.c b/security/apparmor/policy_ns.c
index 43beaad083fe..78700d94b453 100644
--- a/security/apparmor/policy_ns.c
+++ b/security/apparmor/policy_ns.c
@@ -134,7 +134,7 @@ static struct aa_ns *alloc_ns(const char *prefix, const char *name)
 	return ns;
 
 fail_unconfined:
-	kfree_sensitive(ns->base.hname);
+	aa_policy_destroy(&ns->base);
 fail_ns:
 	kfree_sensitive(ns);
 	return NULL;
-- 
2.35.1



