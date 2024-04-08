Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B564CF2;
	Mon,  8 Apr 2024 13:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581428; cv=none; b=MzhZ5GePg9zvjUQiCji82K9o0xVyymunQbZlL05oWsKz26t2I9BIieNWbPoIvFz3n6PpMfAhZasDWi1FJMAN/vO+LOtlB5MV/aDO7uDRE9PdKYWkQX0G7oSXeRqYiiyjdvqfN/l7VsEIXAzao2nRFhhvQBWYS9Lan5mqi9chvAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581428; c=relaxed/simple;
	bh=E1kZTgikyuer4j5Y4zzr+oCefTbxjZ2Iw3lYuZC0rM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Etam97/5vZKhrknkf5HOmeAXc0ir2ijxt60gRwzgpm/Dq/Lv7WNH0wuhkW5BNZR9oTkBpqqKqW/k98oTTRuW4+EdFG517kG7mlW4BsOJcHLc6jsT/ofDTXy0YCLMEtToN/4crDLUTOmLHPeAjxSnfZML/2cEjQndlQ8sicaRHbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4Qno8Kz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4Qno8Kz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0011FC433F1;
	Mon,  8 Apr 2024 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581428;
	bh=E1kZTgikyuer4j5Y4zzr+oCefTbxjZ2Iw3lYuZC0rM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4Qno8KzR9B+/3j5jCrCAhkqTszWz0p56qhk/pcETLR4PUbwh7d2RRvMzqzf4qHf0
	 OcPyzE4pAnr8r1Jm8kxf+39qi+mnGbLOOC6/NE9LsZcpdAG1WAgB3MTBhd5U8KL/J3
	 LkQSeTGUQ7dnO9t5hcJ8MRfLiRTd2nmGah/xm1X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+33f4297b5f927648741a@syzkaller.appspotmail.com,
	syzbot+aafd0513053a1cbf52ef@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrei Matei <andreimatei1@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/138] bpf: Protect against int overflow for stack access size
Date: Mon,  8 Apr 2024 14:57:12 +0200
Message-ID: <20240408125256.797665332@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit ecc6a2101840177e57c925c102d2d29f260d37c8 ]

This patch re-introduces protection against the size of access to stack
memory being negative; the access size can appear negative as a result
of overflowing its signed int representation. This should not actually
happen, as there are other protections along the way, but we should
protect against it anyway. One code path was missing such protections
(fixed in the previous patch in the series), causing out-of-bounds array
accesses in check_stack_range_initialized(). This patch causes the
verification of a program with such a non-sensical access size to fail.

This check used to exist in a more indirect way, but was inadvertendly
removed in a833a17aeac7.

Fixes: a833a17aeac7 ("bpf: Fix verification of indirect var-off stack access")
Reported-by: syzbot+33f4297b5f927648741a@syzkaller.appspotmail.com
Reported-by: syzbot+aafd0513053a1cbf52ef@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/bpf/CAADnVQLORV5PT0iTAhRER+iLBTkByCYNBYyvBSgjN1T31K+gOw@mail.gmail.com/
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Link: https://lore.kernel.org/r/20240327024245.318299-3-andreimatei1@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 1a29ac4db6eae..27cc6e3db5a86 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4965,6 +4965,11 @@ static int check_stack_access_within_bounds(
 	err = check_stack_slot_within_bounds(min_off, state, type);
 	if (!err && max_off > 0)
 		err = -EINVAL; /* out of stack access into non-negative offsets */
+	if (!err && access_size < 0)
+		/* access_size should not be negative (or overflow an int); others checks
+		 * along the way should have prevented such an access.
+		 */
+		err = -EFAULT; /* invalid negative access size; integer overflow? */
 
 	if (err) {
 		if (tnum_is_const(reg->var_off)) {
-- 
2.43.0



