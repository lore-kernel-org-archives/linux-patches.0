Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39983BB105;
	Tue, 12 May 2026 17:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608433; cv=none; b=YpaEGm2Ksu2JhvB3bzBiwZEgYQoLyMw/euwICNPB6wyUBkhi0+Ii6kEasQO0Mk6U1P2dT0cp5pk9/QwYBog/k7/e7fDPmYihOryMB99q0LRHPGsmFC2g01QCt+i8NrDVkMpkG4MNvqlkFpjMdt6uSgElCb26FbdEeVD7VWdgxU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608433; c=relaxed/simple;
	bh=6lqAy84wzZ0E/MsZHfr7ksP6eo5fBmkUnSZcdbN82LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MU/ablejfh6zjQnRRjoou+VK6ilCKROA4kzeK+xibw5oY54SJo/KZ1lIK4Ll52T3mTRp9pp5wR9yUhsfnoVAjW4/2X7+PptuILKc3CI4Rh8waH70Ai8asS2ztSoBZTtlCUdKfI/kpelVyJzjpBWDRfIlqQ/jopd+fGH7bjsqPDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5UDVWGx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5UDVWGx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 540CBC2BCC7;
	Tue, 12 May 2026 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608432;
	bh=6lqAy84wzZ0E/MsZHfr7ksP6eo5fBmkUnSZcdbN82LI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A5UDVWGxRLojCaTkCsS2Jsaop6cFphpPkZHF5SWFNslkWsBF1wGgOZ5MYjv+G2oTW
	 6SIvh6wHUq9yKlslDDfLSCesGtL0tPZ8KEvKmfiPESSlHRMf9qB6CTNwvA43OTnL6s
	 wqJlwY5xjIYETq7+jNxhzyGauSrlgDfAiCUDmdEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 075/270] rust: drm: gem: clean up GEM state in init failure case
Date: Tue, 12 May 2026 19:37:56 +0200
Message-ID: <20260512173940.031429342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliot Courtney <ecourtney@nvidia.com>

commit 2e42a17b8f6bc3c0cd69d7556b588011d3ec2394 upstream.

Currently, if `drm_gem_object_init` fails, the object is freed without
any cleanup. Perform the cleanup in that case.

Cc: stable@vger.kernel.org
Fixes: c284d3e42338 ("rust: drm: gem: Add GEM object abstraction")
Signed-off-by: Eliot Courtney <ecourtney@nvidia.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Onur Özkan <work@onurozkan.dev>
Link: https://patch.msgid.link/20260423-fix-gem-1-v1-1-e12e35f7bba9@nvidia.com
[ Move safety comment closer to unsafe block to avoid a clippy warning.
  - Danilo ]
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/drm/gem/mod.rs |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/rust/kernel/drm/gem/mod.rs
+++ b/rust/kernel/drm/gem/mod.rs
@@ -232,8 +232,17 @@ impl<T: DriverObject> Object<T> {
         // SAFETY: `obj.as_raw()` is guaranteed to be valid by the initialization above.
         unsafe { (*obj.as_raw()).funcs = &Self::OBJECT_FUNCS };
 
-        // SAFETY: The arguments are all valid per the type invariants.
-        to_result(unsafe { bindings::drm_gem_object_init(dev.as_raw(), obj.obj.get(), size) })?;
+        if let Err(err) =
+            // SAFETY: The arguments are all valid per the type invariants.
+            to_result(unsafe {
+                bindings::drm_gem_object_init(dev.as_raw(), obj.obj.get(), size)
+            })
+        {
+            // SAFETY: `drm_gem_object_init()` initializes the private GEM object state before
+            // failing, so `drm_gem_private_object_fini()` is the matching cleanup.
+            unsafe { bindings::drm_gem_private_object_fini(obj.obj.get()) };
+            return Err(err);
+        }
 
         // SAFETY: We never move out of `Self`.
         let ptr = KBox::into_raw(unsafe { Pin::into_inner_unchecked(obj) });


