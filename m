Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827126;
	b=W7sOkAy8Ci64v9BPZ8jRqGh4WcG8nnalvVzRMO0ffY3/7Dmdc804q+6/Q1H12eoUI2s0
	 ZN+kiUMrIovRSV3w/ebN0d6DG35xcmu8BdZh17+lyye6v5PP5BQASe/4lwQ0l2u1jkKeG
	 lkyVhcsG44ekHGu48/ilnXxyOwRx+uUXxN54Ruy2l20yN64P/PlYM4Yyzooa7XQh9Ne5+
	 FmACtAlOhHAZN+w7MjOzwplp3wqYd9+5h0Q4Q4X1E9ZdLP1hylIdEwS54dCfeIv6QU8/3
	 GDhuTrthueGJ/3UaF7ikmjP1t0ElKqCGyXGS/ctsZBEHCXkhXsnT/vqLLxQ27I2yeYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ylwKLOtT0ssPZg/j8swXfFYj3MtMj7ui4mgWedBIRnE=;
	b=YijDFFFeDFNZgLu8EoriVkDtkWxqZteE2+Gp0/xP/8dBN9mgQr/va9vNqReQGZ0tk3ct
	 8cOi4Sy8ksSE1IieDxs/KsJrZEiHL+8fwoqImqgnN09AX2HnX40S890AVDYAOhN7N9YNZ
	 GgP7YaWyZ4pYh18T9KaF83LHQwmoGWNkCLIQGtmXo/2rGHl0Mrn/C8cClxhd4joO94NfM
	 Kf92jg2+DukScDC9prXHBpErq/cMKtKaKnqvg6uTemU4QwDBYnUX+JSP3PR5+vJ4MqTls
	 tOvad3lj5vrMZNVk8BY5HlF03jqk/bvcdfFT6lTxS5GDLIPk4aUjXzMisDAd56Dga0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1URNTH86;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF15B606AE33;
	Wed,  4 Nov 2026 21:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1URNTH86
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA3B1F00919;
	Wed,  4 Nov 2026 21:18:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827125;
	bh=ylwKLOtT0ssPZg/j8swXfFYj3MtMj7ui4mgWedBIRnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1URNTH86YNXjV+JGCBGicMvTINTVQ9RDDEtqk1tiYBtvysONJMaeeQyWOBXobKefu
	 0MmxuF9wJRzcpQxmtwAPWNn+/v3/1zIK7pz52vVIr+o1xSu8VbjBRjQ3dXzy6uY4Qx
	 C2Eqso+plGXRJxUCmwujOnXT0KnhLwchceY/Hq6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dylan Zueck <dzueck@uci.edu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Priya Bala Govindasamy <pgovind2@uci.edu>,
	Petr Pavlu <petr.pavlu@suse.com>
Subject: [PATCH 7.3 202/547] rust: module_param: Fix potentially incorrect access of `SetOnce<T>`
Date: Wed,  4 Nov 2026 16:06:26 -0500
Message-ID: <20261104211043.883792918@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priya Bala Govindasamy <pgovind2@uci.edu>

commit 2e8bac09ed6d7aa2ad4e8a9a6cba67e5835865c2 upstream.

The `set_param` function casts `kernel_param.arg` to `*const SetOnce<T>`
But the Rust module macro in rust/macros/module.rs initializes `arg` with
`#param_name.as_void_ptr()`, and `#param_name` is a `ModuleParamAccess<T>`,
not a `SetOnce<T>`.

ModuleParamAccess<T> has default Rust layout but `set_param` accesses its
first field SetOnce<T> assuming it to be at offset 0. This is not
guaranteed by Rust and could cause type confusion leading to data
corruption.

Fix this by casting `kernel_param.arg` to `ModuleParamAccess<T>` and
then accessing the `value: SetOnce<T>` field.

Fixes: 0b08fc292842 ("rust: introduce module_param module")
Cc: stable@vger.kernel.org
Reported-by: Dylan Zueck <dzueck@uci.edu>
Assisted-by: LLM
Suggested-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Priya Bala Govindasamy <pgovind2@uci.edu>
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/module_param.rs |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/rust/kernel/module_param.rs
+++ b/rust/kernel/module_param.rs
@@ -74,8 +74,13 @@ where
     crate::error::from_result(|| {
         let new_value = T::try_from_param_arg(arg)?;
 
-        // SAFETY: By function safety requirements, this access is safe.
-        let container = unsafe { &*((*param).__bindgen_anon_1.arg.cast::<SetOnce<T>>()) };
+        // SAFETY: By function safety requirements, `param` is valid for read.
+        let arg = unsafe { (*param).__bindgen_anon_1.arg };
+        let param_access_ptr = arg.cast::<ModuleParamAccess<T>>();
+        // SAFETY: The `arg` field is initialized with a pointer to a `static ModuleAccessParam` by
+        // the rust module macro. Thus, the pointer is valid for use as a reference.
+        let param_access = unsafe { &*(param_access_ptr) };
+        let container = &param_access.value;
 
         container
             .populate(new_value)


