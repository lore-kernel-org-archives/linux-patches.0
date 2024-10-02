Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 822331CF7D4;
	Wed,  2 Oct 2024 14:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879796; cv=none; b=LRxrTiB8W6sX7VARg1HB7RQ9UXBhkOHmfTOmsZuuvL5Qtmns6mq0auxZl11aypj+UV93S57c0QRDrTvpIp+5W/If8EpFk051dSJGyd89P9W/8+l3ISW1rRqT0d/iBHn8/Nhb2wxhUv+3pEzpzWkV8M9mUo38j6eo2NaNzWuOB8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879796; c=relaxed/simple;
	bh=MzqoTq3rMUzuytj+7xWN0AVcR3CtPslNcIHhNIRNnAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBqoI8jj3tW32y97f+PFJBbhhHKeVaGgeFfFeb3s0x4xJXLwKi4oUk1e/SQzNPutzJHG4+1noT5AymbFFuLHzAsiCBWDDxfj3bALAvtdT2dUa+ilx2tDQYx5M2ou249yz8AZMhNTrGtpExbJWC2DmDAmS8MHio2cPKQAyFTc+Zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQsC4x7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQsC4x7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D20CC4CEC2;
	Wed,  2 Oct 2024 14:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879796;
	bh=MzqoTq3rMUzuytj+7xWN0AVcR3CtPslNcIHhNIRNnAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQsC4x7Xv6m5Ez6YYeDGIA4IRHe5wEdQBs2qaKIsmz0QAJfJ7bo+SyS6SvZuTb5N5
	 EIJQbAh4QAGP6bNrKJNJGqtOTgYa/dJ0Jy+MsfP0P8Vkffy2d0f9qHt+kJgkjxkbAG
	 6KMonA07EntXAFCu9Kj97Fkv9GTIEUFNwBkOFqNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/538] bpf: Fix bpf_strtol and bpf_strtoul helpers for 32bit
Date: Wed,  2 Oct 2024 14:58:01 +0200
Message-ID: <20241002125801.803235445@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit cfe69c50b05510b24e26ccb427c7cc70beafd6c1 ]

The bpf_strtol() and bpf_strtoul() helpers are currently broken on 32bit:

The argument type ARG_PTR_TO_LONG is BPF-side "long", not kernel-side "long"
and therefore always considered fixed 64bit no matter if 64 or 32bit underlying
architecture.

This contract breaks in case of the two mentioned helpers since their BPF_CALL
definition for the helpers was added with {unsigned,}long *res. Meaning, the
transition from BPF-side "long" (BPF program) to kernel-side "long" (BPF helper)
breaks here.

Both helpers call __bpf_strtoll() with "long long" correctly, but later assigning
the result into 32-bit "*(long *)" on 32bit architectures. From a BPF program
point of view, this means upper bits will be seen as uninitialised.

Therefore, fix both BPF_CALL signatures to {s,u}64 types to fix this situation.

Now, changing also uapi/bpf.h helper documentation which generates bpf_helper_defs.h
for BPF programs is tricky: Changing signatures there to __{s,u}64 would trigger
compiler warnings (incompatible pointer types passing 'long *' to parameter of type
'__s64 *' (aka 'long long *')) for existing BPF programs.

Leaving the signatures as-is would be fine as from BPF program point of view it is
still BPF-side "long" and thus equivalent to __{s,u}64 on 64 or 32bit underlying
architectures.

Note that bpf_strtol() and bpf_strtoul() are the only helpers with this issue.

Fixes: d7a4cb9b6705 ("bpf: Introduce bpf_strtol and bpf_strtoul helpers")
Reported-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/481fcec8-c12c-9abb-8ecb-76c71c009959@iogearbox.net
Link: https://lore.kernel.org/r/20240913191754.13290-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 9ab6be9653059..0dad29f3e3ba8 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -516,7 +516,7 @@ static int __bpf_strtoll(const char *buf, size_t buf_len, u64 flags,
 }
 
 BPF_CALL_4(bpf_strtol, const char *, buf, size_t, buf_len, u64, flags,
-	   long *, res)
+	   s64 *, res)
 {
 	long long _res;
 	int err;
@@ -541,7 +541,7 @@ const struct bpf_func_proto bpf_strtol_proto = {
 };
 
 BPF_CALL_4(bpf_strtoul, const char *, buf, size_t, buf_len, u64, flags,
-	   unsigned long *, res)
+	   u64 *, res)
 {
 	unsigned long long _res;
 	bool is_negative;
-- 
2.43.0



