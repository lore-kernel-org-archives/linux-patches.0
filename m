Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4744950B402;
	Thu, 17 Sep 2026 16:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789663982; cv=none; b=A7MTHadCSrV107cvtWRidL2qYG3nq6noze5wxqG5C0MNoBA36jpBxzaQDWjPz9KWfhK6n+t1t99d8YYMBRjgcNzTPPS0h6ZDq1iGjIkjbW7LR8MsUQ1/6DbYL4aOX6dwqdHdq+VPNrdh8nm4I00/j1U2aPwIs5lU5eMO+MVmLgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789663982; c=relaxed/simple;
	bh=dOGICeWof7c9Yc1/rJ+A8Plp+f/ICjxVOYEUTHDRCHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6dTQMtvrkg6FspDMNHl4ww0hXXsjCyXgOMhuzNjRUSDjx11VkuUBqmooNkbiv1nXb8BS05igyCpSVeURWwJiolyUpLimt2xiCT+J6ObCqmbZD8ZWjVggwFSxGNYN0Zb58WgipgF7Lo5EbPib7wT/LW0/oWlPyWDid7j7MxKtSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRSBfaZ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRSBfaZ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5561F00893;
	Thu, 17 Sep 2026 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789663981;
	bh=zqcYwlKJWgzKxdA/TYnsy7ipnjhx80eDFnIswedWyf0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CRSBfaZ/c9Wfk351dek0vNXDdgqu76UTwcEn0CjktRb9NreAW4CT2YKBcdwuGkiyG
	 Pxxw6UWpWlXxB0RXqVDYH5UzRxsnM8clWRBzet0eJuHAXTkGu8r4o1ahkeFJ40/Xwo
	 16iu0woPWpVzlKkVsSoV/R7R26/C/qEbig4Wrt/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0220/1250] powercap: intel_rapl: Fix memory leak in rapl_add_package_cpuslocked()
Date: Thu, 17 Sep 2026 16:00:15 +0100
Message-ID: <20260917151558.102559065@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumeet Pawnikar <sumeet4linux@gmail.com>

[ Upstream commit bfc7d93bc5e12288e5dc6bb54260f68cdf5a5c47 ]

When topology_physical_package_id()/topology_logical_die_id() returns
a negative value, rapl_add_package_cpuslocked() returns ERR_PTR(-EINVAL)
directly without freeing the rapl_package structure that was just
allocated by kzalloc_obj(), leaking memory on every failed package
addition.

Use the existing err_free_package label so that the allocation is
released on the error path.

Signed-off-by: Sumeet Pawnikar <sumeet4linux@gmail.com>
Link: https://patch.msgid.link/20260515182616.227707-1-sumeet4linux@gmail.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
index 57bebd07c7d0d..f08ac99f5e55e 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -2216,7 +2216,8 @@ struct rapl_package *rapl_add_package_cpuslocked(int id, struct rapl_if_priv *pr
 			 topology_physical_package_id(id) : topology_logical_die_id(id);
 		if ((int)(rp->id) < 0) {
 			pr_err("topology_logical_(package/die)_id() returned a negative value");
-			return ERR_PTR(-EINVAL);
+			ret = -EINVAL;
+			goto err_free_package;
 		}
 		rp->lead_cpu = id;
 		if (!rapl_msrs_are_pkg_scope() && topology_max_dies_per_package() > 1)
-- 
2.53.0



