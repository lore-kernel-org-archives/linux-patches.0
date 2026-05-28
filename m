Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72CF330B2D;
	Thu, 28 May 2026 19:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998203; cv=none; b=j7Ds2sy8L+d4hqlO29AwuEAbIp04dAwokXpMO3TOqtraHROEg6U/RIpc7XbQe5zK5oVfUhhePV7Ez3fBEmlyd/aOH6SOS+eNdx+umv6u9RY/BgvWI7kPkptyMu54pAf0lPObAXVWt5oKLNKrXylT8QjIril9aSHl/N4leyJIxfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998203; c=relaxed/simple;
	bh=1egP2xvMI/jz9wKbXDenMWy7kY9IXtjUk4N4Q9KqsGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VtEfaOfRsL37MFfhXn0kIiKeSFr6Zu/air3dQVkhHiRrLGv01t2aEqE3wS/uxfeg6OFmfyMfca0bXeXw8lZ+02O3y4Rzwvo13GNJTLEwJ9OuWTPVg4eSkMq1IbKlJ/3mSzPwdMgx7gs1yDXpnmj42x9+aeR5itlQ/8EWozFnkfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGLZlhtC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGLZlhtC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 288451F000E9;
	Thu, 28 May 2026 19:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998202;
	bh=VA7M/zN3EKilO+j+Kq4q3mBNCGxdbksYOML9hvukEYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FGLZlhtC3oynyACTD+zcFjVxpkBJknKAj04XIQgpscFKTAbGnYFRhzCeLIR7Ype6j
	 W4odRY7VjlzWqhzUNukLuAzQNCdTg7EWZ8De7Im4vZUH95FRC8033+3BVRRCbjm+hA
	 4a7Hu5MeWXHLa1SiwS1804OKrC5Ok8a2zduGerFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Grzegorz Nitka <grzegorz.nitka@intel.com>,
	Simon Horman <horms@kernel.org>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 091/461] ice: restore PTP Rx timestamp config after ethtool set-channels
Date: Thu, 28 May 2026 21:43:40 +0200
Message-ID: <20260528194649.567214441@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grzegorz Nitka <grzegorz.nitka@intel.com>

commit 975b564d195b13ca6ee1ef5e6a9561734898eb17 upstream.

When ethtool -L changes queue counts, ice_vsi_recfg_qs() closes and
rebuilds the VSI, reallocating Rx rings. The newly allocated rings have
ptp_rx cleared, so RX hardware timestamps are no longer attached to skb
until hwtstamp configuration is applied again.

Restore timestamp mode after ice_vsi_open() in the queue reconfiguration
path, matching reset/rebuild behavior and ensuring newly rebuilt Rx rings
have PTP RX timestamping re-enabled.

Testing hints:
- run ptp4l application in client synchronization mode:
	 ptp4l -i ethX -m -s
- run PTP traffic
- change queue number on ethX netdev interface:
	ethtool -L ethX combined new_queue_size
- observe ptp4l output
- expected result: no "received DELAY_REQ without timestamp" messages

Fixes: 77a781155a65 ("ice: enable receive hardware timestamping")
Cc: stable@vger.kernel.org
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Grzegorz Nitka <grzegorz.nitka@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Alexander Nowlin <alexander.nowlin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260515182419.1597859-7-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_main.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -4104,6 +4104,12 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi
 	}
 	ice_pf_dcb_recfg(pf, locked);
 	ice_vsi_open(vsi);
+	/* Rx rings are reallocated during VSI rebuild and lose their ptp_rx
+	 * flag. Restore timestamp mode so newly allocated rings are set up
+	 * for hardware Rx timestamping.
+	 */
+	if (test_bit(ICE_FLAG_PTP_SUPPORTED, pf->flags))
+		ice_ptp_restore_timestamp_mode(pf);
 	goto done;
 
 rebuild_err:


