Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77CF5315785;
	Mon,  4 May 2026 14:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904383; cv=none; b=By1aZmbWW9CkSJtQNiacA9jvT4b3T1fvp5ErECf1sk4l5RE2JiaN7a7A1nu9dpE5X8FU/QgUbdZng8AEKVG3cM6ZB5sw00K/syWR3Se+AIqh3UZfV1fLF/qfcInus3agbZbpbgWUHLe9TVnsZdpFC49pE9soS+wPm6nTr3bJNsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904383; c=relaxed/simple;
	bh=zU1jOws7vpwhazwW/zcaTiZoOn+HKRqKZQ6pWN8GtS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s2Qd46216bg7i1+hnjrE87WQYLj9rVrMs2eKHYXl36BFd2zSYuAf8SXGMNZudce55wwle+bqm2aZdHCZeMCj91UEFy4nPMEEXJPRlpfV3lt8q66wwiTsmSm35i96w5oDuBO8wgHFO6E9NDx5FhDc7k1XmmgqgpajQNWQXkFxu4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gbatHP+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gbatHP+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6BAC2BCF4;
	Mon,  4 May 2026 14:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904383;
	bh=zU1jOws7vpwhazwW/zcaTiZoOn+HKRqKZQ6pWN8GtS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gbatHP+OqjeYh9x+srUmvjpfwUu4DOR/hTk13n+ciVKk5X3/OQ2q1eu9QMPJgJo4z
	 wdPhRI9Ey0/EeNvwWWKZ/cFV9CIIuYJsx2+pKjxhxhROnexuUsLA4blWg4fhyyS1vV
	 iLrJly4EEO+tcQcg3iWqV4M2IwtoDS3wC8FZV9Sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 018/215] kbuild: rust: allow `clippy::uninlined_format_args`
Date: Mon,  4 May 2026 15:50:37 +0200
Message-ID: <20260504135130.840131480@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 10eea3c147141c90cf409b8df56d245c9d7f88d9 upstream.

Clippy in Rust 1.88.0 (only) reports [1]:

    warning: variables can be used directly in the `format!` string
       --> rust/macros/module.rs:112:23
        |
    112 |         let content = format!("{param}:{content}", param = param, content = content);
        |                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#uninlined_format_args
        = note: `-W clippy::uninlined-format-args` implied by `-W clippy::all`
        = help: to override `-W clippy::all` add `#[allow(clippy::uninlined_format_args)]`
    help: change this to
        |
    112 -         let content = format!("{param}:{content}", param = param, content = content);
    112 +         let content = format!("{param}:{content}");

    warning: variables can be used directly in the `format!` string
       --> rust/macros/module.rs:198:14
        |
    198 |         t => panic!("Unsupported parameter type {}", t),
        |              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#uninlined_format_args
        = note: `-W clippy::uninlined-format-args` implied by `-W clippy::all`
        = help: to override `-W clippy::all` add `#[allow(clippy::uninlined_format_args)]`
    help: change this to
        |
    198 -         t => panic!("Unsupported parameter type {}", t),
    198 +         t => panic!("Unsupported parameter type {t}"),
        |

The reason it only triggers in that version is that the lint was moved
from `pedantic` to `style` in Rust 1.88.0 and then back to `pedantic`
in Rust 1.89.0 [2][3].

In the first case, the suggestion is fair and a pure simplification, thus
we will clean it up separately.

To keep the behavior the same across all versions, and since the lint
does not work for all macros (e.g. custom ones like `pr_info!`), disable
it globally.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://lore.kernel.org/rust-for-linux/CANiq72=drAtf3y_DZ-2o4jb6Az9J3Yj4QYwWnbRui4sm4AJD3Q@mail.gmail.com/ [1]
Link: https://github.com/rust-lang/rust-clippy/pull/15287 [2]
Link: https://github.com/rust-lang/rust-clippy/issues/15151 [3]
Link: https://patch.msgid.link/20260331205849.498295-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -459,6 +459,7 @@ export rust_common_flags := --edition=20
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
+			    -Aclippy::uninlined_format_args \
 			    -Wclippy::unnecessary_safety_comment \
 			    -Wclippy::unnecessary_safety_doc \
 			    -Wrustdoc::missing_crate_level_docs \


