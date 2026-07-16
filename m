Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BEC3009E2;
	Thu, 16 Jul 2026 14:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210662; cv=none; b=c4tGr27cPadtV/UV3EAheTioockwsu6k9GdThWaWl25tAnrpMClP5HrqR+cJz5sEHP2gVNaodqnOPnzX8ZSz81egFh6j7UXtZhGAZ3nYue8Il6mgHOafxXdEdSLnqRbniHd3mC50ZDu69Yk714+ZUioOxI6DqynqHTf3YXqe7s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210662; c=relaxed/simple;
	bh=IVPIwS0eDnFleSJ+goaN4NUv7tCJjqKhGOabmyroXxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZsaaL+iLYcso6W4Gq2X8+oYFHQT1OT9tuPLwfrn9URsXl1d+oJdo3/8X/D/X0kT8m73M1EogtLMzBzL5TdOcahdFCTswtu4kY9b5JRyUu8TqTDRGLRnz99dIxFkJwvc0bpA//tQbdhjUzjvUDhDpqbQxgayoyiOFA0WWjQ6bD5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5s3pGFk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5s3pGFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 467F91F000E9;
	Thu, 16 Jul 2026 14:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210660;
	bh=IZrYTm789vQbrzY359E5PwFtI4ik9Erwum+NKauC318=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5s3pGFkKgphOufmIh8jW85FiqSZTK6uCvMWmsFn96e+DiaYsUXst5vOb9BBrn/HW
	 74swPwfbG9fsf2SdBBc9rlmclxvbW6Jy0YIxT6OwGlLQvM0EdSaStzNV/fQn8f2kK2
	 Fkpc5/+JUI2n86/JN6Y1a3lNRSd6t8gwHGsWM5M8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Keshav Verma <iganschel@gmail.com>
Subject: [PATCH 6.18 130/480] rust_binder: synchronize Rust Binder stats with freeze commands
Date: Thu, 16 Jul 2026 15:27:57 +0200
Message-ID: <20260716133047.521638331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Keshav Verma <iganschel@gmail.com>

commit eb1645bf10190e71f6f0316e37ff70755d719b53 upstream.

Rust Binder stats use BC_COUNT and BR_COUNT to size the command and
return counters, and use event string tables when printing debug
statistics.

The Binder protocol includes freeze-related commands and return codes,
but the Rust Binder statistics code was not updated to cover them. As a
result, those commands and return codes are not accounted for or printed
by the stats debug output.

Update the counts and event string tables so these commands and return
codes are included in the debug statistics output.

Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Cc: stable <stable@kernel.org>
Acked-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Link: https://patch.msgid.link/20260615211743.734-1-iganschel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/rust_binder_events.c |    7 ++++++-
 drivers/android/binder/stats.rs             |    4 ++--
 2 files changed, 8 insertions(+), 3 deletions(-)

--- a/drivers/android/binder/rust_binder_events.c
+++ b/drivers/android/binder/rust_binder_events.c
@@ -28,6 +28,9 @@ const char * const binder_command_string
 	"BC_DEAD_BINDER_DONE",
 	"BC_TRANSACTION_SG",
 	"BC_REPLY_SG",
+	"BC_REQUEST_FREEZE_NOTIFICATION",
+	"BC_CLEAR_FREEZE_NOTIFICATION",
+	"BC_FREEZE_NOTIFICATION_DONE",
 };
 
 const char * const binder_return_strings[] = {
@@ -51,7 +54,9 @@ const char * const binder_return_strings
 	"BR_FAILED_REPLY",
 	"BR_FROZEN_REPLY",
 	"BR_ONEWAY_SPAM_SUSPECT",
-	"BR_TRANSACTION_PENDING_FROZEN"
+	"BR_TRANSACTION_PENDING_FROZEN",
+	"BR_FROZEN_BINDER",
+	"BR_CLEAR_FREEZE_NOTIFICATION_DONE",
 };
 
 #define CREATE_TRACE_POINTS
--- a/drivers/android/binder/stats.rs
+++ b/drivers/android/binder/stats.rs
@@ -8,8 +8,8 @@ use crate::defs::*;
 use core::sync::atomic::{AtomicU32, Ordering::Relaxed};
 use kernel::{ioctl::_IOC_NR, seq_file::SeqFile, seq_print};
 
-const BC_COUNT: usize = _IOC_NR(BC_REPLY_SG) as usize + 1;
-const BR_COUNT: usize = _IOC_NR(BR_TRANSACTION_PENDING_FROZEN) as usize + 1;
+const BC_COUNT: usize = _IOC_NR(BC_FREEZE_NOTIFICATION_DONE) as usize + 1;
+const BR_COUNT: usize = _IOC_NR(BR_CLEAR_FREEZE_NOTIFICATION_DONE) as usize + 1;
 
 pub(crate) static GLOBAL_STATS: BinderStats = BinderStats::new();
 


