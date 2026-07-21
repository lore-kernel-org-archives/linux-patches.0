Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7BD432E9C;
	Tue, 21 Jul 2026 19:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663272; cv=none; b=les1t7g2Zwp/6YsXLw3mHyR+EJTJeb3O+vRddqc35jTsi7QMpjBtxmHJZqHFUDdZETuGn7R0GH7KVLw3AULz+8CE3ansHv+ubLxRxce2m6/E3Krw9/ZhWpQhzUKApedsuKnzKF/AId5TY6EBIKPYmdTXN1jUPE9qXsgVxz6bmyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663272; c=relaxed/simple;
	bh=04a9HBTp8yNx3LzEJQCU/vSCT/wjREC+DJRH3A2BT8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQQuzmmKraP6h3aUYBoGPEHVAq9AWDWO/yAvvSLC7bSXE/KOIx+tChlxctx9obb3nG9dQ7PejmGjtdSgZ3c51nLzND7MRXx5W4L1yJAmCdxdFcVe85G4xgLa6h7r8XRvfXhp3nUNqalgLKUlt6ecyersiAQibpv5UIZ0wAx6fHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IahE03oa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IahE03oa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA2F1F000E9;
	Tue, 21 Jul 2026 19:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663271;
	bh=tGujV7fOhemNJPg6pHB/OM9VbhN2os9Fd6e8ENosMjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IahE03oadyNmTyTETVuUQla2Q8JhB8VebDXhc/NygqosQsIHPVHSacKtrZ8EuXY27
	 hajwVBfgfxjVTI1BfBPStRL2RKY73r9GAqs4YsLdc466+x/O1+oOdgDZFU8m26ZcOq
	 XD8y3iaKs2Uf86fSiAFc525jIyLRZ0/B253Kdyd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qihang <q.h.hack.winter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0760/1276] gue: validate REMCSUM private option length
Date: Tue, 21 Jul 2026 17:20:03 +0200
Message-ID: <20260721152503.083948343@linuxfoundation.org>
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

From: Qihang <q.h.hack.winter@gmail.com>

[ Upstream commit d335dcc6f521571d57117b8deeebc940836e5450 ]

GUE private flags can indicate that remote checksum offload metadata is
present. The private flags field itself is accounted for by
guehdr_flags_len(), but guehdr_priv_flags_len() currently returns 0 even
when GUE_PFLAG_REMCSUM is set.

This lets a packet with only the private flags field pass
validate_gue_flags(), after which gue_remcsum() and gue_gro_remcsum()
read the missing REMCSUM start/offset fields from the following bytes.

Account for GUE_PLEN_REMCSUM when GUE_PFLAG_REMCSUM is present so that
malformed packets are rejected during option validation.

Fixes: c1aa8347e73e ("gue: Protocol constants for remote checksum offload")
Signed-off-by: Qihang <q.h.hack.winter@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/gue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gue.h b/include/net/gue.h
index dfca298bec9ccd..caefd6da86939b 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -80,7 +80,7 @@ static inline size_t guehdr_flags_len(__be16 flags)
 
 static inline size_t guehdr_priv_flags_len(__be32 flags)
 {
-	return 0;
+	return (flags & GUE_PFLAG_REMCSUM) ? GUE_PLEN_REMCSUM : 0;
 }
 
 /* Validate standard and private flags. Returns non-zero (meaning invalid)
-- 
2.53.0



