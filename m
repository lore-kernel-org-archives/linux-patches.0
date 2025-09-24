Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D32BEC3F;
	Wed, 24 Sep 2025 13:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758719120; cv=none; b=CYkP6t0Cq9HgXir3WVZHpgSw93VGbBwdhSJRBHI8854bk1cFHa5o0ioTuG2SMAz+ON8TF6o9Q9jRK+xO85lyI1OjCwzhy+AiDXTDYXoZ6eZ+H8ccOK4Ih8WRwlMHlKF+qyMVH+9dRGda9FieOp5KGTOmwNt8qQrjPb/0lMH5MIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758719120; c=relaxed/simple;
	bh=VCX+bPfmwlJvBV7ggmKNCWRg6wq0qGc1Q2G3C6b5A/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=neumqbKInx47OGda+JFC809UP6axI6z1yRqDTSiepHCR/zK5sd4v6bmk3SkV5486UnMIxq/yo/n2y/oR4BemMLoL7qRcGlEyTELTUccWG50KaTOZia/rsOEycQn5eI84jRRmBF4i0NKZBxqBwYedTe1sgvHZEJmp7nNhAjZVMgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ARF5q5Wz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ARF5q5Wz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11903C4CEE7;
	Wed, 24 Sep 2025 13:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758719119;
	bh=VCX+bPfmwlJvBV7ggmKNCWRg6wq0qGc1Q2G3C6b5A/E=;
	h=From:To:Cc:Subject:Date:From;
	b=ARF5q5WzwiuyaUFaEoSou6ctzP7E4nF5eyRnlqj6VLFle+rDWgffKO016PLtS/ESQ
	 9X4fhwo4LBqdYLk7RLwGGP27y3rkckG/koLu0muI4lCSkYpO5xdOuV7/yjDa2pN+T3
	 KvwBj3watBpB7uOMR762xPG7VqUqwETHezMpBFnW+YMs9etYS/kbLiNJvMs8L9SNr/
	 IksOxs44f2gXaZKz1EGQVeNFqL7j2Qx9BgGppfLE5m1eMBqjg2eF3GSkvK88Uv/y6a
	 vBMJJBLiRXQ1me4N2ddhRt9arXM9q6gHJ2bGi1xUJZa1cq/j9b/HAASglr5qroFUu1
	 K0OGeVvfjFGnA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alice Ryhl <aliceryhl@google.com>
Cc: =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
	Todd Kjos <tkjos@android.com>,
	Martijn Coenen <maco@android.com>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Christian Brauner <christian@brauner.io>,
	Carlos Llamas <cmllamas@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH] rust_binder: clean `clippy::mem_replace_with_default` warning
Date: Wed, 24 Sep 2025 15:05:10 +0200
Message-ID: <20250924130510.752115-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clippy reports:

    error: replacing a value of type `T` with `T::default()` is better expressed using `core::mem::take`
       --> drivers/android/binder/node.rs:690:32
        |
    690 |             _unused_capacity = mem::replace(&mut inner.freeze_list, KVVec::new());
        |                                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ help: consider using: `core::mem::take(&mut inner.freeze_list)`
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#mem_replace_with_default
        = note: `-D clippy::mem-replace-with-default` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::mem_replace_with_default)]`

The suggestion seems fine, thus apply it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
I noticed this in next-20250923 after cleaning another error. Greg,
please feel free to rebase the fix in place (or not). Thanks!

 drivers/android/binder/node.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/android/binder/node.rs b/drivers/android/binder/node.rs
index ade895ef791e..08d362deaf61 100644
--- a/drivers/android/binder/node.rs
+++ b/drivers/android/binder/node.rs
@@ -687,7 +687,7 @@ pub(crate) fn remove_freeze_listener(&self, p: &Arc<Process>) {
             );
         }
         if inner.freeze_list.is_empty() {
-            _unused_capacity = mem::replace(&mut inner.freeze_list, KVVec::new());
+            _unused_capacity = mem::take(&mut inner.freeze_list);
         }
     }


base-commit: eafedbc7c050c44744fbdf80bdf3315e860b7513
--
2.51.0
