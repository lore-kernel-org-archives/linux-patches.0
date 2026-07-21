Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD5A043031D;
	Tue, 21 Jul 2026 19:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661992; cv=none; b=FATCdXn8tad4XzHrCi1RDtLPS7JRy05fxNun9Wuuuj10aHSuSLqT7w/z/RGRHvmyhhQDyGNH0LKpZCx8EavurhhRjYMJ62dluuvMxOFwSKRyzQxmtYVo2Nf2AAwiDfiqAPQstSodLfH/33DgwFss2LV/qNRjPIEk3r71QyiLaWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661992; c=relaxed/simple;
	bh=8k+OdGtwRjOO3X54lBbbNJ0DqJxdB9x4e62sIS4cFME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJA5p7imY6vfs4rOIxY6pEHRt90k5bDfQb970uDh3Qe7XvGdJqllR2MSV73UgCQ4txd1Eg9l+3+bOoJriqywZVtjo6LHZqOqhUiQux4nxoDQgaIVRfU1deDVovhSAsIRZrHwKZzhpPCPDTHWpVM4CIjhVgpbNLYtCikZmaKyAs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHQB4GcN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHQB4GcN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 191331F000E9;
	Tue, 21 Jul 2026 19:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661990;
	bh=8wo6AKkW2VtfdBVcflZErR+jYYvcQkyeCcxICNiBbW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kHQB4GcNKFJd3WEezFZ7aQvebHpTRF5VA/8jS0d4hoSO+KveJqQKmOrsi1Ltf77Lo
	 BXvPHI3oFeSZiNQwxoHi3BY0geEh9XUcAe1yAkPBLEaOn7jpMl6vtZNXHG5BocY57B
	 L8XnMXiJRZOxfuowESpTlyyAr4HLMo/fbhhSmoQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0233/1276] xfrm: fix NAT-related field inheritance in SA migration
Date: Tue, 21 Jul 2026 17:11:16 +0200
Message-ID: <20260721152451.305158960@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 04cb201638027d..c39f91b858c815 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -1954,6 +1954,8 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 
 		if (!x->encap)
 			goto error;
+		x->mapping_maxage = orig->mapping_maxage;
+		x->nat_keepalive_interval = orig->nat_keepalive_interval;
 	}
 
 	if (orig->security)
@@ -1988,7 +1990,6 @@ static struct xfrm_state *xfrm_state_clone(struct xfrm_state *orig,
 	x->km.seq = orig->km.seq;
 	x->replay = orig->replay;
 	x->preplay = orig->preplay;
-	x->mapping_maxage = orig->mapping_maxage;
 	x->lastused = orig->lastused;
 	x->new_mapping = 0;
 	x->new_mapping_sport = 0;
-- 
2.53.0



