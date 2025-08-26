Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C60F435690E;
	Tue, 26 Aug 2025 14:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218418; cv=none; b=m93Q213Uq6+Bj7ycjsmJp1/PbZG9c8MPzrLtJp0cSaL/6WcN6U/L7bL5D1/zLDDwEVfNNxLMfm40jDoDC11BP8A3g5eE4xkn/UY6RWjCkAWLVcNAclbf+znjyYGMoQ8TL1NREojcPYqs1huueSIXt1Zr9OXsg8xf6DUHS4eN1U8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218418; c=relaxed/simple;
	bh=Jwro2h1HgMZuFWY5TQOBthsuBUPwP2F9yltsShxPi8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gmuDW7N5WR5zJexYxBlB4zHPFfqmCXeZHYJ9Rl70oS7MIS4ZfDZVyVFKaFdLj1SlEDR7KK4+2wXhV6jIy85xcIVn5IQCFsUOm0/wzCWiX+sQG0mfwByWyhcvlKlWG8ShDAf7Dc8K8fsh+ajUbXLAZsHBAOmjsBT40YCkHVnClqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wsRNK/5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wsRNK/5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0F0C19421;
	Tue, 26 Aug 2025 14:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218418;
	bh=Jwro2h1HgMZuFWY5TQOBthsuBUPwP2F9yltsShxPi8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wsRNK/5uCg/ipLek0RyK2E0Qrz7EH7YtxuQpFdoecDLr71k9VQLx59hhoF8bIbE7z
	 TlDt3RqcicAsMCyRGNPLEFtIHjaR9JBifScATJfeRp7KefHVMqgFpo+1pFtLxB8QLk
	 Tqsm06BW0OYXjOWXTaytmykP/zKnrVbCOXGE38zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Paul Menzel <pmenzel@molgen.mpg.de>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Priya Singh <priyax.singh@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 515/523] ixgbe: xsk: resolve the negative overflow of budget in ixgbe_xmit_zc
Date: Tue, 26 Aug 2025 13:12:05 +0200
Message-ID: <20250826110937.143618878@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 4d4d9ef9dfee877d494e5418f68a1016ef08cad6 ]

Resolve the budget negative overflow which leads to returning true in
ixgbe_xmit_zc even when the budget of descs are thoroughly consumed.

Before this patch, when the budget is decreased to zero and finishes
sending the last allowed desc in ixgbe_xmit_zc, it will always turn back
and enter into the while() statement to see if it should keep processing
packets, but in the meantime it unexpectedly decreases the value again to
'unsigned int (0--)', namely, UINT_MAX. Finally, the ixgbe_xmit_zc returns
true, showing 'we complete cleaning the budget'. That also means
'clean_complete = true' in ixgbe_poll.

The true theory behind this is if that budget number of descs are consumed,
it implies that we might have more descs to be done. So we should return
false in ixgbe_xmit_zc to tell napi poll to find another chance to start
polling to handle the rest of descs. On the contrary, returning true here
means job done and we know we finish all the possible descs this time and
we don't intend to start a new napi poll.

It is apparently against our expectations. Please also see how
ixgbe_clean_tx_irq() handles the problem: it uses do..while() statement
to make sure the budget can be decreased to zero at most and the negative
overflow never happens.

The patch adds 'likely' because we rarely would not hit the loop condition
since the standard budget is 256.

Fixes: 8221c5eba8c1 ("ixgbe: add AF_XDP zero-copy Tx support")
Signed-off-by: Jason Xing <kernelxing@tencent.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Tested-by: Priya Singh <priyax.singh@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Link: https://patch.msgid.link/20250819222000.3504873-4-anthony.l.nguyen@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
index ca1a428b278e..54351d6742d0 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_xsk.c
@@ -390,7 +390,7 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 	dma_addr_t dma;
 	u32 cmd_type;
 
-	while (budget-- > 0) {
+	while (likely(budget)) {
 		if (unlikely(!ixgbe_desc_unused(xdp_ring))) {
 			work_done = false;
 			break;
@@ -425,6 +425,8 @@ static bool ixgbe_xmit_zc(struct ixgbe_ring *xdp_ring, unsigned int budget)
 		xdp_ring->next_to_use++;
 		if (xdp_ring->next_to_use == xdp_ring->count)
 			xdp_ring->next_to_use = 0;
+
+		budget--;
 	}
 
 	if (tx_desc) {
-- 
2.50.1



