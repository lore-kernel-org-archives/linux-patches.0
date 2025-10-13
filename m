Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48334306480;
	Mon, 13 Oct 2025 14:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367295; cv=none; b=XwIgJIcXn4jWWk4VP1kPYUIu9DeFEppdaFKBYzRBvgy9T7wnDC/gGMYn4vctLgaqHAInSaelluEetKwOKkJyd6p3QdMTjZb4GzG9dNXcV+N/mZKy6SkLEnVz3indQjETXZfp8TjrRRnxOcI751bgUUqhKnVJMd/PPaj8ZewBanw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367295; c=relaxed/simple;
	bh=VK4Vc4e3MDAfFf1g0dgbgtxauS2FvHFNhEjRINUB+C8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqzQ9XBoAz/wcg3SVpAWQTKpojQyCBSKPzCuJlaEArTFd028RgIFSQsawF+OW/w56/YLsgVjTsgJ9fRPwWC+MzlPB+7hYzSYUksW8avEaxnY8r5Im5e7JgsRz927fIDQ1vF8cAC27CTV/Q/HbiOT1tGiwYpplTTt42BeJFZNArk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UqwkXmjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqwkXmjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC23C4CEE7;
	Mon, 13 Oct 2025 14:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367295;
	bh=VK4Vc4e3MDAfFf1g0dgbgtxauS2FvHFNhEjRINUB+C8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqwkXmjBponOC1cm9Nf6Kx/HelJTBVwnpzXHwQ7hF9A8P5NCdwSxE9VIcI8jrrZUJ
	 wfHTvWnPipqhGdOWhvh8UZaXwcko9fuiIKlxtQysr1/DBXx86Q7Ea/tYdKxxWfEc0e
	 akxQP6V+rrntlILaB8vDcNxFWjKFDMVeDWb0PdcM=
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
Subject: [PATCH 6.1 126/196] drivers/base/node: handle error properly in register_one_node()
Date: Mon, 13 Oct 2025 16:44:59 +0200
Message-ID: <20251013144319.253469825@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a4141b57b1478..cbaa4e2eddcef 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -869,6 +869,11 @@ int __register_one_node(int nid)
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



