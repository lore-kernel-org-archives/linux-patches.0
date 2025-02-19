Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 188001EB1B7;
	Wed, 19 Feb 2025 08:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954306; cv=none; b=dqg2SNemP8jS47ryJWUkAwlvig02n8U5Rf1bq2ostpqPpwFSdHSonLQqswLArPiViiuX3T3QKRbaEBCkA4WtukDS95dPnEWqBN8tC5Y8B/EsLKwQgTSTMFE9fFmytZXV6I6J0usncPWfUBmWNqNnBA9AV9roIljDMD0tYkiK2Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954306; c=relaxed/simple;
	bh=SLniBlol/ROX692NE4piP/P6Ec8hEGcu3qPCMpO1VAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h/ItMkNyj6gcSzB1qWpuTUG5l7EpwB6nKN3wIvHcs+iSZXBd6dZH4d5nh+ick2jauBtdiN6gR+wl7y+Tgyd9ECRQTU9gIM+OkwyRfqKzypmYDa6dJVtddeA5/0q00PD9Hp2x/jaTkfkPd7japihbNDGSolb+6HrGGvA4WPse0Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UELw7wve; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UELw7wve"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BE91C4CED1;
	Wed, 19 Feb 2025 08:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954306;
	bh=SLniBlol/ROX692NE4piP/P6Ec8hEGcu3qPCMpO1VAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UELw7wveIp6D5DSOKc8vvkzVKtm7Ra20ey+cbPxnExuTZIuXmtoI2g+tbDEpzIc9W
	 Q7koAyw1xBa03CCsYCuUPAo2iCHuqOo1jvRThOu/XwdI/rnTiUwUu2LkJRJIpLrFwJ
	 8P55b8ykyGX790kjQQWIk3MVkJJrK/9YRkm35FBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yutaro Ohno <yutaro.ono.418@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.13 162/274] rust: rbtree: fix overindented list item
Date: Wed, 19 Feb 2025 09:26:56 +0100
Message-ID: <20250219082615.935009111@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 2e4f982cf392af2f1282b5537a72144e064799e3 upstream.

Starting with Rust 1.86.0 (to be released 2025-04-03), Clippy will have
a new lint, `doc_overindented_list_items` [1], which catches cases of
overindented list items.

The lint has been added by Yutaro Ohno, based on feedback from the kernel
[2] on a patch that fixed a similar case -- commit 0c5928deada1 ("rust:
block: fix formatting in GenDisk doc").

Clippy reports a few cases in the kernel, apart from the one already
fixed in the commit above. One is this one:

    error: doc list item overindented
        --> rust/kernel/rbtree.rs:1152:5
         |
    1152 | ///     null, it is a pointer to the root of the [`RBTree`].
         |     ^^^^ help: try using `  ` (2 spaces)
         |
         = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_overindented_list_items
         = note: `-D clippy::doc-overindented-list-items` implied by `-D warnings`
         = help: to override `-D warnings` add `#[allow(clippy::doc_overindented_list_items)]`

Thus clean it up.

Cc: Yutaro Ohno <yutaro.ono.418@gmail.com>
Cc: stable@vger.kernel.org # Needed in 6.12.y and 6.13.y only (Rust is pinned in older LTSs).
Fixes: a335e9591404 ("rust: rbtree: add `RBTree::entry`")
Link: https://github.com/rust-lang/rust-clippy/pull/13711 [1]
Link: https://github.com/rust-lang/rust-clippy/issues/13601 [2]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Yutaro Ohno <yutaro.ono.418@gmail.com>
Link: https://lore.kernel.org/r/20250206232022.599998-1-ojeda@kernel.org
[ There are a few other cases, so updated message. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/rbtree.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/rbtree.rs
+++ b/rust/kernel/rbtree.rs
@@ -1149,7 +1149,7 @@ pub struct VacantEntry<'a, K, V> {
 /// # Invariants
 /// - `parent` may be null if the new node becomes the root.
 /// - `child_field_of_parent` is a valid pointer to the left-child or right-child of `parent`. If `parent` is
-///     null, it is a pointer to the root of the [`RBTree`].
+///   null, it is a pointer to the root of the [`RBTree`].
 struct RawVacantEntry<'a, K, V> {
     rbtree: *mut RBTree<K, V>,
     /// The node that will become the parent of the new node if we insert one.


