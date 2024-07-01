Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D8116F273;
	Mon,  1 Jul 2024 18:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859028; cv=none; b=NUi+c8btXLbstDLfCcogp0kndONB6xqdwsoQUV2yrPgjaVPHtCu/5WIdH2REOQEIoPkE7qqZz2CHIxG1l+Qs8FzbBQM4Ea1wZ7EnZ/is8hiAJKM8gs9fXQVRpAsOr4aPwD9ljbtr4zxhqyhTajq1JuitYC4N/utmQeW1qMkgwPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859028; c=relaxed/simple;
	bh=OMurDCisKjAllrHkCPJ/1qS7Xxemz+3k0gh+ghbhMAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SN+SzqsiZIl1ZnjLHFNp3Kv8RPkgm23H/TZ91vglF9L3u23QEiR+MKpywOr2oen1fsdxjjpG+aL/wjVLDomh8IZvNWNqBUNs4vVd2u7lRxkeAXNQlEtywpUDIA5Yh7SXjss61HfDsbw3bEIFpar/MdJKj+OjgiaSIVadfedkQAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GrZ6dsTs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GrZ6dsTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996A9C4AF0C;
	Mon,  1 Jul 2024 18:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859028;
	bh=OMurDCisKjAllrHkCPJ/1qS7Xxemz+3k0gh+ghbhMAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GrZ6dsTsVGz9WjzTPMaz73LfWAQDl6VlNpXXpqbAt9NmsT9eky7xzxvQWP5P7jHlm
	 T4J8BP3oIALDO5pHzU7//fOJQvYjbN7YxrBqropcGfuHzSvu5ESroSHBW84miKkiss
	 RmHon2B1YtjBZbPcJI3eckyX6irPYRuy7j0i61faR6Fk2vzuMpcWalSoC+p8P10RGL
	 In1cHf7KvtbluHaFWDHRBce01gwPbaUOV6ApFjgeuumySuTbG0ZskKbkNKELnJw4qB
	 tPQ1YNA/may9x2Mu7Fy8gCOR3WAE+U6BaoLjL+g0nqxqhvJUyYSwaMJxU98PvIgGqU
	 d22kAB2UIN6FQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas@fjasle.eu>,
	linux-kbuild@vger.kernel.org
Subject: [PATCH 05/13] rust: simplify Clippy warning flags set
Date: Mon,  1 Jul 2024 20:36:15 +0200
Message-ID: <20240701183625.665574-6-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All Clippy lint groups that we enable, except `correctness`, have a
default `warn` level, thus they may be removed now that we relaxed all
lints to `warn`.

Moreover, Clippy provides an `all` lint group that covers the groups
we enable by default. Thus just use `all` instead -- the only change is
that, if Clippy introduces a new lint group or splits an existing one,
we will cover that one automatically.

In addition, `let_unit_value` is in `style` since Rust 1.62.0, thus it
does not need to be enabled manually.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 056176a55d63..3f43f03f855e 100644
--- a/Makefile
+++ b/Makefile
@@ -465,10 +465,8 @@ export rust_common_flags := --edition=2021 \
 			    -Wunreachable_pub -Wnon_ascii_idents \
 			    -Wmissing_docs \
 			    -Wrustdoc::missing_crate_level_docs \
-			    -Wclippy::correctness -Wclippy::style \
-			    -Wclippy::suspicious -Wclippy::complexity \
-			    -Wclippy::perf \
-			    -Wclippy::let_unit_value -Wclippy::mut_mut \
+			    -Wclippy::all \
+			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
 			    -Wclippy::no_mangle_with_rust_abi \
-- 
2.45.2

