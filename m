Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533CB44607D;
	Tue, 21 Jul 2026 15:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648859; cv=none; b=PE5BZO0NDu0jX75vCRe/HXkp94E+Psj3ypNsd77zG7whtWks9n1jPB/GCVZOvwmbQlk2gTzZqoBmzAxtqdEpFBvyjNOOJUARcNY7g+AdSonf2yhTcMH1yAfFJvHM/CUKA4CMwbl4bTtTkZ0ezC+pEdCMLWw9zmunR/nW0MbmyXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648859; c=relaxed/simple;
	bh=UthCMxpUDtMxFfjGiyGSzDf34qc4mplL/4S9Ac5wHtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlVWrNlO1yOjaxvbYN10cIx9c/Y953F9nMYjEe8Q7U6s2CxPVSedfVciaNJ8uyWxt57iwXRqMZW+zxmdGX0RD2XKdQf26+qzc4Fs2VEjVao5BBjbkEiFjgLd3/RYsZqekY9ibHk8SYq0KAcj4rPYWYcQM8YMgZlg1rbcgbzevG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7D+zIpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7D+zIpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71ECF1F000E9;
	Tue, 21 Jul 2026 15:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648857;
	bh=HNqr9Zm6OdGyzKpPI6eI2UzlEjo8hDCyyn+vRaswvPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7D+zIpciW0wWPFx59Gyk6Ctgl6rDQV4Bx7XpUQ6aEXDTLGUAHLaHU7qYorEX8eTu
	 zQrfEEwBrNb9EkL2+Q3lBt2nfxc27z7IdWEVG06rmjzbCJoeLOaA2u84MI/1FksBHT
	 4m5hafrNTNE+dmeKgrs4mkbAJIOkaZ2UnuouyDwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Eliot Courtney <ecourtney@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0356/2077] rust: devres: add static bound to Devres<T>
Date: Tue, 21 Jul 2026 17:00:29 +0200
Message-ID: <20260721152601.085977397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit 016267b521b18529c977c9eca9597a1669c3d73c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/devres.rs | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/devres.rs b/rust/kernel/devres.rs
index 9e5f93aed20cf1..2e258d31a45cac 100644
--- a/rust/kernel/devres.rs
+++ b/rust/kernel/devres.rs
@@ -122,7 +122,7 @@ struct Inner<T> {
 /// # Ok(())
 /// # }
 /// ```
-pub struct Devres<T: Send> {
+pub struct Devres<T: Send + 'static> {
     dev: ARef<Device>,
     inner: Arc<Inner<T>>,
 }
@@ -184,7 +184,7 @@ mod base {
     }
 }
 
-impl<T: Send> Devres<T> {
+impl<T: Send + 'static> Devres<T> {
     /// Creates a new [`Devres`] instance of the given `data`.
     ///
     /// The `data` encapsulated within the returned `Devres` instance' `data` will be
@@ -349,7 +349,7 @@ unsafe impl<T: Send> Send for Devres<T> {}
 // SAFETY: `Devres` can be shared with any task, if `T: Sync`.
 unsafe impl<T: Send + Sync> Sync for Devres<T> {}
 
-impl<T: Send> Drop for Devres<T> {
+impl<T: Send + 'static> Drop for Devres<T> {
     fn drop(&mut self) {
         // SAFETY: When `drop` runs, it is guaranteed that nobody is accessing the revocable data
         // anymore, hence it is safe not to wait for the grace period to finish.
-- 
2.53.0



