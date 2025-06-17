Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333862EA158;
	Tue, 17 Jun 2025 16:42:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178575; cv=none; b=DXSoib3jcYl2gVTiHZO2e+bbWmnZjdoIEIdsTzayKOVtk3Nfx8PV7NnSWPqJfincUUjYTFa9hcEKKWY8G0IQHVh2IGrV02URQGz1GAV5rONyDYBmw3s+YzJCAr5CEfAHXU3Q1XvPhlBoHSqlM66OttCHJ5I2Ns7JUQvp1AoGupc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178575; c=relaxed/simple;
	bh=tJuK8/DtIwju2VEyRNAqFfVFKZZF0QnYTl9ZqGLn1n4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CaH7UYkmMZxFswvlNrpJF/o1h58xzcAgEhb5fEDlNJ+EHa2+E0QXjssZ65jW7kUjKPW0dxAC5Y+NMxIPNXx4gDsy8tKtopO9QoleuWn9ok54rA3FFBSk/oN5zCcgcdnCSrjWpl5mkHo+qfVlTIkBBCAW9HtcPO17EILmfuNXW2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FtkToE6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FtkToE6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AB0C4CEE3;
	Tue, 17 Jun 2025 16:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178575;
	bh=tJuK8/DtIwju2VEyRNAqFfVFKZZF0QnYTl9ZqGLn1n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FtkToE6VHWzeKhobDCm3ir6rPdQo3MEOSXQo5CyVq1xsFWS0W4KI8XqbfwwqHeooy
	 Kry5OOtAZ3OplTQl7Jn+WF3VH/wr3AplyI/a7axNS7rVskvn5SHHHfManTbvSYhG5T
	 /KVyDhjb8JoNJY3fxUhZX/NTwgg0iiDE2MfRyKs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 489/780] rust: alloc: add missing invariant in Vec::set_len()
Date: Tue, 17 Jun 2025 17:23:17 +0200
Message-ID: <20250617152511.401624499@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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



