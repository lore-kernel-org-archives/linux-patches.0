Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1C730C143;
	Thu, 30 Jul 2026 15:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426417; cv=none; b=eaHa18gpMJIygcb/NLZLlB9Ys3p+9a/0nkilkbiRBJ77SgpXvND139W97Bgsl5CMtFTZbhx5atzedPA2beDAQ/d58fFp39jhT462nle9bNxoK8WCgsTGU9qfQ7Rvs2lreH3AqXT6ilSs7Xn8sWLcnVtcZxItWlW9NrO/aQh+Z/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426417; c=relaxed/simple;
	bh=ar3XwCAnoCSuhDuK7sTfIVa0SAeoVLvz15m0z8FKYq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZg+sap3pwGPAtFh7KQbHjJ49KhqrF37m5CF2zuYQXnXCjeJ8mv9amafla01NHXO0jgsNo6FWAlxiWXTD1p0OhKgj7etE6EBVOphoHLavX4KBOZoAsVa0OgYH0St/pprI2lXbae+ZROP2h4Rf/OMv/sq0LBG8tfWzdl0Z5rDOXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FNYyCHvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FNYyCHvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2421C1F000E9;
	Thu, 30 Jul 2026 15:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426416;
	bh=YDAzS5wRmyyBY4JcI/0SvP/JH9GRaCyrwK1nvGUH4GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FNYyCHvOPx/EdLbPd3WSsE57mPb0bm1u9Ofz0c9qwhAcGvWKJTVxI182V93x+4WFg
	 0mgNI51hT4FZ/dzYqWMBZuD7HfglbyOIIMoPnPPfxokGrd1n8pbniQwtksRwEj5Tnu
	 Dx4DFd3yhedWEXrvN0dZJvgt9j+paZHrTNBfdTrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandra Winter <wintera@linux.ibm.com>,
	Hidayath Khan <hidayath@linux.ibm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 411/602] net/af_iucv: fix NULL deref in afiucv_hs_callback_syn()
Date: Thu, 30 Jul 2026 16:13:23 +0200
Message-ID: <20260730141444.602888413@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Hidayath Khan <hidayath@linux.ibm.com>

commit 47a5116e56a6b6fe1e909f244e39cd0fc26ceee4 upstream.

afiucv_hs_callback_syn() allocates the child socket with GFP_ATOMIC.
If the allocation fails, nsk is NULL.

The connection-refused path is entered when the listen state check
fails, the accept backlog is full, or nsk is NULL. The code
unconditionally calls iucv_sock_kill(nsk) in that path.

iucv_sock_kill() does not accept a NULL socket pointer and immediately
dereferences sk via sock_flag(sk, SOCK_ZAPPED). When nsk is NULL,
calling iucv_sock_kill(nsk) results in a NULL pointer dereference.

Only call iucv_sock_kill() when a child socket was successfully
allocated.

Fixes: 3881ac441f64 ("af_iucv: add HiperSockets transport")
Cc: stable@vger.kernel.org
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Hidayath Khan <hidayath@linux.ibm.com>
Link: https://patch.msgid.link/20260709191732.124092-1-hidayath@linux.ibm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/iucv/af_iucv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/iucv/af_iucv.c
+++ b/net/iucv/af_iucv.c
@@ -1871,7 +1871,8 @@ static int afiucv_hs_callback_syn(struct
 		afiucv_swap_src_dest(skb);
 		trans_hdr->flags = AF_IUCV_FLAG_SYN | AF_IUCV_FLAG_FIN;
 		err = dev_queue_xmit(skb);
-		iucv_sock_kill(nsk);
+		if (nsk)
+			iucv_sock_kill(nsk);
 		bh_unlock_sock(sk);
 		goto out;
 	}


