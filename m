Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8D4502D4A;
	Thu, 17 Sep 2026 17:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667609; cv=none; b=S+E8UFKgDtBJKJVMhNbZbjD22KjCXSiB5K4k4YSAM+s2obTrs44Q6VeeQg/uGZvNA2EZrcOrqTaxzkmZ4K7FDfoBh5VE9nmop0lKLojk6JCyyfafJ8YQzdgQxlxiQYIYjT1g1dADKvHxZ4R0lkA0ZESqMoIMbSaiQvKdrWSBZL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667609; c=relaxed/simple;
	bh=upkxk1btuzjwIbRdjCFeYi0M9DLx77hofnU+krvx/Lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2AVjg1n4yxXmHDrk9BayI5no0gkN2Ao2mfYVH1nZIbDSh9MJ5+ug1GmNDe+QsZMzVMmC+Y3Sdevx9uJZQioUX376lNHovoSyLbW5/7yuiu7ph2xe9QpEXRcgDdaNiaP4SXPUi2ECYuVkp2wLMhTD99X0DPOvkFsnlhjpC7G74U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m6D6Saks; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m6D6Saks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64521F000FF;
	Thu, 17 Sep 2026 17:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667607;
	bh=6woy9dqnhxqgs7IQgZ32KdoC9Z+VoVzDnb6NCajpPm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m6D6SaksF0nlJ1pV5X0q3cmxe8HuFBi796uIpfXRlFtZ2MQnlGlqPoocCRkAzz89C
	 OChQyKyD/8qOW3OR8dAWwm+vp1XxVI9D1lel1OFUdyknBnF528oGmFHvzMSQxhHPh2
	 UGn/xELY5P5AZ0vGUAO5sOgaLjMm/CQDF2AVMpjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumeet Pawnikar <sumeet4linux@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0149/1102] powercap: intel_rapl: Fix memory leak in rapl_add_package_cpuslocked()
Date: Thu, 17 Sep 2026 16:01:32 +0100
Message-ID: <20260917151543.269764379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c3de52e78e016..4af20c36a8095 100644
--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -2211,7 +2211,8 @@ struct rapl_package *rapl_add_package_cpuslocked(int id, struct rapl_if_priv *pr
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



