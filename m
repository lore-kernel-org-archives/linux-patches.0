Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97840299948;
	Mon, 13 Oct 2025 15:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367724; cv=none; b=R/3JZ3q/JtuTdln/MLdMM+LsogCsClBcnXiU2al1y445ASeuve3Amogq0Clttafu1DK3hpnmd+BIr/hBzWjwY4z2D5bHunI5M+GEnbi+1a4gS9t7HQGVogBalaK7+vTfMMtWBNuSl2/Dpk5ckV6lFUC800lx827ldd5fEiu+8BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367724; c=relaxed/simple;
	bh=H5J9bhqqAU+Dwo1n6yR4HQ88M1fxrMh0e66JLl86QfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jwB8AVSfsIY8eejZi2/p8XWuRnLP2BitUs069380m567rZTQXglBdRrrPKbjYinbBGRDOlP9O/yb4JMQemhQ6zBzmeeqdyn7BllEmnKzP5zM47ZstnNqqbxIUdG6ycneb5LnGTDCiwMe34p895NwOofUEBG9nsCLNDCJdpNheFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHOrYGWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHOrYGWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF31BC4CEE7;
	Mon, 13 Oct 2025 15:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367724;
	bh=H5J9bhqqAU+Dwo1n6yR4HQ88M1fxrMh0e66JLl86QfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FHOrYGWjGntPYGQGHV2ToBXbxKeE9tol/yjizTfYYAWmiomG+S+ITn6EVGwmxw8lk
	 1yNVzEfRugpRqW/6xkZ2BYrBnstBfFVM/GNKBPV9QF4zekXsa0avBWpuFuaaxxGMFr
	 JngqqJcivx2OVu/qYTAPq7YwUoIDcKdJl3At4hw8=
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
Subject: [PATCH 6.6 112/196] drivers/base/node: handle error properly in register_one_node()
Date: Mon, 13 Oct 2025 16:45:03 +0200
Message-ID: <20251013144319.363492889@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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
index 4d588f4658c85..7b2ff66c119ae 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -878,6 +878,11 @@ int __register_one_node(int nid)
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



