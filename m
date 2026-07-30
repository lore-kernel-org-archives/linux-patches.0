Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB3F35C180;
	Thu, 30 Jul 2026 14:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422809; cv=none; b=ES82xqgg0Rz8zTvMdM/vDx6SSXftJ+nOcn08pljOuWttb1mTZxk/VkgXjZxr5rqUkeu1kfuyKh8rjwlW5XOxy6xZmSPqOdJmUS8l3ki4v93Zb2s4C2nPG34+jpl7A/f32JCPeCDFfp0haLmOPw2R7w85ieLROG+9/nPAx+8J4H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422809; c=relaxed/simple;
	bh=cQI6MULA/eSdx+PrVGPkUqHdfgKzBVw20aE6hWuut1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KY8gD8A2JSbZb75kYP+G3r6aER1OFcTSpW36u6pe/Y90esFHY7KxHxnMFITOQlvWQAAqtEpfLE/lwozmKNS9gXw8sziW5qBs82YXycCOzUlSSF1fZb1hhmgTFhvbKIDmCydFwvFowEh99RPtNoEKgaZTzocFXHixTSpY5TEITII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PF/inEdT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PF/inEdT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D4E1F000E9;
	Thu, 30 Jul 2026 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422807;
	bh=QudUQRQ5Gn5v3mWNKui5A72PUcGkijpPTyl8oFjxgKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PF/inEdTHGl8UFYqBbqwig26huecAO3FbkIZOAtQKHq4AHr2UrAIcZK9x6opnFJic
	 zZbaJhfNanv0gI4zRuewRNfnPCmLItNhHnIlnBstWu6OIlXpEmsb3MjVWl82Vs1GYm
	 siJGeb6pKGnXXXhUoQOqBCIm6Fg3YcgZhi/oSAGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.1 564/744] rust: time: fix as_micros_ceil() to round correctly for negative Delta
Date: Thu, 30 Jul 2026 16:13:57 +0200
Message-ID: <20260730141456.273177799@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

commit 880c43b185ca52239e75bc546cc4f4d9154d0fed upstream.

The ceiling-division idiom `(n + d - 1) / d` only produces the
correct result when `n` is non-negative.

For example, if n = -1000 (exactly -1us), the old code computed (-1000
+ 999) / 1000 == 0 instead of -1.

For negative n, truncating division already rounds towards positive
infinity, so no bias is needed in that case.

Fixes: fae0cdc12340 ("rust: time: Introduce Delta type")
Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Acked-by: Andreas Hindborg <a.hindborg@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260713225235.3243480-1-tomo@flapping.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/time.rs |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/rust/kernel/time.rs
+++ b/rust/kernel/time.rs
@@ -441,15 +441,22 @@ impl Delta {
     /// to the value in the [`Delta`].
     #[inline]
     pub fn as_micros_ceil(self) -> i64 {
+        let n = self.as_nanos();
+        let n = if n >= 0 {
+            n.saturating_add(NSEC_PER_USEC - 1)
+        } else {
+            n
+        };
+
         #[cfg(CONFIG_64BIT)]
         {
-            self.as_nanos().saturating_add(NSEC_PER_USEC - 1) / NSEC_PER_USEC
+            n / NSEC_PER_USEC
         }
 
         #[cfg(not(CONFIG_64BIT))]
         // SAFETY: It is always safe to call `ktime_to_us()` with any value.
         unsafe {
-            bindings::ktime_to_us(self.as_nanos().saturating_add(NSEC_PER_USEC - 1))
+            bindings::ktime_to_us(n)
         }
     }
 


