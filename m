Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300DA4071E3;
	Sun,  7 Jun 2026 10:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828178; cv=none; b=Y1NeOc7HqFkUkNRo6Idbo8tCtmtUpHSv7JMH/SQaQapZW1ocZFVnCU9HaDOW7HQVuJdayB71aJwp15RkVD2Uz0ryPMt98iyUvGNwAJtm/Esik5pibThhA6w7jze5nye4ZzgFgPZbfVBTN7GQZNHeO74LEdsoh141GlhHTPSo2mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828178; c=relaxed/simple;
	bh=OyqxCUvIM7lqLKg6h0iChMLbaR7O78h7yYopTG1PfGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAJ1+/+X9BDGufCRN5HRXfB3BEeXtB3NU9bS8O4Rq4OJF4sblvIrO1rlrCEsdPnXbP/F7BLdMhMwhwVaMaoJonhDsGAZ0f512cBBO/OBScmeCovSS6Dtn6g0EOWQ926N6cnKnFn9tTRFwxDDwcG0xM81H4qTGAdjYk/JbmE7DHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpPbYtm8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpPbYtm8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B86E1F00893;
	Sun,  7 Jun 2026 10:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828177;
	bh=hx7AwKF8bQTtZq1lKzzKum8xu0Kl2CV5YXIWpOzeAGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpPbYtm85ZI0vuhnMkxcKJ0j73PCzoAsEgmZnJYQS9/hdOmj0arjTFzSAIWRp3R0n
	 7UZ1mELktC6BjWjINNmV2SKozTK6WQYzmOYo5BZtl0kAeTUjqXZ8ACrUnsKL8+hTXK
	 UiKxEk+pAjdrvaaBSIWg6zO8h7ucUhZopKGuJBBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Stevens <stevensd@google.com>,
	Matthew Maurer <mmaurer@google.com>,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 6.18 138/315] rust_binder: Avoid holding lock when dropping delivered_death
Date: Sun,  7 Jun 2026 11:58:45 +0200
Message-ID: <20260607095732.674036613@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

From: Matthew Maurer <mmaurer@google.com>

commit f6d8fea9e3953151a4adb4f603503dc3dc9c69da upstream.

In 6c37bebd8c926, we switched to looping over the list and dropping each
individual node, ostensibly without the lock held in the loop body.

If the kernel were using Rust Edition 2024, the comment would be
accurate, and the lock would not be held across the drop. However, the
kernel is currently using 2021, so tail expression lifetime extension
results in the lock being held across the drop. Explicitly binding the
expression result to a variable makes the lockguard no longer part of a
tail expression, causing the lock to be dropped before entering the loop
body.

This was detected via `CONFIG_PROVE_LOCKING` identifying an invalid wait
context at the drop site.

Reported-by: David Stevens <stevensd@google.com>
Signed-off-by: Matthew Maurer <mmaurer@google.com>
Cc: stable <stable@kernel.org>
Fixes: 6c37bebd8c92 ("rust_binder: avoid mem::take on delivered_deaths")
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260403-lockhold-v1-1-c332b56cd8ae@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/process.rs |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -1366,7 +1366,12 @@ impl Process {
         // Clear delivered_deaths list.
         //
         // Scope ensures that MutexGuard is dropped while executing the body.
-        while let Some(delivered_death) = { self.inner.lock().delivered_deaths.pop_front() } {
+        while let Some(delivered_death) = {
+            // Explicitly bind to avoid tail expression lifetime extension of the lockguard
+            // Can be removed when the kernel moves to edition 2024
+            let maybe_death = self.inner.lock().delivered_deaths.pop_front();
+            maybe_death
+        } {
             drop(delivered_death);
         }
 


