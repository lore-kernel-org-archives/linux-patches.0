Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F5D941A79A;
	Thu, 16 Jul 2026 13:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209312; cv=none; b=cls+rZXyGsu3YA+X0aRxo5AHY9kZMYATEp+MQbByZcg8c7bYHpEPMFZcHomTtDArJK9+VPQWY5jEQeLEAyE/w2xwTVdvJukD7BywgGPKLP4iYoyFKTuuJCniP+pkgqTPCu6K6gND+7as3CKNqk83kU03t3GoZkJ6nYiBNGYEAZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209312; c=relaxed/simple;
	bh=waJGgxqgC5hh7S0UqYAI6WY8+nzD2YznkxAh61xM7a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mCDlHVj52ttCX+0iLANzqOispwC9ytfHw/PaJvKxOLP4xyp3UPN5H5OPJ8Cs9cTQTJ2WTZjY8TvxbRExH/pa9wMV1die9Bh8YBgpQLBxahFSnWnSttOVzi9ven7lmJT5/Pp0CGYDApZAJzqiKdhfYaw4DAmHD6whsal5iOIqYVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoSGfbRJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoSGfbRJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 758DB1F000E9;
	Thu, 16 Jul 2026 13:41:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209311;
	bh=0OP76ppKBGZdZQ8f2P6i+qekWm2HjJm0kegNHC2O4ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoSGfbRJ4YzeqNebiTHIQ+aTne1M2KJgP57WQrz9eQogOr0COafw1am3kygUdmjGM
	 C+h1nFcfcXVBjIPxu2Kkd5K/mdpXP5dDVKflbOCLua1lQwjXT08EvOlG5LXH8UwtbC
	 ctHKI6vDdHCqauR42b1g41ZtSrtG2mvRG1IqHpCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Carlos Llamas <cmllamas@google.com>
Subject: [PATCH 7.1 120/518] rust_binder: fix BINDER_GET_EXTENDED_ERROR
Date: Thu, 16 Jul 2026 15:26:28 +0200
Message-ID: <20260716133050.480213348@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

From: Alice Ryhl <aliceryhl@google.com>

commit 77bfebf110773f5a0d6b5ff8110896adb2c9c335 upstream.

This code currently copies the ExtendedError struct to the stack,
modifies the copy, and then doesn't modify the original. Thus, fix it.

Furthermore, errors when replying must be delivered directly to the
remote thread, so update deliver_reply() to take an extended error
argument.

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Acked-by: Carlos Llamas <cmllamas@google.com>
Link: https://patch.msgid.link/20260605-set-extended-error-v3-1-d60b69a75f97@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/error.rs       |   13 ++----
 drivers/android/binder/thread.rs      |   65 ++++++++++++++++++++++++----------
 drivers/android/binder/transaction.rs |   15 +++----
 3 files changed, 58 insertions(+), 35 deletions(-)

--- a/drivers/android/binder/error.rs
+++ b/drivers/android/binder/error.rs
@@ -73,20 +73,17 @@ impl fmt::Debug for BinderError {
     fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
         match self.reply {
             BR_FAILED_REPLY => match self.source.as_ref() {
-                Some(source) => f
-                    .debug_struct("BR_FAILED_REPLY")
-                    .field("source", source)
-                    .finish(),
+                Some(source) => source.fmt(f),
                 None => f.pad("BR_FAILED_REPLY"),
             },
             BR_DEAD_REPLY => f.pad("BR_DEAD_REPLY"),
             BR_FROZEN_REPLY => f.pad("BR_FROZEN_REPLY"),
             BR_TRANSACTION_PENDING_FROZEN => f.pad("BR_TRANSACTION_PENDING_FROZEN"),
             BR_TRANSACTION_COMPLETE => f.pad("BR_TRANSACTION_COMPLETE"),
-            _ => f
-                .debug_struct("BinderError")
-                .field("reply", &self.reply)
-                .finish(),
+            _ => match self.source.as_ref() {
+                Some(source) => source.fmt(f),
+                None => self.reply.fmt(f),
+            },
         }
     }
 }
--- a/drivers/android/binder/thread.rs
+++ b/drivers/android/binder/thread.rs
@@ -495,9 +495,16 @@ impl Thread {
         Ok(())
     }
 
+    pub(crate) fn clear_extended_error(&self, debug_id: usize) {
+        self.inner.lock().extended_error = ExtendedError::new(debug_id as u32, BR_OK, 0);
+    }
+
     pub(crate) fn get_extended_error(&self, data: UserSlice) -> Result {
         let mut writer = data.writer();
-        let ee = self.inner.lock().extended_error;
+        let mut inner = self.inner.lock();
+        let ee = inner.extended_error;
+        inner.extended_error = ExtendedError::new(0, BR_OK, 0);
+        drop(inner);
         writer.write(&ee)?;
         Ok(())
     }
@@ -1109,7 +1116,10 @@ impl Thread {
             inner.pop_transaction_to_reply(thread.as_ref())
         } {
             let reply = Err(BR_DEAD_REPLY);
-            if !transaction.from.deliver_single_reply(reply, &transaction) {
+            if !transaction
+                .from
+                .deliver_single_reply(reply, &transaction, None)
+            {
                 break;
             }
 
@@ -1121,8 +1131,9 @@ impl Thread {
         &self,
         reply: Result<DLArc<Transaction>, u32>,
         transaction: &DArc<Transaction>,
+        extended_error: Option<ExtendedError>,
     ) {
-        if self.deliver_single_reply(reply, transaction) {
+        if self.deliver_single_reply(reply, transaction, extended_error) {
             transaction.from.unwind_transaction_stack();
         }
     }
@@ -1136,6 +1147,7 @@ impl Thread {
         &self,
         reply: Result<DLArc<Transaction>, u32>,
         transaction: &DArc<Transaction>,
+        extended_error: Option<ExtendedError>,
     ) -> bool {
         if let Ok(transaction) = &reply {
             crate::trace::trace_transaction(true, transaction, Some(&self.task));
@@ -1152,6 +1164,12 @@ impl Thread {
                 return true;
             }
 
+            if let Some(ee) = extended_error {
+                if inner.extended_error.command == BR_OK {
+                    inner.extended_error = ee;
+                }
+            }
+
             match reply {
                 Ok(work) => {
                     inner.push_work(work);
@@ -1222,6 +1240,9 @@ impl Thread {
         info.buffers_size = td.buffers_size as usize;
         // SAFETY: Above `read` call initializes all bytes, so this union read is ok.
         info.target_handle = unsafe { td.transaction_data.target.handle };
+
+        info.debug_id = super::next_debug_id();
+
         Ok(())
     }
 
@@ -1230,6 +1251,8 @@ impl Thread {
         let mut info = TransactionInfo::zeroed();
         self.read_transaction_info(cmd, reader, &mut info)?;
 
+        self.clear_extended_error(info.debug_id);
+
         let ret = if info.is_reply {
             self.reply_inner(&mut info)
         } else if info.is_oneway() {
@@ -1239,23 +1262,21 @@ impl Thread {
         };
 
         if let Err(err) = ret {
-            if err.reply != BR_TRANSACTION_COMPLETE {
-                info.reply = err.reply;
-            }
-
             self.push_return_work(err.reply);
-            if let Some(source) = &err.source {
-                info.errno = source.to_errno();
+            if err.reply != BR_TRANSACTION_COMPLETE {
                 info.reply = err.reply;
+                if let Some(source) = &err.source {
+                    info.errno = source.to_errno();
 
-                {
-                    let mut ee = self.inner.lock().extended_error;
-                    ee.command = err.reply;
-                    ee.param = source.to_errno();
+                    {
+                        let mut inner = self.inner.lock();
+                        inner.extended_error =
+                            ExtendedError::new(info.debug_id as u32, err.reply, source.to_errno());
+                    }
                 }
 
                 pr_warn!(
-                    "{}:{} transaction to {} failed: {source:?}",
+                    "{}:{} transaction to {} failed: {err:?}",
                     info.from_pid,
                     info.from_tid,
                     info.to_pid
@@ -1320,18 +1341,24 @@ impl Thread {
             let allow_fds = orig.flags & TF_ACCEPT_FDS != 0;
             let reply = Transaction::new_reply(self, process, info, allow_fds)?;
             self.inner.lock().push_work(completion);
-            orig.from.deliver_reply(Ok(reply), &orig);
+            orig.from.deliver_reply(Ok(reply), &orig, None);
             Ok(())
         })()
         .map_err(|mut err| {
             // At this point we only return `BR_TRANSACTION_COMPLETE` to the caller, and we must let
             // the sender know that the transaction has completed (with an error in this case).
+
             pr_warn!(
-                "Failure {:?} during reply - delivering BR_FAILED_REPLY to sender.",
-                err
+                "{}:{} reply to {} failed: {err:?}",
+                info.from_pid,
+                info.from_tid,
+                info.to_pid
             );
-            let reply = Err(BR_FAILED_REPLY);
-            orig.from.deliver_reply(reply, &orig);
+
+            let param = err.source.as_ref().map_or(0, |e| e.to_errno());
+            let ee = ExtendedError::new(info.debug_id as u32, err.reply, param);
+            orig.from
+                .deliver_reply(Err(BR_FAILED_REPLY), &orig, Some(ee));
             err.reply = BR_TRANSACTION_COMPLETE;
             err
         });
--- a/drivers/android/binder/transaction.rs
+++ b/drivers/android/binder/transaction.rs
@@ -42,6 +42,7 @@ pub(crate) struct TransactionInfo {
     pub(crate) reply: u32,
     pub(crate) oneway_spam_suspect: bool,
     pub(crate) is_reply: bool,
+    pub(crate) debug_id: usize,
 }
 
 impl TransactionInfo {
@@ -93,7 +94,6 @@ impl Transaction {
         from: &Arc<Thread>,
         info: &mut TransactionInfo,
     ) -> BinderResult<DLArc<Self>> {
-        let debug_id = super::next_debug_id();
         let allow_fds = node_ref.node.flags & FLAT_BINDER_FLAG_ACCEPTS_FDS != 0;
         let txn_security_ctx = node_ref.node.flags & FLAT_BINDER_FLAG_TXN_SECURITY_CTX != 0;
         let mut txn_security_ctx_off = if txn_security_ctx { Some(0) } else { None };
@@ -101,7 +101,7 @@ impl Transaction {
         let mut alloc = match from.copy_transaction_data(
             to.clone(),
             info,
-            debug_id,
+            info.debug_id,
             allow_fds,
             txn_security_ctx_off.as_mut(),
         ) {
@@ -128,7 +128,7 @@ impl Transaction {
         let data_address = alloc.ptr;
 
         Ok(DTRWrap::arc_pin_init(pin_init!(Transaction {
-            debug_id,
+            debug_id: info.debug_id,
             target_node: Some(target_node),
             from_parent,
             sender_euid: Kuid::current_euid(),
@@ -152,9 +152,8 @@ impl Transaction {
         info: &mut TransactionInfo,
         allow_fds: bool,
     ) -> BinderResult<DLArc<Self>> {
-        let debug_id = super::next_debug_id();
         let mut alloc =
-            match from.copy_transaction_data(to.clone(), info, debug_id, allow_fds, None) {
+            match from.copy_transaction_data(to.clone(), info, info.debug_id, allow_fds, None) {
                 Ok(alloc) => alloc,
                 Err(err) => {
                     pr_warn!("Failure in copy_transaction_data: {:?}", err);
@@ -165,7 +164,7 @@ impl Transaction {
             alloc.set_info_clear_on_drop();
         }
         Ok(DTRWrap::arc_pin_init(pin_init!(Transaction {
-            debug_id,
+            debug_id: info.debug_id,
             target_node: None,
             from_parent: None,
             sender_euid: Kuid::current_euid(),
@@ -394,7 +393,7 @@ impl DeliverToRead for Transaction {
         let send_failed_reply = ScopeGuard::new(|| {
             if self.target_node.is_some() && self.flags & TF_ONE_WAY == 0 {
                 let reply = Err(BR_FAILED_REPLY);
-                self.from.deliver_reply(reply, &self);
+                self.from.deliver_reply(reply, &self, None);
             }
             self.drop_outstanding_txn();
         });
@@ -478,7 +477,7 @@ impl DeliverToRead for Transaction {
         // If this is not a reply or oneway transaction, then send a dead reply.
         if self.target_node.is_some() && self.flags & TF_ONE_WAY == 0 {
             let reply = Err(BR_DEAD_REPLY);
-            self.from.deliver_reply(reply, &self);
+            self.from.deliver_reply(reply, &self, None);
         }
 
         self.drop_outstanding_txn();


