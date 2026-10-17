Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0593C6A56;
	Sat, 17 Oct 2026 17:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259343; cv=none; b=QVyFQnrLv49KiC6DVryB9LWnFsQqMMqckBQmvn6BHog4MZzyqRYNem77OwQCkF6aVq4DJYqMCn2HdOlDVmK3X247Mph9f0l2bXCxmcmxUFnodokDibpAq4fkLylcIPWahV4JkCORSMYmXxC8cgyiEoUOL1OjsAepi8VRkGxIpY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259343; c=relaxed/simple;
	bh=dBmTPdnECkr1gWOA1crt5P8uMWHv6rKV/yqGYSYlquA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGIO6f9rh9eFwT7qZvw9OtVxdV7IMit3UJjSYowz6P0HdIPnOQaaSX5jSqO5TL2XG2KsuYJjTz8UGp6Y6BuQwgEw+bfxhhLQwUQ6xqrXh7bOiwh0mpZn6t89dQJxdnKObjsS2Orl2u3dTQslkh/hzTdNRHihz1NEidB288rePjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z/1tGlZT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z/1tGlZT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25BF31F000C4;
	Sat, 17 Oct 2026 17:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259342;
	bh=FtahwaxCtwr7s/Hlt7bYhuWGJdw8TL/WPeW1wAU2Yrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z/1tGlZTRv2foVIrfCFEHrKe2UtyZDmtHRmtZBkIYiMFK8Ovs5Ct5P2tBU9Tsb3uI
	 d6iRCeqq9k9SPl/qQYvYblulvorXF2qRxU93NSiLWDDX81RQDSPuvDeTyyKqN4K23T
	 ula7sM/AT2bfBlmn7Hn7H/RFe76+kgLtlMAoDD5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ling Xu <ling_ling.xu@unisoc.com>,
	Di Shen <di.shen@unisoc.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1181/1674] OPP: Fix race between OPP addition and lookup
Date: Sat, 17 Oct 2026 17:57:33 +0200
Message-ID: <20261017160501.460468445@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Di Shen <di.shen@unisoc.com>

[ Upstream commit f5e1cc9a284bff2510981643a5bca4bc4c21b81a ]

A race exists between dev_pm_opp_add_dynamic() and
dev_pm_opp_find_freq_exact():

  CPU0 (add)                          CPU1 (lookup)
  -------------------------------     ------------------------------
  _opp_add()
    mutex_lock()
    list_add(&new_opp->node, head)
    mutex_unlock()                    _opp_table_find_key()
                                        mutex_lock()
                                        dev_pm_opp_get(opp)
                                          kref_get()
                                        mutex_unlock()
    kref_init(&new_opp->kref)
                                      dev_pm_opp_put()
                                        kref_put_mutex()

The newly added OPP is inserted into the list before its kref is
initialized. A concurrent lookup can find this OPP and increment its
reference count while it is still uninitialized, leading to refcount
corruption and a potential premature free.

Fix this by initializing ->kref and ->opp_table before making the OPP
visible via list_add(). This ensures any concurrent lookup observes a
fully initialized object.

Fixes: 7034764a1e4a (PM / OPP: Add 'struct kref' to struct dev_pm_opp)
Co-developed-by: Ling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Ling Xu <ling_ling.xu@unisoc.com>
Signed-off-by: Di Shen <di.shen@unisoc.com>
[ Viresh: Updated commit log ]
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/core.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/opp/core.c b/drivers/opp/core.c
index 218cb2e7f3605..02db807adad42 100644
--- a/drivers/opp/core.c
+++ b/drivers/opp/core.c
@@ -1998,11 +1998,10 @@ int _opp_add(struct device *dev, struct dev_pm_opp *new_opp,
 		return ret;
 	}
 
-	list_add(&new_opp->node, head);
-	mutex_unlock(&opp_table->lock);
-
 	new_opp->opp_table = opp_table;
 	kref_init(&new_opp->kref);
+	list_add(&new_opp->node, head);
+	mutex_unlock(&opp_table->lock);
 
 	opp_debug_create_one(new_opp, opp_table);
 
-- 
2.53.0



