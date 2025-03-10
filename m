Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DE722D4D0;
	Mon, 10 Mar 2025 17:18:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627122; cv=none; b=apy+/hFyoRyuU/Lx3YZyBA+8cDZOKKOav8aSvy384gMunQx+L2ZYZdceMYlOKcguAYarldKX95Zz5xB3wko3QOvqITukb5OSu7Z11v+VudhDaFChTis4EhMORPZYz9PtG8nNOTMr9x/N+dP04DqS2G41/6F+UAYLeYXRLv+yiaw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627122; c=relaxed/simple;
	bh=x9A+qg1Oux5ae4rRi91yzYTemOvHWvjQRQTZq91MyqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRQIqLMSK9I+MDgJHSGpl2a38xMFZmC1MwuE2+PTQ0DID5Z/tVGivuXjMBbbdSWARZpwjwZIS8hKA3SUwaArZPHRYVR8UNJRznFThHzdrq9NsIYZtJSETd9KB61g9wYvDbbIreIyFn7GDjPHP0wui1LklknTWqREh4O1WfY7SlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MT7w6FIe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MT7w6FIe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB18C4CEE5;
	Mon, 10 Mar 2025 17:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627122;
	bh=x9A+qg1Oux5ae4rRi91yzYTemOvHWvjQRQTZq91MyqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MT7w6FIeBEiooTWDej2bUzmlw0wk+5mGC+o8kdkRFsRIJ1fUwvTBGpbLg8/BDMcOS
	 6JBO/ufegjzeVvC05JlR+rUGSekPbJxZvgX5wS2WGIwH0DlC/dDloW4kTEOOzMSWw+
	 NujylQA43SQtHB+x21ZozyrI3uS3UbgSaHoIbcXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 021/269] rust: sync: remove unneeded `#[allow(clippy::non_send_fields_in_send_ty)]`
Date: Mon, 10 Mar 2025 18:02:54 +0100
Message-ID: <20250310170458.555319788@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 5e7c9b84ad08cc7a41b2ddbbbaccb60057da3860 upstream.

Rust 1.58.0 (before Rust was merged into the kernel) made Clippy's
`non_send_fields_in_send_ty` lint part of the `suspicious` lint group for
a brief window of time [1] until the minor version 1.58.1 got released
a week after, where the lint was moved back to `nursery`.

By that time, we had already upgraded to that Rust version, and thus we
had `allow`ed the lint here for `CondVar`.

Nowadays, Clippy's `non_send_fields_in_send_ty` would still trigger here
if it were enabled.

Moreover, if enabled, `Lock<T, B>` and `Task` would also require an
`allow`. Therefore, it does not seem like someone is actually enabling it
(in, e.g., a custom flags build).

Finally, the lint does not appear to have had major improvements since
then [2].

Thus remove the `allow` since it is unneeded.

Link: https://github.com/rust-lang/rust/blob/master/RELEASES.md#version-1581-2022-01-20 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/8045 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-11-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/sync/condvar.rs |    1 -
 1 file changed, 1 deletion(-)

--- a/rust/kernel/sync/condvar.rs
+++ b/rust/kernel/sync/condvar.rs
@@ -92,7 +92,6 @@ pub struct CondVar {
     _pin: PhantomPinned,
 }
 
-#[allow(clippy::non_send_fields_in_send_ty)]
 // SAFETY: `CondVar` only uses a `struct wait_queue_head`, which is safe to use on any thread.
 unsafe impl Send for CondVar {}
 


