Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A441A33FE15;
	Sat, 30 May 2026 17:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161435; cv=none; b=H8CzrvoAwaFFMvsoT0IcXjYOenpEcFkCSfZkxWqIBjj0CXmvPSVHgnezapobIWt/Tbao8MBXAnFnGyzihL2xhNYa8gBZvVYEA7Od/eoqcl1dJIGADgJLXDbTPc5JljbyWxbRfobilDrIFRUnaijN/JmwxvCVIN9YIsL+GQWobq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161435; c=relaxed/simple;
	bh=HEemyZiL0XZmjE3j46zW05ilf4Q6c7uuzA1sNmJEZTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n/LR4QxWAfNMCMlotVbgzd+LAjz9quzOhsq2I0mAlKhnX88zU9ljXykzxPYJKuzkLNcyiohT7aIPHz9/a9oDv1CbhkPQK/azNqECJEQrVvmB1oriNiHfsuVdOKI3Z5D85sOA313MUxvvRmC6Rg0N4Ub9LVVFxo6UJ6+tll4lSrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/xsZFGK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/xsZFGK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D93721F00893;
	Sat, 30 May 2026 17:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161433;
	bh=WnT4R6mWjUnG/UDQ2QB3cG6bZxrT8JwG1sxqL9lhcMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/xsZFGKaW458ZMRCxA1vGioYA0j4KYOYYKylQ4DkC4Y92KZxzloMKlBQTq2tATlP
	 6/DL+eQdCX4+37LbVKap2xw3DGiuQDBRIQV6SkD6QFg9H+T3Ur2RF5jGW7F5xAVMY1
	 Hm6jA65ssNJ24hLB9tVP/wN9yQa12WDFo+DfNal8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 622/969] bpf: Fix precedence bug in convert_bpf_ld_abs alignment check
Date: Sat, 30 May 2026 18:02:26 +0200
Message-ID: <20260530160317.617491125@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index aee85a0062ce6..90e986228ab9a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -493,7 +493,7 @@ static bool convert_bpf_ld_abs(struct sock_filter *fp, struct bpf_insn **insnp)
 	    ((unaligned_ok && offset >= 0) ||
 	     (!unaligned_ok && offset >= 0 &&
 	      offset + ip_align >= 0 &&
-	      offset + ip_align % size == 0))) {
+	      (offset + ip_align) % size == 0))) {
 		bool ldx_off_ok = offset <= S16_MAX;
 
 		*insn++ = BPF_MOV64_REG(BPF_REG_TMP, BPF_REG_H);
-- 
2.53.0



