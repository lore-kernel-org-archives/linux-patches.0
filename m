Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16F63FB05A;
	Wed, 20 May 2026 18:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301010; cv=none; b=FOmhgJc5tbD6Uix9z3QSwUzlWlDNsKS0TUYQHr1MmdpmqH1vq4WaeXJOG+nJUNYyQ6L9pHE/mBAgjTVuzFuFSYRXpJR6JlpQn97JwYWzx9CINJBCU1LbtLEitYFquIx+mubwdWkR086S38Kp1AIksPj0KsHi6nHAjJaJOGqPR4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301010; c=relaxed/simple;
	bh=n0U1z1GIo2iGgj9tcTtSXtf8A5TZIcaYUpbE19CUQYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xz1lQidSK+5u7TqjgM1RhqqhKqr3fKOEbmfCJnBGAK+VuUT3EFcYBlfwFwqOpn/IEqXt2vKqbaZJxDbkjxDQ9k2WHK11v/GfY28MEe/s5JpZEedAboXnfboHJMImniiiLn0oSiIHVl7GWoXzOAb5/zzkcLsBxPDQlZojAhNprK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KK0fQML0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KK0fQML0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6327B1F000E9;
	Wed, 20 May 2026 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301006;
	bh=TJ5OLgsKv68g8mPsQUgfhPvUO5l7CJ+aI3UrouNsUgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KK0fQML0VuO+78fqJvMFcOGDnCXKDKvIEdevuJELLYR91iUr3emLzWRPgQAEI3EeT
	 uA4hzD8wPoQTWIpeIiusuMTMnpCSU50QptVsNk345UMIMCbPjlCYft6Vzwsskp8hEJ
	 UbQx6ri/8HddzLztJBHJJdHVyPNZDOLgTp7LmbFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 350/666] bpf: Fix precedence bug in convert_bpf_ld_abs alignment check
Date: Wed, 20 May 2026 18:19:21 +0200
Message-ID: <20260520162118.815569655@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e5f635edd393aeaa7cad9e42831d397e6e2e1eed ]

Fix an operator precedence issue in convert_bpf_ld_abs() where the
expression offset + ip_align % size evaluates as offset + (ip_align % size)
due to % having higher precedence than +. That latter evaluation does
not make any sense. The intended check is (offset + ip_align) % size == 0
to verify that the packet load offset is properly aligned for direct
access.

With NET_IP_ALIGN == 2, the bug causes the inline fast-path for direct
packet loads to almost never be taken on !CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
platforms. This forces nearly all cBPF BPF_LD_ABS packet loads through
the bpf_skb_load_helper slow path on the affected archs.

Fixes: e0cea7ce988c ("bpf: implement ld_abs/ld_ind in native bpf")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260416122719.661033-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 795e558155c6d..1d7467601a32c 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -499,7 +499,7 @@ static bool convert_bpf_ld_abs(struct sock_filter *fp, struct bpf_insn **insnp)
 	    ((unaligned_ok && offset >= 0) ||
 	     (!unaligned_ok && offset >= 0 &&
 	      offset + ip_align >= 0 &&
-	      offset + ip_align % size == 0))) {
+	      (offset + ip_align) % size == 0))) {
 		bool ldx_off_ok = offset <= S16_MAX;
 
 		*insn++ = BPF_MOV64_REG(BPF_REG_TMP, BPF_REG_H);
-- 
2.53.0



