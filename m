Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CC3912C462;
	Tue, 30 Apr 2024 10:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474366; cv=none; b=tHnXBnGJWh1J0mmPoE8UCI/vyNV+bXEUaITWO3ml0i8oodePuTf1Kfe1T1suYevbl0z3Hl308ORrtlne79qnpePr6VwdwqXjzWFL5FkxXVqjiaQZ3F2j6fxfwsVBFtjQX00Rnn23/upiT2KDVjNFAHHOzCpCnwXC/7C/64+alyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474366; c=relaxed/simple;
	bh=LYUvsh9nILT2+SkXpiOSDJAHNoXtRJLJ7COuFHTBJT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEYlarD1lbK8czlXSFglzpU3s74AE7NmcP4yAg9S9abf2yW2C/8bJbzadLKIYROqOKKvYjit5V9aLM+U2MzFDSNPpShbLfDexZQy7V6T4SEyiVq6uTJFLLjYzQgiMSewjA5DAW8W3r1H4T4ikReAGFd8/H5nxKlA1b+zF+nHiUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xb05J+Up; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xb05J+Up"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BD0C2BBFC;
	Tue, 30 Apr 2024 10:52:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474366;
	bh=LYUvsh9nILT2+SkXpiOSDJAHNoXtRJLJ7COuFHTBJT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xb05J+UpA1Dmlu7FTwgn/MjPK8SRhE5BGTOiTbVx1W0f9gU2UFdRn8W91G5+kSzM0
	 xtOb3YTcs4CJQEg6EUttFFOvVAogCLmYB7SSa/JX+pufzxQrpmNwK+82nGemnNeKom
	 aVzB2R+KRtw3Arr5jDzuBy5Gyyj11JbKl87ZRacM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.8 135/228] rust: kernel: require `Send` for `Module` implementations
Date: Tue, 30 Apr 2024 12:38:33 +0200
Message-ID: <20240430103107.697790011@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wedson Almeida Filho <walmeida@microsoft.com>

commit 323617f649c0966ad5e741e47e27e06d3a680d8f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/lib.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -66,7 +66,7 @@ const __LOG_PREFIX: &[u8] = b"rust_kerne
 /// The top level entrypoint to implementing a kernel module.
 ///
 /// For any teardown or cleanup operations, your type may implement [`Drop`].
-pub trait Module: Sized + Sync {
+pub trait Module: Sized + Sync + Send {
     /// Called at module initialization time.
     ///
     /// Use this method to perform whatever setup or registration your module


