Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B1EF472777;
	Tue, 16 Jun 2026 16:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628087; cv=none; b=bPMzglNMVZyZDpMQ5S0VCD7ygDLnydoTyv1F8HCSTP1HSrFV69Or4PfTP9//2iBBfjmn1sirJ2G4CTDHdfHxaLKlRMXd0vNP4K4B4+9r/8GOg7/A+9nW/gGtPQ4ZIlplfwnwb4dAgrwcumkG9NscunAtJvv3aSTb5gj4pFAwIsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628087; c=relaxed/simple;
	bh=vxGjvxe28by+0BVqEcLv+UCwrElcHK/ixvT97Ztt9Iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOmQoTLG98HDp6RKJ8gKFWLyhHPH7luPPSME83LjliNulrjlxJL8zQFr0RnD67G/TM+sLOYDuFxolTgYJGI6UVZKYKKWAAn5kTtvwNOw5IUwq2vf/dcqrE9HlRCMFYg8UFhEufHtQlVzLhCpPP/vqHlzSgNKqmbT24NmZE+9t70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3dyZduJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3dyZduJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4E61F000E9;
	Tue, 16 Jun 2026 16:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628086;
	bh=wklumsmGeMqfXQ4zA+kGRe1hx7Io78H7db87MI+MSQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a3dyZduJwzsZnSprb5+GemGxWK5oc25cm7sGtrHE/5ZfKDz5KVeUjR3BNeBuMf8vp
	 9PkrVbOe/RPqukbRWJkXslZS/EDzgeNMcX8aGxsZScyVBghg+8NVrg59CA7ju7/os3
	 a2p6sZgppIn2VAfuY1RhvB7jzr7k5uFBr3b+3Z+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luka Gejak <luka.gejak@linux.dev>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/452] net: hsr: fix potential OOB access in supervision frame handling
Date: Tue, 16 Jun 2026 20:24:15 +0530
Message-ID: <20260616145119.349891242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Luka Gejak <luka.gejak@linux.dev>

[ Upstream commit f229426072fc865654a60978bb7fda790a051ff3 ]

Ensure the entire TLV header is linearized before access by adding
sizeof(struct hsr_sup_tlv) to the pskb_may_pull() calls. Without this,
a truncated frame could cause an out-of-bounds access.

Fixes: eafaa88b3eb7 ("net: hsr: Add support for redbox supervision frames")
Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Link: https://patch.msgid.link/20260523130330.61880-1-luka.gejak@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 3852fd99509f04..7a596c4f603e2d 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -84,7 +84,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 
 	/* Get next tlv */
 	total_length += hsr_sup_tag->tlv.HSR_TLV_length;
-	if (!pskb_may_pull(skb, total_length))
+	if (!pskb_may_pull(skb, total_length + sizeof(struct hsr_sup_tlv)))
 		return false;
 	skb_pull(skb, total_length);
 	hsr_sup_tlv = (struct hsr_sup_tlv *)skb->data;
@@ -100,7 +100,7 @@ static bool is_supervision_frame(struct hsr_priv *hsr, struct sk_buff *skb)
 
 		/* make sure another tlv follows */
 		total_length += sizeof(struct hsr_sup_tlv) + hsr_sup_tlv->HSR_TLV_length;
-		if (!pskb_may_pull(skb, total_length))
+		if (!pskb_may_pull(skb, total_length + sizeof(struct hsr_sup_tlv)))
 			return false;
 
 		/* get next tlv */
-- 
2.53.0



