Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29803368A2;
	Tue, 21 Jul 2026 17:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656385; cv=none; b=Jrn0DcknGwRHlo4xrjPxTGJLfDjpK6qrIk/KAiTQ15xxx5GhzWODOd8oYW2BevjTo3HqUuJ8m1TuXjnHyPdNCwjii/LV8ZI16qoaW+cXcHo2D6DyS4WKbbfwvnO4IcX70Z77bX17s3LxrBQrq/derLYhQkpr0LYaYkKRD9JQK+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656385; c=relaxed/simple;
	bh=K1CwaqcBQL/guKqb5elGZQ6kwlNvnEG92pPXsAoSYXc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UHwprvWfF4e496JId9cj5qhobfbnWKonDzKTtnomiXQ6ALclC0NJmGCN3Qx4c3XghtTbSkxesnIUP+LeT4DGrwnQgyoMXHzeCLK839Q6fh2mlCe7Tow+PZJvqbDJDGVyapX2lZDY1xnr3FUzH2o1I5LjCQTgDTyiFR9KoAhAnPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwTr7D2W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwTr7D2W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8B21F000E9;
	Tue, 21 Jul 2026 17:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656384;
	bh=iGAQT4tcttAWEaNTrrOlSR/a/9tFEB+LsCwA6n8pqoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwTr7D2WOJcGS/E0UBWcOCHQqNw4zEEtVk5XAy584mgglyo/vD+KUVVCmFXolKe0s
	 5dN3RRo8l7g1xmJDye1MlhSulODomaJoT0QDqtztIecTlr70cG90eGXG+nYp02e+en
	 4zrN76saW5M3T566o8XsPs8n8DTX/K3NTBFEhEMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0330/1611] xfrm: fix NAT-related field inheritance in SA migration
Date: Tue, 21 Jul 2026 17:07:26 +0200
Message-ID: <20260721152522.517427757@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Antony Antony <antony.antony@secunet.com>

[ Upstream commit 364e165e0b63e8142e76de83e96ae8e36c3b955a ]

During SA migration via xfrm_state_clone_and_setup(),
nat_keepalive_interval was silently dropped and never copied to the new
SA. mapping_maxage was unconditionally copied even when migrating to a
non-encapsulated SA.

Both fields are only meaningful when UDP encapsulation (NAT-T) is in
use. Move mapping_maxage and add nat_keepalive_interval inside the
existing if (encap) block, so both are inherited when migrating with
encapsulation and correctly absent when migrating without it.

Fixes: f531d13bdfe3 ("xfrm: support sending NAT keepalives in ESP in UDP states")
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index 898cddff498c7c..efbe0135d27764 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2020,6 +2020,8 @@ static struct xfrm_state *xfrm_state_clone_and_setup(struct xfrm_state *orig,
 
 		if (!x->encap)
 			goto error;
+		x->mapping_maxage = orig->mapping_maxage;
+		x->nat_keepalive_interval = orig->nat_keepalive_interval;
 	}
 
 	if (orig->security)
@@ -2054,7 +2056,6 @@ static struct xfrm_state *xfrm_state_clone_and_setup(struct xfrm_state *orig,
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
-	x->mapping_maxage = orig->mapping_maxage;
 	x->lastused = orig->lastused;
 	x->new_mapping = 0;
 	x->new_mapping_sport = 0;
-- 
2.53.0



