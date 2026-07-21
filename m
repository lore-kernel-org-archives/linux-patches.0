Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B88ED2E736D;
	Tue, 21 Jul 2026 17:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653944; cv=none; b=FUnCsgK8UMBexyFgJdcaw4fJd1QjjBpNuycyNJJl4yrhZ56TKCynX/46Qipw/hcd0hnYIjZy4QxF3VLg93yLXUKzs3utuSqMM7nvQIHkZZZ2LDvyfqW42qSFYzbHelIXR7S5M91u6cSKuKWpefMRJvrsYG85F81r7GNOXzVTbu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653944; c=relaxed/simple;
	bh=aFQHPCydSl90pBNaE/GHUXPw5TYyGqCnR4hW/Wf+iu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ShiHtwVyezXtJy6Ap6sbucDZoAt0SQN4qtToXKeA/HqT8kRsgJzcR1Ih2mpQmqUCazsIvar5OmQNWV7KC0ck00+OuH9J3iA+0SNmwQCq/EJWaTW37E9XmR9D0xc5vjmHDebzYz3L+jeYwtPrrwO8f6Va5mIpb9D7GnWAuAC7aNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZO/kndyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZO/kndyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5421F000E9;
	Tue, 21 Jul 2026 17:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653943;
	bh=LhpEo8+iaIHnCWVSBrn4msGCax7mrrw9HaA1fb8XP3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZO/kndyUvsNCLdwpOjV7xZ/vYd2GPSPgPyHhGPM32FvmPy58cdwOeM3/m6BTpdSFl
	 8hf0A4eGCSvOHQ/Mqz6Sd5i2muxES6MXFJdnvUj2GmlRyw98OlaYqUChcs4ZCdF5Zu
	 zPCdYacEOsSpmfJaK1szAyKeTfwshqJQO7rIOKvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 1516/2077] mlxsw: fix refcount leak in mlxsw_sp_port_lag_join()
Date: Tue, 21 Jul 2026 17:19:49 +0200
Message-ID: <20260721152628.540292849@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 41c8c1d65b32beacd8d916a22457b4f6e47f45af upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4360,7 +4360,7 @@ static int mlxsw_sp_port_lag_join(struct
 	lag_id = lag->lag_id;
 	err = mlxsw_sp_port_lag_index_get(mlxsw_sp, lag_id, &port_index);
 	if (err)
-		return err;
+		goto err_lag_uppers_bridge_join;
 
 	err = mlxsw_sp_lag_uppers_bridge_join(mlxsw_sp_port, lag_dev,
 					      extack);


