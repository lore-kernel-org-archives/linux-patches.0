Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3DA3F54B6;
	Tue, 17 Mar 2026 16:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766036; cv=none; b=Pgk8uAgcxT4DqC9SRECko33eehl0MvTVZeu6fZEHmMsTMqQ95y2cRYr4oFF6HTDXPH3Tgsx2lcgKHGYEVNlHncL+27CGKF7uUDEDiYbAf7YQZyK0zK6MeqhMSZi3tJ36jnE5AtIOOZiCxkNCkPFymUeBxymv1XZMm3RxynQjQYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766036; c=relaxed/simple;
	bh=t2zxRUBIRIFP2lgdJQEKIFFTwUREEQ+jWiojO84Blx0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LkhVvzzZ3fAnDeqzivrnulUIaNKhM8ANPNFLmnfT5Em+QcMIqA4EFwyl6Wm2p8GylyTHS/jYvtVHLxpROIC466/NTRPd6Djqkrp1rylF4CdgwptuNdydgl9e3slplp5PWqg2iXzRwZPPJpQBYuWkB4eKpE5DMJ73wSgnPMJcU3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+nY6Udb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+nY6Udb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDE5C4CEF7;
	Tue, 17 Mar 2026 16:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766036;
	bh=t2zxRUBIRIFP2lgdJQEKIFFTwUREEQ+jWiojO84Blx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+nY6Udbb+/cp/zwt+uqgiG+jbzbZIowCKfnLCTKGIRhzqkWmDv7uIo9avHeYRe4q
	 DaqUIx2oMGLjnPeZiKQUfHzVNgWPi8OfYl8400dDELY+hxGcjnw8dzR5az0iNCgj6i
	 C4dO143IarmeF+aad5d9jqxfiPsVNkIU5r4Xrf7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+c8287e65a57a89e7fb72@syzkaller.appspotmail.com,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Andreas Hindborg <a.hindborg@kernel.org>
Subject: [PATCH 6.19 129/378] rust_binder: call set_notification_done() without proc lock
Date: Tue, 17 Mar 2026 17:31:26 +0100
Message-ID: <20260317163011.760686909@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 2e303f0febb65a434040774b793ba8356698802b upstream.

Consider the following sequence of events on a death listener:
1. The remote process dies and sends a BR_DEAD_BINDER message.
2. The local process invokes the BC_CLEAR_DEATH_NOTIFICATION command.
3. The local process then invokes the BC_DEAD_BINDER_DONE.
Then, the kernel will reply to the BC_DEAD_BINDER_DONE command with a
BR_CLEAR_DEATH_NOTIFICATION_DONE reply using push_work_if_looper().

However, this can result in a deadlock if the current thread is not a
looper. This is because dead_binder_done() still holds the proc lock
during set_notification_done(), which called push_work_if_looper().
Normally, push_work_if_looper() takes the thread lock, which is fine to
take under the proc lock. But if the current thread is not a looper,
then it falls back to delivering the reply to the process work queue,
which involves taking the proc lock. Since the proc lock is already
held, this is a deadlock.

Fix this by releasing the proc lock during set_notification_done(). It
was not intentional that it was held during that function to begin with.

I don't think this ever happens in Android because BC_DEAD_BINDER_DONE
is only invoked in response to BR_DEAD_BINDER messages, and the kernel
always delivers BR_DEAD_BINDER to a looper. So there's no scenario where
Android userspace will call BC_DEAD_BINDER_DONE on a non-looper thread.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Reported-by: syzbot+c8287e65a57a89e7fb72@syzkaller.appspotmail.com
Tested-by: syzbot+c8287e65a57a89e7fb72@syzkaller.appspotmail.com
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://patch.msgid.link/20260224-binder-dead-binder-done-proc-lock-v1-1-bbe1b8a6e74a@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/process.rs |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -1289,7 +1289,8 @@ impl Process {
     }
 
     pub(crate) fn dead_binder_done(&self, cookie: u64, thread: &Thread) {
-        if let Some(death) = self.inner.lock().pull_delivered_death(cookie) {
+        let death = self.inner.lock().pull_delivered_death(cookie);
+        if let Some(death) = death {
             death.set_notification_done(thread);
         }
     }


