Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622482;
	b=lfvbllgx1o1prDVAAChSc3AJ3VRHJp2ngJP0wTHpD+X1SVZflJVP1hfNG8rbsjX7oPwa
	 BQL40oyCt1gkzgp2ryZ6COc681KmTWtwkJ67a3kkaTxJLCY2OupeMbDL5X07Tf/wkZ4+W
	 CYOb7UyxXEThTbqp6afLAyoUEGVzIqdLQWOnPkqGY6eI882qxLGKifrpoah8chLUyZ3+Q
	 Z97YMwgVYDSIj9mbSmsYHpsC883eJd48vhk2ullofOTELLelWhf7872swLWER4lzmOv7m
	 gv9daWYLdxD338EaHeRiV5uMr5kVTu4NEUMH9eAMNPTgCih8Pg1RVMZfAAAeKDUNggw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jo5mpwNrIX/f2X1W20PmqEXwEk9/Dsimh2nTq1Zn4o0=;
	b=gZF0tUE5z98UyXrNeRyoGcZDbYqQgYllNOChdmLMn8BJx7GykPcyCR6sPOeyb9+m8RwV
	 1JCVGcTA+TLlOImJV5NHXwhf3o1N0M2K7tqjJjmSHkAonBtWrHFOCBv5XqRWkLVJANzOp
	 P+peHiX1UsZsV3wrJV+4eW6kejD+a3NIl+GAV34hK3mU77nidwwQ1GUkMsbg1AvSo8oiw
	 VTGqfiek+dVDBcUQsymiObfBvOB+5jiZ7cJG8yCaTdLEVBOLCdV/xlfoyEVANAVZt2Gxd
	 EwEGsW389ZRTEDfnktUEjWkVLo7ZlJRm7xpNwvpEyvyDBnJMQM5YE3HeHJcnaDOMfgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3JKtM8z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FA6606A339;
	Wed, 25 Nov 2026 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O3JKtM8z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3FC1F000C6;
	Wed, 25 Nov 2026 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622481;
	bh=jo5mpwNrIX/f2X1W20PmqEXwEk9/Dsimh2nTq1Zn4o0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O3JKtM8zmoQbprctJh1KbjQfiKmmiLilSJ9kn93LD9MuZsJIXLhuE8mDjFXtj0W1s
	 YnpKwg2qB5KnFIgImxDpRmDEmwQEK/8Uno2ScaRn+burR+d9wfZmk/s7AKGdgFcU50
	 u1fY+IrLKCRKJ4vuQJ2/RWvFNlZ+kG1I2nIlEApI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 553/990] bpf: Rebase the exception callback subprog when dead subprogs are removed
Date: Wed, 25 Nov 2026 15:32:00 +0100
Message-ID: <20261125143835.052984614@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 8608ec8e981974b18834e2d67ed39638a9ec2e63 ]

adjust_subprog_starts_after_remove() compacts subprog_info[] and the
func_info when whole subprograms are removed as dead code, but leaves
env->exception_callback_subprog alone, so an exception callback declared
through the exception_callback decl tag which sits behind a removed
subprogram keeps its old index. jit_subprogs() then takes the exception
callback from func[] at that index, which is past the end when the
callback was the last subprogram, or another subprogram otherwise.

Rebase the index along with the entries it refers to.

Fixes: b9ae0c9dd0ac ("bpf: Add support for custom exception callbacks")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20260925175244.1136329-4-daniel@iogearbox.net
[ sashal: Applied the fix to the same function in kernel/bpf/verifier.c, since this tree predates the split into fixups.c; the three added lines and surrounding context are otherwise identical. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 23c1401a97bdf..b664c160b9277 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -21608,6 +21608,9 @@ static int adjust_subprog_starts_after_remove(struct bpf_verifier_env *env,
 			 * in adjust_btf_func() - no need to adjust
 			 */
 		}
+		/* The exception callback is live, so it cannot sit inside the removed range. */
+		if (env->exception_callback_subprog >= j)
+			env->exception_callback_subprog -= j - i;
 	} else {
 		/* convert i from "first prog to remove" to "first to adjust" */
 		if (env->subprog_info[i].start == off)
-- 
2.53.0



