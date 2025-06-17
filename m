Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 954D4235071;
	Tue, 17 Jun 2025 16:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177192; cv=none; b=AtcMEkFMufQj9iDKxBIrY3JAzfE9HvLGWCXG61LP+km2J4sEt1NqVoZdzB7PH9FqmsuIpiyx8sDhMn6Fzi3MYHMaEixEVKLWdDfe9m1pni4acUAScI5eVb6F2FFLeqIwM4ImC9mKSGQc9/yn3SJmmkaHyMpJ7S/3d5HLfPdscsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177192; c=relaxed/simple;
	bh=HdznCL5Y7x7UUAYnyd8zKlqBEku6BCYym9wz0MU6tgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYRAnkjiA18fo5EDiPmbGwOzpePpXKCGdgslA+TDTunR5LVtxLSb8altjQKPS/m4aWP1zJeQEXePWxf559+0qEBkueTRhZ0NtxxJ7pvOLxk3UsoZ7JF/RsH+jJmg40rrKnZZlrSB2gGFvgRCBEapZ36NOl1DU9UBRXyjQIHYeDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y0jkMlng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y0jkMlng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DECC4CEE3;
	Tue, 17 Jun 2025 16:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177192;
	bh=HdznCL5Y7x7UUAYnyd8zKlqBEku6BCYym9wz0MU6tgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y0jkMlngU/sMXC6tOmzRhJsdHC8zp5f/oG7RGqCG+gm5c/2FJ/DezbE59FlieHUcL
	 7X4NMc9Ua3r3bu7eXFLFNSZYJPs/K1whWL/A9Cr6567UpiRSNjo99AiJn3aBBVtxMY
	 ApN921XbM2tgCJAnptMmVkCUbf+f7X3xS6TYFmWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 305/512] rust: alloc: add missing invariant in Vec::set_len()
Date: Tue, 17 Jun 2025 17:24:31 +0200
Message-ID: <20250617152431.965868558@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit fb1bf1067de979c89ae33589e0466d6ce0dde204 ]

When setting a new length, we have to justify that the set length
represents the exact number of elements stored in the vector.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reported-by: Alice Ryhl <aliceryhl@google.com>
Closes: https://lore.kernel.org/rust-for-linux/20250311-iov-iter-v1-4-f6c9134ea824@google.com
Fixes: 2aac4cd7dae3 ("rust: alloc: implement kernel `Vec` type")
Link: https://lore.kernel.org/r/20250315154436.65065-2-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/alloc/kvec.rs | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/rust/kernel/alloc/kvec.rs b/rust/kernel/alloc/kvec.rs
index 87a71fd40c3ca..f62204fe563f5 100644
--- a/rust/kernel/alloc/kvec.rs
+++ b/rust/kernel/alloc/kvec.rs
@@ -196,6 +196,9 @@ where
     #[inline]
     pub unsafe fn set_len(&mut self, new_len: usize) {
         debug_assert!(new_len <= self.capacity());
+
+        // INVARIANT: By the safety requirements of this method `new_len` represents the exact
+        // number of elements stored within `self`.
         self.len = new_len;
     }
 
-- 
2.39.5



