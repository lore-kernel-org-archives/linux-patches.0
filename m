Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8B95013AB;
	Wed, 30 Sep 2026 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789069; cv=none; b=VymK8NlikW5ddDunrjsMVdbQ8Y54zLCqk9IT8n704/PbDYeyhx2i84tt77tozI+Ya0A15f+7Vl0YfsFdqHfg2L9vCP277pqv90GWB//FN8Rxn9ftK9sb5WIjAkvtdguNm2ZW49UOH4+KP+YyLIADnBgSgXKdFMzSBuWRKTVff0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789069; c=relaxed/simple;
	bh=18GtcZPuVM0a5SjAFe7ysq8jJxqKgTECQCFSneZam0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hu54izXRVPZWx2tyU77VYFAuDez7wJ2gJSbudiK6BaGdhLm+QvV1qFF49JA9VoqSl+nM+ksOdvDgKDxY5rEIY/A/XuIcBVnfIydyWggrEUPbrrZ/6KosE/kyt0M0II8NKCozoDwOzqc3S3Ujy1Y6Rp9vxFYgJA7JzwftH+eiA/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WRLtu8/6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WRLtu8/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367441F000FF;
	Wed, 30 Sep 2026 17:24:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789067;
	bh=kF7bfj2MKLyT3teY4H8KMrg7IvJnmaZ1oJwSYO45x/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WRLtu8/6FRd4ooTYDXIEPLCfFuHyrGlo3/tv4IZSgl1z+TQ6hBz2bhYYV0THlou+V
	 INLtjTIvOqaQf88WAudhYGKUjt3eUOPWoWZ6kJc2CGm+wRuMJtJGbjfStWCKPWEQcC
	 4pAT1GRRRK387OComh0it+Qdrzd1r1I7yAdiRsis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 345/877] net/mlx5: devcom, Base component size on linked devices
Date: Wed, 30 Sep 2026 17:20:56 +0200
Message-ID: <20260930152422.113503837@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Shay Drory <shayd@nvidia.com>

[ Upstream commit d09e8f64653c93da5793c16be19330968f2a32e6 ]

mlx5_devcom_comp_get_size() returns the component's kref count. That
kref is bumped in mlx5_devcom_register_component() under comp_list_lock,
before the comp_dev is linked onto comp_dev_list_head under comp->sem.
The event broadcast (mlx5_devcom_locked_send_event()) walks that list.

Hence, a caller can read the expected size, but send_event won't be sent
to all peers. In the SD group registration path, this lets a member
broadcast its role-election event over an incomplete list, electing a
primary that never completes the group, is never marked ready, and
leaves the group with a stale primary.

Track the number of linked comp_devs in a dedicated counter, maintained
under comp->sem together with the list add/remove, and return it from
mlx5_devcom_comp_get_size().

Fixes: 9bb1ac80738a ("net/mlx5: devcom, Add component size getter")
Signed-off-by: Shay Drory <shayd@nvidia.com>
Reviewed-by: Akiva Goldberger <agoldberger@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260915113459.3934760-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
index 7b0766c89f4cf..cd8ce2abcf189 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -29,6 +29,7 @@ struct mlx5_devcom_comp {
 	struct list_head comp_dev_list_head;
 	mlx5_devcom_event_handler_t handler;
 	struct kref ref;
+	int nr_devs;
 	bool ready;
 	struct rw_semaphore sem;
 	struct lock_class_key lock_key;
@@ -158,6 +159,7 @@ devcom_alloc_comp_dev(struct mlx5_devcom_dev *devc,
 
 	down_write(&comp->sem);
 	list_add_tail(&devcom->list, &comp->comp_dev_list_head);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs + 1);
 	up_write(&comp->sem);
 
 	return devcom;
@@ -170,6 +172,7 @@ devcom_free_comp_dev(struct mlx5_devcom_comp_dev *devcom)
 
 	down_write(&comp->sem);
 	list_del(&devcom->list);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
 	up_write(&comp->sem);
 
 	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
@@ -260,7 +263,7 @@ int mlx5_devcom_comp_get_size(struct mlx5_devcom_comp_dev *devcom)
 {
 	struct mlx5_devcom_comp *comp = devcom->comp;
 
-	return kref_read(&comp->ref);
+	return READ_ONCE(comp->nr_devs);
 }
 
 int mlx5_devcom_send_event(struct mlx5_devcom_comp_dev *devcom,
-- 
2.53.0



