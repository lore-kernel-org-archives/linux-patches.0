Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06374415B8E;
	Sat, 12 Sep 2026 09:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207128; cv=none; b=CemRQcmPfjlPZVTu29TBt3h7PHrlgq0W6eOnXSRg5AXyoP2QnDcocnEK9A2FKW52Rh40q1IxNkn2F3fq5nNFOfHa7kLmQ07t1LA8YOPTjXPkk106uOq+gei70yXnWbMd+i24nKBPNeHnpsxcjEeDm/sLHJQogeNJNY8AV/+NqYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207128; c=relaxed/simple;
	bh=nElRMPd5fMxdyidYi/L/UPGBpDmCfmLHDufx/Qj8TiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulZu13k+M+nqkSMIomm/hRT68n0ew/1Ki0s2yhpQJS038cAzl0QDW7uBvmhS+siZ11rvTRDueFEbn04YWTyMSt7eyrqh3tlbNfCKiRHyDHAo9EZhZYzIHoz2wtmfXgENZrHIiN4255avVFpT5kHJ4EvSGjKbusYVBae4lubE+ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ERS9Tsdx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ERS9Tsdx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C511F000FF;
	Sat, 12 Sep 2026 09:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207126;
	bh=T7pVgt3bOXRx+UhfXB4IOz4TBatdmQNG7YPFtVxVL74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ERS9Tsdx3QHgESdx29saNVifezBovkuGQWYRhoI5QorMcsPMvdo6MTnyOuLRzNsuY
	 uRw9DreXjuRywRJoG1lF7Q+yKRbMWVW8TgCRhD+IYZUbDEOgiI0/86slGuI6bZ70EM
	 6q7ADILk6iNsGziyCiGNuMiucrQ9bDg6zPrJwxXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Weiming Shi <bestswngs@gmail.com>,
	Xiang Mei <xmei5@asu.edu>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0349/1518] xfrm6: fix out-of-bounds write in xfrm6_input_addr() when secpath is full
Date: Sat, 12 Sep 2026 08:41:58 +0200
Message-ID: <20260912065631.368209647@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Xiang Mei <xmei5@asu.edu>

[ Upstream commit 5d9e3bf34fec9a5d237e4b7cef4a707bc2e091bc ]

The depth check in xfrm6_input_addr() is off by one:

  if (1 + sp->len == XFRM_MAX_DEPTH)
          goto drop;
  ...
  sp->xvec[sp->len++] = x;

xfrm_input() can leave sp->len == XFRM_MAX_DEPTH, and the transport-mode
receive path re-enters IPv6 input via xfrm_trans_reinject() with that
secpath preserved. If the inner packet carries a destination-options HAO
option or a type-2 routing header, xfrm6_input_addr() is called with
sp->len == XFRM_MAX_DEPTH; the check (1 + 6 == 6) is false, so
sp->xvec[sp->len++] writes one slot past the 6-element xvec[]. The write
stays within the sec_path allocation (invisible to KASAN); UBSAN_BOUNDS
flags it and panics under panic_on_warn.

Use "sp->len >= XFRM_MAX_DEPTH", matching xfrm_input(). This also
restores one chain level the old check rejected at sp->len == 5.

  UBSAN: array-index-out-of-bounds in net/ipv6/xfrm6_input.c:309:10
  index 6 is out of range for type 'xfrm_state *[6]'

Fixes: 9473e1f631de ("[XFRM] MIPv6: Fix to input RO state correctly.")
Reported-by: Weiming Shi <bestswngs@gmail.com>
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/xfrm6_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/xfrm6_input.c b/net/ipv6/xfrm6_input.c
index 699a001ac1662..c9e208c57a6b5 100644
--- a/net/ipv6/xfrm6_input.c
+++ b/net/ipv6/xfrm6_input.c
@@ -249,7 +249,7 @@ int xfrm6_input_addr(struct sk_buff *skb, xfrm_address_t *daddr,
 		goto drop;
 	}
 
-	if (1 + sp->len == XFRM_MAX_DEPTH) {
+	if (sp->len >= XFRM_MAX_DEPTH) {
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINBUFFERERROR);
 		goto drop;
 	}
-- 
2.53.0



