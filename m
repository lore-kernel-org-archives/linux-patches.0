Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1D936A35E;
	Thu, 16 Jul 2026 13:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209341; cv=none; b=ajhqt3kueodmOHs36GOAeB8sdOyp2DYrhjJuePSDc2yP7zgOcoinjWTkvssgMlnGHajMp32eE5TaJiDMft1YRSyfVJrm1q1hU2hZcgwm687oV2C7kgt51g/2+RknZft1H5lWnZJqTuT8/xwx29f6Wy9Rnj7bufg9CBral+7Q6UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209341; c=relaxed/simple;
	bh=ARuwheOVLLqcGHUSeQueBPGHafAooZUw4w1Aha2n010=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dsW21Rsi+l1pCXf/UQhsq1Lfo7vM2Oj5ISUIqjSFB61TzKrAmslWT5Yo8MU9hVwcT0qd24UwL90SW+3FWqow0VMAB2IGRAyQCEAykke5Jrpv8F7PBCrX2dTD/QlSr3hvuKS0YY0qYEIy/h79ByHQTMVSjCodcVcARiWE0/gbuhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YR8OEpbe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YR8OEpbe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72E9A1F00A3F;
	Thu, 16 Jul 2026 13:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209339;
	bh=nzf4w9dFa0VIgNsRbzV4k0XTsBaPpIqT7uw19rqE/Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YR8OEpbevcBcVxLIVF9DIQrmDR/F3n7U8a5f0XkL3URPjONMDvinZpXDVc2aYBcuZ
	 HZ97l/xEWazgKhwNp2U1zIFDwIKtyORSAqDNQHvjTglg0ijiqXDRKOhiJ3XJisfG7Y
	 v9Edy1PkFl5rp6QSDU+KDbS5XQ4FdusrGgc4Epi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Keshav Verma <iganschel@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 7.1 121/518] rust_binder: reject context manager self-transaction
Date: Thu, 16 Jul 2026 15:26:29 +0200
Message-ID: <20260716133050.504364304@linuxfoundation.org>
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
@@ -900,7 +900,11 @@ impl Process {
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


