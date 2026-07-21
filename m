Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD76746D2C3;
	Tue, 21 Jul 2026 18:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657798; cv=none; b=GFJ2oT8RM4pSLkpf+3JzwKwyN9HcF0JZjN3Lu9YlUMYKcjV2XUf8GPdxYIr00t+P+VTKbaRsjzIXBtooOAaqZ+9Z1edxncnwE4/dn+QYyX5hYtOr+GodQBdVvsmKN0wiyxGjP0nXnmV37qsIe4jPf+S+Tx9ayr4DjwU6GC5Rqyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657798; c=relaxed/simple;
	bh=PIBiGWdARqXKDZa9azegLLBj6JnEvSeQF8VLN6LZm40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u4sGOuuuI2W+KfhUpAXH5byfHMf8kRMJa8g1JvbzRPqSiKQdQIUScYVUNxaqHfECe18qwQeFQ8HA5m59STQTGYP35/ql7DVadQif1Bl5NEF9S+b+h7oeZ9mfNe3rosHV35cVuZXYefjxfYcLE1IQlBCt7hURNJsy8v1YheM6tlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mI94c8sT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mI94c8sT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB271F00A3A;
	Tue, 21 Jul 2026 18:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657796;
	bh=IEUvZSAQqPQO7bnTzzUlO6EgvnRnFSyJQw9zcr2uDBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mI94c8sT9hasIC2vNSlIoWZXb7QglnnjrdRbeohlLpwn4wOssJ0fe3xvgbM1hEWkY
	 rKZFm8YAS6+SnLqT0o4oZ6pVL7wmC+DOIcRVarjXPVklSaFdlD8BfpXT+orF3Ck0g8
	 UTp2V5uwLebDeRAAcEdENeDZXP02rlpthJD2rY+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0901/1611] bpf: Disable xfrm_decode_session hook attachment
Date: Tue, 21 Jul 2026 17:16:57 +0200
Message-ID: <20260721152535.655895423@linuxfoundation.org>
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
index 554985ce9025ac..518c933fe944c4 100644
--- a/kernel/bpf/bpf_lsm.c
+++ b/kernel/bpf/bpf_lsm.c
@@ -50,6 +50,9 @@ BTF_ID(func, bpf_lsm_key_getsecurity)
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



