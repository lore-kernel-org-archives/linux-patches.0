Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A647224D6;
	Sat, 17 Oct 2026 15:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792252639; cv=none; b=J1pCntmGSKPadHEHeLHWOA2FQECW51oFdgtftY9M6zDKX+koSHHjturkPPx7ijlpS0DVwRQl9JfggUV8GXMUvQrSA9lgStdp4pEj4XDGnhAmyr5dEDM3IARIEcZwhkKf0EyNkeKwl8VRGHP+7ccsQAjzs2kMcKCu3h7ARovAPwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792252639; c=relaxed/simple;
	bh=iRMs/AvbyB9D1zZiSTj5/neUcBqQ+Pm1/HPYmlcmiVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bVoG3eR4p6A9puf/t3/AoDTuf/wskdJz8AGN6oJIwAzJePziteiMTpRIV7F31wcLd+k6O2dJTkISLNtSTQkPPT5UXbBrbW2LkcLWr18S2wQykDvcv1q7Djkt0tDbF5Mh4nsXCtxRDIZwv9lHuwOyqkfDVJVNXUZ2Ht4PJU8PSfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wyi5/5KF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wyi5/5KF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D942D1F000C4;
	Sat, 17 Oct 2026 15:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792252638;
	bh=/dRsNb38146F4du00zxdAKkAk0OFzTMl6EFWep2fjSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wyi5/5KFqM8V4uI8jwPI5QhCPQkK/g3Mf5flUfHVPy6nGcG1f1bFvzGB6PsPyF0mc
	 M3FfZFOBxljuEa42+8LbHSLcDutEO8ae0EKj+Lj9pnt1A/3QapawkGtTgoBGlw76ZL
	 Pqzn57dhgVY/X66ZDnVL7XdLMRlmQjJbZbQ/0mYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Slepecki <jakub.slepecki@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 46/52] ice: fix broken Rx on VFs
Date: Sat, 17 Oct 2026 17:54:47 +0200
Message-ID: <20261017155106.326116803@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017155104.830766652@linuxfoundation.org>
References: <20261017155104.830766652@linuxfoundation.org>
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

From: Alexander Lobakin <aleksander.lobakin@intel.com>

[ Upstream commit 436fa8e7d1a119ec90f39e7c2ce0f3a146652899 ]

Since the tagged commit, ice stopped respecting Rx buffer length
passed from VFs.
At that point, the buffer length was hardcoded in ice, so VFs still
worked up to some point (until, for example, a VF wanted an MTU
larger than its PF).
The next commit 93f53db9f9dc ("ice: switch to Page Pool"), broke
Rx on VFs completely since ice started accounting per-queue buffer
lengths again, but now VF queues always had their length zeroed, as
ice was already ignoring what iavf was passing to it.

Restore the line that initializes the buffer length on VF queues
basing on the virtchnl messages.

Fixes: 3a4f419f7509 ("ice: drop page splitting and recycling")
Reported-by: Jakub Slepecki <jakub.slepecki@intel.com>
Reviewed-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Alexander Lobakin <aleksander.lobakin@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Jakub Slepecki <jakub.slepecki@intel.com>
Link: https://patch.msgid.link/20251124170735.3077425-1-aleksander.lobakin@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/virt/queues.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/intel/ice/virt/queues.c b/drivers/net/ethernet/intel/ice/virt/queues.c
index 771434ec881e2..431c9c546b04f 100644
--- a/drivers/net/ethernet/intel/ice/virt/queues.c
+++ b/drivers/net/ethernet/intel/ice/virt/queues.c
@@ -863,6 +863,9 @@ int ice_vc_cfg_qs_msg(struct ice_vf *vf, u8 *msg)
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
 			     qpi->rxq.databuffer_size < 128))
 				goto error_param;
+
+			ring->rx_buf_len = qpi->rxq.databuffer_size;
+
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
 			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;
-- 
2.53.0



