Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB414BAA4;
	Tue, 23 Jan 2024 00:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970717; cv=none; b=OvKBjGi5tEiqJXqp7w3oJVVHgEJJQFPHFd/c/Zkmr0wfHGM0PUiagTlFvOzIYoBaKI5/s4OYrBhD15BqWSfkmN1oaHpoTAI7ZtNOVMj4vsMbUj47EFg/mckRaA0UpdcNAJcKAmCtosuElKsS0BlIsDT332e2v5G6pZw9XWvXLUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970717; c=relaxed/simple;
	bh=CAkwx+q5kBIKnaUrqSopT0afF6VDWoX/P4zeGwvsgJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0SOFuFL2ot4TMfO7+QzO+zosD8J+thE1p0GbqAPSRIWq8yJDKeVPwlYPkY+WRsJjnKA6t0bm9Gz9tqswlx+BiDkQnH4WbuMBkYAE3NJ5i+LVEh0tZ0UeYrMu1QtfcqxmBdT4U0i9Q1/BMxUQSI+X5x6IpVIcGmfnoxM0j20Oxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zhgjhBKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zhgjhBKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70078C433C7;
	Tue, 23 Jan 2024 00:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970717;
	bh=CAkwx+q5kBIKnaUrqSopT0afF6VDWoX/P4zeGwvsgJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zhgjhBKA9hm+sBoUIUr6sg8ZnzsHeKbsQaRt2UW7gwXEiGKiurkH6qqgCQLoAoXoQ
	 aGXYhrMncOKsnsyAZe3OJhOSzJb3TrePVNAin47erO4rv/fdtTJl+sDtF8aOnQuVO6
	 9Zjx/saytKE5rmAJoHNBVNm+fpCscbP8m4Wzl4do=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/417] bpf: fix check for attempt to corrupt spilled pointer
Date: Mon, 22 Jan 2024 15:54:26 -0800
Message-ID: <20240122235755.088199771@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit ab125ed3ec1c10ccc36bc98c7a4256ad114a3dae ]

When register is spilled onto a stack as a 1/2/4-byte register, we set
slot_type[BPF_REG_SIZE - 1] (plus potentially few more below it,
depending on actual spill size). So to check if some stack slot has
spilled register we need to consult slot_type[7], not slot_type[0].

To avoid the need to remember and double-check this in the future, just
use is_spilled_reg() helper.

Fixes: 27113c59b6d0 ("bpf: Check the other end of slot_type for STACK_SPILL")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-4-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 024a2393613f..adadf8546270 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3284,7 +3284,7 @@ static int check_stack_write_fixed_off(struct bpf_verifier_env *env,
 	 * so it's aligned access and [off, off + size) are within stack limits
 	 */
 	if (!env->allow_ptr_leaks &&
-	    state->stack[spi].slot_type[0] == STACK_SPILL &&
+	    is_spilled_reg(&state->stack[spi]) &&
 	    size != BPF_REG_SIZE) {
 		verbose(env, "attempt to corrupt spilled pointer on stack\n");
 		return -EACCES;
-- 
2.43.0



