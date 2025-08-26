Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F403234A304;
	Tue, 26 Aug 2025 11:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207889; cv=none; b=h0OqmDgoA82+0/6nF2JWMbmjQ3/RGp99r3fxwFnfFY7mz8ygoGxmlcTqsc0Kayvcuv/pHXAIdKvTTIwcQRVNyy18LkRiX2A3Dom7jn+GjoLeEihiduoFXQE99ZgkTg3wIBORfBh1zlmZdUav+nYjSj9XykIBFIIjN32WGcmeGQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207889; c=relaxed/simple;
	bh=EXWZd/cZOLGCx0aDA8sFaXnosopQDgzTPrsDy2empKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqEwl3djBOud4ihZighKr/p7kBq4z+ztxq786y4kifzOgVpuFWZj7tkR5OHojV+B5Hup1s5bgZF4NUxuiNCzdysSPltluxjKOLT18NiL5pN/zy8iGBIz4z2EqAuLCHOoPoGgEGMM+moWlv04a0+jlMc3pvWiCkrO5hb2mgYPjIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qm2/3hmp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qm2/3hmp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369ABC4CEF1;
	Tue, 26 Aug 2025 11:31:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207887;
	bh=EXWZd/cZOLGCx0aDA8sFaXnosopQDgzTPrsDy2empKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qm2/3hmpyo4rFpH+0KBfqmZ376eBp58n/eKvdgN0pUc2RlLWK4MwpiyYN5StDPnBi
	 ANSPn8r4v/qCIu6yXY6Eke2hfkD2FCQsGJekYxRZN7U37LUP1kpJtc4MgKBDI98knT
	 oy8hHX1KkQCf/RArL0UQqVwq17z2L67/Z7APkjm4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Lalaev <andrey.lalaev@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 356/457] drm/panic: Add a u64 divide by 10 for arm32
Date: Tue, 26 Aug 2025 13:10:40 +0200
Message-ID: <20250826110946.115434093@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jocelyn Falempe <jfalempe@redhat.com>

[ Upstream commit 9af8f2b469c0438620832f3729a3c5c03853b56b ]

On 32bits ARM, u64 divided by a constant is not optimized to a
multiply by inverse by the compiler [1].
So do the multiply by inverse explicitly for this architecture.

Link: https://github.com/llvm/llvm-project/issues/37280 [1]
Reported-by: Andrei Lalaev <andrey.lalaev@gmail.com>
Closes: https://lore.kernel.org/dri-devel/c0a2771c-f3f5-4d4c-aa82-d673b3c5cb46@gmail.com/
Fixes: 675008f196ca ("drm/panic: Use a decimal fifo to avoid u64 by u64 divide")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Jocelyn Falempe <jfalempe@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panic_qr.rs | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index 18492daae4b3..b9cc64458437 100644
--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -381,6 +381,26 @@ struct DecFifo {
     len: usize,
 }
 
+// On arm32 architecture, dividing an `u64` by a constant will generate a call
+// to `__aeabi_uldivmod` which is not present in the kernel.
+// So use the multiply by inverse method for this architecture.
+fn div10(val: u64) -> u64 {
+    if cfg!(target_arch = "arm") {
+        let val_h = val >> 32;
+        let val_l = val & 0xFFFFFFFF;
+        let b_h: u64 = 0x66666666;
+        let b_l: u64 = 0x66666667;
+
+        let tmp1 = val_h * b_l + ((val_l * b_l) >> 32);
+        let tmp2 = val_l * b_h + (tmp1 & 0xffffffff);
+        let tmp3 = val_h * b_h + (tmp1 >> 32) + (tmp2 >> 32);
+
+        tmp3 >> 2
+    } else {
+        val / 10
+    }
+}
+
 impl DecFifo {
     fn push(&mut self, data: u64, len: usize) {
         let mut chunk = data;
@@ -389,7 +409,7 @@ impl DecFifo {
         }
         for i in 0..len {
             self.decimals[i] = (chunk % 10) as u8;
-            chunk /= 10;
+            chunk = div10(chunk);
         }
         self.len += len;
     }
-- 
2.50.1



