Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23371A5BB1;
	Tue, 12 Aug 2025 18:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024339; cv=none; b=Oyb4vfpTC2GgPcvxca4iAy/8z+YzcoB0oPP8Y31ZLLmGP2pNXDfL2jpZKAoHsVLiw/Qhmqb2/OfjIbcjQiqDhIWuBJ+SfEqh584jNkeWuW71MutoNwxrbotaXi6pDLlovxqzgH5wV4cgnrmO16xnXeJm60RaKBzT/xsOKVaTS30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024339; c=relaxed/simple;
	bh=L6EoyOjofhcSYWj5/QHYYjwqrRcWxlanpB4e6zUoAbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtSs9UCS0/xsIu3BoAMN00KIxjXWOb81vDxx+ezO3yCRaq7dFTV3cPl2rRPnN0h5S3uRAcETGAYtfn1fY56vPh/W6SqH12NEuas4Qz+AKZ0I00wO4B2gxajP6Rd6EZLgexivlXW6E+lUp2KIVfPdz9oiUJ/gRbBnxUAiUvazz0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnXHbnw5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnXHbnw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9CEC4CEF0;
	Tue, 12 Aug 2025 18:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024338;
	bh=L6EoyOjofhcSYWj5/QHYYjwqrRcWxlanpB4e6zUoAbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pnXHbnw5cLG0tfwc8kC1sSZps6lmRo6N1hKgNTiKc5kZPE8oSGZg0cZD8AGTgu1tp
	 tsrz9OUWiCG/vKtn+ynDqfgjDEOqOFZYyzROryLKw9SZ21AQ0ivS0yo7OEB8CMYnWp
	 g18vgQHu/874U1xox6K40QbYCc1dQkFc7yYt9+GY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parav Pandit <parav@nvidia.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 342/627] RDMA/uverbs: Check CAP_NET_RAW in user namespace for flow create
Date: Tue, 12 Aug 2025 19:30:37 +0200
Message-ID: <20250812173432.293396619@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Parav Pandit <parav@nvidia.com>

[ Upstream commit f458ccd2aa2c5a6f0129a9b1548f2825071fdc6b ]

Currently, the capability check is done in the default
init_user_ns user namespace. When a process runs in a
non default user namespace, such check fails. Due to this
when a process is running using Podman, it fails to create
the flow resource.

Since the RDMA device is a resource within a network namespace,
use the network namespace associated with the RDMA device to
determine its owning user namespace.

Fixes: 436f2ad05a0b ("IB/core: Export ib_create/destroy_flow through uverbs")
Signed-off-by: Parav Pandit <parav@nvidia.com>
Suggested-by: Eric W. Biederman <ebiederm@xmission.com>
Link: https://patch.msgid.link/6df6f2f24627874c4f6d041c19dc1f6f29f68f84.1750963874.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/device.c     | 27 ++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.c  | 29 ++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |  2 +-
 include/rdma/ib_verbs.h              |  3 +++
 4 files changed, 60 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index d4263385850a..792824e0ab2c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -145,6 +145,33 @@ bool rdma_dev_access_netns(const struct ib_device *dev, const struct net *net)
 }
 EXPORT_SYMBOL(rdma_dev_access_netns);
 
+/**
+ * rdma_dev_has_raw_cap() - Returns whether a specified rdma device has
+ *			    CAP_NET_RAW capability or not.
+ *
+ * @dev:	Pointer to rdma device whose capability to be checked
+ *
+ * Returns true if a rdma device's owning user namespace has CAP_NET_RAW
+ * capability, otherwise false. When rdma subsystem is in legacy shared network,
+ * namespace mode, the default net namespace is considered.
+ */
+bool rdma_dev_has_raw_cap(const struct ib_device *dev)
+{
+	const struct net *net;
+
+	/* Network namespace is the resource whose user namespace
+	 * to be considered. When in shared mode, there is no reliable
+	 * network namespace resource, so consider the default net namespace.
+	 */
+	if (ib_devices_shared_netns)
+		net = &init_net;
+	else
+		net = read_pnet(&dev->coredev.rdma_net);
+
+	return ns_capable(net->user_ns, CAP_NET_RAW);
+}
+EXPORT_SYMBOL(rdma_dev_has_raw_cap);
+
 /*
  * xarray has this behavior where it won't iterate over NULL values stored in
  * allocated arrays.  So we need our own iterator to see all values stored in
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 90c177edf9b0..18918f463361 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -1019,3 +1019,32 @@ void uverbs_finalize_object(struct ib_uobject *uobj,
 		WARN_ON(true);
 	}
 }
+
+/**
+ * rdma_uattrs_has_raw_cap() - Returns whether a rdma device linked to the
+ *			       uverbs attributes file has CAP_NET_RAW
+ *			       capability or not.
+ *
+ * @attrs:       Pointer to uverbs attributes
+ *
+ * Returns true if a rdma device's owning user namespace has CAP_NET_RAW
+ * capability, otherwise false.
+ */
+bool rdma_uattrs_has_raw_cap(const struct uverbs_attr_bundle *attrs)
+{
+	struct ib_uverbs_file *ufile = attrs->ufile;
+	struct ib_ucontext *ucontext;
+	bool has_cap = false;
+	int srcu_key;
+
+	srcu_key = srcu_read_lock(&ufile->device->disassociate_srcu);
+	ucontext = ib_uverbs_get_ucontext_file(ufile);
+	if (IS_ERR(ucontext))
+		goto out;
+	has_cap = rdma_dev_has_raw_cap(ucontext->device);
+
+out:
+	srcu_read_unlock(&ufile->device->disassociate_srcu, srcu_key);
+	return has_cap;
+}
+EXPORT_SYMBOL(rdma_uattrs_has_raw_cap);
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index bc9fe3ceca4d..6700c2c66167 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3225,7 +3225,7 @@ static int ib_uverbs_ex_create_flow(struct uverbs_attr_bundle *attrs)
 	if (cmd.comp_mask)
 		return -EINVAL;
 
-	if (!capable(CAP_NET_RAW))
+	if (!rdma_uattrs_has_raw_cap(attrs))
 		return -EPERM;
 
 	if (cmd.flow_attr.flags >= IB_FLOW_ATTR_FLAGS_RESERVED)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index c83e5a375cd6..087048b75d13 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -4801,6 +4801,8 @@ static inline int uverbs_destroy_def_handler(struct uverbs_attr_bundle *attrs)
 }
 #endif
 
+bool rdma_uattrs_has_raw_cap(const struct uverbs_attr_bundle *attrs);
+
 struct net_device *rdma_alloc_netdev(struct ib_device *device, u32 port_num,
 				     enum rdma_netdev_t type, const char *name,
 				     unsigned char name_assign_type,
@@ -4855,6 +4857,7 @@ static inline int ibdev_to_node(struct ib_device *ibdev)
 bool rdma_dev_access_netns(const struct ib_device *device,
 			   const struct net *net);
 
+bool rdma_dev_has_raw_cap(const struct ib_device *dev);
 static inline struct net *rdma_dev_net(struct ib_device *device)
 {
 	return read_pnet(&device->coredev.rdma_net);
-- 
2.39.5



