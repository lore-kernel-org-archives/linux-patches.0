Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102F23FE668;
	Wed, 20 May 2026 18:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302371; cv=none; b=IFnMMC2HwB7PuyzrxszOcs9RZczUl/Y75xTeggc5P/8qC+iQuITMsc4heexG48To1NQanvNydy7sEJYrAtmp7WGYSi5WjD0B0lcXST9XW20v5XYeVlWR/Bxw+fTmuIPK/heI4a+/+oHhskmyTbNqac+AtixJe7lpq4ZUFI+njyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302371; c=relaxed/simple;
	bh=uZ+97EuX3xdgptpnIDHxSH5r1O3JCqXuBiob+UOa500=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TT5jPQVzxhGPMLAzNRpqvvDjRoBzK40hVetksHOjSk/+TiHxzOEDDYHDGn6t2M1QvjagzDQofV+eDxFQDNEg9ge0RUTv9tJmswkTKkdG6aZ6wen4nVp61DYIHRG6s9AoVX0ye478T4ldLZLVumhzLM20SFn1qjWdGUrjzG6Obpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEqrip48; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEqrip48"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 759621F000E9;
	Wed, 20 May 2026 18:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302370;
	bh=Y7sv2zq5CEgC73DW1l1YSvfIuIZ0bMBOoURoL80wMpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zEqrip48sJbVy4tp1NpKe61HPHP8CWeH4m8amxXLpORD4PGFVCSQDKfmpObGG/lls
	 cit+M7bhsn4u61IOVYGOG7F/w6f1vbko/EXq03XdmDZlbO+iNEOrcmAVjVyOyM+xvS
	 PEjSuOWU0PQktsHlN0bkaGsLIIDHmVidZ1CVqK+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 240/508] bpf: Fix precedence bug in convert_bpf_ld_abs alignment check
Date: Wed, 20 May 2026 18:21:03 +0200
Message-ID: <20260520162103.849773416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index c24510037334c..371f4e789998d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -492,7 +492,7 @@ static bool convert_bpf_ld_abs(struct sock_filter *fp, struct bpf_insn **insnp)
 	    ((unaligned_ok && offset >= 0) ||
 	     (!unaligned_ok && offset >= 0 &&
 	      offset + ip_align >= 0 &&
-	      offset + ip_align % size == 0))) {
+	      (offset + ip_align) % size == 0))) {
 		bool ldx_off_ok = offset <= S16_MAX;
 
 		*insn++ = BPF_MOV64_REG(BPF_REG_TMP, BPF_REG_H);
-- 
2.53.0



