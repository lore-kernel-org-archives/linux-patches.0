Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B30EF31E846;
	Fri,  9 Oct 2026 14:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557110; cv=none; b=odM4O699rXd1m2AEt3xY075ArZZBdHq6ae0WGOd1M74Mi0/FxFRKkUjqGPmRCV+mg0g0YajDJy65BknD+pXoWvmRjEv22TlvVE0M4+wCKgQarreJAnJGY1cn/nTljknt3fs6hZvnUuDCSJWVE9o+phKeT0EMgiqQ8JnMrBgb6Tw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557110; c=relaxed/simple;
	bh=yWqXYur2Q9LZpjDQnBsgZbg0eZFlBQppmWe7jXTzzEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUOZr5mxWl3yQs1/Q9ROJdwnR8LIg551FRqkxHtK0ExgpWtMPbV2JuqhZfqnA0NZ7ADykGtXq6bD9yl4YlldGMKySuMO4oCMCPb142Xl/xkQAT7D/VzMmcGmyFaxIBu2acbFaRRdYHi2S9MsOHzCclUqpI+sk94mIiHBu/1rpHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+vxpO6x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+vxpO6x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D9531F000FF;
	Fri,  9 Oct 2026 14:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557109;
	bh=dWP2B+yQ0IDtXiRzGmmGB1ZA2zEDOOAu/zlMsxJX43w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R+vxpO6xWIzcThEIA8cl7koLf0YugOmoOjDWEwq/xEazZ0pG7OlVztuPynb9YYOVv
	 UnvHndLpGdRs6lGCb5MLOhgH1jQ7dnD0B2zv4Ac8EdOGJLIHeStQCsLrO3ApwfGnbw
	 2KEt+gglTpak+zVmIK0Q6dbaMyoBN842ygbt9FgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 348/403] rust: devres: add static bound to Devres<T>
Date: Fri,  9 Oct 2026 16:11:49 +0200
Message-ID: <20261009141000.408689031@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

commit 016267b521b18529c977c9eca9597a1669c3d73c upstream.

Devres::new() registers a callback with the C devres subsystem via
devres_node_add(). If the Devres is leaked (e.g. via
core::mem::forget(), which is safe), its Drop impl never runs, and the
devres release callback will revoke the inner Revocable on device
unbind, which drops T in place. If T contains non-'static references,
those may be dangling by that point.

Add a 'static bound to prevent storing types with borrowed data in
Devres.

Fixes: 76c01ded724b ("rust: add devres abstraction")
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Eliot Courtney <ecourtney@nvidia.com>
Link: https://patch.msgid.link/20260526000447.350558-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -97,7 +97,7 @@ use crate::{
 /// # Ok(())
 /// # }
 /// ```
-pub struct Devres<T: Send> {
+pub struct Devres<T: Send + 'static> {
     dev: ARef<Device>,
     /// Pointer to [`Self::devres_callback`].
     ///
@@ -107,7 +107,7 @@ pub struct Devres<T: Send> {
     data: Arc<Revocable<T>>,
 }
 
-impl<T: Send> Devres<T> {
+impl<T: Send + 'static> Devres<T> {
     /// Creates a new [`Devres`] instance of the given `data`.
     ///
     /// The `data` encapsulated within the returned `Devres` instance' `data` will be
@@ -236,7 +236,7 @@ unsafe impl<T: Send> Send for Devres<T>
 // SAFETY: `Devres` can be shared with any task, if `T: Sync`.
 unsafe impl<T: Send + Sync> Sync for Devres<T> {}
 
-impl<T: Send> Drop for Devres<T> {
+impl<T: Send + 'static> Drop for Devres<T> {
     fn drop(&mut self) {
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.


