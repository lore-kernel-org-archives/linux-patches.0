Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C8D33A9F4;
	Wed, 21 Jan 2026 18:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020046; cv=none; b=XTUA2CKicct8rPnyEMpO+g07Jz8jALRucf4+81mpxVmmSUfXWte3dfCMhquqde+7sAFT9wlPSKsIqiiHBypA3sSGRXDKzh/s9Ags2XbN/ee04hDnjHH2sWyCjbiABtHNccRWyHlaemwQq5FknwzeUmGjhBMZh/FeNHxsAmeAFPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020046; c=relaxed/simple;
	bh=HoqZ1t/Ad83K4/qNPjUfNYzWWbEIpGzu+pwIsubXvT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiyNKK1v9DCYrs86UYzHKVc4wAuZuZkV8HP6qjpGbarPqbmcq7Wu/IOKCjbxfajp6cBaupv4tpaxZj30pwSzjTV0XuDDznJbtVCvfjbq7g4sHrj3jkvjy/PPtDjbsodxan8AItPvun/YnwZjYmYOp9YI8hiQoCKVRS8mBh/pOw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MNqU0/y+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MNqU0/y+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC8BC4CEF1;
	Wed, 21 Jan 2026 18:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020045;
	bh=HoqZ1t/Ad83K4/qNPjUfNYzWWbEIpGzu+pwIsubXvT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MNqU0/y+dTJ/3r6j6ZiN+CiiCkFcwEWyN5IsBTQv+QTVwbjKRGba32w1Xx2I7brJn
	 2boJBesnbzPP7bavdgUVBqjSNRRGAkkWI/mcFzUlTDbtpCt49D8A3nuT89dAPpQyPt
	 eF08T7YCuyec+Hu8bx5ZNVXQLjzy+gE8zAbpuLq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ming <ming.li@zohomail.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 044/198] cxl/hdm: Fix potential infinite loop in __cxl_dpa_reserve()
Date: Wed, 21 Jan 2026 19:14:32 +0100
Message-ID: <20260121181420.135776460@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Li Ming <ming.li@zohomail.com>

[ Upstream commit d4026a44626490dc4eca4dd2c4d0816338fa179b ]

In __cxl_dpa_reserve(), it will check if the new resource range is
included in one of paritions of the cxl memory device.
cxlds->nr_paritions is used to represent how many partitions information
the cxl memory device has. In the loop, if driver cannot find a
partition including the new resource range, it will be an infinite loop.

[ dj: Removed incorrect fixes tag ]

Fixes: 991d98f17d31 ("cxl: Make cxl_dpa_alloc() DPA partition number agnostic")
Signed-off-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://patch.msgid.link/20260112120526.530232-1-ming.li@zohomail.com
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/hdm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index d3a094ca01ad9..20dd638108062 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -403,7 +403,7 @@ static int __cxl_dpa_reserve(struct cxl_endpoint_decoder *cxled,
 	 * is not set.
 	 */
 	if (cxled->part < 0)
-		for (int i = 0; cxlds->nr_partitions; i++)
+		for (int i = 0; i < cxlds->nr_partitions; i++)
 			if (resource_contains(&cxlds->part[i].res, res)) {
 				cxled->part = i;
 				break;
-- 
2.51.0



