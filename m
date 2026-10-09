Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433533D5236;
	Fri,  9 Oct 2026 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556568; cv=none; b=dO9xQ+mvMvtSJZ0rAHGIrqURDEm4HhPCi5S33p2ktrKIfTxPByl4/0tmAf5fhCRBSRcfQn18VQ1/4mMhmM6/WK/VYz2lPAZHzsBSbHTR8WCrr5FNWgwjgvlYJppnKZQfltdYPl3GocQ13jLBRQEAEpDEBTQC5J6pykYNZP0/8KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556568; c=relaxed/simple;
	bh=975rxIFE7QOnRt81HMaA72ekfYjUEDXQPzm+7lF2TS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HK+kddy6FvHV4wUVtOIzvIi/1MGHJoRdO1w+jA/9oT6XdMswa1Ot1IC8lIbm5bSXvzUAOpw5Soysd/U7YSncaoelnTrpgPmnSWv2OPew2ENYH7M0FWrPDMvjigHjTM8eViz4Ak9MP2gidMxV+pUTq0FMw518xhGU0a5gucY/Lf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nxJZh99e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nxJZh99e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B481F000FF;
	Fri,  9 Oct 2026 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556567;
	bh=Q5aO22EC7campi+D+DVrVrlrAxzmsmlukn0Xd+4ztlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nxJZh99edvWa+sujfsrxJfw31my4RAmpewJK/6/ubige8P7YaBb3iHzHdKQfHm+KZ
	 tAnVLeAHJ9ewYoMrK9lILCj117NTsY1xqG6ZqAkvkTNe6jiVKyQayrun0jv7bB+sFB
	 TaNEftfYqN++Z00vHgDOGm4671cXCcGMuRERAIrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.2 202/428] rust_binder: cancel deferred work items in thread exit
Date: Fri,  9 Oct 2026 16:08:59 +0200
Message-ID: <20261009140950.568834672@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -659,6 +659,12 @@ impl Thread {
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
@@ -1621,7 +1627,7 @@ impl Thread {
         self.unwind_transaction_stack();
 
         // Cancel all pending work items.
-        while let Ok(Some(work)) = self.get_work_local(false) {
+        while let Some(work) = self.pop_work_even_if_deferred() {
             work.into_arc().cancel();
         }
     }


