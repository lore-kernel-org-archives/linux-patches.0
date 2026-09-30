Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491BD563296;
	Wed, 30 Sep 2026 17:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790436; cv=none; b=uooqUlr5hhZ7pQfH6rA+yTP4aBKtlk+RUZ+kaN94RCEr+qyHpd5iYRHDYwfynONQXI6cqYZStJUkkNTM4Ljqz54syktUtmFp40n+aU/m4p4af7mfxl0D7rcOSYl6Q1fEwPjRhq1LqXc5W/SLGKT5bDPjlHVO07hXZfo9W4vOlKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790436; c=relaxed/simple;
	bh=GmmXpjEVUh29dbLqNX46faO4PTe7etf+VkRHXHw9ooU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcj9Ivd93LpHaL2Tb0doQB6b5jyS4SfOVlpx+J1cGHlnnEYBeqMyCCCbtAWHjkswJ/+s+rMnJcNw4udIaDoI4nejIxKhql3ubkdY/jZ8YU1FMY/C+dQjr92PsapPZ4idnLdPyfraUVSH3s10V4PInfoH7FPYFD9aTDCTziadtV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R26upmHH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R26upmHH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2D941F00898;
	Wed, 30 Sep 2026 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790435;
	bh=Xr2p7JTxWZ+c0p1oo9Rb8AXhSzhm0kTFoG97Yurzwd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R26upmHHPhha3ysLSZbeormcnhzCGlMNlE8eiOQJ2d5ea7YX74llhICrnczWfMK2v
	 Bl5zEJFyDf3EYwu9uPs2Y0+aGIW7s27Ok47LiFc+g6Z1KsqmdDBz3fPSyup5JwiI6G
	 /4MTkTbjVXbXN7OTrbXeNDyVqFctT8L/KodhVhUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 826/877] drm/i915/dp_mst: Fix configuring FEC for a disconnected stream
Date: Wed, 30 Sep 2026 17:28:57 +0200
Message-ID: <20260930152432.554485649@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

[ Upstream commit acbe9a3b60b9a6ace8ef11fe898f586251c84592 ]

During an atomic commit after all the MST stream CRTC state is computed
the driver ensures that the FEC is configured the same way (enabled or
disabled) for all the streams on a given MST topology's link.
drm_dp_mst_port_downstream_of_parent() used to determine if a stream is
downstream of an MST port will return false if the whole topology is
disconnected, since in that case it can't verify that the port/
parent_port passed to it is in the given MST topology. This is a problem
during the above FEC configuration check, since
intel_dp_mst_check_dsc_change()->get_pipes_downstream_of_mst_ports()
will not return all the stream CRTCs/pipes for the topology as expected.
Since passing parent_port==NULL to get_pipes_downstream_of_mst_port()
is meant to return all the streams for the given topology (i.e. mst_mgr)
skip checking if an MST port is downstream of a parent port in this
case.

This fixes a problem where the FEC configuration check explained above
failed to ensure that all streams' FEC is configured the same way if the
topology was disconnected, leading to a FEC state mismatch error.

Cc: stable@vger.kernel.org # v6.10+
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16073
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/work_items/16384
Reviewed-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patch.msgid.link/20260907174413.741851-1-imre.deak@intel.com
(cherry picked from commit 270681fbffbba2b6ccf5b7e3c34b8b563b36167f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -739,7 +739,8 @@ static u8 get_pipes_downstream_of_mst_po
 		if (&connector->mst.dp->mst.mgr != mst_mgr)
 			continue;
 
-		if (connector->mst.port != parent_port &&
+		if (parent_port &&
+		    connector->mst.port != parent_port &&
 		    !drm_dp_mst_port_downstream_of_parent(mst_mgr,
 							  connector->mst.port,
 							  parent_port))


