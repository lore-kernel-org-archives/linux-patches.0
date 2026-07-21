Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523642DECDF;
	Tue, 21 Jul 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658318; cv=none; b=AYMW0GXae83C4VFfEzEe2iPPLcHQdp9uqLJS5hzv5wSKYCXLQnAFn+ax3/oV+j6Mt19syYdb1knxrgLFZIz9yQleG3RitMCcQtfyzNymyP5C9eHOPooVu/B5/ZuVOAAQw/EXtbsE5hl2X/XiKBe5jrmIXF4n1UnZZK1Nr0bS0kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658318; c=relaxed/simple;
	bh=p0Q7v4Vr9POYtoIsDL0dnYxgqOvybM3gZ+XQSxTeV2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqCxPPpaTR9enfCF6a1Y7iKJGUOgoaMnrN9l9zpEuJX/+KNr8dcusLUtuQJ+vW7E33dqoZEirXchT5CSxv38MsCVBbJH4Z1VkMu+oO2faXMpn1IwqPKmxL1ZuO99+CPsG1LRj4xVY/92Gkb7bkcQ3z/svQJzzRO3YPw9p2+JC64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Axjobn2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Axjobn2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B96531F00A3D;
	Tue, 21 Jul 2026 18:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658317;
	bh=xEPisc/j5Fu9sp0qnebHlSK84LW/1VsjDrsx1GWmc/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Axjobn2W0P8MYCE0HDAF7ztJLCXOjJovb4cOCD8gMIjmkAbrYETQrE2G8smI4CLv2
	 zd4PRIBdBUYf1k+K9Ph0teWkPhVxhP5PKvbwXNwrVFYm40blreBwG9SQhJgizih4OK
	 87l6EDHo1UWj+DrfAbcHg0Po65pEJi5FZUthblTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 1097/1611] mlxsw: fix refcount leak in mlxsw_sp_vrs_lpm_tree_replace()
Date: Tue, 21 Jul 2026 17:20:13 +0200
Message-ID: <20260721152540.091469471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
@@ -1019,6 +1019,7 @@ static int mlxsw_sp_vrs_lpm_tree_replace
 
 err_tree_replace:
 	for (i--; i >= 0; i--) {
+		vr = &mlxsw_sp->router->vrs[i];
 		if (!mlxsw_sp_vr_lpm_tree_should_replace(vr, proto, new_id))
 			continue;
 		mlxsw_sp_vr_lpm_tree_replace(mlxsw_sp,


