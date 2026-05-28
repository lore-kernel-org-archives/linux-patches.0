Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E0425F7B9;
	Thu, 28 May 2026 20:37:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000679; cv=none; b=urcod5VYgPPcRc4Veeu7/5TUXzxHLbQSE8Nr0isSeoRSeceLURlyMOJBGZBRRIu5HHxNX9+L05Cnll0q8YmXf2uqs1hn3qBxymEW8Az6VUqy2HwihuDRVLxfyZrSt2ep6cu9jX5kIjt7P1SPmV6uytA5cdmlpgbNfX2luRU5c3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000679; c=relaxed/simple;
	bh=mRJ70b1tEPGR2KSzSS1Pyy/5sF9cEjCW5byFKJglhZs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1SyIpZbljSvuClSB1BQQCfJBm0RdT+3xz15Uoih3IDeqHj1GVVrxi5jURbngXDdMx8rnafKuqR/SjlxwRlK0cvYii0DJu9QAoTrQJV2J4IznWycKbpvhSAWZYuU33atHiPPAK4KmWZEiYvYWrJFcFXF88oeOZVNWV5H7gr9aCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N15Z2Oz8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N15Z2Oz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ADC1F000E9;
	Thu, 28 May 2026 20:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000678;
	bh=GR1Aeh6/tTrvaoqyrNiP2pxR73geyMUL5iALECiB2pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N15Z2Oz8cN1MlglC4asYRuZp8A5RVDXWAh7uPUHpnbZQyywVLhBkqyUqQAAHpKI+A
	 6dZsxC4UBl3qOlsm88dw9rCV1mcQwk1CFkI0orYEFV5inHwCB3MraNufy0yLfXeGb0
	 mqvjd4R3y65jGaUAjqYkz3Eb28GLdw9BgT64a8Gg=
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
Subject: [PATCH 6.12 094/272] ice: restore PTP Rx timestamp config after ethtool set-channels
Date: Thu, 28 May 2026 21:47:48 +0200
Message-ID: <20260528194632.010589010@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
References: <20260528194629.379955525@linuxfoundation.org>
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
@@ -4197,6 +4197,12 @@ int ice_vsi_recfg_qs(struct ice_vsi *vsi
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


