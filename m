Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4891C3F
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1525C433C8;
	Tue, 18 Jul 2023 05:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689658102;
	bh=xI4obn244cY8Q+3uoNdU7rfmCYQDFQ/FNZ5BuI7JKb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ki79avhf+MFTmpgrn762d3n7YkOcX4RD6ODRBckw0ziZHddezjRCbKIOMR4bwmL4u
	 du/EL3U2xedsGeqmeMFAuKQjh/Ox1ZMTFNEnOdI/IvIcbdqFn6/emN/zjgaqMHKwuV
	 LEqfm+0AFHa8ARWPgZMsk0VTR64Gwnc0OFzy7w5GGcd/n+a4BNr7SSZ4JPhzx+JMty
	 e2a7iXsNCy4HqRPVmrSbvJ3ad58C2Bf6l5/s1NXO7I/x11/NxlTgR4UcCf4bwlA3UB
	 rkNRJvK/fBvMuz13D+25s6VAGm+so+BaZDPxr1QpY2RMvHmWHT8p1VFpev7et6pA4E
	 jlOjjsDW8thSA==
From: Miguel Ojeda <ojeda@kernel.org>
To: David Gow <davidgow@google.com>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <nmi@metaspace.dk>,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH v2 1/7] kunit: test-bug.h: include `stddef.h` for `NULL`
Date: Tue, 18 Jul 2023 07:27:46 +0200
Message-ID: <20230718052752.1045248-2-ojeda@kernel.org>
In-Reply-To: <20230718052752.1045248-1-ojeda@kernel.org>
References: <20230718052752.1045248-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The header uses `NULL` in both `CONFIG_KUNIT=y` and `=n` cases,
but does not include it explicitly.

When `CONFIG_KUNIT=y`, the header is already getting included via
the other headers, so it is not a problem for users.

However, when `CONFIG_KUNIT=n`, it is not, and thus a user could hit
a build error when including `kunit/test-bug.h`, like we are doing
later in this series [1].

Thus include `linux/stddef.h`, and do so outside the `#if`, since it
is used in both cases.

Reported-by: Boqun Feng <boqun.feng@gmail.com>
Closes: https://lore.kernel.org/rust-for-linux/ZJ8cNUW3oR2p+gL1@boqun-archlinux/ [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/kunit/test-bug.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/kunit/test-bug.h b/include/kunit/test-bug.h
index 30ca541b6ff2..47aa8f21ccce 100644
--- a/include/kunit/test-bug.h
+++ b/include/kunit/test-bug.h
@@ -9,6 +9,8 @@
 #ifndef _KUNIT_TEST_BUG_H
 #define _KUNIT_TEST_BUG_H
 
+#include <linux/stddef.h> /* for NULL */
+
 #if IS_ENABLED(CONFIG_KUNIT)
 
 #include <linux/jump_label.h> /* For static branch */
-- 
2.41.0

