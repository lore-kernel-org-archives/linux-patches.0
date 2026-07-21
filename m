Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7B130F80C;
	Tue, 21 Jul 2026 17:42:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655779; cv=none; b=PoGYDBI4X9xU5NnqIQPzCBwi395fRxHPK+CwE9ahw7w8BKbTSIcfdbzOhQXb52Q0CN15+A2sGRf3VTVFQxdyiullgj8GNavGEVAHqFSZfylyIQCIo380WFBNymbErLbDaXMOeBYUN81JffXK1GxvLbjlRcxItCMWonj0VxE+IdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655779; c=relaxed/simple;
	bh=ix4+LyJRNBKrr4AdgdE88FxCbTsdHOk5hfwZjkhxAMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DozUZDZ1cxMG9yZhQPPeUQRcwtpkyaSCyjWvkwdYvJDnXki/ZYU1mokPrBmdOBocDz16yUnorXCJ9X7nrbNESyhjFwG+N5lNpYRTcZ3+3Bjkz0vExNVjEOZkwcaC+2VF39wJRq+lSsqA2xpEdcNMl862doLLkE+ZoLWI/i0COYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yhsicgiB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yhsicgiB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB681F000E9;
	Tue, 21 Jul 2026 17:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655778;
	bh=d1SuF/5uSexPmNCTEowL+1eqgZf8vkpbEW9zgKi7Yq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yhsicgiB9/LWUYsI7aIZqdckjn+0Kix2nyarNJnzvF+sJDMsBOt7Q3UjMlCVB0IIb
	 uKmmX5Cn8JVszoRduKfXei2oE9Z46H+L3CuQxvg66H+gl2UiDpPJPTAQlcMMcVn32I
	 Kwy8atGB2cX0zDAgYp2Ld2WovBuxkPG4Nq6cy/uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hsiu Che Yu <yu.whisper.personal@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0136/1611] rust: alloc: fix `Vec::extend_with` SAFETY comment
Date: Tue, 21 Jul 2026 17:04:12 +0200
Message-ID: <20260721152517.933584649@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Hsiu Che Yu <yu.whisper.personal@gmail.com>

[ Upstream commit f497aae6ded43f91b1dbf29a35d7062823635640 ]

Fix an incorrect operator in the SAFETY comment, changing `<` to `<=`,
since `Vec::reserve` guarantees capacity for exactly n additional elements,
so the equal case should be included.

Signed-off-by: Hsiu Che Yu <yu.whisper.personal@gmail.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Fixes: 2aac4cd7dae3d ("rust: alloc: implement kernel `Vec` type")
Link: https://patch.msgid.link/18fc8eee2f057a6bfbcadae156d1d0b7c40d0077.1777111268.git.yu.whisper.personal@gmail.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/kvec.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index ac8d6f763ae81d..b6a97b8fb51211 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -754,7 +754,7 @@ impl<T: Clone, A: Allocator> Vec<T, A> {
         spare[n - 1].write(value);
 
         // SAFETY:
-        // - `self.len() + n < self.capacity()` due to the call to reserve above,
+        // - `self.len() + n <= self.capacity()` due to the call to reserve above,
         // - the loop and the line above initialized the next `n` elements.
         unsafe { self.inc_len(n) };
 
-- 
2.53.0



