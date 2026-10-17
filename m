Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795E432FA18;
	Sat, 17 Oct 2026 17:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259225; cv=none; b=Fw493q83O4u+mDXFrVdSD2ELhGc8nAy19S7QyYzVrTHrOFf/Cor7f+znguQpJSnNCDWtafoF2CXAggQVOoLyPH69rBQWIPlQv6Ou0QnMQPLUEWHiVnuT8Q/Qe9ruIvUWJHTGrG3aymh5HphW10JariqTa6tC0+1r9dCK3w9CUCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259225; c=relaxed/simple;
	bh=2kUoQhCQU/QsuZHP7SC+zo9Q/Gh2+Pn+so1R/VjKeP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=amYl1LmLAvg14Op670huG13U1pLTis/zdZwuumCT2i4lWjE6KRx189w9uBinHAswQDwddbFOt3hhklEc0kztJinygz4mmWnQ6AMGNQDH4IgGCswC6ekj0KbSDWO+mXXYu/glOleMdSxBh5+vVJFzx2MTK9mMJ7OAWrXSfUhtVnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYQskAN1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYQskAN1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D11CF1F000C4;
	Sat, 17 Oct 2026 17:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259224;
	bh=hHkf75VDBjV0NqBwh9eFLaRVm83Vmzhki/YcufaTFEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYQskAN1nQc8jELGHSkYGilMNAB6GWt/T2YYE+6JMWq0xE2JgOO/0d69g+IcA3PbE
	 btG2HS0wvFzCVHoZmhpApAtBXQSNELy3r4ahPdpODbeq696XuZV23RI1Bo2eHeie6e
	 21uIruborm28MPf3pewcQOX4jhHKrt+EYothnz14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Wozniak <petr.wozniak@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1106/1674] xfrm: fix stale skb->prev after async crypto steals a GSO segment
Date: Sat, 17 Oct 2026 17:56:18 +0200
Message-ID: <20261017160459.516308085@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Petr Wozniak <petr.wozniak@gmail.com>

[ Upstream commit 3f4c3919baf0944ad96580467c302bc6c7758b00 ]

skb_gso_segment() leaves the segment list head with ->prev pointing at
the last segment, an invariant validate_xmit_skb_list() relies on when
it sets its tail pointer (tail = skb->prev).

When validate_xmit_xfrm() walks a GSO list and some segments are stolen
by async crypto (->xmit() returns -EINPROGRESS), those segments are
unlinked from the list but the head ->prev is never updated.  If the
last segment is the one stolen, the returned head still has ->prev
pointing at it, even though it is now owned by the crypto engine and may
be freed.  validate_xmit_skb_list() later does tail->next = skb, writing
through that stale pointer -- a use-after-free.

Repoint skb->prev at the last retained segment before returning.

Fixes: f53c723902d1 ("net: Add asynchronous callbacks for xfrm on layer 2.")
Signed-off-by: Petr Wozniak <petr.wozniak@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_device.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index a73b3c9d7e4d4..49529d95afa3f 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -226,6 +226,14 @@ struct sk_buff *validate_xmit_xfrm(struct sk_buff *skb, netdev_features_t featur
 		pskb = skb2;
 	}
 
+	/* skb_gso_segment() set skb->prev to the last segment, but async
+	 * crypto may have stolen it above without updating ->prev.  Repoint
+	 * it at the last retained segment so validate_xmit_skb_list() does
+	 * not chain onto a segment now owned by the crypto engine.
+	 */
+	if (skb)
+		skb->prev = pskb;
+
 	return skb;
 }
 EXPORT_SYMBOL_GPL(validate_xmit_xfrm);
-- 
2.53.0



