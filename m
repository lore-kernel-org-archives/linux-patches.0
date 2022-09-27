Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E437333FB
	for <patches@lists.linux.dev>; Tue, 27 Sep 2022 15:32:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 284C9C433C1;
	Tue, 27 Sep 2022 15:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1664292741;
	bh=HnO17c79QWZdKEnu0tf8BfIuBm6ZnXghdoli6EdxWYY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HRp6BasLHPp12GKH64z8vC/L8a6gie5hI/aV8EtoNvtzxunxuSKZUUgJgvos2Zhsi
	 oKK8l0qp3abovT0zPXPyIvPYS0r7RDlYo481RUTphE+WmQq0PH3aOYWJomGRkN5wdS
	 4Ms/2skM942xIS5i4R9b9ulyyg5R9kzW2C7SuVN8=
Date: Tue, 27 Sep 2022 17:32:19 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@google.com>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>
Subject: Re: [PATCH v10 13/27] rust: export generated symbols
Message-ID: <YzMXgwsbWem2j7iG@kroah.com>
References: <20220927131518.30000-1-ojeda@kernel.org>
 <20220927131518.30000-14-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220927131518.30000-14-ojeda@kernel.org>

On Tue, Sep 27, 2022 at 03:14:44PM +0200, Miguel Ojeda wrote:
> All symbols are reexported reusing the `EXPORT_SYMBOL_GPL` macro
> from C. The lists of symbols are generated on the fly.
> 
> There are three main sets of symbols to distinguish:
> 
>   - The ones from the `core` and `alloc` crates (from the Rust
>     standard library). The code is licensed as Apache/MIT.
> 
>   - The ones from our abstractions in the `kernel` crate.
> 
>   - The helpers (already exported since they are not generated).
> 
> We export everything as GPL. This ensures we do not mistakenly
> expose GPL kernel symbols/features as non-GPL, even indirectly.
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Co-developed-by: Alex Gaynor <alex.gaynor@gmail.com>
> Signed-off-by: Alex Gaynor <alex.gaynor@gmail.com>
> Co-developed-by: Wedson Almeida Filho <wedsonaf@google.com>
> Signed-off-by: Wedson Almeida Filho <wedsonaf@google.com>
> Co-developed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
> Signed-off-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  rust/exports.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>  create mode 100644 rust/exports.c
> 
> diff --git a/rust/exports.c b/rust/exports.c
> new file mode 100644
> index 000000000000..bb7cc64cecd0
> --- /dev/null
> +++ b/rust/exports.c
> @@ -0,0 +1,21 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * A hack to export Rust symbols for loadable modules without having to redo
> + * the entire `include/linux/export.h` logic in Rust.
> + *
> + * This requires the Rust's new/future `v0` mangling scheme because the default
> + * one ("legacy") uses invalid characters for C identifiers (thus we cannot use
> + * the `EXPORT_SYMBOL_*` macros).
> + *
> + * All symbols are exported as GPL-only to guarantee no GPL-only feature is
> + * accidentally exposed.
> + */
> +
> +#include <linux/module.h>
> +
> +#define EXPORT_SYMBOL_RUST_GPL(sym) extern int sym; EXPORT_SYMBOL_GPL(sym)
> +
> +#include "exports_core_generated.h"
> +#include "exports_alloc_generated.h"
> +#include "exports_bindings_generated.h"
> +#include "exports_kernel_generated.h"
> -- 
> 2.37.3

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


