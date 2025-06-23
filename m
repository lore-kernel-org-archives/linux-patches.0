Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 726DA222590;
	Mon, 23 Jun 2025 22:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716328; cv=none; b=hvZXf1fjYsCVnkSZ7SpUahIz9S4AFpiROVk0JpDfTSbrjfsWPvC7NuTvNiUO0zQqWYv6B3bPaiuQMT/QwAzinpXE7GcTHmBBrEcvIFo3Oun82+EkgJBnU1YndbWQ/lDBrS0OA7ZKVh+r/67NvsfAkEvCc1tT+8f0mSF8YYXHkuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716328; c=relaxed/simple;
	bh=kleeZwu5N572GPYu6SKm21BQQU9VATMkDs4XVpfhC1U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfqoMy54Z2597E8G891kyJgiTjnspWxs4VZMFXMCVsT7jthPZHYs94QU7zZQ4GLkMKnhQZpDwsCGkKa46+o94YJRh12EVAwhg1GEK6Rjejnkd9HGk+QHlRE3ZulPGYN0XACxXKydX6oWLZmgYpMR8IIUdykvCiT7NE4BhayMWUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MRLHIZxs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MRLHIZxs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC5EC4CEEA;
	Mon, 23 Jun 2025 22:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716328;
	bh=kleeZwu5N572GPYu6SKm21BQQU9VATMkDs4XVpfhC1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MRLHIZxseN/Zrvd8iUNscG13B57ZR+l/ZtIGXQr+lD66IKiXwx8WQ/7+Lw7ey6C4W
	 ie1l1P5xZKZvwlm4ScY0bObPJrITOu5Z63ekz+iBiEcc4eQDpIi4jqfofR0eT+0Uim
	 lP+OVyQ+B92eTEN5YEObT42j1afWwxuRLJ5sh+IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Alexandre Courbot <acourbot@nvidia.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 516/592] rust: devres: implement Devres::access()
Date: Mon, 23 Jun 2025 15:07:54 +0200
Message-ID: <20250623130712.710172536@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

[ Upstream commit f301cb978c068faa8fcd630be2cb317a2d0ec063 ]

Implement a direct accessor for the data stored within the Devres for
cases where we can prove that we own a reference to a Device<Bound>
(i.e. a bound device) of the same device that was used to create the
corresponding Devres container.

Usually, when accessing the data stored within a Devres container, it is
not clear whether the data has been revoked already due to the device
being unbound and, hence, we have to try whether the access is possible
and subsequently keep holding the RCU read lock for the duration of the
access.

However, when we can prove that we hold a reference to Device<Bound>
matching the device the Devres container has been created with, we can
guarantee that the device is not unbound for the duration of the
lifetime of the Device<Bound> reference and, hence, it is not possible
for the data within the Devres container to be revoked.

Therefore, in this case, we can bypass the atomic check and the RCU read
lock, which is a great optimization and simplification for drivers.

Reviewed-by: Christian Schrefl <chrisi.schrefl@gmail.com>
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Joel Fernandes <joelagnelf@nvidia.com>
Link: https://lore.kernel.org/r/20250428140137.468709-3-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Stable-dep-of: 20c96ed278e3 ("rust: devres: do not dereference to the internal Revocable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/devres.rs | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index f3a4e3383b8d2..acb8e1d13ddd9 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -196,6 +196,44 @@ pub fn new_foreign_owned(dev: &Device, data: T, flags: Flags) -> Result {
 
         Ok(())
     }
+
+    /// Obtain `&'a T`, bypassing the [`Revocable`].
+    ///
+    /// This method allows to directly obtain a `&'a T`, bypassing the [`Revocable`], by presenting
+    /// a `&'a Device<Bound>` of the same [`Device`] this [`Devres`] instance has been created with.
+    ///
+    /// # Errors
+    ///
+    /// An error is returned if `dev` does not match the same [`Device`] this [`Devres`] instance
+    /// has been created with.
+    ///
+    /// # Example
+    ///
+    /// ```no_run
+    /// # use kernel::{device::Core, devres::Devres, pci};
+    ///
+    /// fn from_core(dev: &pci::Device<Core>, devres: Devres<pci::Bar<0x4>>) -> Result {
+    ///     let bar = devres.access(dev.as_ref())?;
+    ///
+    ///     let _ = bar.read32(0x0);
+    ///
+    ///     // might_sleep()
+    ///
+    ///     bar.write32(0x42, 0x0);
+    ///
+    ///     Ok(())
+    /// }
+    /// ```
+    pub fn access<'a>(&'a self, dev: &'a Device<Bound>) -> Result<&'a T> {
+        if self.0.dev.as_raw() != dev.as_raw() {
+            return Err(EINVAL);
+        }
+
+        // SAFETY: `dev` being the same device as the device this `Devres` has been created for
+        // proves that `self.0.data` hasn't been revoked and is guaranteed to not be revoked as
+        // long as `dev` lives; `dev` lives at least as long as `self`.
+        Ok(unsafe { self.deref().access() })
+    }
 }
 
 impl<T> Deref for Devres<T> {
-- 
2.39.5



