Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D73DA2F5A2C;
	Mon, 13 Oct 2025 15:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368484; cv=none; b=UCLF1PWmF+N16xRmHDjyqNAP2e/T8jFwrIjuUmkD1RgpJ5aOuu0ooeMQKu9l1SCrgL0O3Q+MFfcHUv6OdtrRNxBdaDQYI02FEMqHIIrhEWHI3/vGUNYl9ih567Ksn0qzLqeCJTEqDwFKzHjtXehYGTqKyjOgRHyPaCPPztjOreE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368484; c=relaxed/simple;
	bh=U2a2WChg4D+bx6HAjKIoyjiJIQdUuTOs3zSMR1lTXcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6NwuoJDn4Dw0CRc8M3C6VNHMCGrm0TuGMLWMJS7paJQpFuEqUPFLPyK0Lg0hqFE3CyvfYHwB/xlZRa4iQz5XR1BlqehxxINpjfQZSBxbvnm1dFlrbcNJ3vbbANIIh8I7+NWp7f8I1d5hVzI9OLF8y7yMuRCsRE+YL0+mo/k030=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1kPcVxrl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1kPcVxrl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34289C4CEE7;
	Mon, 13 Oct 2025 15:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368484;
	bh=U2a2WChg4D+bx6HAjKIoyjiJIQdUuTOs3zSMR1lTXcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1kPcVxrlDu+1MDJNB9JqAMwIp8uumtW925SMVAX3dONTdfxwn8KWNMrrCSETuU6A1
	 vMlw9vfuXMkDsrowJmY7dYEK3Ixk0YLHFSph3gcTKw6z2z1/bL2GrFitK//7otMazu
	 P5Nct4/JPfdYM7w77B0hF4SaltjMsscoCgC29mFw=
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
Subject: [PATCH 6.12 145/262] drivers/base/node: handle error properly in register_one_node()
Date: Mon, 13 Oct 2025 16:44:47 +0200
Message-ID: <20251013144331.344388775@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index eb72580288e62..6f09aa8e32237 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -879,6 +879,11 @@ int __register_one_node(int nid)
 	node_devices[nid] = node;
 
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



