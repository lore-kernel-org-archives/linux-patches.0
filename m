Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490FB31B81D;
	Mon, 27 Oct 2025 18:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591081; cv=none; b=YZ3Rc8+lDrJiieyBrIJcoUEM58Z4UGXSy9fqO3rxecWK1XT4kKk9zkaES+oTwsknc8PZKpXcgKff/gBL/4rOxo3tSZ3SLBUal4Dr0fa9gFoxOKDjUC3zYsAGe6d1OHWlm2Y+yihhJJyCCnmzFBXsVJXM37NikgZRnZRmq84HnCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591081; c=relaxed/simple;
	bh=hxC735n89VP89gk7LwbmpCVLzQl6tsb8X+K2ZmlX1Ns=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdiAG4YFGfPG4msdhviPp0Z6hanM3Wyvk8bh2o+X2TUHSxhXN3m4lGqhtsPZ+PnlQ6jcMDBjpt82kmDPjNrTGHDwqAf8Y2eRmt1spxiF33ijgaTLjE333WpPZ8TnJb0Cw8NqVrh/rpzGJdieoAQG9UWX2THRcK9EvAEHLnuuLnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zS2rXpXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zS2rXpXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A70CBC4CEF1;
	Mon, 27 Oct 2025 18:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591081;
	bh=hxC735n89VP89gk7LwbmpCVLzQl6tsb8X+K2ZmlX1Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zS2rXpXHlQZmIZ0ANxbufmVD3VSF268Q6pkonr4SxNncihwHtlvepDxULxI63RI5w
	 h95EQT5R2NBnqk/G2YARFAXZ+S6CXrXbAuiROVktwavoJ+b5ka/unCwmn/iJouBgqv
	 FDfwRHUZOHtA2FDZgeRn4NYHm2i4D/vatKPGzwdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donet Tom <donettom@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>,
	Joanthan Cameron <Jonathan.Cameron@huawei.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	"Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 060/332] drivers/base/node: handle error properly in register_one_node()
Date: Mon, 27 Oct 2025 19:31:53 +0100
Message-ID: <20251027183526.204862707@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Donet Tom <donettom@linux.ibm.com>

[ Upstream commit 786eb990cfb78aab94eb74fb32a030e14723a620 ]

If register_node() returns an error, it is not handled correctly.
The function will proceed further and try to register CPUs under the
node, which is not correct.

So, in this patch, if register_node() returns an error, we return
immediately from the function.

Link: https://lkml.kernel.org/r/20250822084845.19219-1-donettom@linux.ibm.com
Fixes: 76b67ed9dce6 ("[PATCH] node hotplug: register cpu: remove node struct")
Signed-off-by: Donet Tom <donettom@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Donet Tom <donettom@linux.ibm.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hiroyouki Kamezawa <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Joanthan Cameron <Jonathan.Cameron@huawei.com>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: Yury Norov (NVIDIA) <yury.norov@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/node.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 5f745c906c330..735527922a3d3 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -961,6 +961,11 @@ int __register_one_node(int nid)
 		return -ENOMEM;
 
 	error = register_node(node_devices[nid], nid);
+	if (error) {
+		node_devices[nid] = NULL;
+		kfree(node);
+		return error;
+	}
 
 	/* link cpu under this node */
 	for_each_present_cpu(cpu) {
-- 
2.51.0



