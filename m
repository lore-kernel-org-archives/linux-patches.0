Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A67346E55;
	Wed, 20 May 2026 18:45:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302734; cv=none; b=BfSM0h9CvBrMMrzyxXBSjBTKrON+luDZG+vUqVF6AJ63TwINU4UMQeUYZKriWvE21TY92lsJLz8++O7I4ROGCI8Ee0jyqsaKx5SnEYpxkU3p85YnpblHaxPA7IPYx2rQZTBNVzFtMKnimlNyLURWzz+DTOMzWaqLfm5S+sGk9gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302734; c=relaxed/simple;
	bh=C0nqaA80972wgFO0a7OuJWDmdE49fS0yhHDqp5/6rDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azf4+fWU5YxeK+pDLtuXMaiEiL2wC8Zu4Hg2frihZdVvAhpwpvPEJS4brdrmpTZ7nxTXZK7oQYGPZ4pBvuoe14TJfG55IqJaTnavbQhnt+BO8Lm4AXJJs9C2QhbIWX77T0ZtuLsw3VSSAdd9EotOorwSZgVI8yXHRQH/7+ey3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kziEqQof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kziEqQof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6C41F000E9;
	Wed, 20 May 2026 18:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302732;
	bh=nZtGCb3mcxmxaAMOnN0FJc6tfzu3ajHkuMq5Sym6RRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kziEqQofnQJRX2r0tWP4UdTbkv09pokGCBNFJSgVdFOat1WBdiZOvmoEJN7NBfK7i
	 VNkCxs21DtP3n1LcLERKV882Dz7NgUQOqp1L4tRRvmyVkq6rgrkozCJIeGHHIIFGD8
	 gDTlQYnsmcEXfCm+bcnHW1uvCLHKvT3CxN/Nts30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Guan <guanwentao@uniontech.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/508] arm64/scs: Fix potential sign extension issue of advance_loc4
Date: Wed, 20 May 2026 18:23:21 +0200
Message-ID: <20260520162106.812959250@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 4023b7424ecd5d38cc75b650d6c1bf630ef8cb40 ]

The expression (*opcode++ << 24) and exp * code_alignment_factor
may overflow signed int and becomes negative.

Fix this by casting each byte to u64 before shifting. Also fix
the misaligned break statement while we are here.

Example of the result can be seen here:
Link: https://godbolt.org/z/zhY8d3595

It maybe not a real problem, but could be a issue in future.

Fixes: d499e9627d70 ("arm64/scs: Fix handling of advance_loc4")
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/patch-scs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/patch-scs.c b/arch/arm64/kernel/patch-scs.c
index 6d656179ea03b..d6e8ad142f75c 100644
--- a/arch/arm64/kernel/patch-scs.c
+++ b/arch/arm64/kernel/patch-scs.c
@@ -175,9 +175,9 @@ static int noinstr scs_handle_fde_frame(const struct eh_frame *frame,
 			loc += *opcode++ * code_alignment_factor;
 			loc += (*opcode++ << 8) * code_alignment_factor;
 			loc += (*opcode++ << 16) * code_alignment_factor;
-			loc += (*opcode++ << 24) * code_alignment_factor;
+			loc += ((u64)*opcode++ << 24) * code_alignment_factor;
 			size -= 4;
-		break;
+			break;
 
 		case DW_CFA_def_cfa:
 		case DW_CFA_offset_extended:
-- 
2.53.0



