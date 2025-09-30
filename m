Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B1F20E334;
	Tue, 30 Sep 2025 15:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245732; cv=none; b=WZ5bq5XanS7dDASXVBl4veHcvUw+QBth0D3kFjwAeyuYYGAwQAhuG/gII7JU2z1Q5eLIfAWsrDvXb/LFE58ln1hZLPetemztffJ3W73VCU8b1VISWBCGyiJyKg96o5TrvPo30yp6Ds28sKvgjQj1IK0PBHzn9B/f5roBNJmHaSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245732; c=relaxed/simple;
	bh=1AFbflOeQzuY7qtEJCAHWrOCmJo34jTLG3OL8PqPBp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqMbCFt4XR1EyHDDVsxzlAmK7nnp2KVPrnH7aK/PMA3wN07KhYjnV6aMLCEq3j1/QhsRlyC5McQPAxBj6sG41Tabdp2w1kP0Tq02hjTFJnzTdAjMzR3nQyWDUAEADlxkKOQq0UwssLdT98hQZJ+v1i7gUo89eu2XFweMtxxFELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOGprnpW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOGprnpW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED529C4CEF0;
	Tue, 30 Sep 2025 15:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245732;
	bh=1AFbflOeQzuY7qtEJCAHWrOCmJo34jTLG3OL8PqPBp8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOGprnpWQznTg9i+cdL8gVYtogIwCAu7RUe0PpHaViTrRK9unZkZ2o1pqspKSMQRg
	 sCmj460J6ALwYCt19mnlXQtmZb2HfyjrOTZ6UE6qSU1rXsznT7LHw+vt1AXt0BF4oL
	 nUVYQJZK/OiFbpVn/S8qUNuqom74ZyiW8aYYqnTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a25ee9d20d31e483ba7b@syzkaller.appspotmail.com,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 34/91] xfrm: xfrm_alloc_spi shouldnt use 0 as SPI
Date: Tue, 30 Sep 2025 16:47:33 +0200
Message-ID: <20250930143822.566682871@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
References: <20250930143821.118938523@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit cd8ae32e4e4652db55bce6b9c79267d8946765a9 ]

x->id.spi == 0 means "no SPI assigned", but since commit
94f39804d891 ("xfrm: Duplicate SPI Handling"), we now create states
and add them to the byspi list with this value.

__xfrm_state_delete doesn't remove those states from the byspi list,
since they shouldn't be there, and this shows up as a UAF the next
time we go through the byspi list.

Reported-by: syzbot+a25ee9d20d31e483ba7b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a25ee9d20d31e483ba7b
Fixes: 94f39804d891 ("xfrm: Duplicate SPI Handling")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index acfbe1f013d1b..ded559f557675 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2296,6 +2296,8 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 
 	for (h = 0; h < range; h++) {
 		u32 spi = (low == high) ? low : get_random_u32_inclusive(low, high);
+		if (spi == 0)
+			goto next;
 		newspi = htonl(spi);
 
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
@@ -2311,6 +2313,7 @@ int xfrm_alloc_spi(struct xfrm_state *x, u32 low, u32 high,
 		xfrm_state_put(x0);
 		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 
+next:
 		if (signal_pending(current)) {
 			err = -ERESTARTSYS;
 			goto unlock;
-- 
2.51.0



