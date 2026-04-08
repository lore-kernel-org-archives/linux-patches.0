Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4297B2FF144;
	Wed,  8 Apr 2026 18:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672995; cv=none; b=SjiFZyK9l+wPy0r8z764nrw70jk1ykrXiCEd+TEbrJyTtjKwkROkVmS6g2jyAYiiSGw+XEvbEXCQmlQZq7t14Bu7kypXsX9uLOuy+HbH4KCNTgUhAliliKDYwQo+E+JJUgkLzYQJ3optZH8zdh0J/1lN+R0bvfVkJWHQN/cwAZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672995; c=relaxed/simple;
	bh=dH88Z3BHRKyCAbknAU5jU7GL2QZRuj8AFZZ4V//hHDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d5XOkaE2qfEQGzmp7o9tHoHTREwaM7olHNx/0/w1P4GDPCQu60MaWBPUwBhx8b3aWMRwbdkh8mCHlK3bfL7ZC7rtTnysHzcuCMVtAVvxoq9unF9bfaJ8ktfu0nOPDN+znxfkgG8q3W0sagkfEjfKmqCi5jVCsNitL7Pj7q91rJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ii1MsoGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ii1MsoGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFEAEC19421;
	Wed,  8 Apr 2026 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672995;
	bh=dH88Z3BHRKyCAbknAU5jU7GL2QZRuj8AFZZ4V//hHDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ii1MsoGfYBTvg7Q3wUp6EC1A0w85xTOlVsGGveZDRDR25LN7A7EYP+7tqWg8MltTU
	 ZRr2xl5X0vbq7DxA6dATmGcJzOc+mD07YHqDstB+Y03fU/rGBposCDqkWYaUp6r3G0
	 xmwjLXdLOhU0qHZNAZWur548n++8TOzXVWv3ikiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Amery Hung <ameryhung@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/277] bpf: Fix regsafe() for pointers to packet
Date: Wed,  8 Apr 2026 20:00:45 +0200
Message-ID: <20260408175936.100668925@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit a8502a79e832b861e99218cbd2d8f4312d62e225 ]

In case rold->reg->range == BEYOND_PKT_END && rcur->reg->range == N
regsafe() may return true which may lead to current state with
valid packet range not being explored. Fix the bug.

Fixes: 6d94e741a8ff ("bpf: Support for pointers beyond pkt_end.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Reviewed-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260331204228.26726-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 3eaff8453e9a9..ecdbc821bd1a4 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -18985,8 +18985,13 @@ static bool regsafe(struct bpf_verifier_env *env, struct bpf_reg_state *rold,
 		 * since someone could have accessed through (ptr - k), or
 		 * even done ptr -= k in a register, to get a safe access.
 		 */
-		if (rold->range > rcur->range)
+		if (rold->range < 0 || rcur->range < 0) {
+			/* special case for [BEYOND|AT]_PKT_END */
+			if (rold->range != rcur->range)
+				return false;
+		} else if (rold->range > rcur->range) {
 			return false;
+		}
 		/* If the offsets don't match, we can't trust our alignment;
 		 * nor can we be sure that we won't fall out of range.
 		 */
-- 
2.53.0



