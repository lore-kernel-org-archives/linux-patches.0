Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3F7267B91;
	Tue,  8 Apr 2025 12:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744114842; cv=none; b=mKfZ1ySlXJ4BtRp+PsuieyJNrDM42qQxHS4pVZmuDXzX5YfPupIUIudnjp0dZ9BWeH33CbJAltbhpqSs4Gs8SitmKvDMNm9CIgO2kLDiPliG9QfUat7cL/rUk//iUy3gBS3wzLtZNn5khmpRk4OrIbHKDY59wyQrj91QW9XeFcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744114842; c=relaxed/simple;
	bh=0O1c+PZ0PdCX3zYtSqeeufuca6J2tPBMot/vIOjXzEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lw/ALjqUVPel1SGBUOAjLp6hIuO5qmh3f74qlAWvt3uaUfVGDModQXCn1ZHp1USUA3otmHWjDlHffEV15ZGhYYvYNXew4XkpcA/8a2KUIVKDVIKdrEkW1ic3OEnHeBKRKdgMoycwHcppq14RKCsKJtK8u0QYz2MWCWz2tEJWlHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGbqeBY3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGbqeBY3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2CEC4CEE5;
	Tue,  8 Apr 2025 12:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744114842;
	bh=0O1c+PZ0PdCX3zYtSqeeufuca6J2tPBMot/vIOjXzEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGbqeBY3V+ApFXnj2tMqDqfFowTxzBi/pJeLag3E0lX9WkObKNgrgrIEhLMuUkJky
	 omf7sS5i0rERR9XxTl7sv1YhdkkgOIZChYUCAd+BiZXQ3KnHfZYWirsS9KN0tdNqgN
	 wPcxFDTEsg7T0AxZ0CsfGhX9Cq4q3B9cROtad84Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haoran Zhang <wh1sper@zju.edu.cn>,
	Mike Christie <michael.christie@oracle.com>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 215/499] vhost-scsi: Fix handling of multiple calls to vhost_scsi_set_endpoint
Date: Tue,  8 Apr 2025 12:47:07 +0200
Message-ID: <20250408104856.568767753@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Christie <michael.christie@oracle.com>

[ Upstream commit 5dd639a1646ef5fe8f4bf270fad47c5c3755b9b6 ]

If vhost_scsi_set_endpoint is called multiple times without a
vhost_scsi_clear_endpoint between them, we can hit multiple bugs
found by Haoran Zhang:

1. Use-after-free when no tpgs are found:

This fixes a use after free that occurs when vhost_scsi_set_endpoint is
called more than once and calls after the first call do not find any
tpgs to add to the vs_tpg. When vhost_scsi_set_endpoint first finds
tpgs to add to the vs_tpg array match=true, so we will do:

vhost_vq_set_backend(vq, vs_tpg);
...

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

If vhost_scsi_set_endpoint is called again and no tpgs are found
match=false so we skip the vhost_vq_set_backend call leaving the
pointer to the vs_tpg we then free via:

kfree(vs->vs_tpg);
vs->vs_tpg = vs_tpg;

If a scsi request is then sent we do:

vhost_scsi_handle_vq -> vhost_scsi_get_req -> vhost_vq_get_backend

which sees the vs_tpg we just did a kfree on.

2. Tpg dir removal hang:

This patch fixes an issue where we cannot remove a LIO/target layer
tpg (and structs above it like the target) dir due to the refcount
dropping to -1.

The problem is that if vhost_scsi_set_endpoint detects a tpg is already
in the vs->vs_tpg array or if the tpg has been removed so
target_depend_item fails, the undepend goto handler will do
target_undepend_item on all tpgs in the vs_tpg array dropping their
refcount to 0. At this time vs_tpg contains both the tpgs we have added
in the current vhost_scsi_set_endpoint call as well as tpgs we added in
previous calls which are also in vs->vs_tpg.

Later, when vhost_scsi_clear_endpoint runs it will do
target_undepend_item on all the tpgs in the vs->vs_tpg which will drop
their refcount to -1. Userspace will then not be able to remove the tpg
and will hang when it tries to do rmdir on the tpg dir.

3. Tpg leak:

This fixes a bug where we can leak tpgs and cause them to be
un-removable because the target name is overwritten when
vhost_scsi_set_endpoint is called multiple times but with different
target names.

The bug occurs if a user has called VHOST_SCSI_SET_ENDPOINT and setup
a vhost-scsi device to target/tpg mapping, then calls
VHOST_SCSI_SET_ENDPOINT again with a new target name that has tpgs we
haven't seen before (target1 has tpg1 but target2 has tpg2). When this
happens we don't teardown the old target tpg mapping and just overwrite
the target name and the vs->vs_tpg array. Later when we do
vhost_scsi_clear_endpoint, we are passed in either target1 or target2's
name and we will only match that target's tpgs when we loop over the
vs->vs_tpg. We will then return from the function without doing
target_undepend_item on the tpgs.

Because of all these bugs, it looks like being able to call
vhost_scsi_set_endpoint multiple times was never supported. The major
user, QEMU, already has checks to prevent this use case. So to fix the
issues, this patch prevents vhost_scsi_set_endpoint from being called
if it's already successfully added tpgs. To add, remove or change the
tpg config or target name, you must do a vhost_scsi_clear_endpoint
first.

Fixes: 25b98b64e284 ("vhost scsi: alloc cmds per vq instead of session")
Fixes: 4f7f46d32c98 ("tcm_vhost: Use vq->private_data to indicate if the endpoint is setup")
Reported-by: Haoran Zhang <wh1sper@zju.edu.cn>
Closes: https://lore.kernel.org/virtualization/e418a5ee-45ca-4d18-9b5d-6f8b6b1add8e@oracle.com/T/#me6c0041ce376677419b9b2563494172a01487ecb
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>
Message-Id: <20250129210922.121533-1-michael.christie@oracle.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/scsi.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 718fa4e0b31ec..7aeff435c1d87 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1699,14 +1699,19 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		}
 	}
 
+	if (vs->vs_tpg) {
+		pr_err("vhost-scsi endpoint already set for %s.\n",
+		       vs->vs_vhost_wwpn);
+		ret = -EEXIST;
+		goto out;
+	}
+
 	len = sizeof(vs_tpg[0]) * VHOST_SCSI_MAX_TARGET;
 	vs_tpg = kzalloc(len, GFP_KERNEL);
 	if (!vs_tpg) {
 		ret = -ENOMEM;
 		goto out;
 	}
-	if (vs->vs_tpg)
-		memcpy(vs_tpg, vs->vs_tpg, len);
 
 	mutex_lock(&vhost_scsi_mutex);
 	list_for_each_entry(tpg, &vhost_scsi_list, tv_tpg_list) {
@@ -1722,12 +1727,6 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		tv_tport = tpg->tport;
 
 		if (!strcmp(tv_tport->tport_name, t->vhost_wwpn)) {
-			if (vs->vs_tpg && vs->vs_tpg[tpg->tport_tpgt]) {
-				mutex_unlock(&tpg->tv_tpg_mutex);
-				mutex_unlock(&vhost_scsi_mutex);
-				ret = -EEXIST;
-				goto undepend;
-			}
 			/*
 			 * In order to ensure individual vhost-scsi configfs
 			 * groups cannot be removed while in use by vhost ioctl,
@@ -1774,15 +1773,15 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 		}
 		ret = 0;
 	} else {
-		ret = -EEXIST;
+		ret = -ENODEV;
+		goto free_tpg;
 	}
 
 	/*
-	 * Act as synchronize_rcu to make sure access to
-	 * old vs->vs_tpg is finished.
+	 * Act as synchronize_rcu to make sure requests after this point
+	 * see a fully setup device.
 	 */
 	vhost_scsi_flush(vs);
-	kfree(vs->vs_tpg);
 	vs->vs_tpg = vs_tpg;
 	goto out;
 
@@ -1802,6 +1801,7 @@ vhost_scsi_set_endpoint(struct vhost_scsi *vs,
 			target_undepend_item(&tpg->se_tpg.tpg_group.cg_item);
 		}
 	}
+free_tpg:
 	kfree(vs_tpg);
 out:
 	mutex_unlock(&vs->dev.mutex);
@@ -1904,6 +1904,7 @@ vhost_scsi_clear_endpoint(struct vhost_scsi *vs,
 	vhost_scsi_flush(vs);
 	kfree(vs->vs_tpg);
 	vs->vs_tpg = NULL;
+	memset(vs->vs_vhost_wwpn, 0, sizeof(vs->vs_vhost_wwpn));
 	WARN_ON(vs->vs_events_nr);
 	mutex_unlock(&vs->dev.mutex);
 	return 0;
-- 
2.39.5



