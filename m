Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A80411661;
	Tue, 21 Jul 2026 19:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661088; cv=none; b=tW+vjjDTtcjFZZN4USoxzjlGUwJlcwDUBB5DoPMcoyzSCcnDXk1nFv0oL9aFQ68TZHiwgMyh9X6FGm6IFeQQhIO7AdpSbEnUjUBkjEvH2r0wVsnVxqJZw0H64fiDqBuDv7a5qbqdmQzMfKZh6wdWB0HzZFBJKvT1h4yE21RzEQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661088; c=relaxed/simple;
	bh=VtLLtVdTbUu5s7e4IHJTffGf9u309Gceor8NfUlN/xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OcVBfrs4xfSGUByu1WfTT4inBrsEzmwDcbILqIPEVABSqgPdjiOe5tdAX0C+szL6fz5GENtAi76TI3CueGgG8POxhSpbgk005jstQtc7MNzg7YZErYz0w10hr3eI/1DcX2v6AR9yz2g5zLWkAf2Oim4S+7qIMSvK3B5U1Cu7e5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pb3paObe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pb3paObe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 035771F000E9;
	Tue, 21 Jul 2026 19:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661087;
	bh=h6AMgbkWNzu2DTCp3b3eRQoIMXrR8YpSohhmAixjHeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pb3paObefaMNrCppBSjMTjpzVqBNE7ObMHsJT70Wzx3UfP/au5YcmS06f1K4aiXNB
	 ZM8oXsC3QCyqHb4SOPJMvhBY6jOqFx1EJIDaeYDLyXMXJa/6wcVhN0H8+7O57Doc5r
	 EousH93eNfCyD+cz5RvGxmD6yAmjJGN0kzD7IplM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1225/2077] bpf: Disable xfrm_decode_session hook attachment
Date: Tue, 21 Jul 2026 17:14:58 +0200
Message-ID: <20260721152621.706914466@linuxfoundation.org>
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
index 564071a92d7d20..1433809bb166a3 100644
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
 BTF_ID(func, bpf_lsm_file_alloc_security)
 BTF_SET_END(bpf_lsm_disabled_hooks)
-- 
2.53.0



