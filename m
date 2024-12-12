Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50175215F48;
	Thu, 12 Dec 2024 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016066; cv=none; b=VkqQwfhyckINnQurj1UiRjMIWvt9h5E+dcoLn/hZf58Ej7G66e81CDwhP5zXIY8abY5zeg4tHRsbDaS4eHlzFAnSscrgDmAC1cS0zO6CeEsbFkqXgiyivRsEmejoMeSvwr5KDAnRRM+UlDFleB7X7sNKqORpQjEopBvaRH/dEEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016066; c=relaxed/simple;
	bh=wt/N8ZX5jjgo88VCUl6+z4njAmTe+AhVDWr10oQ2fmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJHgn+dqjoR19/BHB/s+7mHBHcoaNz7NvbcmgbsUEvp0siA9q5gHpDVSJ1yaYDlmhDYYVltRwLwBHfXcQxMw02K0b9jt5PGyrCUrjWoWO2PjJ8UJhvLCUwHtWfF8VImudZ2If2rP8zcCpW0pfpef+qtWvJ7bZZ2Ni/1JRqa198c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uu3NsvHO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uu3NsvHO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C7C4CECE;
	Thu, 12 Dec 2024 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016066;
	bh=wt/N8ZX5jjgo88VCUl6+z4njAmTe+AhVDWr10oQ2fmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uu3NsvHO/pNwGgFFaBJpyevz2TObh6r2GwExLoUr435gQgxJo8P4x6ZeKP5nGgmsj
	 tb592DEypck+zjOG8j8kyHWJ6VikiNZnuWfflX64pErgoHx6hikCSLYPO1h4YjC7MJ
	 Cf2EJmQWMk8fl5P/oniHTJbDHqcRvSFgoYguSgJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 121/466] rust: allow `clippy::needless_lifetimes`
Date: Thu, 12 Dec 2024 15:54:50 +0100
Message-ID: <20241212144311.588804118@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 60fc1e6750133620e404d40b93df5afe32e3e6c6 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -456,6 +456,7 @@ export rust_common_flags := --edition=20
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
+			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::dbg_macro
 


