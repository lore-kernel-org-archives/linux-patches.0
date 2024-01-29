Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1189315D5DE;
	Mon, 29 Jan 2024 17:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548190; cv=none; b=VHnBm35xn7nnvwR9lXv5wEhtpFsu5El8Y5Q0gqD2v/rCHzlg/Cb0efLWmZ1UroYlI07k4rcH9IhRTAEj/xa3XZ8vEswiVRXgozlNWjKznsSb5GQY7eSI9Bj5EeQW0yQ3CMw0UsqgUkUtOP20PkEBtEpoiiFKyQxSGRPTx0BbUm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548190; c=relaxed/simple;
	bh=7k0r/pxrdSKlBgbnmw4lW+o+WFLlDqvMp4z0hAKzf3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LwzZDC/b57iv5RaufvFLW59pLD3cFj1qjF7xw9agtVcKxM630RhUXPN/L7tl23MSyH0OVGSzNFcXWX1VeXJ21kyOpBoswTjD7dHf9mIzAjYEr31GKQHyY10t5BLulL4JDvTfLsdtiabOBK6mnZo8aVpWmzgg7o31cnD1qs9uDtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=em6X+P6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="em6X+P6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE345C433F1;
	Mon, 29 Jan 2024 17:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548189;
	bh=7k0r/pxrdSKlBgbnmw4lW+o+WFLlDqvMp4z0hAKzf3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=em6X+P6Whg1E0AluihRXA5Tc9viPSv/moM374gx9aCbv5lZyIEamNmD5NZKWO4ScY
	 IomYhkD7wAfMUFd0Ly2Sju1Oi9V41e4oDXZTYnBc5r87nJwr9ELffLHZXrC8x3ijHK
	 Rd+UE/oLotrisAR+dLVXAJiuZgAVpKn8/AqE+1P4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 206/346] xsk: recycle buffer in case Rx queue was full
Date: Mon, 29 Jan 2024 09:03:57 -0800
Message-ID: <20240129170022.451212077@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

[ Upstream commit 269009893146c495f41e9572dd9319e787c2eba9 ]

Add missing xsk_buff_free() call when __xsk_rcv_zc() failed to produce
descriptor to XSK Rx queue.

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20240124191602.566724-2-maciej.fijalkowski@intel.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3da0b52f308d..688e641cd278 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -167,8 +167,10 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		contd = XDP_PKT_CONTD;
 
 	err = __xsk_rcv_zc(xs, xskb, len, contd);
-	if (err || likely(!frags))
-		goto out;
+	if (err)
+		goto err;
+	if (likely(!frags))
+		return 0;
 
 	xskb_list = &xskb->pool->xskb_list;
 	list_for_each_entry_safe(pos, tmp, xskb_list, xskb_list_node) {
@@ -177,11 +179,13 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		len = pos->xdp.data_end - pos->xdp.data;
 		err = __xsk_rcv_zc(xs, pos, len, contd);
 		if (err)
-			return err;
+			goto err;
 		list_del(&pos->xskb_list_node);
 	}
 
-out:
+	return 0;
+err:
+	xsk_buff_free(xdp);
 	return err;
 }
 
-- 
2.43.0



