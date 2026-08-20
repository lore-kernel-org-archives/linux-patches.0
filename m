Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48597361657;
	Thu, 20 Aug 2026 16:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787243367; cv=none; b=fCJnNFAX5T/QhXAh3NsY0UCmAHriqOGLOBDmByQX7UwG/K4P9rO/B3g153sPUZdtxpR47WYCqX10eH2Ta6MYqZo9lEk9s9FY/n6H1b7usPDZeZOJ84EITQ0TSzPaGuP9x7r6iQq0kOoHXCOD7qkhnUlDQFpkTKxyKyrI1gJB9I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787243367; c=relaxed/simple;
	bh=FZ2PhnSkTFsxL4eO4g9cjzMI946OpO8Gl7K9ookm3hA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qwO3QZ45xs4f2RBbzk+Sn1ahNxEHhV1HCK/Skd5U7FA4MFA96IV42zwugJtgtWj8cqKagWe6STYEtd/rWYGrQrhojCmnbebDl40pIMp1x5rsf/z9WvPfZFzSe1szbHqwfwCd36EN3ojk54CtqroMPlKibqIPYeEnx6yZoCbzIGc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpz9fGZE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpz9fGZE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33251F000E9;
	Thu, 20 Aug 2026 16:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787243366;
	bh=owOI1dLxa/LNQK2bp8LhKfm3trXeBWs48P7O93sugmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpz9fGZE5HNCKsG1w5DnbJD2agstGmINl3DrpYHFw/nVhLXHuz1gNDKBZ0ApNGur6
	 qAlXS9NBoGmeBxNjFGOK0/cwskzvND86BpmHfYvREU1ML+g3O6Um14uFsl3HWUbSPm
	 6ZvbaY7C9Wt3a801VNJ44JsdotUrXkAX3vao50zM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 069/272] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Thu, 20 Aug 2026 16:54:13 +0200
Message-ID: <20260820145233.355983179@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145231.229664293@linuxfoundation.org>
References: <20260820145231.229664293@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 41c8c1d65b32beacd8d916a22457b4f6e47f45af ]

When mlxsw_sp_port_lag_index_get() fails, mlxsw_sp_port_lag_join()
returns an error without releasing the lag reference obtained by
the earlier mlxsw_sp_lag_get().  All other error paths in the
function jump to the cleanup label that ends with
mlxsw_sp_lag_put(), so this is a single missed release.

Fix the leak by replacing the bare 'return err' with a goto to the
existing error cleanup label, which will drop the reference safely.

Cc: stable@vger.kernel.org
Fixes: 0d65fc13042f ("mlxsw: spectrum: Implement LAG port join/leave")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260609083709.209743-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3942,7 +3942,7 @@ static int mlxsw_sp_port_lag_join(struct
 
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


