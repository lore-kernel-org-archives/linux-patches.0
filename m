Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6593164C3;
	Wed, 20 May 2026 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295953; cv=none; b=JUGat/YQfA/Nx62oNjuEHOtgF9VRUedO7TRHJSphvYVL0pLgEDMv31r2FmIpUlPjp5if6uishov1Dena6wPW+Kq4iyyLKA3R4J/07y71axAohQ/fIHQQRMYvDBhucjP2yaYBxe9cxDjtH3UnLB22HyjMbOL9AwTNfNFFbyfxUx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295953; c=relaxed/simple;
	bh=gBed/N+d4kujpxU32M9fgmoMWGoaP6BV0YJp3yLzBtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVJJXAu3hJmHScP50gVD5jDTya5DEjInbKgUNPCGoLV5gUl1SQmSsOFiR62b4SPPPGP/qDg4Ean/gnk8xr4LGIZH2YaGtX9KTPLxYUeDQMFW8F9TdVHjFyaEho3uZMkZLGvHEVwVgvxtrvLeSmmtyhytF8ZyLfFb3SaUkxvsndM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N5aky5f5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N5aky5f5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D35F41F000E9;
	Wed, 20 May 2026 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295952;
	bh=SEpqY6+gs7JQreNFh2eta5dUSynZ353X86Jk96NLluw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N5aky5f5J21VV8siYHlFSSpcNvOWMpUvlKZIIWyliQ7My5yzhjLvR7iAMqV178eRI
	 Zfa+YS1N8f1gBhBIHylbzWEfswYdglxH8DeTg5REE51554K/3U2W6BIrnUzPsl5NVN
	 nxbl7njR1lC5ASnAPbEF1hLHGMym8RgASniX8CLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0616/1146] bpf: Fix precedence bug in convert_bpf_ld_abs alignment check
Date: Wed, 20 May 2026 18:14:26 +0200
Message-ID: <20260520162202.124475252@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 90ae4f314b6c3..d4fe9e4a45d11 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -508,7 +508,7 @@ static bool convert_bpf_ld_abs(struct sock_filter *fp, struct bpf_insn **insnp)
 	    ((unaligned_ok && offset >= 0) ||
 	     (!unaligned_ok && offset >= 0 &&
 	      offset + ip_align >= 0 &&
-	      offset + ip_align % size == 0))) {
+	      (offset + ip_align) % size == 0))) {
 		bool ldx_off_ok = offset <= S16_MAX;
 
 		*insn++ = BPF_MOV64_REG(BPF_REG_TMP, BPF_REG_H);
-- 
2.53.0



