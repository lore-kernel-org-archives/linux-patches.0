Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28AD2459C9;
	Tue, 29 Apr 2025 17:25:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947502; cv=none; b=hI1di8iGBjEwWbD1PUfj4p2dCS3zkqHg0Z3Y2KdmzvbacI1DPWnNW0Qf73u34XDcBKX/FPkFjedI7RtY4k+o8qZg6iW1IVyhVKItkoeEZbf1z21or5L8xqqNHsy4il1g7lcggvKe7/m3/wHnRd7dUc3TRzPqph3Q9CkhTjdQvbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947502; c=relaxed/simple;
	bh=71LHKA8drU+UzWBbkCjV5QFCyKQUeltATryz42TGPL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gu3Biy3mXmpXEeEPttDjhbxLyf0/4JbgAoW6tTXatoV6oABCGjaeZAft7u0kWBgkv0gKfEDmF3qlL5KSLxO14nj8HbdtQ3OSgB0vA1JUemf3pbADbCrdRFeLml4MZ1QU/WCmsWoWLsLt6gn9SrLRjowh9moHk4BnKnZtrTlAedY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPA6dR+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPA6dR+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4070FC4CEE3;
	Tue, 29 Apr 2025 17:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947502;
	bh=71LHKA8drU+UzWBbkCjV5QFCyKQUeltATryz42TGPL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPA6dR+UOmwElbJHdW+TS1++qW+Zhb5yWTY+Cajhsv/m1NkiVpBPi09rqF52XLcSN
	 GwgEZwMaR1/b49RRieaOIKJfvNgmqs77dU+arKkpblbQ9uMo5IaspXjZNW98d2VXMS
	 Qg0v50W5igg6EJw9zHG4jXZGxPJl5riFckQZnlRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Lukasz Luba <lukasz.luba@arm.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 007/280] PM: EM: use kfree_rcu() to simplify the code
Date: Tue, 29 Apr 2025 18:39:08 +0200
Message-ID: <20250429161115.313971810@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 1618f635bdf56f3ac158171114e9bf18db234cbf ]

The callback function of call_rcu() just calls kfree(), so use
kfree_rcu() instead of call_rcu() + callback function.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/20250218082021.2766-1-lirongqing@baidu.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 3ee7be9e10dd ("PM: EM: Address RCU-related sparse warnings")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/energy_model.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/kernel/power/energy_model.c b/kernel/power/energy_model.c
index 927cc55ba0b3d..e303d938637f1 100644
--- a/kernel/power/energy_model.c
+++ b/kernel/power/energy_model.c
@@ -161,14 +161,6 @@ static void em_debug_create_pd(struct device *dev) {}
 static void em_debug_remove_pd(struct device *dev) {}
 #endif
 
-static void em_destroy_table_rcu(struct rcu_head *rp)
-{
-	struct em_perf_table __rcu *table;
-
-	table = container_of(rp, struct em_perf_table, rcu);
-	kfree(table);
-}
-
 static void em_release_table_kref(struct kref *kref)
 {
 	struct em_perf_table __rcu *table;
@@ -176,7 +168,7 @@ static void em_release_table_kref(struct kref *kref)
 	/* It was the last owner of this table so we can free */
 	table = container_of(kref, struct em_perf_table, kref);
 
-	call_rcu(&table->rcu, em_destroy_table_rcu);
+	kfree_rcu(table, rcu);
 }
 
 /**
-- 
2.39.5



