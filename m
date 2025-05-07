Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB6F29A0;
	Wed,  7 May 2025 19:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644654; cv=none; b=kZklfnPQq3Wepas6LTpTYRjc9w2TH+cXl/8SAsiSglN5+vttMsa8+3uJzsGIeWRab82bva1fVowPzFfqz9iHcg5mdvunKBlHLGU2yFEEu9R91gHpJMjmlRLjBwYwSUUzee8zHlsn20CSWQzeA3zPCqIBw9+FSInW11SpCOuTgoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644654; c=relaxed/simple;
	bh=GYQO1ja9UWWb9GRBCMznRTM9Qnd9FPtzaLxCmJMD0dg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cI5mysrQ1CoJ1swrf9s//9nOR+jGLdTkM50Em5NFlFuTOb7oyXdpi99HGYgheKiGVMpSJRmbn1YWm+4y18AFy8F+kdOPupu7cT7hBcLS2ytgP8KL2Gkaoo9cTsxpNGd17V5wuFsbqlQkKfqoZn/tb5zR4tUXbFYx2GUzcw7vDpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1uGXrID; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1uGXrID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2C2BC4CEE2;
	Wed,  7 May 2025 19:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644654;
	bh=GYQO1ja9UWWb9GRBCMznRTM9Qnd9FPtzaLxCmJMD0dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1uGXrIDt0ZrZ36ZH/BhGhCvY4Eemhmb7CtW6m/NtsV6BEBcdA0K97eQLCwWGAuv1
	 zKYgVCBLMwa6cqnCnS4+Ak9JdScZhjSeiKEHuS8CY/auu44ZECau9jOzFJeko04ht+
	 Cw5fK+/+V6rMg1S6ZQqEQvHbMVXfi9Rb54S7G6BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 113/164] bnxt_en: Add missing skb_mark_for_recycle() in bnxt_rx_vlan()
Date: Wed,  7 May 2025 20:39:58 +0200
Message-ID: <20250507183825.550386786@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit a63db07e4ecd45b027718168faf7d798bb47bf58 ]

If bnxt_rx_vlan() fails because the VLAN protocol ID is invalid,
the SKB is freed but we're missing the call to recycle it.  This
may cause the warning:

"page_pool_release_retry() stalled pool shutdown"

Add the missing skb_mark_for_recycle() in bnxt_rx_vlan().

Fixes: 86b05508f775 ("bnxt_en: Use the unified RX page pool buffers for XDP and non-XDP")
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 026f0d7569e1c..74be0dd6f7a53 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1986,6 +1986,7 @@ static struct sk_buff *bnxt_rx_vlan(struct sk_buff *skb, u8 cmp_type,
 	}
 	return skb;
 vlan_err:
+	skb_mark_for_recycle(skb);
 	dev_kfree_skb(skb);
 	return NULL;
 }
-- 
2.39.5



