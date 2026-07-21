Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4AD46C4AE;
	Tue, 21 Jul 2026 15:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649143; cv=none; b=Vcia7vqIKq+y3LB06oNbtE2hjrA3RmGecJOlOuLVNQrH8z+YuhVWXLyxdmtVkYOd4YtMBc+k1kYdaKL6LPR5T3E6pmkts51EAQ//GgnnkVho+5haGjRDZ0moaV2iM5hGfj8Q/wwiXGE6/oW4nCOKiVR1CTpUNjwyZNWM8e8CerE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649143; c=relaxed/simple;
	bh=7OWQ2w69+kqSB32Zf4dIXUziW+ERMy7ntHbcvwdpWs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kidU3+giQkiTSkdPSm4ZAgDDiB2u32hfOzHzJ7TgdJAfzhBqmWfXw2GRk0LmKGd/FTU6tVj3iBoDO2yfIilYxqkYqnVBziuK4NTBxHXnOYGxcj3Hdpe8580HB+ZVqCUl+YvRkXV/TUN+fyFVMy/rblytL6Mlrab1QDErpVq/lXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uOKXtiY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uOKXtiY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0BBB1F000E9;
	Tue, 21 Jul 2026 15:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649142;
	bh=U5o/hf/Vx3R4baocxz9bBSkEKl8MeOgUpP58pFf182s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uOKXtiYXJdlNZRjEqDIpa11ij0Qkhtd3GKKlX9ErhyoFSMIGGCcpRRsOiZ598fyx
	 dEkQQGAUSXFVPZI06PI0abIewHDfCa02wK/QRyaK9QjyySCvlzEV1AwmxbDryfxbnc
	 ab1Q7t/Ky1eolJsMNnV/uaODpcTlqP2eVHUSzNEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antony Antony <antony.antony@secunet.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0467/2077] xfrm: fix NAT-related field inheritance in SA migration
Date: Tue, 21 Jul 2026 17:02:20 +0200
Message-ID: <20260721152603.807788254@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 589c3b6e467913..4c7eed689cd444 100644
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



