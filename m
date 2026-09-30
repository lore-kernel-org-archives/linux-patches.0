Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3564351617E;
	Wed, 30 Sep 2026 16:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787583; cv=none; b=MUQFvjlvHn6JUAjGi6APFVi80oQcfUXNQ7YY4CkP2jm4DkX9UyZz4IYEO/RTLQrLHODnNlrUMYV9xBoQ5dia5zvwR+6g9eEjUaGmgIpuLwMHzOjZlepDHWhlgaEWqZHFx16Gy1MTmOhgbwe7cXtZ2RqLWfW8UKEoOayZWQaQcwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787583; c=relaxed/simple;
	bh=r0CnBkjKevgTj+vtYBKq2ZQ42CJLY0yoRzdWitPm36w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ML9IiH9tFtxO8H+0MDfW69rQ5hEHqhK3wGqrxu6/qJ0qC7PfbxARfKvqpekO8TJA6O09/+bwfl4SIBafIdQTVbef/pOSPMMwoeHXNXjpO7e/eXRoFw6lMtLQQM9nTf3TAAPXQ8EvbCPz9iZsS4TVmtNnOgDJxtJnbwud8teBsCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZwRPxLi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZwRPxLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91AE01F00898;
	Wed, 30 Sep 2026 16:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787582;
	bh=zCXVnGzAfbzkwISU1+AKRwS61Wdybm1U569VOu1reA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AZwRPxLi748dJLCLEBA63wgcB48Nap6UXq8mLJ7h+dNiIidG/ktfN7Stssq30FNrA
	 nZCN7X5qm0/S9ntm4ER46MoAFoDWfe4tCC2JhUDnb59UonMtzOC1ZWw03DQsCIdpGN
	 xgvExmdzO1UvKC/a5Gtv4stBNsxX1CSF/lxQIn84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luca Coelho <luciano.coelho@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 7.2 280/457] drm/i915/dp_mst: Fix configuring FEC for a disconnected stream
Date: Wed, 30 Sep 2026 17:26:25 +0200
Message-ID: <20260930152352.079515126@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -813,7 +813,8 @@ static u8 get_pipes_downstream_of_mst_po
 		if (&connector->mst.dp->mst.mgr != mst_mgr)
 			continue;
 
-		if (connector->mst.port != parent_port &&
+		if (parent_port &&
+		    connector->mst.port != parent_port &&
 		    !drm_dp_mst_port_downstream_of_parent(mst_mgr,
 							  connector->mst.port,
 							  parent_port))


