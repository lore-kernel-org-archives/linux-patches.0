Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7630E3BE642;
	Wed, 30 Sep 2026 18:28:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792895; cv=none; b=bSTw7r3XZnS9JRg63RfqZ2zeH4tbzp2fIwyUdlufMlXXigpuwJ8V1XmJmltDRN/qAqthdJV6+SIwUR5Hr6GfYmIS/c/rFIQe5oZzVKXCdd8JZXT8Ee9ksH23KYqgnUy00PGWRAt40tKb4fnuRzWEvTkfHpglq7TMhedWmO/zj7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792895; c=relaxed/simple;
	bh=Nyz/weyFDmkTAwQGTnX1Hmybcar8dqY09f2q4ce+Gfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cbd3jENdMlcv26B4QpYy+YvAdmioOHObLbX1QJL3YgU4k2YmGQ+7XP3CuoKqUOLlvzzER+MkYSRSb3/00qhUECimvd2Ch5dXYQB5SHGuQ2oSgnmr5noNAgyaUaF3M9tgFAbrv6w9e4TZRosRVKClWuHEM5OAPhvSJbDpVBbfZQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pnEVpoSZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pnEVpoSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D9A1F000FF;
	Wed, 30 Sep 2026 18:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792894;
	bh=e7uzK6WyAqC9dotCFiU6Js6yXqyUHWzSZ9/Blh38yBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pnEVpoSZczTVPTpCJ5qSQ3+w0kTMxLCYANCalt+AA6zUenm6oteY7x6U6oed6hOYS
	 QdMevFh/IDhRWtkA6b/xg6mZX3ZL/GQHw+j+jQK9w8ioeZ9LUavigXI40YROc+U5/W
	 7baLT2gguk6heU/GrqN4Ed1M0yLXLiX2bF/FmP6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Drory <shayd@nvidia.com>,
	Akiva Goldberger <agoldberger@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 062/395] net/mlx5: devcom, Base component size on linked devices
Date: Wed, 30 Sep 2026 17:25:24 +0200
Message-ID: <20260930152341.978856704@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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
index e749618229bc0..8946ba5e30bf1 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/devcom.c
@@ -36,6 +36,7 @@ struct mlx5_devcom_comp {
 	struct mlx5_devcom_key key;
 	mlx5_devcom_event_handler_t handler;
 	struct kref ref;
+	int nr_devs;
 	bool ready;
 	struct rw_semaphore sem;
 	struct lock_class_key lock_key;
@@ -169,6 +170,7 @@ devcom_alloc_comp_dev(struct mlx5_devcom_dev *devc,
 
 	down_write(&comp->sem);
 	list_add_tail(&devcom->list, &comp->comp_dev_list_head);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs + 1);
 	up_write(&comp->sem);
 
 	return devcom;
@@ -181,6 +183,7 @@ devcom_free_comp_dev(struct mlx5_devcom_comp_dev *devcom)
 
 	down_write(&comp->sem);
 	list_del(&devcom->list);
+	WRITE_ONCE(comp->nr_devs, comp->nr_devs - 1);
 	up_write(&comp->sem);
 
 	kref_put(&devcom->devc->ref, mlx5_devcom_dev_release);
@@ -283,7 +286,7 @@ int mlx5_devcom_comp_get_size(struct mlx5_devcom_comp_dev *devcom)
 {
 	struct mlx5_devcom_comp *comp = devcom->comp;
 
-	return kref_read(&comp->ref);
+	return READ_ONCE(comp->nr_devs);
 }
 
 int mlx5_devcom_send_event(struct mlx5_devcom_comp_dev *devcom,
-- 
2.53.0



