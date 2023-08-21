Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33BC01171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF93C433C7;
	Mon, 21 Aug 2023 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648225;
	bh=Jc0F6imRx6iuhSuwPHk2gJscSUX/TTHPAs2uzOeVCO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Bj3pZ+G6QOTN08Dp7hXM8bICzzydVM8/QCufgddHodWQQieQkNSPuiS6h7G3bUlS
	 DVgxkzWxZBnj/YKsMbgf7ZDJVG890fM/IFsvw5i7Q46EWRqy09CA98oky/UkYOqazl
	 9YfU9hCP2brghCNVEoi2LcByWSABy1DL/z1iL13k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingsong Chen <changxian.cqs@antgroup.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= <sergio.collado@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.4 092/234] rust: macros: vtable: fix `HAS_*` redefinition (`gen_const_name`)
Date: Mon, 21 Aug 2023 21:40:55 +0200
Message-ID: <20230821194132.869666160@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qingsong Chen <changxian.cqs@antgroup.com>

commit 3fa7187eceee11998f756481e45ce8c4f9d9dc48 upstream.

If we define the same function name twice in a trait (using `#[cfg]`),
the `vtable` macro will redefine its `gen_const_name`, e.g. this will
define `HAS_BAR` twice:

    #[vtable]
    pub trait Foo {
        #[cfg(CONFIG_X)]
        fn bar();

        #[cfg(not(CONFIG_X))]
        fn bar(x: usize);
    }

Fixes: b44becc5ee80 ("rust: macros: add `#[vtable]` proc macro")
Signed-off-by: Qingsong Chen <changxian.cqs@antgroup.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Sergio González Collado <sergio.collado@gmail.com>
Link: https://lore.kernel.org/r/20230808025404.2053471-1-changxian.cqs@antgroup.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/macros/vtable.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/macros/vtable.rs b/rust/macros/vtable.rs
index 34d5e7fb5768..ee06044fcd4f 100644
--- a/rust/macros/vtable.rs
+++ b/rust/macros/vtable.rs
@@ -74,6 +74,7 @@ pub(crate) fn vtable(_attr: TokenStream, ts: TokenStream) -> TokenStream {
                 const {gen_const_name}: bool = false;",
             )
             .unwrap();
+            consts.insert(gen_const_name);
         }
     } else {
         const_items = "const USE_VTABLE_ATTR: () = ();".to_owned();
-- 
2.41.0



