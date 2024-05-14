Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37A8C7FBD3;
	Tue, 14 May 2024 11:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686076; cv=none; b=P/JZj31eCmzQjyUs+wP1AjNB5JS/txxmFgut/PAvzZVMIb4yyjR4SVuMVgcXUYxgqHITHkzwiDRZIFh4EsMKYFpg5i7vBNuOvjGGlzlF5l4bkfExMI8yV98Alh+Mmo5BUzH+/zDc4Hhuz/MeEcWNSQ+qxmP7IsMsesnjwGw0kOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686076; c=relaxed/simple;
	bh=cyZXUTrZAFThX5iTo1lGQEoplI1okWO3rrdCDnpPnsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnBSltJ2pCocaxt5wC7uTXpmRfNcCUPHVzjdcBRrq5pAjS97F4DG66urht8naBPiw76CcnxzIzkpkKX1m6xuFCGi0O3DSMpc2vzULmRKCQ63yCh8aTeh9fWgZ4a4g0HYOqdDp1EApAOBE1Hj35MZ9baH7l7vpc+sWODuJsKNSgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vF5Vapno; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vF5Vapno"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38DCC2BD10;
	Tue, 14 May 2024 11:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686076;
	bh=cyZXUTrZAFThX5iTo1lGQEoplI1okWO3rrdCDnpPnsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vF5Vapnoo89KoHADS74W1YkdnuiEV7b5zeidHstaqPlkEbAWryV8lOIHGpFQTTuLx
	 ekFYUVxi1WpzMUpZKdXdp7YERKM5RzryuGWih1+8/7gJK17nintUKheKG/toWbF/1H
	 hac4SJICz4g2ed2y2cEVJtFrYbxLhsC6zYzuicfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/236] rust: kernel: require `Send` for `Module` implementations
Date: Tue, 14 May 2024 12:16:06 +0200
Message-ID: <20240514101020.493044334@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wedson Almeida Filho <walmeida@microsoft.com>

[ Upstream commit 323617f649c0966ad5e741e47e27e06d3a680d8f ]

The thread that calls the module initialisation code when a module is
loaded is not guaranteed [in fact, it is unlikely] to be the same one
that calls the module cleanup code on module unload, therefore, `Module`
implementations must be `Send` to account for them moving from one
thread to another implicitly.

Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Cc: stable@vger.kernel.org # 6.8.x: df70d04d5697: rust: phy: implement `Send` for `Registration`
Cc: stable@vger.kernel.org
Fixes: 247b365dc8dc ("rust: add `kernel` crate")
Link: https://lore.kernel.org/r/20240328195457.225001-3-wedsonaf@gmail.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index abd46261d3855..43cf5f6bde9c2 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -37,7 +37,7 @@
 /// The top level entrypoint to implementing a kernel module.
 ///
 /// For any teardown or cleanup operations, your type may implement [`Drop`].
-pub trait Module: Sized + Sync {
+pub trait Module: Sized + Sync + Send {
     /// Called at module initialization time.
     ///
     /// Use this method to perform whatever setup or registration your module
-- 
2.43.0



