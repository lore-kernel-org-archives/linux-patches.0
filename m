Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905C723D2B2;
	Mon, 29 Dec 2025 16:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025460; cv=none; b=ImzbkD5OuPCqi097tqR8sLDRFw/I7unq7kx5ZcmHu9zzIYNj1CeTpqnbBCYFPSC9EU5azPLvZOe/eHszx7obqnJ+XXR/S6dGiHSM9z2zabHU/6mYZVr6JmzN8mo2I7yDImGc/Rvq4z+J6fNyRkdxKvq5bd5WbbbWPtZdFxDdQQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025460; c=relaxed/simple;
	bh=xphKcEXnxFogSu0E0pkuo2BIVHofreM5L+pcBEYIOw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H93ViDe0VmH7b7Hd4VYRq2Okm+BcKJ8PIjYk2GJsjmUAnOQnECGomNaGU8pbJ37bizHRoyYn4KL0BNsJWQ//6HHN6GPw3/cveMH5oO8SOpRpLa6f0GIg6BOMIMFR3bZUxE/3SEpVXt9O2FI1GPra93PU1maeF4SR8d6vR6W0D0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ODjjZXSM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ODjjZXSM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D74C4CEF7;
	Mon, 29 Dec 2025 16:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025460;
	bh=xphKcEXnxFogSu0E0pkuo2BIVHofreM5L+pcBEYIOw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODjjZXSMwFSjXjxn0kCInxDzPG+7i7FIFp2fpMe0Lhm2feK5HUeHw/oGlZXAZ4XVH
	 SJyam86euhUxSwmDsgCryqtaSZosz5300ETnWwKmmxIV4bSlo7so2NBSWqp0ibE9tA
	 88Xqfk6CCV3N+odywJLU7Cal45gV6rF5oq59KWGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 221/430] rust_binder: avoid mem::take on delivered_deaths
Date: Mon, 29 Dec 2025 17:10:23 +0100
Message-ID: <20251229160732.484635685@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit 6c37bebd8c926ad01ef157c0d123633a203e5c0d upstream.

Similar to the previous commit, List::remove is used on
delivered_deaths, so do not use mem::take on it as that may result in
violations of the List::remove safety requirements.

I don't think this particular case can be triggered because it requires
fd close to run in parallel with an ioctl on the same fd. But let's not
tempt fate.

Cc: stable@vger.kernel.org
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://patch.msgid.link/20251111-binder-fix-list-remove-v1-2-8ed14a0da63d@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/process.rs | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/android/binder/process.rs b/drivers/android/binder/process.rs
index 27323070f30f..fd5dcdc8788c 100644
--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -1362,8 +1362,12 @@ fn deferred_release(self: Arc<Self>) {
             work.into_arc().cancel();
         }
 
-        let delivered_deaths = take(&mut self.inner.lock().delivered_deaths);
-        drop(delivered_deaths);
+        // Clear delivered_deaths list.
+        //
+        // Scope ensures that MutexGuard is dropped while executing the body.
+        while let Some(delivered_death) = { self.inner.lock().delivered_deaths.pop_front() } {
+            drop(delivered_death);
+        }
 
         // Free any resources kept alive by allocated buffers.
         let omapping = self.inner.lock().mapping.take();
-- 
2.52.0



