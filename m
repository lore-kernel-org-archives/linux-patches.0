Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66DA64F3EA5;
	Tue, 13 Oct 2026 12:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894592; cv=none; b=UKspax3L2zFel1GXmPQGFPC2ni5/F79L7RfzS9aa5jhoH0EwgdabO4F5jB+926CzljEea+vkX4dWC9nisLxQETqSEetwB4cahLe8CzPxQKss8fC699y3lpiPfAJNeMpcdl2OBOelOAuGgQacPVskSL9WsbxmNv1Cbp1x2+/Lm7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894592; c=relaxed/simple;
	bh=+hKLdiy3vV506XAeIY68MOhuNCG0fnqyQbbbFv7yhkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o99novlMkkoEJra41jIoVTQmH5caqg8BnV2KwK5q8FlbYqjG3ZKg6LHL2pHxzFOOi/fKHF86FscYgJp2Tg1vUAPettYzx/JwN5AbhlmGDLxxIZWMHy5JjRDsqRuiRU8lb4vEdDp8JvcJ2yA81In1MY3AY4XEwlzfCuQKlbsGhqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mox6btTc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mox6btTc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 998961F000FF;
	Tue, 13 Oct 2026 12:29:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894591;
	bh=GEF1+QWPY/IX5vqpooRzt4mpovlZjtHO3D5y01kAzBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mox6btTc8fG7os9cyr/P9nO8DK2IRRszeHRmBcT5KsLVvZnt7ZQ6wZOjqzZ2p9aYN
	 wW1KAKh5ZpdkuX8ex1+AAEm6DdTIOhAPniUBFMludJ1G3rB5IeJXLO05hHRmh+cahu
	 rbfwwsihrGzyPLHsVGbHLGgqnqoiQo1H6fsGnniA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Slepecki <jakub.slepecki@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 611/621] ice: fix broken Rx on VFs
Date: Tue, 13 Oct 2026 13:40:06 +0200
Message-ID: <20261013112935.297304431@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

commit 436fa8e7d1a119ec90f39e7c2ce0f3a146652899 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/intel/ice/virt/queues.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/intel/ice/virt/queues.c
+++ b/drivers/net/ethernet/intel/ice/virt/queues.c
@@ -863,6 +863,9 @@ int ice_vc_cfg_qs_msg(struct ice_vf *vf,
 			    (qpi->rxq.databuffer_size > ((16 * 1024) - 128) ||
 			     qpi->rxq.databuffer_size < 128))
 				goto error_param;
+
+			ring->rx_buf_len = qpi->rxq.databuffer_size;
+
 			if (qpi->rxq.max_pkt_size > max_frame_size ||
 			    qpi->rxq.max_pkt_size < 64)
 				goto error_param;


