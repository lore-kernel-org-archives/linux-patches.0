Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11043F23D6;
	Tue, 17 Mar 2026 16:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766069; cv=none; b=YIto9DEq826jboXwH5jpL1xeH7QI6XFq985BRI5iSDWJ7o5uht0Kz4FYHlZhYU8IN3p7uGW7eeaejSD1v95g/oHAtNa+nOukgUNj3s5BKiZvkhHPs59ggxWk1Fr/M+s6je3AYC+qiSApACzA/PphXWlFbXZUlnX3KYGFohNlav4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766069; c=relaxed/simple;
	bh=qOyrNyDKxZio8MVevgqcTt8QgY5YiK22ZYXf/zwUylM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gjXi/HqA/lJdHOzUUtBT/map9ONEApqHSe4Sm4n2HoCrkZ/XciGagX044BRy9OTGTuFmouRd68XLXVulUr+EmN7sXW01OWugnmm18J+SqTKcH5n0RVEvXcQki39mg2WsimiMUGvnccmVeF0GsSA1vjFZdEhuwJKF+AZ41KkDk8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CTJqemwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTJqemwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E438C19424;
	Tue, 17 Mar 2026 16:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766068;
	bh=qOyrNyDKxZio8MVevgqcTt8QgY5YiK22ZYXf/zwUylM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTJqemwd15jKgPT8rS3FbC7xi5EPvexliXfXLMyXsqoelgYnY3vg7zsvzT/XhDUaD
	 j+qKkP2BXIiFW8bVqXd1Cp+Kc4tuQuCF0G/eJ7Eaw+yJb1qC1ZJdi5OMS9cb5KsRRI
	 BLWefiq6k+Y8lnx5zyEfOA3u8ZXw5FlbV2Oph3ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <lossin@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.19 130/378] rust: kbuild: allow `unused_features`
Date: Tue, 17 Mar 2026 17:31:27 +0100
Message-ID: <20260317163011.797146775@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 592c61f3bfceaa29f8275696bd67c3dfad7ef72e upstream.

Starting with the upcoming Rust 1.96.0 (to be released 2026-05-28),
`rustc` introduces the new lint `unused_features` [1], which warns [2]:

    warning: feature `used_with_arg` is declared but not used
     --> <crate attribute>:1:93
      |
    1 | #![feature(asm_const,asm_goto,arbitrary_self_types,lint_reasons,offset_of_nested,raw_ref_op,used_with_arg)]
      |                                                                                             ^^^^^^^^^^^^^
      |
      = note: `#[warn(unused_features)]` (part of `#[warn(unused)]`) on by default

The original goal of using `-Zcrate-attr` automatically was that there
is a consistent set of features enabled and managed globally for all
Rust kernel code (modulo exceptions like the `rust/` crated).

While we could require crates to enable features manually (even if we
still keep the `-Zallow-features=` list, i.e. removing the `-Zcrate-attr`
list), it is not really worth making all developers worry about it just
for a new lint.

The features are expected to eventually become stable anyway (most already
did), and thus having to remove features in every file that may use them
is not worth it either.

Thus just allow the new lint globally.

The lint actually existed for a long time, which is why `rustc` does
not complain about an unknown lint in the stable versions we support,
but it was "disabled" years ago [3], and now it was made to work again.

For extra context, the new implementation of the lint has already been
improved to avoid linting about features that became stable thanks to
Benno's report and the ensuing discussion [4] [5], but while that helps,
it is still the case that we may have features enabled that are not used
for one reason or another in a particular crate.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust/pull/152164 [1]
Link: https://github.com/Rust-for-Linux/pin-init/pull/114 [2]
Link: https://github.com/rust-lang/rust/issues/44232 [3]
Link: https://github.com/rust-lang/rust/issues/153523 [4]
Link: https://github.com/rust-lang/rust/pull/153610 [5]
Reviewed-by: Benno Lossin <lossin@kernel.org>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260312111014.74198-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -473,6 +473,7 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
 			    -Astable_features \
+			    -Aunused_features \
 			    -Dnon_ascii_idents \
 			    -Dunsafe_op_in_unsafe_fn \
 			    -Wmissing_docs \


