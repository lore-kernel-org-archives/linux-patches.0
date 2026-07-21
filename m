Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638E9418A58;
	Tue, 21 Jul 2026 21:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669618; cv=none; b=FR89VeEsXqQAgMHUz2tz8nlFBE6qEYWxst/5teqPrmhRbhOHye8b/GQsQUctPEk8KyDsJ7fPVA8WAVWNGbUB48c1uhT5XX2Q2AmZq0Yzyu6J0x/IjtFUnmSlGFo1yNIB2XVwq5oBeB14Y4DCCXoCDrQbZw9cENGp9UTTlRhkPpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669618; c=relaxed/simple;
	bh=ojx6JOwDrTEagkTwnkEvGRFzETMvyXv0Iluf9WRvlb4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T70GshWTIZLdgn20YeBNseB0cNOS391h3K9oX0ZCwLmBx52RQQAep+uhh2pb6sI7GqYvRA5JZsE/3G6GWoUOaaXNl9etlc2g/PRgyDCpgHQqQ4bqLPlpMSCI/w8FFfu9LbjCUT7MVfu72s/iFRYexJ7Gbfb5vx9WFvWIKDaV0ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UIy2ht4Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UIy2ht4Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF89F1F000E9;
	Tue, 21 Jul 2026 21:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669616;
	bh=YVvSYA6a7F4OXfvZIBO0rOw/uzgMAe5WVS5UcMllYwM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UIy2ht4YyK00a6oHy+JnAAf833irY+0KcLBVMY7IYm75KpSfiTy4fak8cocYDHYT7
	 FusEqPjAXv30obNGPFOwliQpYSmOsv/n7LMmFEYOMyIV1TmhA7HkCzW1+ajKZbQl1A
	 TQrWhjgZ/bU7fjQEx6LK1yxSherBjLpqO+bRHEps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0623/1067] bpf: Disable xfrm_decode_session hook attachment
Date: Tue, 21 Jul 2026 17:20:24 +0200
Message-ID: <20260721152438.535314599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Bradley Morgan <include@grrlz.net>

[ Upstream commit 12091470c6b4c1c14b2de12dcbae2ada6cb6d20b ]

BPF LSM programs can currently attach to xfrm_decode_session(). That
hook may return an error, but security_skb_classify_flow() calls it
from a void path and triggers BUG_ON() if an error is returned.

Disable BPF attachment to the hook to prevent a BPF LSM program from
turning packet classification into a full panic.

Fixes: 9e4e01dfd325 ("bpf: lsm: Implement attach, detach and execution")
Signed-off-by: Bradley Morgan <include@grrlz.net>
Link: https://lore.kernel.org/r/20260619130305.27779-1-include@grrlz.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/bpf_lsm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/bpf_lsm.c b/kernel/bpf/bpf_lsm.c
index 39f398ca798c47..4bb8c363c0bfde 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -51,6 +51,9 @@ BTF_ID(func, bpf_lsm_key_getsecurity)
 #ifdef CONFIG_AUDIT
 BTF_ID(func, bpf_lsm_audit_rule_match)
 #endif
+#ifdef CONFIG_SECURITY_NETWORK_XFRM
+BTF_ID(func, bpf_lsm_xfrm_decode_session)
+#endif
 BTF_ID(func, bpf_lsm_ismaclabel)
 BTF_SET_END(bpf_lsm_disabled_hooks)
 
-- 
2.53.0



