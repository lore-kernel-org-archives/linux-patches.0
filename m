Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E1273FADF1;
	Thu, 30 Jul 2026 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423106; cv=none; b=gkJO1BuxsCayJ/ZR0gEQ8fQOBBo2M335RK9vKhOxN/hwm0lHb/OEUkd1Yz9+aVWRqtaEYQR9uvYDmbS3YXHpi74QJ1Wo8mfiB3vxSF+x8Aelr/jL41XQxQsmVVGPJJIKIpEYPm8Hex894qlyRKFC+LOs0ts4odmu1aasL7rON5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423106; c=relaxed/simple;
	bh=Zwdwqe6zTviB9IB6f0GdOZBWxDL0/UJcZbFHLUsaeEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s4pHwbhWW4AAixYPSfUpv89H2uy6AGjNc3+TjaxWDduRbHckudeRWCx9+EJEf0fSQjgFPBWVhAUkwqhXT44NIXL/5zHPpKZzZIQyI5Sh68w+tSC6KQmyoQiUf3AG7oPbPvNcaIUSINJ+pUYxZxH+q/IUVthwJUPoE8aYLgGXSxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5Ihf7M5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5Ihf7M5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCA8E1F000E9;
	Thu, 30 Jul 2026 14:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423105;
	bh=byOio88uv1E49nWaZqbgmjSxOEhkzLwn/rVsjAvByF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m5Ihf7M5CwpbsLWSmK3XEgiZfB9cW7XCZ8/5zNC4+9SNFO97DJO+7jfbRNfTJTP2A
	 f6eEDZ9pBAhEr9MNw4Mew2p/tWSYpeQHv4qMgVMQ+GMpxt6qr7ds9H27kqUGSaSxRw
	 7gLe7RxezR+du3WB6fSgNUhvKfuZzBgxR4BTycUI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Greenwalt <paul.greenwalt@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Simon Horman <horms@kernel.org>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Rinitha S <sx.rinitha@intel.com>
Subject: [PATCH 7.1 668/744] ice: fix PTP Call Trace during PTP release
Date: Thu, 30 Jul 2026 16:15:41 +0200
Message-ID: <20260730141458.462291063@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Greenwalt <paul.greenwalt@intel.com>

commit f6a7e00b81e35ef1325234925f2fe1e53b466f92 upstream.

If a PF reset occurs when the PTP state is ICE_PTP_UNINIT, then
ice_ptp_rebuild() will update the state to ICE_PTP_ERROR. This will
result in the following PTP release call trace during driver unload:

    kernel BUG at lib/list_debug.c:52!
    ice_ptp_release+0x332/0x3c0 [ice]
    ice_deinit_features.part.0+0x10e/0x120 [ice]
    ice_remove+0x100/0x220 [ice]

This was observed when passing PF1 through to a VM. ice_ptp_init()
fails because ctrl_pf is NULL and sets the state to ICE_PTP_UNINIT.

Fix by detecting the ICE_PTP_UNINIT state in ice_ptp_rebuild() and
returning without error, preventing the invalid state transition to
ICE_PTP_ERROR. The only valid path to ICE_PTP_ERROR is from
ICE_PTP_RESETTING after a failed rebuild.

Fixes: 8293e4cb2ff5 ("ice: introduce PTP state machine")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Greenwalt <paul.greenwalt@intel.com>
Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Rinitha S <sx.rinitha@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20260717185340.3595286-10-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/ice_ptp.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/ethernet/intel/ice/ice_ptp.c
+++ b/drivers/net/ethernet/intel/ice/ice_ptp.c
@@ -3035,6 +3035,11 @@ void ice_ptp_rebuild(struct ice_pf *pf,
 	struct ice_ptp *ptp = &pf->ptp;
 	int err;
 
+	if (ptp->state == ICE_PTP_UNINIT) {
+		dev_dbg(ice_pf_to_dev(pf), "PTP was not initialized, skipping rebuild\n");
+		return;
+	}
+
 	if (ptp->state == ICE_PTP_READY) {
 		ice_ptp_prepare_for_reset(pf, reset_type);
 	} else if (ptp->state != ICE_PTP_RESETTING) {


