Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABCF446EF86;
	Tue, 21 Jul 2026 19:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662965; cv=none; b=A1GzTyfxtQow2cKCPXmRQQjbQx6j7hjul4H/eFJih7hIaf6N4aA4fYYf2kPVqiSWQj5rGud12LdRotYy3u+/ZYqQnLpUz/h9TLC2GJdoihvxVEXMhg176gLYkR4ABtyXU24nvLYMirlaV3DGN5IVdS79Qg193Hnj7Q9k/eptEHo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662965; c=relaxed/simple;
	bh=U3mkz36ZM/HOPtfENwccJATSsFLorzGV3jrDrlXkBZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMhDT1Br894LmqxC3ic/RLltDs6tCKgK0+mbmU/BHxKZt2La42+9D3WnAJx0cxIkCHeoie8nB4ezh27AWRnyo3VX+R8bdn0xEBuJh/f/fQ4Shv0rocpMko/1S23/PuQjkbsYD8tLnRaYDX/XSZ6JwbBl6Fb0nwYPs+9McCv4ZE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1YcDQugW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1YcDQugW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2B61F000E9;
	Tue, 21 Jul 2026 19:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662964;
	bh=B3aDJlIw3ffrtSDpQBAOLcgpp7T6wiH8DlKH9pN7Fow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1YcDQugWq33fJPYbBXf7h0O059SkQhKoX+JvFQEhltvOqvn9i3gVFjA1afLteyMbQ
	 7IBWfK51IxN1nTFq6AXu15Rl+YNYSPSMeOm5YuyAfOfchjGeGQD8pXs4qUEgNyXltT
	 fvkxSy+V2N6KRrPYrfOtUB10vx9EalHCOrKBMtd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0642/1276] bpf: Disable xfrm_decode_session hook attachment
Date: Tue, 21 Jul 2026 17:18:05 +0200
Message-ID: <20260721152500.475135380@linuxfoundation.org>
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
index 0849453b361768..969a6ca362ecb5 100644
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



