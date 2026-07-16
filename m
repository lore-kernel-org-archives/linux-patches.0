Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EF213148C2;
	Thu, 16 Jul 2026 14:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210659; cv=none; b=X4k6H3v5EF88aAEnfYKHE2y77tntKWowtctvBRCEE5oZIUiSFPu8cYJTXHb48Lb818SGQ3IvkCghFeprwQaxA58tlKvIdovX0jAW7SRWk88o3jS8mR9chORa+u/8wgNJpDaKJlmfNZFbUZg65FvQMyCSh+K7Q5jUDO9mT4If6GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210659; c=relaxed/simple;
	bh=0Icyq7uzqxi5qQVo1boGpm6UdtagCtufGEwElTMD+uE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qht86GEQcQkF4tqvoRtHhgr4jijHNztPtHomdDITY7564pFOGECGjUS3TVJGR58gjZvNImaF0krwvdS0WDggojGZs6O/eJTLTmxNtxByDXXNwDkkf1eCZohMxE2upHc82L5efNYpZCj8TdGY5mitGQiTT5IQgHt5VNUS2Aab7Tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cABPWzrR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cABPWzrR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A395B1F000E9;
	Thu, 16 Jul 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210658;
	bh=tnH5rIg4RhglEKWXBpOrsPvat8ebnl/RLJ8UvZ8rUzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cABPWzrR9gAHe80dZ1naJQP7Ywu46y8VJqIIbeZIqF9wUqkSjZCqJZhy8FYm3opv7
	 DbNKrixrTSxb4ANEp1FyK//UncEB+DSSq7b31y2sLfXTwlzlVJRIj3nW5111+XxQHj
	 bpRB/hJABg5J9fXnwtgJYYhGGM9lVoFljQIaBE2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6.18 129/480] rust_binder: reject context manager self-transaction
Date: Thu, 16 Jul 2026 15:27:56 +0200
Message-ID: <20260716133047.500477531@linuxfoundation.org>
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

commit 6849cabfd30fb5727cfd31e8241e15801e17ebf9 upstream.

Rust binder resolved handle 0 to the context manager node, but it does not
reject the case where the caller owns the same node.

The C binder driver rejects transactions from the context-manager process
to handle 0 after resolving the target node. Match that behavior in Rust
Binder by rejecting handle 0 transactions when the resolved context-manager
node is owned by the calling process.

This applies to both synchronous and oneway transactions because both paths
resolve the target through Process::get_transaction_node().

Cc: stable <stable@kernel.org>
Fixes: eafedbc7c050 ("rust_binder: add Rust Binder driver")
Signed-off-by: Keshav Verma <iganschel@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260625103957.730-1-iganschel@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/process.rs |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/android/binder/process.rs
+++ b/drivers/android/binder/process.rs
@@ -873,7 +873,11 @@ impl Process {
     pub(crate) fn get_transaction_node(&self, handle: u32) -> BinderResult<NodeRef> {
         // When handle is zero, try to get the context manager.
         if handle == 0 {
-            Ok(self.ctx.get_manager_node(true)?)
+            let node_ref = self.ctx.get_manager_node(true)?;
+            if core::ptr::eq(self, &*node_ref.node.owner) {
+                return Err(EINVAL.into());
+            }
+            Ok(node_ref)
         } else {
             Ok(self.get_node_from_handle(handle, true)?)
         }


