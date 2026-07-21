Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C140043E071;
	Tue, 21 Jul 2026 22:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672246; cv=none; b=cvUDjg33ovKYJ2WO9EznLMbiarTZfacJQ54vaf1QB2RkcJp0vKWUacM5eT0ZxOaybD5BRRXxUIZAUjH/0d6Riki8iO4koF8aqc++uh+B4lO89f1JjbQ/wdhBqyU/ecwFK+ivMl0VwoXZbW/xQHi3ShTQyBeuEcqfuL3VsyPUMu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672246; c=relaxed/simple;
	bh=8F5vqnVqJk/7hcaE2fMDPuO/W9Unn064jbQP4RI2DU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H9aqG/GRuRYBoVafAJyOt/iv0XWkM+op7Nbo9wz5kDyb3ycv+1UhLcNqtEwcGJAVy0H17v8KEJK52XYGU6e4woEm3B8da6Ig7BFkUVtdOyyj/T6E3gVGoZx3/9k8XsP7+8rzMjrqia6Uvd8/6GrX0StV8YxmIVH2c8yl+de5Vo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc2nXYrY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc2nXYrY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8A21F000E9;
	Tue, 21 Jul 2026 22:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672245;
	bh=Ehnnk1z9NeyQp+/oVpaL8x91VCv4K9yjeGCUEGM7NY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Uc2nXYrYcJens3+K7Q9YEv0gXHOzZ7Vx/TzlnQhdJgEBwrbxpiNHmQRvs6kzErq0Y
	 qfC84R/UvORUN482NLUQ1iuiVz3p97kPCc9PXsq8ewzEWFnvCvevD73bkMdjURgDeI
	 K/uJLUZMcHDriukfcwWu4pYyNy9l85UTRq3Il/Jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 553/843] mlxsw: fix refcount leak in mlxsw_sp_vrs_lpm_tree_replace()
Date: Tue, 21 Jul 2026 17:23:08 +0200
Message-ID: <20260721152418.488293379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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
@@ -1007,6 +1007,7 @@ static int mlxsw_sp_vrs_lpm_tree_replace
 
 err_tree_replace:
 	for (i--; i >= 0; i--) {
+		vr = &mlxsw_sp->router->vrs[i];
 		if (!mlxsw_sp_vr_lpm_tree_should_replace(vr, proto, new_id))
 			continue;
 		mlxsw_sp_vr_lpm_tree_replace(mlxsw_sp,


