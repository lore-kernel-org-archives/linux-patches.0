Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7677405B;
	Mon, 29 Jan 2024 17:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548564; cv=none; b=K6+mLjqtLMEN7YMoo9P2mkEvpUxeIqHOquhuBIiGgZUX0didcE6oAsyx4XhU9HbRmPorkljhCHGBXkE3U0Y6fLzDNHT5ercu06CffF/hooOEiss4DZ0o0onQwbF5aRDC8P6OW9g+fSSaguKFZcmIqwT1+OP9QCd8yt65fKU0nsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548564; c=relaxed/simple;
	bh=0ECCP6ELM9hYyrNda17JcM8D8a6uzHlahUiWnr9sAGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PDM0pOjbwwdsoXFthOlKmpsHRSlLDWbOLY5f3FlApszIAXiKpV9RLdHwZMfTzqCiJcQOYL56JJ8cinMUqa1Ibz4X4XIbA72GpAtDYNO5ho6OAHBMWzy0h2KjrHU6xTvnoBVdXqmk9WuvW9qhfXlMFL/kEwoVyZco8P5qlMVoFzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6MVQ9HT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6MVQ9HT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346E6C43390;
	Mon, 29 Jan 2024 17:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548564;
	bh=0ECCP6ELM9hYyrNda17JcM8D8a6uzHlahUiWnr9sAGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6MVQ9HTweLUEwlT5wQcRgxQ2bn0xg8GQd5X9QglKzAI1wenVw1PoSx8F0FuBGqsq
	 FMMTxZxpAeY87P3FFa+r0WwnuMrRMzpjcuJjQ3wxodefSCfcJ5mMsrAYyqzTxiY5KW
	 5tms+fFRF6oEK5hTJbS8F3y+F+6FcRk8MFz5R1D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Magnus Karlsson <magnus.karlsson@intel.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/331] xsk: recycle buffer in case Rx queue was full
Date: Mon, 29 Jan 2024 09:04:36 -0800
Message-ID: <20240129170021.085326196@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 774a6d1916e4..d849dc04a334 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -166,8 +166,10 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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
@@ -176,11 +178,13 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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



