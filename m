Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32264F68C9;
	Wed, 30 Sep 2026 18:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793393; cv=none; b=tqc16GV/FhZ1Brp8zU0aUyPaosQVOhrivwgS6okQfScR1UpKp58vzI99j5VQDezNOtF4sssD3o8uyVy+/O/V0URb3a995go4mCaLrCPaL6TVxmzY9LdJ1IaiYBS+N39A+IrMIgGXKdQb9rftbdZPDn2QGoc+spOgE2cIdE28fCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793393; c=relaxed/simple;
	bh=kIr90d45gqEGaELX1Sk1agu1i/iqKToHJmJLR3hRmkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwLiEKtGJAip0aW7r0pi/i7vwbhlsqQy9E7xO3yi+7PdqILar6joocCfYqzEnRIJelaDe/WUUG2iBuRRTcsT4A0cgDM4pLiQ6sLuQ6MNF5+Jhj+xenTBZAqitO1O74uMcwzr7XsTwYoEmClQc8/B2uvKk6YRcRyrLgoQTF3wFzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D9P794RU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D9P794RU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199A41F000FF;
	Wed, 30 Sep 2026 18:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793392;
	bh=QIWgcm8bCUDEHuh7qSj3LZHMCMkM12wke/51pDhM1eA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D9P794RUSZJ8dW53Y8ZymUZIaIwvfKLkZ1XVsLpNazRdLiqWw5phtnQeesTVlNNjc
	 i3E7mZ4TO44g1eMb3OTd48KqLMtNwV9kWRWVJHvgaiHH4eAKqyp0FiV/D3GFvPlh1q
	 uo1p6JLbb9eFT513oSeOe4O9RSRZmr3DJoymabn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.18 239/395] drm/i915/dp_mst: Fix configuring FEC for a disconnected stream
Date: Wed, 30 Sep 2026 17:28:21 +0200
Message-ID: <20260930152345.842427516@linuxfoundation.org>
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

From: Imre Deak <imre.deak@intel.com>

commit acbe9a3b60b9a6ace8ef11fe898f586251c84592 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -799,7 +799,8 @@ static u8 get_pipes_downstream_of_mst_po
 		if (&connector->mst.dp->mst.mgr != mst_mgr)
 			continue;
 
-		if (connector->mst.port != parent_port &&
+		if (parent_port &&
+		    connector->mst.port != parent_port &&
 		    !drm_dp_mst_port_downstream_of_parent(mst_mgr,
 							  connector->mst.port,
 							  parent_port))


