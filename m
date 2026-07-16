Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADA33BE161;
	Thu, 16 Jul 2026 13:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209374; cv=none; b=tgFVTszTH4qw+xXvh2LzNnHTIf8KqbBsZddIcxeMpEZuztJsSlUiXjR088s8jeS5Ytyl0GnW2kquASYFhEA8xxYQJJ/4F1XHYji275Z3zTg8gdutrY6EPeTHByBYp0EYAYaKFdS/nIBRFsn0upWm3JyWNFvYM0rxScY/6FXKtnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209374; c=relaxed/simple;
	bh=pMgmzWFV9D2ABB+y13en6AUb/fI+9ztBEwcLc4fQqoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZL/eOATscw5gECBUd7wm4H2Ofwd5pIVhQEY6rKVGRhvGuurZnVzE0IHGuVcpWtXk5vucw5Q47P3dSndGEfh5Yq7ZF7ed+b1FmMUaWIThSKhBCyF4a/Axb9adFJvxxk6Ae0EfHDdogKv48ox1bNoOpBJn2VGV4YcLDdQaO/0SioY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B30nNFhe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B30nNFhe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C341F00A3A;
	Thu, 16 Jul 2026 13:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209369;
	bh=Oh91/EjTaXJB0lJ3hZWhxLVcTRpMaTx4FQcf89VfIwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B30nNFhemRVqZErog2go6GOCpOru1pjdmYMhS0ZtAiMg0lQ5yqX1B5owV0wc2tdZv
	 YQoAIG8turbgGeHyX0IvUgv5Xcoxdq6gPlfLVwDvRIBlwF1cjlRXKWSTmQmaE76dgj
	 xXZf7hSdGpQg31MGHhaOy3kqf94dZwbe5qBQAiVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Carlos Llamas <cmllamas@google.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Keshav Verma <iganschel@gmail.com>
Subject: [PATCH 7.1 122/518] rust_binder: synchronize Rust Binder stats with freeze commands
Date: Thu, 16 Jul 2026 15:26:30 +0200
Message-ID: <20260716133050.525915050@linuxfoundation.org>
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
 use kernel::sync::atomic::{ordering::Relaxed, Atomic};
 use kernel::{ioctl::_IOC_NR, seq_file::SeqFile, seq_print};
 
-const BC_COUNT: usize = _IOC_NR(BC_REPLY_SG) as usize + 1;
-const BR_COUNT: usize = _IOC_NR(BR_TRANSACTION_PENDING_FROZEN) as usize + 1;
+const BC_COUNT: usize = _IOC_NR(BC_FREEZE_NOTIFICATION_DONE) as usize + 1;
+const BR_COUNT: usize = _IOC_NR(BR_CLEAR_FREEZE_NOTIFICATION_DONE) as usize + 1;
 
 pub(crate) static GLOBAL_STATS: BinderStats = BinderStats::new();
 


