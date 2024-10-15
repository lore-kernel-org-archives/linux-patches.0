Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA8DC1D89F5;
	Tue, 15 Oct 2024 11:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992862; cv=none; b=io1j8o1bQmF5Snc/c7/5sMATS1B1j2qGK1+L3ALGsPoCUXbmkZTt7mXQ1BlWatq4tL8P+7u9/PlspgAHYLRRQOwfKWJcyBXz17nLnHQLNBRFghkPIB2lBF46tKK9bRZQVDdQiKLbzxv3xPR5GyBJPb/cnnRsaOV6UHnYqZa2q0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992862; c=relaxed/simple;
	bh=mh/EzTFHeOViYH2/PS7t1YpV8CFZArZD4ZyrGTOvjcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMTK8CUDp0N6tk7O1UWU8vEbtswF0Z92j5/tUm+zz0qMQ1MjvrGbzMIgv69HsrHFGwLz+JHLioLTlKGbKbHtLyiHMhZdQ8ObERYtog7X5D++HMltboQGG9TEWwp5N2YjxvEpT3GTu7/U0zNtmOlLlnmU/6UKZG/HdbzXbEYBQZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Zpz/1bp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Zpz/1bp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17515C4CEC6;
	Tue, 15 Oct 2024 11:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992861;
	bh=mh/EzTFHeOViYH2/PS7t1YpV8CFZArZD4ZyrGTOvjcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1Zpz/1bpCk5z7gRznKMvdKLQljGYYx95EZYrlkCEZt2IVQ9+rJeVukTgcMGgI5VRb
	 X2sgvje0kvo/N44oAdgCuMfy1/B025mf25Osc7Y1bmAjmTX03tMqUc18VTegcA2RtE
	 gaf7aLICOY2nHLlVR6smCbJ0tt92OnYm/zHV5Kv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 213/691] bpf: Fix bpf_strtol and bpf_strtoul helpers for 32bit
Date: Tue, 15 Oct 2024 13:22:41 +0200
Message-ID: <20241015112448.812711432@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 273f2f0deb239..13f870e47ab6d 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -512,7 +512,7 @@ static int __bpf_strtoll(const char *buf, size_t buf_len, u64 flags,
 }
 
 BPF_CALL_4(bpf_strtol, const char *, buf, size_t, buf_len, u64, flags,
-	   long *, res)
+	   s64 *, res)
 {
 	long long _res;
 	int err;
@@ -537,7 +537,7 @@ const struct bpf_func_proto bpf_strtol_proto = {
 };
 
 BPF_CALL_4(bpf_strtoul, const char *, buf, size_t, buf_len, u64, flags,
-	   unsigned long *, res)
+	   u64 *, res)
 {
 	unsigned long long _res;
 	bool is_negative;
-- 
2.43.0



