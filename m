Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09981C3BF1;
	Wed, 19 Feb 2025 08:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953874; cv=none; b=p25qrAy8RYtQOfEVBZGZ6yBMDAV30d26UfPFvuQhQi/3knD570q0DoJ2V6TnUduz2iMnVuTesVd25MKiM7YdsJiVPpJqara/ak22Ln08OZCpNIgWcoQUS/noPCh/veGf21dQ2fr4tke4/I6CtCQSArKbQ36gZt+O8+yHPNvrZHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953874; c=relaxed/simple;
	bh=QNH0A1kdCZGLBIgoN3O+5ft9K/Md0HjJU7guiqvjDA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paLO1U26B8jILlWSEa2lJ8rixZnp/eP/h0kv7iFMJNkNc8mX8qKtbpl9crn333Mi7VSJczDsPDpgULMB/YUS4cROoe7xZaqahc0AB04tpRpdyo/tGeyRRM6+s5xU0HcJ6FxNYhlKwoX5QWyOyOR7PvpkAMDXQVjpST3XvLt1RiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR0L0q95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR0L0q95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE600C4CED1;
	Wed, 19 Feb 2025 08:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953874;
	bh=QNH0A1kdCZGLBIgoN3O+5ft9K/Md0HjJU7guiqvjDA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR0L0q95WP7pDhgKvd0rksJEPEauo5pCQHZPwg4pQpKDnZjgLHx0bhIV9aqb7FnBq
	 sL95XVgolFgSDaC+FX0z4nkRUMJbUFCZFOJhcWCZyuGJ1KafeJnT+oghveqmeYvPcB
	 vJUKbG3TomaprPeEOD3q6LTx96WYcqNuWc9Y6/Vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 025/274] idpf: fix handling rsc packet with a single segment
Date: Wed, 19 Feb 2025 09:24:39 +0100
Message-ID: <20250219082610.524393718@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sridhar Samudrala <sridhar.samudrala@intel.com>

[ Upstream commit 69ab25a74e2df53edc2de4acfce0a484bdb88155 ]

Handle rsc packet with a single segment same as a multi
segment rsc packet so that CHECKSUM_PARTIAL is set in the
skb->ip_summed field. The current code is passing CHECKSUM_NONE
resulting in TCP GRO layer doing checksum in SW and hiding the
issue. This will fail when using dmabufs as payload buffers as
skb frag would be unreadable.

Fixes: 3a8845af66ed ("idpf: add RX splitq napi poll support")
Signed-off-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Tested-by: Samuel Salin <Samuel.salin@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/idpf/idpf_txrx.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/idpf/idpf_txrx.c b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
index 2fa9c36e33c9c..c9fcf8f4d7363 100644
--- a/drivers/net/ethernet/intel/idpf/idpf_txrx.c
+++ b/drivers/net/ethernet/intel/idpf/idpf_txrx.c
@@ -3008,8 +3008,6 @@ static int idpf_rx_rsc(struct idpf_rx_queue *rxq, struct sk_buff *skb,
 		return -EINVAL;
 
 	rsc_segments = DIV_ROUND_UP(skb->data_len, rsc_seg_len);
-	if (unlikely(rsc_segments == 1))
-		return 0;
 
 	NAPI_GRO_CB(skb)->count = rsc_segments;
 	skb_shinfo(skb)->gso_size = rsc_seg_len;
-- 
2.39.5



