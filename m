Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E8EB18DB1F;
	Thu, 30 Jul 2026 15:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424653; cv=none; b=rhIie4it3ex4t1Ib+sKudIr95+wNnPVRx9JvUAzchuSldXGuiaQTESMJF+6U4EazVXo+iHeQqtRzcxaDMRF7HRgOYO0bbDm+ZwnM5yKa1UZZMHmvjBAkfVgc9+agTUM/cilolLI/IoD4+Ujvsn2erIt5jBRGUcXrJ0l9EqBP/xk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424653; c=relaxed/simple;
	bh=B3w48TU082dQEpwYNkuIY1LcnY0wUDQopQf0ONy5Eeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WF6m2bkZDGZKz2a6FUsw8tiyDADW02SKENLdsNfbYH6hgzmK6jWl2pVx30VsYwXvMNhbfFpLZb1VEdBIeNz+XdsvLykv12T870kDw/kpqqKh88BGEO0dZ9xZacF1ZJcbZi/5rsjeNuRVdoSiEzxJZK6Vc8yQxkKyUMiT7ZDlVZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgFx9icd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgFx9icd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F041F000E9;
	Thu, 30 Jul 2026 15:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424652;
	bh=T585mgbr4IUpsfsYSCSC/tBXazb71VG2LTqkOOTI7tQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zgFx9icdwggRfSlKz4tLiuH36LW4Ap8AqhxuRUbQe0oKv1qe2z6I5PgM/AAafOWQV
	 vDXMbggq3iDYnWFP5+nMY8V5Qv0ptu+nhifkyBo6UR7TDTU6kYbnOdxfskm3keVQNo
	 NNYF9dM2Zr2MGwBuCY3bodM1AOmfAxbSiA3moGPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 470/675] rust: time: fix as_micros_ceil() to round correctly for negative Delta
Date: Thu, 30 Jul 2026 16:13:20 +0200
Message-ID: <20260730141455.118199621@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -421,15 +421,22 @@ impl Delta {
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
 


