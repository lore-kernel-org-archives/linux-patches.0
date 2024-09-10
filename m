Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31AFF199937;
	Tue, 10 Sep 2024 10:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963964; cv=none; b=r9AVtmdPrxTK+z3iiuqGnFkpZd8RYUXT506mwlEv9oNvyHvFL1HIr4RQlBCD5b4fps1Ofi0HYT8e1TqBvZXyPJ0ERs6H1zplr5Vffkq5qyjulIJEtePqyaKa7dWxSO1fPk7BSXS9IPmq6xQOxCPJl9k7bHb812tA04LGvUUyZHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963964; c=relaxed/simple;
	bh=zQ9P4GXKd59PRNsVeY99nDsy6mQiutWrKauWQFo1oS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=smH3aw4rFylFoWA4VXb8e3MuJs8bkG8zuKkWVDmkZAnq3NhhXpC8b8mbQlqT3719YnPk9KLigZMZizWnztoY3v1vohIT7QdneS9h0SmBco2rHXntMPgGgF0FFn5NzgsjxmDPeQLaF9nHNI7B7y7yfaFEtHMV3nkXsKOl3rYCSGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LqFUw5eo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LqFUw5eo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6BDC4CEC3;
	Tue, 10 Sep 2024 10:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963964;
	bh=zQ9P4GXKd59PRNsVeY99nDsy6mQiutWrKauWQFo1oS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LqFUw5eomiA1peuHZy1VgRfJxkWTIVFZCsNUAsXKnQt/c8iFYc4EjhDu+h5Jo7BZW
	 TpN1U3BbHG2nkOm+Ofwt6KuZ7cW79ohxe3NB51fwXhxPFQx42ZjrNT0B6xbDfNh64a
	 Q6EZV5wmlS+EVFJqFhuWmnSbkvW8Kd6BeAPlE5Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 021/269] rust: types: Make Opaque::get const
Date: Tue, 10 Sep 2024 11:30:08 +0200
Message-ID: <20240910092609.017359706@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boqun Feng <boqun.feng@gmail.com>

commit be2ca1e03965ffb214b6cbda0ffd84daeeb5f214 upstream.

To support a potential usage:

    static foo: Opaque<Foo> = ..; // Or defined in an extern block.

    ...

    fn bar() {
        let ptr = foo.get();
    }

`Opaque::get` need to be `const`, otherwise compiler will complain
because calls on statics are limited to const functions.

Also `Opaque::get` should be naturally `const` since it's a composition
of two `const` functions: `UnsafeCell::get` and `ptr::cast`.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Wedson Almeida Filho <walmeida@microsoft.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Link: https://lore.kernel.org/r/20240401214543.1242286-1-boqun.feng@gmail.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/types.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -248,7 +248,7 @@ impl<T> Opaque<T> {
     }
 
     /// Returns a raw pointer to the opaque data.
-    pub fn get(&self) -> *mut T {
+    pub const fn get(&self) -> *mut T {
         UnsafeCell::get(&self.value).cast::<T>()
     }
 


