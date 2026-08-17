Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5B243A7F9;
	Mon, 17 Aug 2026 13:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974766; cv=none; b=PIOfzqLizklm+ll6VGJE4oL2qGQy6maBop2VNWNP9VHwUKbrWgm6JGGATLehPc5k68aUWoK+u3ypP9C+l8SFdSl+g0j490xmP9UIcteyLdf9zzSWvgx2moYovzaLt92Jq6tMLLhxCusrbv54aBGihFcKBO+/cJHSb2BwYiYF6YE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974766; c=relaxed/simple;
	bh=aW8Zg0iLn91fAXX0dKnKMKflyIRG8KYerAgKQvnYsgw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAhs+Ee4fXA+Zf7Q/a/lDtuUDEAa9UhdvrjwKmjrKwdv8mOnhyLKCiGSL+42JQ8YYevzEb4dW0UweuXei27WlicZvLVQSw619+CoKo3GFsfuIzGvOeboXYDJIiLq5rOiPy9azzXj7KFONH2GZv/3HYkFH7YKcwXTXE7pFIUA9Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nweHsUm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nweHsUm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1E21F00A3A;
	Mon, 17 Aug 2026 13:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974758;
	bh=QNEEB31OkOEaE9KdoybpGV45WmmL4AEUT9IiAc8uTtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nweHsUm8HfI623lY+C1rqScb9KZU77AA1QHzqQGAxhMSrZwJ0Ceihf9kTVrAhcdOS
	 cI8YBCVwZacYR1orSRNMb/ZwR93iCw0F9APEYY3jxdgdoZiKPF+0M2Rws4YuTqur6n
	 oZRBqQHhjf2ceN/wz+Fp7t6KZf2QRPbWlU5HksO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>,
	Daniel Wade <danjwade95@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 045/250] bpf: Propagate untrusted pointer state in commuted arithmetic
Date: Mon, 17 Aug 2026 15:30:06 +0200
Message-ID: <20260817132538.294471820@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>

[ Upstream commit cdf19b1b3c01791de074ce282089131026f52261 ]

The untrusted PTR_TO_MEM early return skips pointer offset tracking
because accesses go through probe-read handling. Moving it after full
pointer-state propagation ensures scalar += untrusted_pointer leaves the
destination as PTR_TO_MEM instead of an unrelated scalar.

Fixes: f2362a57aeff ("bpf: allow void* cast using bpf_rdonly_cast()")
Signed-off-by: Yiyang Chen <chenyy23@mails.tsinghua.edu.cn>
Tested-by: Daniel Wade <danjwade95@gmail.com>
Link: https://patch.msgid.link/20260729-c3-035-public-bpf-v4-v4-3-8ee297e2346b@mails.tsinghua.edu.cn
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 80710cb8421ef..459ed144542cc 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -14713,13 +14713,6 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	/*
-	 * Accesses to untrusted PTR_TO_MEM are done through probe
-	 * instructions, hence no need to track offsets.
-	 */
-	if (base_type(ptr_reg->type) == PTR_TO_MEM && (ptr_reg->type & PTR_UNTRUSTED))
-		return 0;
-
 	switch (base_type(ptr_reg->type)) {
 	case PTR_TO_CTX:
 	case PTR_TO_MAP_VALUE:
@@ -14756,6 +14749,13 @@ static int adjust_ptr_min_max_vals(struct bpf_verifier_env *env,
 	if (dst_reg != ptr_reg)
 		*dst_reg = *ptr_reg;
 
+	/*
+	 * Accesses to untrusted PTR_TO_MEM are done through probe
+	 * instructions, hence no need to track offsets.
+	 */
+	if (base_type(ptr_reg->type) == PTR_TO_MEM && (ptr_reg->type & PTR_UNTRUSTED))
+		return 0;
+
 	if (!check_reg_sane_offset_scalar(env, off_reg, ptr_reg->type) ||
 	    !check_reg_sane_offset_ptr(env, ptr_reg, ptr_reg->type))
 		return -EINVAL;
-- 
2.53.0



