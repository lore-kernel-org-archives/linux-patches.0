Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489E21EB184;
	Wed, 19 Feb 2025 08:45:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954743; cv=none; b=i4bVacM5hvsbeFBjwAWt8f07neuRh1SDKHeZVL5iPNChh57nm8JfQHHC07Rq0GErpr17s8QoZ6aecPWFQOiU9ZS2Udks2h31Zq8F17T4HYrkn9L9Z98DL5nsR6XQjh2lU4QSAduXEnUO3bBKJmMVnyzkIiC/3ZcIqRrgc8sPCCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954743; c=relaxed/simple;
	bh=qp23OwKToTqGYySvgNsb8TsgymsrdthQHsfGrUhC5NI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drUL7uoCcQFJQCpl8Me+fvzXLC20upSDnhg+/zTaqnAHqpktCuradftbpKPhmZ+52aMIaZ3i5FS3lkl5XI+0nOvf1qUJQ6qJ0gASud8Ymk05kd+SNmC9FE1DzMOe7nx7HxPTB6sdur9MntXE+MP48E4fKWE0VoYu5UvfnKzEoKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pMJBi2hG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pMJBi2hG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093F1C4CEEB;
	Wed, 19 Feb 2025 08:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954742;
	bh=qp23OwKToTqGYySvgNsb8TsgymsrdthQHsfGrUhC5NI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pMJBi2hGak53sVl9e7km1cqpra5p9FdlfyXM0dzosZUGyEERmZxNbsRuRDxigLunG
	 UchZ3OqnxEFIY07VxBvbzi24+AbhRhf+iZDZhBFBajZXAm+NaOHt9MqT61B8ACLtiK
	 jGF+LbF/FQQXTs6dChn3ISlY60jHdmrbwiBZm6A0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Samuel Salin <Samuel.salin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/230] idpf: fix handling rsc packet with a single segment
Date: Wed, 19 Feb 2025 09:25:38 +0100
Message-ID: <20250219082602.532340476@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 60d15b3e6e2fa..cd7c297059aed 100644
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



