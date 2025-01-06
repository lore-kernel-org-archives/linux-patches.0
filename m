Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11018635E;
	Mon,  6 Jan 2025 15:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736176997; cv=none; b=oCVeGw2czn+ihKQ4aSb5Iut+QaMxAUZ2JE1sfFeaGXW2oSM06seVnzuwPSsALHfuC2D75D0KEVURqpaplJfZ/X+Ypn11aLCdqbrFBJFe9zEuiQf4EiGQKj7Hf37IOFSpbsz0bkAsOz4KlWHc795kt7aWRe0MafkCQXsMBpZxX4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736176997; c=relaxed/simple;
	bh=tM8Bm91n3iFPmppzfaF7NRG5s6FfhJUKAfJHT0MS7CM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rMxYCckmfH5pq7snsOu+s0OFDHbxisHdTizo3DFb7wMRGGlveQG4BaNhivNseIx5i6iD/z6J0PQsNF60NOSPwablrZeLIY8bk+uGkM9W/+I0hDFWRPMNopcf/L+5L65fYDC/JO4wn5W5Q4adTM5ReNrV+jQwvXq7HXkVATgeSeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z3AQvD/l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z3AQvD/l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53652C4CED2;
	Mon,  6 Jan 2025 15:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736176996;
	bh=tM8Bm91n3iFPmppzfaF7NRG5s6FfhJUKAfJHT0MS7CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z3AQvD/lUnJPwmV9OW9l+HhFm6YfAWzOfkWaEhR6zo29kC+TmJGBZb3frCt6GiYSI
	 wM1E0VLBjdAgpXC3Nac/ier8NrNKfcWgfWAHByTG4NDC8VRa9/jr8p1V0HezCHWQPf
	 ZAr4WP6iu47dIekFHq8k2jWkbErZYz0yXEDGTqqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 017/222] rust: allow `clippy::needless_lifetimes`
Date: Mon,  6 Jan 2025 16:13:41 +0100
Message-ID: <20250106151151.253706204@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

[ Upstream commit 60fc1e6750133620e404d40b93df5afe32e3e6c6 ]

In beta Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
been extended [1] to suggest eliding `impl` lifetimes, e.g.

    error: the following explicit lifetimes could be elided: 'a
    --> rust/kernel/list.rs:647:6
        |
    647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
        |      ^^                                                                  ^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_lifetimes
        = note: `-D clippy::needless-lifetimes` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::needless_lifetimes)]`
    help: elide the lifetimes
        |
    647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
    647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'_, T, ID> {}

A possibility would have been to clean them -- the RFC patch [2] did
this, while asking if we wanted these cleanups. There is an open issue
[3] in Clippy about being able to differentiate some of the new cases,
e.g. those that do not involve introducing `'_`. Thus it seems others
feel similarly.

Thus, for the time being, we decided to `allow` the lint.

Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
Link: https://lore.kernel.org/rust-for-linux/20241012231300.397010-1-ojeda@kernel.org/ [2]
Link: https://github.com/rust-lang/rust-clippy/issues/13514 [3]
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20241116181538.369355-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 0be58613bfe0..31b4fc9f5ccb 100644
--- a/Makefile
+++ b/Makefile
@@ -469,6 +469,7 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::let_unit_value -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
+			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::dbg_macro
 
-- 
2.39.5



