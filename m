Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40E74188A0C;
	Tue, 10 Sep 2024 10:10:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963021; cv=none; b=CqHcEn3socOzp0d9+MGgRqKSBcIiIv4Jo+uVSpjIy00eKu5IUD15JalqcUR6dDcjKBhD/tDdw9hbAbHj26zUEmjtKI5Fx0piuB3OOYN6sfrJs0xDhPiKp/Bv5U7wljSQ9yP6OSitSnAdWD4+o42rGHEorQIJdnBpX6mqW4KN65o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963021; c=relaxed/simple;
	bh=YxJS8bTn3aPEUe6n6GXhXzJD/ZHM+31RpdbSj0J66tE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iMRa42gXb0oh7Aq07TyslCYEl0LDcc4FU62F2LIb2pEQaAhbRE4STmCc+APtcDHFIl6TvdbGzaI8ai+T91t/X+UjOOI2vFlJMc6dCmfigmobeTA548sxRw7jMCbt+ArkUfCzzc/aa997otInNErue8/kw6SMwqTRW9/Pfhd6jt4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ylhLEaUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ylhLEaUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B398AC4CEC3;
	Tue, 10 Sep 2024 10:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963021;
	bh=YxJS8bTn3aPEUe6n6GXhXzJD/ZHM+31RpdbSj0J66tE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ylhLEaUbaP/tlcezWojLU2/5GNiCtIC1HYYEgcdqMczVo1F/OVCkUFGp4NcxyQd5r
	 nN75AfhVFgSCnEaT30ytGzIakd+GKQBpK4YyDvdS4za5ATswsqOnG1vWnEfdNPfRS6
	 y3ezocF0p3yCHXJ1aTv6TrTAvGMsdaLw5LfhXCts=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Chandan Kumar Rout <chandanx.rout@intel.com>
Subject: [PATCH 6.1 081/192] ice: allow hot-swapping XDP programs
Date: Tue, 10 Sep 2024 11:31:45 +0200
Message-ID: <20240910092601.324897521@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 469748429ac81f0a6a344637fc9d3b1d16a9f3d8 ]

Currently ice driver's .ndo_bpf callback brings interface down and up
independently of XDP resources' presence. This is only needed when
either these resources have to be configured or removed. It means that
if one is switching XDP programs on-the-fly with running traffic,
packets will be dropped.

To avoid this, compare early on ice_xdp_setup_prog() state of incoming
bpf_prog pointer vs the bpf_prog pointer that is already assigned to
VSI. Do the swap in case VSI has bpf_prog and incoming one are non-NULL.

Lastly, while at it, put old bpf_prog *after* the update of Rx ring's
bpf_prog pointer. In theory previous code could expose us to a state
where Rx ring's bpf_prog would still be referring to old_prog that got
released with earlier bpf_prog_put().

Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Reviewed-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Tested-by: Chandan Kumar Rout <chandanx.rout@intel.com> (A Contingent Worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Stable-dep-of: 04c7e14e5b0b ("ice: do not bring the VSI up, if it was down before the XDP setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index cd9bcc3536fb..1973b032fe05 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -2633,11 +2633,11 @@ static void ice_vsi_assign_bpf_prog(struct ice_vsi *vsi, struct bpf_prog *prog)
 	int i;
 
 	old_prog = xchg(&vsi->xdp_prog, prog);
-	if (old_prog)
-		bpf_prog_put(old_prog);
-
 	ice_for_each_rxq(vsi, i)
 		WRITE_ONCE(vsi->rx_rings[i]->xdp_prog, vsi->xdp_prog);
+
+	if (old_prog)
+		bpf_prog_put(old_prog);
 }
 
 /**
@@ -2917,6 +2917,12 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		return -EOPNOTSUPP;
 	}
 
+	/* hot swap progs and avoid toggling link */
+	if (ice_is_xdp_ena_vsi(vsi) == !!prog) {
+		ice_vsi_assign_bpf_prog(vsi, prog);
+		return 0;
+	}
+
 	/* need to stop netdev while setting up the program for Rx rings */
 	if (if_running && !test_and_set_bit(ICE_VSI_DOWN, vsi->state)) {
 		ret = ice_down(vsi);
@@ -2947,13 +2953,6 @@ ice_xdp_setup_prog(struct ice_vsi *vsi, struct bpf_prog *prog,
 		xdp_ring_err = ice_realloc_zc_buf(vsi, false);
 		if (xdp_ring_err)
 			NL_SET_ERR_MSG_MOD(extack, "Freeing XDP Rx resources failed");
-	} else {
-		/* safe to call even when prog == vsi->xdp_prog as
-		 * dev_xdp_install in net/core/dev.c incremented prog's
-		 * refcount so corresponding bpf_prog_put won't cause
-		 * underflow
-		 */
-		ice_vsi_assign_bpf_prog(vsi, prog);
 	}
 
 	if (if_running)
-- 
2.43.0



