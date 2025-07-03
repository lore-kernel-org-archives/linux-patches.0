Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0472D6622;
	Thu,  3 Jul 2025 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555390; cv=none; b=VtTX8mdTZ2Blpgp9lCHKOTcKbq3R/8rdFOz/gpHdnUiMszu5ZZwD5l8VoDHcxjqCB1y70KJigsg9OqFQfH5YEyIXbLT0jjEMZt8vggw2G7ou/qkNQ4SgcULgJZgSUq1j4tR5v5sEwMdl84Pyq+XdSXivgEo6pLGyLMGNWh0/6B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555390; c=relaxed/simple;
	bh=Qi6edpjNhie9eEFmtV2GlAj8yBsYfr1roMZkE3gJCJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbckIyubK4qrEC5YiHsL4JpPi7YLS/uv9sevebsExDKfY8C0BvSZxq+FWz3GSbYGCE/DOi+9RQgvkdoneBZ5xIeOCiIyVMMXibvCaHhj+d4wrDPM4SP5IejDZJqL8U+L1qKmrI41tOMugnbHOt1ZWutUj87+9ZmLLo0plURAFOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vkL7Gl3e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vkL7Gl3e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C8C3C4CEE3;
	Thu,  3 Jul 2025 15:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555390;
	bh=Qi6edpjNhie9eEFmtV2GlAj8yBsYfr1roMZkE3gJCJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vkL7Gl3eERRo4rXOwpZ/asecgn6yWk3ujaDnBhGzTZ6SGwTlnfmAaPyu2bZZZXKuf
	 iJIHjH8vS24u74g2Nc1bGmRyspYWfo2bPJPHws7xj8TINWQ8Hn8qQBMLI225WZXyKe
	 GSidFuG2IQCa9xspl00QHew5LDxM6JZL1O6gEo3U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.15 255/263] rust: revocable: indicate whether `data` has been revoked already
Date: Thu,  3 Jul 2025 16:42:55 +0200
Message-ID: <20250703144014.634269087@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

commit 4b76fafb20dd4a2becb94949d78e86bc88006509 upstream.

Return a boolean from Revocable::revoke() and Revocable::revoke_nosync()
to indicate whether the data has been revoked already.

Return true if the data hasn't been revoked yet (i.e. this call revoked
the data), false otherwise.

This is required by Devres in order to synchronize the completion of the
revoke process.

Reviewed-by: Benno Lossin <lossin@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20250612121817.1621-3-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/revocable.rs |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/rust/kernel/revocable.rs
+++ b/rust/kernel/revocable.rs
@@ -126,8 +126,10 @@ impl<T> Revocable<T> {
     /// # Safety
     ///
     /// Callers must ensure that there are no more concurrent users of the revocable object.
-    unsafe fn revoke_internal<const SYNC: bool>(&self) {
-        if self.is_available.swap(false, Ordering::Relaxed) {
+    unsafe fn revoke_internal<const SYNC: bool>(&self) -> bool {
+        let revoke = self.is_available.swap(false, Ordering::Relaxed);
+
+        if revoke {
             if SYNC {
                 // SAFETY: Just an FFI call, there are no further requirements.
                 unsafe { bindings::synchronize_rcu() };
@@ -137,6 +139,8 @@ impl<T> Revocable<T> {
             // `compare_exchange` above that takes `is_available` from `true` to `false`.
             unsafe { drop_in_place(self.data.get()) };
         }
+
+        revoke
     }
 
     /// Revokes access to and drops the wrapped object.
@@ -144,10 +148,13 @@ impl<T> Revocable<T> {
     /// Access to the object is revoked immediately to new callers of [`Revocable::try_access`],
     /// expecting that there are no concurrent users of the object.
     ///
+    /// Returns `true` if `&self` has been revoked with this call, `false` if it was revoked
+    /// already.
+    ///
     /// # Safety
     ///
     /// Callers must ensure that there are no more concurrent users of the revocable object.
-    pub unsafe fn revoke_nosync(&self) {
+    pub unsafe fn revoke_nosync(&self) -> bool {
         // SAFETY: By the safety requirement of this function, the caller ensures that nobody is
         // accessing the data anymore and hence we don't have to wait for the grace period to
         // finish.
@@ -161,7 +168,10 @@ impl<T> Revocable<T> {
     /// If there are concurrent users of the object (i.e., ones that called
     /// [`Revocable::try_access`] beforehand and still haven't dropped the returned guard), this
     /// function waits for the concurrent access to complete before dropping the wrapped object.
-    pub fn revoke(&self) {
+    ///
+    /// Returns `true` if `&self` has been revoked with this call, `false` if it was revoked
+    /// already.
+    pub fn revoke(&self) -> bool {
         // SAFETY: By passing `true` we ask `revoke_internal` to wait for the grace period to
         // finish.
         unsafe { self.revoke_internal::<true>() }


