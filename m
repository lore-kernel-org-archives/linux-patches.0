Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD55356A12;
	Tue, 21 Jul 2026 20:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666679; cv=none; b=KQ5nkgw7Ls3p8mPFDg/nRTxwK5I1YrvS2yOv8YgTdVUj6USqBZS6vIoRH0hJ8qGo5mjIc3aLJvCUMrjwlT11/wLLcZux7vjE/SBX9s0Pn7IsKr049GBHZ6qBpa/m02FnlhaxLYVEBzG6pxsVp6gW++hdolcLxSwZizTmhpxZPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666679; c=relaxed/simple;
	bh=07qGwIXRQy9/U8aPIuRchdcL+ajhC9CIpfySj7qtfzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gdpWPWc0mMsgsDIaKQFA5UcAtnNhWizdh2rJ1Hq0su8ONY8NvhS90t//lxukNKKRxJlOBwTNk9kjjAlhCqF4ht3C3I3j/nTic4FPbRVNioU+wXcJ/Iyp2W8u0ViSK5SV+Cfw3nUfK42GfxRCyhqFBy/60WO5HmdkEs1Fkcz2vzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kvz9BZeF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kvz9BZeF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2DCC1F000E9;
	Tue, 21 Jul 2026 20:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666678;
	bh=Ab3lD90xpB6ZhlKOZpv5sC7aEunBaQr2lRMzcEiiJ14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kvz9BZeFJVlHSJbOTyU99Jm9TljdUzMH1HP+ywO+n4SIHx6u2epnQ96LvS/+hWBoB
	 17jhN7egGANT+fIs5fSW2xVpcrsb3ydCtDlWnN/Q2ciCMaH+q/wCNGx6oT7T+L+zCZ
	 6zskZLUzC1JeMnB/BQGiTovEjqYpIznxxCgHGiF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <include@grrlz.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0773/1266] bpf: Disable xfrm_decode_session hook attachment
Date: Tue, 21 Jul 2026 17:20:10 +0200
Message-ID: <20260721152459.162263206@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index c7c4201644322b..147c3a8ad4e8e0 100644
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



