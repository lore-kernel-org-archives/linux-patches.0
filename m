Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 537951C761F;
	Mon, 14 Oct 2024 14:58:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917923; cv=none; b=mRWFKEkD04a/gV9rybs0NeRsQmtkW0Tg2DuVxqmRCZ82Bn8O7Bw/0JE0S8HlltdovFa8yn23rQ6dgsz9ZnTbNdzv/ci/bp/7pCtyCRsawckKIiGKOIdOAE/9i5AnH7rJ/KcenD6OQSfgfZ+Yxew0rD9DlGON57Bpvn5QIVU2QlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917923; c=relaxed/simple;
	bh=U2QqdkpPoHVUY1KgcGp5Jl3P1aXsqKlFmU+5BNIFzME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bsIzYb1ECnir5wFFdciw5J0Y8i5f80g9ZbuwhCIsTywrTwCFb/Ias8+3Hab8YJU1Ixsy0CDNk2RGA7f4JMk0m91P6oy7PAcJ+GRE2rAwbXiHXpgJuGNsh+wuQKvdRlpN71lmz280HoR+KK7ONv64HGKTU819MXXsm8EZ1RKMio4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xe3hVBmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xe3hVBmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB139C4CEC3;
	Mon, 14 Oct 2024 14:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917923;
	bh=U2QqdkpPoHVUY1KgcGp5Jl3P1aXsqKlFmU+5BNIFzME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xe3hVBmpVsFZr5/5O5nUIts/sYq7VGsqHji+ZVpjLGpmwK6uJHo/fVdOmTDAsq0QU
	 uI8D4bQZYOIFUQ11ilbaZb0dxLNkssnpgSfCskZzu1LrxG04L88J0qsS0VGuMokSw2
	 LbQ/oiPeXoPc3LuNi6TrEg+gcudAc+IHTxECk3ws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 174/798] bpf: Fix bpf_strtol and bpf_strtoul helpers for 32bit
Date: Mon, 14 Oct 2024 16:12:08 +0200
Message-ID: <20241014141224.763000958@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 758510b46d87b..d12e696fac74f 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -509,7 +509,7 @@ static int __bpf_strtoll(const char *buf, size_t buf_len, u64 flags,
 }
 
 BPF_CALL_4(bpf_strtol, const char *, buf, size_t, buf_len, u64, flags,
-	   long *, res)
+	   s64 *, res)
 {
 	long long _res;
 	int err;
@@ -534,7 +534,7 @@ const struct bpf_func_proto bpf_strtol_proto = {
 };
 
 BPF_CALL_4(bpf_strtoul, const char *, buf, size_t, buf_len, u64, flags,
-	   unsigned long *, res)
+	   u64 *, res)
 {
 	unsigned long long _res;
 	bool is_negative;
-- 
2.43.0



