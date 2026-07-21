Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FD644AB91;
	Tue, 21 Jul 2026 22:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674143; cv=none; b=ZAmHwOcdmJBwR1dPGVHgdwthqKLXC/XUrVkEWyj004Sgl7tL3gq+hxqn4ehU5rLj0RrqCl2XgodUf98QKhXLCb3W2rbIndX0eKS/UX7jlWnvhNngZfKKTU8owjwCPvqP6r1wdJFnjZgwort7Q0A5MbgbJ+Ezh0gNtvdvcRQLCcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674143; c=relaxed/simple;
	bh=/PLPtYoLfqVKgJuXpsMAazljUh6Gm05AR3n7P+/KJN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTVbjknabMzJWaDRNCT+DEAR3z6S/Nueue2GsxJMaJkGJrINN1VedJOAnAi796fyRrIbvTFc4TMOZJn5POaTg0ZJND+d9/TfXTaN1VxJDEGWz5OBuriRXaOKshqelnsij6I3LWvi4i9yIGFAF/xGBZlzh3BSqeiR+Kg1OQQyzVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IyaWEzl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IyaWEzl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A29B1F000E9;
	Tue, 21 Jul 2026 22:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674141;
	bh=Xck4Mm1XrSF5nt9mjbYrtEWeBB95S8pq8NPDOe3z9dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IyaWEzl13zQTOxCjBNAGnMuK1ZeCC3Ccsv6p0jq1Cf3Xt4KmPZaAAAWP6Ep/NpH5t
	 Qt/S0QnDeobQTShr4JJjlB/z/F5sitGc0HpPb0YP6bw/o3XsjAnj/NLWY7HU+/+Mgd
	 bcFXo6aSl4Zg4dHza0xqsv0dSZJyx0vfbbQ16l88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 429/699] mlxsw: fix refcount leak in mlxsw_sp_vrs_lpm_tree_replace()
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152405.368489808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -910,6 +910,7 @@ static int mlxsw_sp_vrs_lpm_tree_replace
 
 err_tree_replace:
 	for (i--; i >= 0; i--) {
+		vr = &mlxsw_sp->router->vrs[i];
 		if (!mlxsw_sp_vr_lpm_tree_should_replace(vr, proto, new_id))
 			continue;
 		mlxsw_sp_vr_lpm_tree_replace(mlxsw_sp,


