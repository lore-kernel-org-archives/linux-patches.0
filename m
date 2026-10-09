Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7637C3F54BD;
	Fri,  9 Oct 2026 14:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556222; cv=none; b=EH/EXAM7/bnuCRV0fj6KgoUQWw11wRLNokMyHTNo1S5UytxJIgfENLMD1ekEG647A67RrRfIircvstxERYKYTsSnhdSB0bYD6djdJcOGraR9QYiYgxNLch5jf1zYoFMchyO31LZNxhqSVARh2lKh5ty2427LNU7RWFqdC6uEaQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556222; c=relaxed/simple;
	bh=9ngTKZu2NDEVIoCzHK3UiBoXIJBZ+C7d75L16a8Yg4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BF1T10XWEfrbYS8vnkNxMOdINHpgfUrhY2EQmNXpW4YdYygcmy8FsTQpMX91WHNwjowkgNUDMKYOZz8ghmVwOnBW6KCN/blyDKPhd9h2McQcZF3EkA1g+D6dmOxIhnOnrSSl2gVKbzevsmhOnQGw5SHRBb1AHQcVSPLCtFnllzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZtS3SAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZtS3SAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83BFC1F000FF;
	Fri,  9 Oct 2026 14:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556221;
	bh=Qj6jB1u75BUts+ideaiqrka1fYfBxw6lcADlEAXYGMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZtS3SACGmF6/VQcz083BiyQKIdvhvp75SQt7yQlF/otIh81OvjwzC2rRctmo8+7m
	 O31/bgjI6BwwHQ7Swip/uldxqZEwNE7lhnUaQMkRUuuL1IAcc2l77529RuRdDxu4zs
	 o3NR7gtrJDxPEdDQ7ceQp42gT+iUMXunn1rGg6EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 157/403] rust_binder: cancel deferred work items in thread exit
Date: Fri,  9 Oct 2026 16:08:38 +0200
Message-ID: <20261009140955.748524977@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit 62479b6e5df82cbdf3c4145130928f233fae78fb upstream.

If there are deferred work items on the thread todo list, then they are
not cleaned up in the Thread::release() method. Thus, update the code to
clean up the work items even if they are deferred.

This can happen if the thread dies while it has an active outgoing
transaction.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260903-binder-exit-get-work-v1-1-2d6129a238df@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/thread.rs |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -656,6 +656,12 @@ impl Thread {
         self.inner.lock().push_return_work(reply);
     }
 
+    pub(crate) fn pop_work_even_if_deferred(&self) -> Option<DLArc<dyn DeliverToRead>> {
+        let mut thread_inner = self.inner.lock();
+        thread_inner.process_work_list = true;
+        thread_inner.pop_work()
+    }
+
     fn translate_object(
         &self,
         obj_index: usize,
@@ -1606,7 +1612,7 @@ impl Thread {
         self.unwind_transaction_stack();
 
         // Cancel all pending work items.
-        while let Ok(Some(work)) = self.get_work_local(false) {
+        while let Some(work) = self.pop_work_even_if_deferred() {
             work.into_arc().cancel();
         }
     }


