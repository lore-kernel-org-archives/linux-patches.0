Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA7E7188715;
	Tue, 12 Aug 2025 18:30:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023420; cv=none; b=oN4EiuhWEkZ71ZGLV2nfZTTVwA3mrwbbXVw2OOXvvakbh7zl213EkyOXxJ/ATkqmFYudat1gqzfct1AUfW9xLl+3O3bSLDo9nt2R/t/lxMY16y6PiLNFnbgsVgIl09bggx1YHmC5ooAJTv4wBsInxpHaLGRVt/MQ/ZEzZJXs3pA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023420; c=relaxed/simple;
	bh=U6dx0xSNl1GB8cfzj104sXvapvTIjOMeVN3pONnQEr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrX3HE03dBcw4ne24UuZopBjuQkXPSUeTj6g3m3GJKsa8J8fDWBy1fb9nOaM4aecFoNznTZeVuzBHUOXjw3Xwy4ghmTR9CTMMod7/jqwwvQ9/jk5m9BnOhVp+iCXqTY88hqlZC/lMkkxGZCvgUSmR9uceeoe9ysM/SLxAlCbaG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TNfGK9dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TNfGK9dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A9D8C4CEF0;
	Tue, 12 Aug 2025 18:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023419;
	bh=U6dx0xSNl1GB8cfzj104sXvapvTIjOMeVN3pONnQEr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TNfGK9ddhlU8WkUkkwnl2oTyfogEq4vOfqPa/Dg31Y4hCM95ZdAELRigkYfCY80sp
	 W8HVJCRHYE3jM3jbV4bVd4QKuM/B398jG3tEAzPhvevFlqnlHOAr0hFfxIBLyGGcRV
	 6Z4KYZEhzdeYqSD/jeWf66ClAzJvIcKUSLqGrn24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Boqun Feng <boqun.fenng@gmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 075/627] rust: devres: require T: Send for Devres
Date: Tue, 12 Aug 2025 19:26:10 +0200
Message-ID: <20250812173422.167339714@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 0dab138d0f4c0b3ce7f835d577e52a2b5ebdd536 ]

Due to calling Revocable::revoke() from Devres::devres_callback() T may
be dropped from Devres::devres_callback() and hence must be Send.

Fix this by adding the corresponding bound to Devres and DevresInner.

Reported-by: Boqun Feng <boqun.feng@gmail.com>
Closes: https://lore.kernel.org/lkml/aFzI5L__OcB9hqdG@Mac.home/
Fixes: 76c01ded724b ("rust: add devres abstraction")
Reviewed-by: Boqun Feng <boqun.fenng@gmail.com>
Reviewed-by: Benno Lossin <lossin@kernel.org>
Link: https://lore.kernel.org/r/20250626132544.72866-1-dakr@kernel.org
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/devres.rs | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index 57502534d985..8ede607414fd 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -18,7 +18,7 @@
 };
 
 #[pin_data]
-struct DevresInner<T> {
+struct DevresInner<T: Send> {
     dev: ARef<Device>,
     callback: unsafe extern "C" fn(*mut c_void),
     #[pin]
@@ -95,9 +95,9 @@ struct DevresInner<T> {
 /// # Ok(())
 /// # }
 /// ```
-pub struct Devres<T>(Arc<DevresInner<T>>);
+pub struct Devres<T: Send>(Arc<DevresInner<T>>);
 
-impl<T> DevresInner<T> {
+impl<T: Send> DevresInner<T> {
     fn new(dev: &Device<Bound>, data: T, flags: Flags) -> Result<Arc<DevresInner<T>>> {
         let inner = Arc::pin_init(
             pin_init!( DevresInner {
@@ -175,7 +175,7 @@ fn remove_action(this: &Arc<Self>) -> bool {
     }
 }
 
-impl<T> Devres<T> {
+impl<T: Send> Devres<T> {
     /// Creates a new [`Devres`] instance of the given `data`. The `data` encapsulated within the
     /// returned `Devres` instance' `data` will be revoked once the device is detached.
     pub fn new(dev: &Device<Bound>, data: T, flags: Flags) -> Result<Self> {
@@ -247,7 +247,7 @@ pub fn try_access_with_guard<'a>(&'a self, guard: &'a rcu::Guard) -> Option<&'a
     }
 }
 
-impl<T> Drop for Devres<T> {
+impl<T: Send> Drop for Devres<T> {
     fn drop(&mut self) {
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.
-- 
2.39.5



