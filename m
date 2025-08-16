Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EFB3176FB;
	Sat, 16 Aug 2025 21:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755378143; cv=none; b=BNr4FIU2Zp9Yer/xjunC9y7z/arKas4pToxGsXYLzIVYV99rGJvA+9y0EOJTJZWzQhPP8zhwPinc2EJHYkp2fV0mrXgpxJTy73qVmKPNglTqhh/8JKNoPFE0ex94NfjdFU/VmDPlFmU2SS2mUtJRQDn254YW/s1OtgJ17h0CDWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755378143; c=relaxed/simple;
	bh=LPy5e6n6vR1llHOo2EO24oNety9Sy0DZL4/9aZBMZcA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UcZ2rFO+AkX6IDTQsF7nWz+NA9FpzIsAAre7O/y+u0WP15Si90nfJemlYPvs0p5IN1qmC/1X559X6iGJfv2vM19jXUB9zrUV35fgfeE+E7+F2DCqQu/mwjKMbPycMnhoi/hbvqiJF9yD5s8rpRrSyFbTkG3K7i8GG5cD3GJrW84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b7ZG2hNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b7ZG2hNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F43BC4CEEF;
	Sat, 16 Aug 2025 21:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755378142;
	bh=LPy5e6n6vR1llHOo2EO24oNety9Sy0DZL4/9aZBMZcA=;
	h=From:To:Cc:Subject:Date:From;
	b=b7ZG2hNvVEGsmVZGqFok2B5Ut3JlrhAm0TEb5kcPlq+2FoXEJJwCdOWjPw+OogiC4
	 vHZCCukv1MT5BZzVgAvQpzjkjzrx49nFqAhLInIGTnQFFDtEJulmp5F3v9RW3DwBYq
	 I81Ytc7XJgOdOp8G3SYBA5d8WbeLC+ycWpljp3efVXzvpeZsg2g7cYT33UxaZequeo
	 5zji+Z6frzPsKCjU/n36YsCIIiFxREQJza/yFLhnvDW7qysKMCoahLpV+LOXJZj1gG
	 CwSpw7Ou6R42UU0F3yPH6duyny1UyTixAS91hV8UNblX97rHL3Of/wYXXgQuiIJHFy
	 q1czCwufE8txA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vitaly Wool <vitaly.wool@konsulko.se>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org,
	Vlastimil Babka <vbabka@suse.cz>,
	Uladzislau Rezki <urezki@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: alloc: fix missing import needed for `rusttest`
Date: Sat, 16 Aug 2025 23:02:14 +0200
Message-ID: <20250816210214.2729269-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a missing import of `NumaNode` that is used in the `rusttest`
target:

    error[E0412]: cannot find type `NumaNode` in this scope
      --> rust/kernel/alloc/allocator_test.rs:43:15
       |
    43 |         _nid: NumaNode,
       |               ^^^^^^^^ not found in this scope
       |
    help: consider importing this struct
       |
    12 + use crate::alloc::NumaNode;
       |

Thus fix it by adding it.

Fixes: 8405eafa6e94 ("rust: add support for NUMA ids in allocations")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
akpm: please feel free to rebase this into the patch directly if that is
simpler/preferred.

We are looking into removing this file, possibly this cycle, so it is
not a big deal but meanwhile it would be nice to keep the branch clean
nevertheless.

 rust/kernel/alloc/allocator_test.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index 283c02376458..13435ef8e652 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -9,7 +9,7 @@

 #![allow(missing_docs)]

-use super::{flags::*, AllocError, Allocator, Flags};
+use super::{flags::*, AllocError, Allocator, Flags, NumaNode};
 use core::alloc::Layout;
 use core::cmp;
 use core::ptr;
--
2.50.1
