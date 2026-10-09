Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C0D4EB86F;
	Fri,  9 Oct 2026 14:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557127; cv=none; b=M/YBnUqewSv+JZO0TZ/Y0F4yK+W0qYP6JfLXcvra+Z9O3BzrsakuIeyKIMZqjISXvqqA8k3B5mRGHcv/Hnbu/Pbqrkies4eAgzPX4IT/63hNaI2I8jgJmvbdexlOOpTyOlX60Y3Ncnzp44p4izV0czAoS4g8Z0L4BYAQSb+b+6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557127; c=relaxed/simple;
	bh=vjM5p6PiDobHCUKi8GtLnemj6UnqAMfcABa3YdS0XN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+agSAZVjP1aB6zOxGs3s2tUeRyiVYOYoA42rPzoImpYt2G91TQekos7DrJcbj4OOsdPmH7cHyGr9B9M4WCLnraip7Z4YkhuwKHESbdx8OyLocRaQMCWccdIUJ/qyaymyMnc07XjI3zdqnMXHmHbLSfkRufYSCfcnXPpwuFSfqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwNbgznS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwNbgznS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6A41F00893;
	Fri,  9 Oct 2026 14:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557123;
	bh=+tpWnngQpVNrgz1xP7n1lCB/n7Uc6f8fydRp/ty9mX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwNbgznSgC11KDUYA00Ea4PtpWEnR6TEKVdqbE4F73qu1drXx0Sh4ljHMKBTqWyDI
	 QvGBpsQ53nc5mPBSgWchOiKf9tvjC/LZF75W7UTZPJgOYy8YE5OOVXZAD3LCw5G00a
	 WFEnZbuvVSKOQrd11hWkb6jX8vGdXXK6P5C1kDGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 350/403] rust: devres: ensure revocation is complete before device finishes unbinding
Date: Fri,  9 Oct 2026 16:11:51 +0200
Message-ID: <20261009141000.456771618@linuxfoundation.org>
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

commit a10639966fd72fff8f7fbf3c8e733307daabd38f upstream.

Now that the revocation Completion is in place, also address the
symmetric case. When Devres::drop() wins the is_available swap and the
devres callback loses, the callback returns to devres_release_all()
without waiting. This means device unbinding can complete while
Devres::drop() is still executing drop_in_place() on another CPU, which
is a problem if T's destructor accesses device state.

Make the synchronization bidirectional. Whichever side performs
drop_in_place() signals the Completion, and the other side waits.

This does not reintroduce the nested Devres deadlock fixed by commit
ba268514ea14 ("rust: devres: fix race condition due to nesting"),
because that deadlock was caused by drop waiting for the release
callback to return (the old 'devm' Completion). Here, both sides only
wait for drop_in_place() to finish, which completes within the current
call chain. The Arc<Inner<T>> keeps the Inner allocation alive
independently.

Cc: stable@vger.kernel.org
Fixes: ba268514ea14 ("rust: devres: fix race condition due to nesting")
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260628200304.2365598-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/devres.rs |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -173,6 +173,11 @@ impl<T: Send + 'static> Devres<T> {
 
         if inner.data.revoke() {
             inner.revocation.complete_all();
+        } else {
+            // Devres::drop() is concurrently revoking; wait for it to finish `drop_in_place()`
+            // before returning to `devres_release_all()`, ensuring `T` is fully torn down before
+            // the device finishes unbinding.
+            inner.revocation.wait_for_completion();
         }
     }
 
@@ -261,6 +266,8 @@ impl<T: Send + 'static> Drop for Devres<
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.
         if unsafe { self.data().revoke_nosync() } {
+            self.inner.revocation.complete_all();
+
             // We revoked `self.data` before the devres action did, hence try to remove it.
             if self.remove_action() {
                 // SAFETY: In `Self::new` we have taken an additional reference count of `self.inner`


