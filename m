Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B36C41C303;
	Wed,  4 Feb 2026 15:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218394; cv=none; b=GTIauJPuX9dmoG6MWYQch/AkoBZylNOoTlXOXjZs1zeOwrcwRawSUn+ql9z/8WZ9XFo5SqI97VDl+HkPp/8i5QA+FF2jWg43+suNLY9Sk1vlYx0P0ShEpebls5i/8ZCozAHIGp5uUz7usfhGmnJn5s0MVZjYuaL4Yer0dLYpGFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218394; c=relaxed/simple;
	bh=6ABKFSBLdx07wdo6LwA61flnk8CT6F6tYqd+6TGwj3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c4NRJ0HC3KOyzmGVmuAYlccjAotasNIIXEx9TyJUrtMf/AbLsFpdOG+VStPAPbQEaV+dzK6QA6kcmyRhkILf+VOnmZwtWoylIpXcIYlO33mhAtshDaxmiVZglytb5xL3emtj5LeHlI+qCrbQGYNxfgqiJk9LHj/VjJKVIioHrmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZM5UcfE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZM5UcfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD5EC4CEF7;
	Wed,  4 Feb 2026 15:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218394;
	bh=6ABKFSBLdx07wdo6LwA61flnk8CT6F6tYqd+6TGwj3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZM5UcfEK2hCvZRSjaUpFE3pp9p+kAWPVaVR+kHh+pypw74/F9Dz8tiJfWX3y87W2
	 EpAmOy4gyuoFSQlcOY1lIyCCvmlMg8K5/2/vw1TMwF18Qf3uPIiuTEnWvfN0n2lTN4
	 SrGpliz20zenv9mT/gQbBF0ezz1dWQSw9I3+7ndk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 18/72] net/mlx5e: Skip ESN replay window setup for IPsec crypto offload
Date: Wed,  4 Feb 2026 15:40:21 +0100
Message-ID: <20260204143846.282598489@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
References: <20260204143845.603454952@linuxfoundation.org>
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 011be342dd24b5168a5dcf408b14c3babe503341 ]

Commit a5e400a985df ("net/mlx5e: Honor user choice of IPsec replay
window size") introduced logic to setup the ESN replay window size.
This logic is only valid for packet offload.

However, the check to skip this block only covered outbound offloads.
It was not skipped for crypto offload, causing it to fall through to
the new switch statement and trigger its WARN_ON default case (for
instance, if a window larger than 256 bits was configured).

Fix this by amending the condition to also skip the replay window
setup if the offload type is not XFRM_DEV_OFFLOAD_PACKET.

Fixes: a5e400a985df ("net/mlx5e: Honor user choice of IPsec replay window size")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1769503961-124173-5-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index 5161bf51fa110..fdf664e9c46e9 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -350,7 +350,8 @@ void mlx5e_ipsec_build_accel_xfrm_attrs(struct mlx5e_ipsec_sa_entry *sa_entry,
 		attrs->replay_esn.esn = sa_entry->esn_state.esn;
 		attrs->replay_esn.esn_msb = sa_entry->esn_state.esn_msb;
 		attrs->replay_esn.overlap = sa_entry->esn_state.overlap;
-		if (attrs->dir == XFRM_DEV_OFFLOAD_OUT)
+		if (attrs->dir == XFRM_DEV_OFFLOAD_OUT ||
+		    x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
 			goto skip_replay_window;
 
 		switch (x->replay_esn->replay_window) {
-- 
2.51.0



