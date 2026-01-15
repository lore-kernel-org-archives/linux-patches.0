Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C14F03D3491;
	Thu, 15 Jan 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498229; cv=none; b=tUZXC3+umuVZuV6Xcb6805yRARLfciJ/TDpE8gqRrlDLJ47u51bQL7ANn7nRU5McuojLBEKQaVJoLhKPL5uRb2PdFnpTlKBjLa+qneamjh9AOfXxuW4PKQF2eMbgHTGC2AjpVrztVV0dFYQp9429WuBUhN0hObv3eDo8O3Lbmdw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498229; c=relaxed/simple;
	bh=VOC4aGI8VGaLB7oIb7XRp6X7oMaOITMGqqOaAdhx9tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVSEQ5C3PSdtpx5vU56f6ZRpscaYWDHAtr4FMHqL0GtT1FFnDrfwdMy2bxIvvY3E07DNtHQy5HZMToXIGgdlWdifAuVbAa49A9Lzrupz/TFDb0Q6N0Tn+SmAh6l2RlULMppXCEak/WLPV3noe+vbFCE5b1H9yY2qvh78yJl5dTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oUlwaPHw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oUlwaPHw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52323C2BC87;
	Thu, 15 Jan 2026 17:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498229;
	bh=VOC4aGI8VGaLB7oIb7XRp6X7oMaOITMGqqOaAdhx9tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oUlwaPHwJ8gcTp9CqhPb0h7Uphfigxp3Pv4wChXsyP5up9o8W5NRwcazI3oPLwf+w
	 dFJrlWSyEAhkUiY1AhGPavLlJiVQe9CmMHeaKZjHoIjTMMFg6cGHs1wm2oyyX+Iitm
	 U5LVCvyqZ8RXUk/X7/NoM4z2I4bm9PQh9i/S43lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fatma Alwasmi <falwasmi@purdue.edu>,
	Pwnverse <stanksal@purdue.edu>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/554] net: rose: fix invalid array index in rose_kill_by_device()
Date: Thu, 15 Jan 2026 17:47:05 +0100
Message-ID: <20260115164259.221716818@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pwnverse <stanksal@purdue.edu>

[ Upstream commit 6595beb40fb0ec47223d3f6058ee40354694c8e4 ]

rose_kill_by_device() collects sockets into a local array[] and then
iterates over them to disconnect sockets bound to a device being brought
down.

The loop mistakenly indexes array[cnt] instead of array[i]. For cnt <
ARRAY_SIZE(array), this reads an uninitialized entry; for cnt ==
ARRAY_SIZE(array), it is an out-of-bounds read. Either case can lead to
an invalid socket pointer dereference and also leaks references taken
via sock_hold().

Fix the index to use i.

Fixes: 64b8bc7d5f143 ("net/rose: fix races in rose_kill_by_device()")
Co-developed-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Fatma Alwasmi <falwasmi@purdue.edu>
Signed-off-by: Pwnverse <stanksal@purdue.edu>
Link: https://patch.msgid.link/20251222212227.4116041-1-ritviktanksalkar@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rose/af_rose.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/rose/af_rose.c b/net/rose/af_rose.c
index f8cd085c4234..04173c85d92b 100644
--- a/net/rose/af_rose.c
+++ b/net/rose/af_rose.c
@@ -204,7 +204,7 @@ static void rose_kill_by_device(struct net_device *dev)
 	spin_unlock_bh(&rose_list_lock);
 
 	for (i = 0; i < cnt; i++) {
-		sk = array[cnt];
+		sk = array[i];
 		rose = rose_sk(sk);
 		lock_sock(sk);
 		spin_lock_bh(&rose_list_lock);
-- 
2.51.0



