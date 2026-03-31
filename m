Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E41A3EF0A2;
	Tue, 31 Mar 2026 16:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975775; cv=none; b=Cx8Jc86n5YL2IUWKm4S/6MMdewyUsqbUBp9daiBPg+B2QBVfro5ovgGV2uYCN3P097Pvmi5ELNlhkvMgdXxLQOEZkTkevgy4KJnzuH51EOmACQQ3moQum9A5VHjVozlwm1458LQpChWhXgBscJ3FTdpp2V4KzuY3po8WCcWnyqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975775; c=relaxed/simple;
	bh=7mQGE8NoNUpuu6PoxOaqw+e7cl6Vx/A6Y6IEFH+JvAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhzd6l+ddPY3q1mMAaki2LlbvJm8DMdAy6TVt6BlSlnYIW3A3w7Qa6VtdeAPuE6x1OelUevmM+uuSx7KqTYkHBJOFUJBtmbxX4WIoIyzrHmCU1w5qSTK5rNPxKlSzYIONyWCB+SECauz1GyNpQRbXdhgEV1zuk5nkylEdUNpM2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb13bU0Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb13bU0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D07C19423;
	Tue, 31 Mar 2026 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975774;
	bh=7mQGE8NoNUpuu6PoxOaqw+e7cl6Vx/A6Y6IEFH+JvAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb13bU0YFzjfYKHI+pQMMWAVmCt91+s+Nx7hPE0zv2t9eOOv7Zg3ZSt99pqUi/Dru
	 p1nbET+Z/t1WfbAb1IS/o0WfClN1GT5zJfZDB5cm7apkcQm6aUJCzvw5lofmJ1w5TY
	 u3dhP/3A4Ao2iqhRQEwQlQs7CTfVvXuANPkDocoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Oros <poros@redhat.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Patryk Holda <patryk.holda@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/244] ice: fix inverted ready check for VF representors
Date: Tue, 31 Mar 2026 18:20:32 +0200
Message-ID: <20260331161744.711048512@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Petr Oros <poros@redhat.com>

[ Upstream commit ad85de0fc09eb3236e73df5acb2bc257625103f5 ]

Commit 0f00a897c9fcbd ("ice: check if SF is ready in ethtool ops")
refactored the VF readiness check into a generic repr->ops.ready()
callback but implemented ice_repr_ready_vf() with inverted logic:

  return !ice_check_vf_ready_for_cfg(repr->vf);

ice_check_vf_ready_for_cfg() returns 0 on success, so the negation
makes ready() return non-zero when the VF is ready. All callers treat
non-zero as "not ready, skip", causing ndo_get_stats64, get_drvinfo,
get_strings and get_ethtool_stats to always bail out in switchdev mode.

Remove the erroneous negation. The SF variant ice_repr_ready_sf() is
already correct (returns !active, i.e. non-zero when not active).

Fixes: 0f00a897c9fcbd ("ice: check if SF is ready in ethtool ops")
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Patryk Holda <patryk.holda@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_repr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_repr.c b/drivers/net/ethernet/intel/ice/ice_repr.c
index 970a99a52bf18..1b1288d243248 100644
--- a/drivers/net/ethernet/intel/ice/ice_repr.c
+++ b/drivers/net/ethernet/intel/ice/ice_repr.c
@@ -314,7 +314,7 @@ ice_repr_reg_netdev(struct net_device *netdev, const struct net_device_ops *ops)
 
 static int ice_repr_ready_vf(struct ice_repr *repr)
 {
-	return !ice_check_vf_ready_for_cfg(repr->vf);
+	return ice_check_vf_ready_for_cfg(repr->vf);
 }
 
 static int ice_repr_ready_sf(struct ice_repr *repr)
-- 
2.51.0



