Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831440;
	b=QC5un7y4c0cIuM3zNoETVwaUfs/Xwe0n7bPDHGxSR8O05QCQuenxKhRMo29JKFccBVyE
	 4QAN34s6k12e6wEewipDIn0/whDhdgsJIB6mnr1xSKdhza3Nuf1uhaNqUIJIVrVn4t/dn
	 34FDJn9JMYjaBgHVUNLeYemGdP8LGZcLPRjRhxT54E736dxr2WqMxmXQD2sivng/GJ2zF
	 vgZ80BfvB16SFN9xk8PYUE4IpM0+4/OBSB4U03vCM2PUyFSidNiQNABf1Q2XvAo1H9tXM
	 U2shl+ZefklzfQtizMQP064OC/HYZhhG9H6GIW9/X6bprqQ79bERFfsLEJCx1l+yZYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831440;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WmQzzqAx4vyXdhs1bNkgRj8DAnC360DUwqAdEvGg88s=;
	b=aYSYaPXK3KzMGRMaco69WE7A8dj1+6zCsMPDk0AeqfTFcIrSVPbLPiURsmK9ma0svB9I
	 VFaRx0Zi3PD7SAIH1mQieA24B8936I8fzkEZXM3kuKcvNkucVU6qICTOmcbhzhaZg7ccO
	 DJ7aaTgy1vLGMz7ZffgQuO+sx0Yamu64Pzyr/PtcPrDbuBSoAsQz5iQOZKP4M6Oep3kvz
	 qG/S29CXFSe7n2itQpFB1cGC0gJSW1StDnLFq8gJIWSi+UKh0WRNlLCeqrRLy65f9mKZ9
	 SKUVJt1RQeA/g46oXk+HO1Kvv+4n+yuuW8QA9iSaKK7PI/aIyjix7UcP/Cb65Ix9tpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=og3tm4O7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 000F3606AC00;
	Wed,  4 Nov 2026 22:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=og3tm4O7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F50C1F000C1;
	Wed,  4 Nov 2026 22:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831439;
	bh=WmQzzqAx4vyXdhs1bNkgRj8DAnC360DUwqAdEvGg88s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=og3tm4O7oYBDp3f0TqS0Y/66g7KzjnWZ4ZZI4T2djx9WmcRDUUgNPjK1cUL9l1ctI
	 a9rpYBXhQWc+kuLF1Q8cSPxEdIXKDKO+ML06g2AtK7GNfsWTqN+RNYlrPCIloSSh/W
	 o1YTfwdnO/DbzQimJFcM5rJFjC8unE8TKfYbvEdE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 6.18 0702/1005] rust: configfs: fix data offset calculation for subsystem callbacks
Date: Wed,  4 Nov 2026 16:07:15 -0500
Message-ID: <20261104211103.250519501@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Hindborg <a.hindborg@kernel.org>

commit e84c9b64df615e658e47561b835c1364dc48f0c0 upstream.

`get_group_data()` chooses between `Group::<Parent>::container_of()` and
`Subsystem::<Parent>::container_of()` based on whether `this` represents
the root group of a configfs subsystem. It detects this by checking
`(*this).cg_subsys.is_null()`, but `link_group()` in `fs/configfs/dir.c`
unconditionally sets `cg_subsys` for every `config_group` attached anywhere
in a registered subsystem, including the subsystem's own `su_group`. The
only `config_group` with a NULL `cg_subsys` is the configfs root, on which
userspace cannot trigger callbacks. The check is therefore always false at
runtime, and the `Subsystem` branch is dead. Subsystem-level callbacks
reach the `Group` branch and may read `data` at the wrong offset.

Thus change the `is_root` check to correctly identify whether a group is a
root group by comparing `this` to `subsys.su_group`.

Cc: stable@vger.kernel.org
Fixes: 446cafc295bf ("rust: configfs: introduce rust support for configfs")
Link: https://msgid.link/20260608-configfs-fix-offset-v1-1-7f01b8fb9e5f@kernel.org
[ Andreas: Fix clippy warning on 1.85.0 by moving safety comment. ]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/configfs.rs |   43 ++++++++++++++++++++++++++++---------------
 1 file changed, 28 insertions(+), 15 deletions(-)

--- a/rust/kernel/configfs.rs
+++ b/rust/kernel/configfs.rs
@@ -298,26 +298,39 @@ unsafe impl<Data> HasGroup<Data> for Gro
 ///
 /// `this` must be a valid pointer.
 ///
-/// If `this` does not represent the root group of a configfs subsystem,
-/// `this` must be a pointer to a `bindings::config_group` embedded in a
-/// `Group<Parent>`.
+/// If `this` is the `su_group` field of a `bindings::configfs_subsystem`, that
+/// `configfs_subsystem` must be embedded in a `Subsystem<Parent>`.
 ///
-/// Otherwise, `this` must be a pointer to a `bindings::config_group` that
-/// is embedded in a `bindings::configfs_subsystem` that is embedded in a
-/// `Subsystem<Parent>`.
+/// Otherwise, `this` must be a pointer to a `bindings::config_group` embedded
+/// in a `Group<Parent>`.
 unsafe fn get_group_data<'a, Parent>(this: *mut bindings::config_group) -> &'a Parent {
     // SAFETY: `this` is a valid pointer.
-    let is_root = unsafe { (*this).cg_subsys.is_null() };
+    let subsys = unsafe { (*this).cg_subsys };
 
-    if !is_root {
-        // SAFETY: By C API contact,`this` was returned from a call to
-        // `make_group`. The pointer is known to be embedded within a
-        // `Group<Parent>`.
-        unsafe { &(*Group::<Parent>::container_of(this)).data }
-    } else {
-        // SAFETY: By C API contract, `this` is a pointer to the
-        // `bindings::config_group` field within a `Subsystem<Parent>`.
+    // `link_group()` in `fs/configfs/dir.c` assigns `cg_subsys` for every
+    // `config_group` attached anywhere in a registered subsystem, including
+    // the subsystem's own `su_group` (which gets a pointer to itself). The
+    // only `config_group` with a NULL `cg_subsys` is the configfs root, and
+    // userspace cannot trigger callbacks on it. The group is therefore the
+    // subsystem's `su_group` iff it equals `&cg_subsys->su_group`.
+    let is_root = !subsys.is_null()
+        && core::ptr::eq(
+            this.cast_const(),
+            // SAFETY: For every `config_group` the configfs core dispatches a
+            // callback on, `cg_subsys` was set by `link_group()` at registration time
+            // and points to a valid `configfs_subsystem` that outlives the callback.
+            unsafe { &raw const (*subsys).su_group },
+        );
+
+    if is_root {
+        // SAFETY: By the above, `this` is the `su_group` field of a
+        // `configfs_subsystem` that, by function safety requirements, is
+        // embedded in a `Subsystem<Parent>`.
         unsafe { &(*Subsystem::container_of(this)).data }
+    } else {
+        // SAFETY: By function safety requirements, `this` is a
+        // `config_group` embedded in a `Group<Parent>`.
+        unsafe { &(*Group::<Parent>::container_of(this)).data }
     }
 }
 


