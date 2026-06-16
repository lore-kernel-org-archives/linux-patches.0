Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135B846AF15;
	Tue, 16 Jun 2026 16:31:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627517; cv=none; b=b2g/GIyX3eUU5nmCI4Nm49cP5rrwVw7sgsrmMdoBcAyBOz5Ip8ggs5Xa+60JQ1BOwRNGJGBDipl5PPmBGv+T3WKnysHyTYnYJYXk77j8fLHQPWyBJrUw2y5wPzq2jsldUB0KOXYlSqBz/9imC5pyZCD/zjWVq5L3NBIai8g1hh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627517; c=relaxed/simple;
	bh=mub0T502W2Gm4L38sOJIoh763S3vs1Za9X3hwYXQao0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b05XOr/vr5bM9aKTx7NBapzXRbJg6LWE0lZXFixNXCtgRt2r0dpO+gZjOTxiuQHl8CcRNzlLVW8GysfWBxbMhm5APMYyCC27L6qZHbNoGEi8/m5+YPcV/zlqcfVIO+TdZFctPA5dEREXfBUwpcNkeE8G0IRggssGn6lZjW945dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fY9dAd7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fY9dAd7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B121F000E9;
	Tue, 16 Jun 2026 16:31:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627516;
	bh=KhVEBz7D2Fw2p8CIJgfuMHuf7B2Fr2pYw4bYFNv2+JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fY9dAd7Rp0deimphl66njELJOyW7lFaLWKS3C8tQh1DIs7i9zhR6GeAPPt6gqwh/s
	 oIQk7QEN1sZTeeslWSKYqfqFeWt/lbnqlukYv7rHr2mH8KMDtXHY7AlCIK26KmYQh5
	 nY8RIoOO+PYgpZlOQ6oGF0S8IXqZEwPo4xRSqRCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.12 186/261] nvmem: core: fix use-after-free bugs in error paths
Date: Tue, 16 Jun 2026 20:30:24 +0530
Message-ID: <20260616145053.687357948@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

commit 5b6b6fc491899d583eaa75344e094796ae9b530b upstream.

Fix several instances of error paths in which we call
__nvmem_device_put() - which may end up freeing the underlying memory
and other resources - and then keep on using the nvmem structure. Always
put the reference to the nvmem device as the last step before returning
the error code.

Cc: stable@vger.kernel.org
Fixes: 7ae6478b304b ("nvmem: core: rework nvmem cell instance creation")
Fixes: e888d445ac33 ("nvmem: resolve cells from DT at registration time")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204340.116743-3-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/core.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -1501,18 +1501,16 @@ struct nvmem_cell *of_nvmem_cell_get(str
 	cell_entry = nvmem_find_cell_entry_by_node(nvmem, cell_np);
 	of_node_put(cell_np);
 	if (!cell_entry) {
-		__nvmem_device_put(nvmem);
 		nvmem_layout_module_put(nvmem);
-		if (nvmem->layout)
-			return ERR_PTR(-EPROBE_DEFER);
-		else
-			return ERR_PTR(-ENOENT);
+		ret = nvmem->layout ? -EPROBE_DEFER : -ENOENT;
+		__nvmem_device_put(nvmem);
+		return ERR_PTR(ret);
 	}
 
 	cell = nvmem_create_cell(cell_entry, id, cell_index);
 	if (IS_ERR(cell)) {
-		__nvmem_device_put(nvmem);
 		nvmem_layout_module_put(nvmem);
+		__nvmem_device_put(nvmem);
 	}
 
 	return cell;
@@ -1626,8 +1624,8 @@ void nvmem_cell_put(struct nvmem_cell *c
 		kfree_const(cell->id);
 
 	kfree(cell);
-	__nvmem_device_put(nvmem);
 	nvmem_layout_module_put(nvmem);
+	__nvmem_device_put(nvmem);
 }
 EXPORT_SYMBOL_GPL(nvmem_cell_put);
 


