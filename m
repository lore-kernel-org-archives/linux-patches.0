Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186A63EDE45;
	Tue, 12 May 2026 18:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609239; cv=none; b=O+dZqyKvKgyDW8ODu7e4aBF3r0oyMu2m82ZH2Ru+FHlfxr1sbtIkGtFEvM+w7xZtDCJrj2il3iGI6Y13BJWlXA7/pSfr3O6p+tD+kEkiFsgQ2xhXx2wKcbjqnOEkUTEHVl9V1O+3dXSqHaYfZReAYz+2ZKYfiTP+8/euolQ42SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609239; c=relaxed/simple;
	bh=qDNiAptU+XeqrRK/sYWisypSgmf9L4MlHwM7B6UtiY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o0d0DhvEet9LZM0h6D8ux6EVFH5U9VMZZhMamKEGirbKYkikePVd8lBngYtUjvUZSnser7Mw3becAROoRTL66vb8lmidk4vQpR2EaqtwMh/oXQPT6E8EMVImZ5vHqZ5Q5vOkGKtVo/KUsU78nzCk6iKQqV4jTugk26wlFXIk2lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiKrywZq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiKrywZq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F07CC2BCB0;
	Tue, 12 May 2026 18:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609238;
	bh=qDNiAptU+XeqrRK/sYWisypSgmf9L4MlHwM7B6UtiY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TiKrywZqMfFfIkZ5akyR2EnTLXYEy+jMGmrnG3vBVte+AzjoZuV4S9BI5UdLZ5o0E
	 VZNA2vkNUf8TentEHPq0SE2cS8gpG78v192tsRk3aUBHXQVO8Gf7lxXn8xi+grj6AB
	 NhWZA2ZjYSBQavM+dAcZodKndCfGBwicQ7/BK4lo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eliot Courtney <ecourtney@nvidia.com>,
	Alice Ryhl <aliceryhl@google.com>,
	=?UTF-8?q?Onur=20=C3=96zkan?= <work@onurozkan.dev>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 7.0 077/307] rust: drm: gem: clean up GEM state in init failure case
Date: Tue, 12 May 2026 19:37:52 +0200
Message-ID: <20260512173941.746077564@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -207,8 +207,17 @@ impl<T: DriverObject> Object<T> {
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
 
         // SAFETY: We will never move out of `Self` as `ARef<Self>` is always treated as pinned.
         let ptr = KBox::into_raw(unsafe { Pin::into_inner_unchecked(obj) });


