Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E20C438FEE;
	Tue, 21 Jul 2026 20:49:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666987; cv=none; b=i/siS8UgI0EPmniSC3EoW1usUmOJwjLOGvpfz4wzOjfgz0Y6aXsWOLA5KNRzmrK8jyRj+M9MiahY5m0V6t7aEdujJMZWn+1PGcI/xe/W4bP1DvuPz+r/mNT9h0k166gI2aCCPcKUQ+iAXl0NKYiPZPi+WEJj+ErwLthJ4wc4iwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666987; c=relaxed/simple;
	bh=i2Nc82TruJJw+5N6aTnL8dpoc1bU1RTwAWdwFs780Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEDUbhLI6PmJ1/ip9CgyulpLrEaQig8WMFrMEkrup+5mBS0ayZqYY6/DxRTD7mfZQJa1rIoaiz0KCejFf2xcjlKsD2rK+ljZnV4uDCdgkKb1tOlWm6hr2bJgqUWWXFT5qQ7Ad6GX/H5EvUqXPZhUBqq7xyphphUh07Qg+fcSbYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VcIYYgAB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcIYYgAB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B68B1F000E9;
	Tue, 21 Jul 2026 20:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666983;
	bh=umE3IjriutHWzF2f3R2/QZxcIY9YRu3KjoTJBRygFVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VcIYYgABJTR2/9Q1tRqjh55vHJphWQoadOQryWuHGPESu8bBy1yRMXHpyAhox5Ug8
	 AuCEx89lQKvcB52TwRQX9cKHm+rEoqZJ+Nd8fyMvSbKJsahTINtkAa4XFzpiuIMJQB
	 Nj8nLZNfhZl9QYgzWvvsICPoiLjJjuHYYq0wmBI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0890/1266] mlxsw: fix refcount leak in mlxsw_sp_vrs_lpm_tree_replace()
Date: Tue, 21 Jul 2026 17:22:07 +0200
Message-ID: <20260721152501.763773435@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 21cf8dc478a49e8de039c2739b1646a774cb1944 upstream.

When mlxsw_sp_vrs_lpm_tree_replace() fails after replacing some VRs,
the error rollback loop does not correctly revert the preceding
replacements. The loop decrements the index but fails to update the
vr pointer, which still points to the VR that caused the failure. As
a result, the condition and the rollback call always operate on the
same VR, potentially calling mlxsw_sp_vr_lpm_tree_replace() multiple
times on it while never rolling back the earlier VRs. Those VRs
continue to hold a reference to new_tree acquired via
mlxsw_sp_lpm_tree_hold(), leaking the reference count of new_tree.

Fix by reinitializing vr inside the error loop with the updated index:

	vr = &mlxsw_sp->router->vrs[i];

so that the loop correctly iterates over all VRs that were actually
replaced.

Cc: stable@vger.kernel.org
Fixes: fc922bb0dd94 ("mlxsw: spectrum_router: Use one LPM tree for all virtual routers")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20260609084730.215732-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1018,6 +1018,7 @@ static int mlxsw_sp_vrs_lpm_tree_replace
 
 err_tree_replace:
 	for (i--; i >= 0; i--) {
+		vr = &mlxsw_sp->router->vrs[i];
 		if (!mlxsw_sp_vr_lpm_tree_should_replace(vr, proto, new_id))
 			continue;
 		mlxsw_sp_vr_lpm_tree_replace(mlxsw_sp,


