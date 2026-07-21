Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580013B52FF;
	Tue, 21 Jul 2026 22:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671998; cv=none; b=oXPWTQLJHv6VrX2q1qTCgfLx7l04o/C9gqYsb/YTbK3M0szeTRyKlq7bcI4XhhkVjtXkZ3FbyKJyrLqW4EUVfJxOZVkjNWHo5KRMMZltnZZgNdCCrNFQ0vfwL+H2eDpgaW0kuWurbbY7+KYeIR7A4iopP0CylNDLjGVNUStzx08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671998; c=relaxed/simple;
	bh=6CcmRHpE0NffC1ZPH95qymOB5klKbdpMge8Wqjuv01A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cTY82J0NkT0Hd1gZc2c2gtSjWxffkr4QpUv6BYm0XsUP4qDd2K/NGMNdd3K+E4XE02SSU9TmfWowB3hfzVC79x+6AkcJ+3MHplYxfU7L86OMr1bn4UqUY14gE1ZQ+E2fNPFbcTfXd9b3moQeWVa6M7X9ZnHh8xHJmbJEqFQTmwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzBwTWiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzBwTWiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52421F000E9;
	Tue, 21 Jul 2026 22:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671997;
	bh=dAdFvzJZi2sVWna3zqwn9lcyDj6AoYuylENqtCPv/Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzBwTWiAlr6HXHJFUhlHHM9zQ8DashyKkXRY3Xwgbe2OYS9W66yM82mF40xCHcI1N
	 nQKobVKI5yuC1IdqwDSdHVxd41BYNGwvIG/rOXmDYR8YNkMQI84S5bZMQ20huoXm0w
	 c0xo4QHsDgKJwjR/wKDH04StApZgNY2PRPTjswJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <luis.gerhorst@fau.de>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 459/843] bpf: Fix stack slot index in nospec checks
Date: Tue, 21 Jul 2026 17:21:34 +0200
Message-ID: <20260721152416.356650219@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>

[ Upstream commit d1d53aa30ab3b5ae89161c9cc840b3f7489ad386 ]

check_stack_write_fixed_off() computes the byte slot for a fixed-offset
stack write as -off - 1, and records each written byte in slot_type[] with
(slot - i) % BPF_REG_SIZE.

The Spectre v4 sanitization pre-check uses slot_type[i] instead. For a
4-byte write at fp-8 after the lower half of fp-8 has been zeroed, the
pre-check scans bytes 0..3 and sees STACK_ZERO while the actual write updates
bytes 7..4. That can leave the second half-slot write without nospec_result
even though the bytes being overwritten still require sanitization.

Use the same slot index in the sanitization pre-check that the write path uses
when updating slot_type[].

Fixes: 2039f26f3aca ("bpf: Fix leakage due to insufficient speculative store bypass mitigation")
Acked-by: Luis Gerhorst <luis.gerhorst@fau.de>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Nuoqi Gui <gnq25@mails.tsinghua.edu.cn>
Link: https://lore.kernel.org/r/20260618-f01-11-stack-nospec-slot-index-v3-1-780297041721@mails.tsinghua.edu.cn
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7f5bdc817aecce..ec447854f53450 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2876,7 +2876,8 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 		bool sanitize = reg && is_spillable_regtype(reg->type);
 
 		for (i = 0; i < size; i++) {
-			u8 type = state->stack[spi].slot_type[i];
+			u8 type = state->stack[spi].slot_type[(slot - i) %
+							      BPF_REG_SIZE];
 
 			if (type != STACK_MISC && type != STACK_ZERO) {
 				sanitize = true;
-- 
2.53.0



