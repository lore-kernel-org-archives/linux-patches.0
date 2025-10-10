Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC714231A30;
	Fri, 10 Oct 2025 17:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118268; cv=none; b=ETwHP8TcTUaUrxSRzVzJhQn3qgLzmmEUqjsKjwMgVeU4aVbByx5KMJLhWvEBnJFyiQTFhhvYrk5naHt1srgr+6fvKYPgYVRfZRMWfBmlh8wUWriicCLn0CzHr7vb6evnxJpFfXAisPSrW8ulqHJi9WeQ4yAt5CgxHQ5v+Atk9go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118268; c=relaxed/simple;
	bh=wZIygxQdT5DiLOau68Xpa/62K8oxbMttfztozN2k3NE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LXicn1OdPo3dmWEjGJHqvXiQ0vL3H5XxvKHBaUF0NSU4VYWfYgNzClVaFLK0wqokpftupx5TxntamXr7hvcjstwgkooDcooTuReLSQC5XenJYCm6GUcTK2P42LBWdDHH5OPvL/nmeirGldxGIJ6VD2g8ge8Rradtyv8jyn4Uig0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=asRYPEXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="asRYPEXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E481C4CEF1;
	Fri, 10 Oct 2025 17:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760118268;
	bh=wZIygxQdT5DiLOau68Xpa/62K8oxbMttfztozN2k3NE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=asRYPEXRzT1luNvkcZaBy21Pq50KVSDex9TSms/6xJ3w2+VFaZPMEZYh6RphuGtUA
	 N69H4XKEaLiYKcolZwEYq2UzpBzH10DNcICViMhopZOLWU0sujq2xjOXzIsnjHe06C
	 xlwzwOo0h8Bus+C5Q49FBi9jU/rXs2LAucGpSUMFJyQQnqU/RUy8HviGWOChntZDno
	 YMwBXKPQ8f2FK/CFf1pgQnIfyYKp3SOlVlyJevdvRETG4SomNVG+B+v7Uxkn7Im8df
	 0DrXsN5qiJfwxP6IKnL5BtdPPIs5VFiw+jJkZ01tJ4xGvHR2vn9/Al1JiZnan9dprw
	 3DWQkrGKbyQpw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Caleb Cartwright <caleb.cartwright@outlook.com>,
	Yacin Tmimi <yacintmimi@gmail.com>,
	Manish Goregaokar <manishsmail@gmail.com>,
	Deadbeef <ent3rm4n@gmail.com>,
	Cameron Steffen <cam.steffen94@gmail.com>,
	Jieyou Xu <jieyouxu@outlook.com>
Subject: [PATCH 1/3] docs: rust: add section on imports formatting
Date: Fri, 10 Oct 2025 19:43:49 +0200
Message-ID: <20251010174351.948650-2-ojeda@kernel.org>
In-Reply-To: <20251010174351.948650-1-ojeda@kernel.org>
References: <20251010174351.948650-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

`rustfmt`, by default, formats imports in a way that is prone to conflicts
while merging and rebasing, since in some cases it condenses several
items into the same line.

For instance, Linus mentioned [1] that the following case:

    use crate::{
        fmt,
        page::AsPageIter,
    };

is compressed by `rustfmt` into:

    use crate::{fmt, page::AsPageIter};

which is undesirable.

Similarly, `rustfmt` may put several items in the same line even if the
braces span already multiple lines, e.g.:

    use kernel::{
        acpi, c_str,
        device::{property, Core},
        of, platform,
    };

The options that control the formatting behavior around imports are
generally unstable, and `rustfmt` releases do not allow to use nightly
features, unlike the compiler and other Rust tooling [2].

For the moment, we can introduce a workaround to prevent `rustfmt`
from compressing the example above -- the "trailing empty comment":

    use crate::{
        fmt,
        page::AsPageIter, //
    };

which is reminiscent of the trailing comma behavior in other formatters.
We already used empty comments for formatting purposes in the past,
e.g. in commit b9b701fce49a ("rust: clarify the language unstable features
in use").

In addition, `rustfmt` actually reformats with a vertical layout (i.e. it
does not put two items in the same line) when seeing such a comment,
i.e. it doesn't just preserve the formatting, which is good in the sense
that we can use it to easily reformat some imports, since it matches
the style we generally want to have.

A Git merge driver would help (suggested by Gary and Wedson), though
maintainers would need to set it up, the diffs would still be larger
and the formatting rules for imports would remain hard to predict.

Thus document the style that we will follow in the coding guidelines
by introducing a new section and explain how the trailing empty comment
works there too.

We discussed the issue with upstream Rust in our usual Rust <-> Rust
for Linux meeting [3], and there have also been a few other discussions
in parallel in issues [4][5] and Zulip [6]. We will see what happens,
but upstream Rust has already created a subteam of `rustfmt` to try
to overcome the bandwidth issue [7], which is a good signal, and some
organization work has already started (e.g. tracking issues). We will
continue our discussions with them about it.

Cc: Caleb Cartwright <caleb.cartwright@outlook.com>
Cc: Yacin Tmimi <yacintmimi@gmail.com>
Cc: Manish Goregaokar <manishsmail@gmail.com>
Cc: Deadbeef <ent3rm4n@gmail.com>
Cc: Cameron Steffen <cam.steffen94@gmail.com>
Cc: Jieyou Xu <jieyouxu@outlook.com>
Link: https://lore.kernel.org/all/CAHk-=wgO7S_FZUSBbngG5vtejWOpzDfTTBkVvP3_yjJmFddbzA@mail.gmail.com/ [1]
Link: https://github.com/rust-lang/rustfmt/issues/4884 [2]
Link: https://hackmd.io/iSCyY3JTTz-g8YM-nnzTTA [3]
Link: https://github.com/rust-lang/rustfmt/issues/4991 [4]
Link: https://github.com/rust-lang/rustfmt/issues/3361 [5]
Link: https://rust-lang.zulipchat.com/#narrow/channel/392734-council/topic/rustfmt.20maintenance/near/543815381 [6]
Link: https://github.com/rust-lang/team/pull/2017 [7]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 75 ++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index 6ff9e754755d..3198be3a6d63 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -38,6 +38,81 @@ Like ``clang-format`` for the rest of the kernel, ``rustfmt`` works on
 individual files, and does not require a kernel configuration. Sometimes it may
 even work with broken code.
 
+Imports
+~~~~~~~
+
+``rustfmt``, by default, formats imports in a way that is prone to conflicts
+while merging and rebasing, since in some cases it condenses several items into
+the same line. For instance:
+
+.. code-block:: rust
+
+	// Do not use this style.
+	use crate::{
+	    example1,
+	    example2::{example3, example4, example5},
+	    example6, example7,
+	    example8::example9,
+	};
+
+Instead, the kernel uses a vertical layout that looks like this:
+
+.. code-block:: rust
+
+	use crate::{
+	    example1,
+	    example2::{
+	        example3,
+	        example4,
+	        example5, //
+	    },
+	    example6,
+	    example7,
+	    example8::example9, //
+	};
+
+That is, each item goes into its own line, and braces are used as soon as there
+is more than one item in a list.
+
+The trailing empty comment allows to preserve this formatting. Not only that,
+``rustfmt`` will actually reformat imports vertically when the empty comment is
+added. That is, it is possible to easily reformat the original example into the
+expected style by running ``rustfmt`` on an input like:
+
+.. code-block:: rust
+
+	// Do not use this style.
+	use crate::{
+	    example1,
+	    example2::{example3, example4, example5, //
+	    },
+	    example6, example7,
+	    example8::example9, //
+	};
+
+The trailing empty comment works for nested imports, as shown above, as well as
+for single item imports -- this can be useful to minimize diffs within patch
+series:
+
+.. code-block:: rust
+
+	use crate::{
+	    example1, //
+	};
+
+The trailing empty comment works in any of the lines within the braces, but it
+is preferred to keep it in the last item, since it is reminiscent of the
+trailing comma in other formatters. Sometimes it may be simpler to avoid moving
+the comment several times within a patch series due to changes in the list.
+
+There may be cases where exceptions may need to be made, i.e. none of this is
+a hard rule. There is also code that is not migrated to this style yet, but
+please do not introduce code in other styles.
+
+Eventually, the goal is to get ``rustfmt`` to support this formatting style (or
+a similar one) automatically in a stable release without requiring the trailing
+empty comment. Thus, at some point, the goal is to remove those comments.
+
 
 Comments
 --------
-- 
2.51.0

