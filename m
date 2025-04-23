Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C82028B518;
	Wed, 23 Apr 2025 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420693; cv=none; b=Z8uKltUqVKBBFjbw3F82qqiTR/bnTBocsGt/OlgBJdlGPdP6pRqPNyGZK4v+fG2zEk4xWKN175nnjxU32uyGAMbwMz4UliVO+iCrbAI8+LNWIoNcyi+40/BNy3i38e84Uwg7gJCrXHHXOElOht37BYaXgWRgtU3+b2b+dcvxIhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420693; c=relaxed/simple;
	bh=PC25LzY+o8yviPD7OW2JMthnHMltgKS6+FBrnIOgTVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aMiOdArt+C6dfYyKDUe5xDwlVWp5a1MIRQyTjSYAuWveCxY0lW5/1Fl3BhllCUGx7/xgjHooX/nkLhHlZtMCQJWenpjEhkit2US0ZS6wT/sJwvs73gqc4/jiSVBDqHwqCS8kBt1YMTLUnO6GSy5iRxFU6r1j3iTIJm/HtxOk1ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kd4u6y5k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kd4u6y5k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5F0C4CEE2;
	Wed, 23 Apr 2025 15:04:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420692;
	bh=PC25LzY+o8yviPD7OW2JMthnHMltgKS6+FBrnIOgTVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kd4u6y5kAYYS25W6LDR3n4/xyZZjimhX0vYUDuzPmn4L1lvP2LkSu7FWBnK11ha4D
	 zEX41Q/MeME4Y8hN6pLqLR1+wMqbIB6hFbzcHki8jUv0XEJTWYw/Z9jBJ6LtSsF3S/
	 dvSjybLq46bOXnoP+sk9Zm9G8OsvNnQG4quNS0W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.14 099/241] rust: disable `clippy::needless_continue`
Date: Wed, 23 Apr 2025 16:42:43 +0200
Message-ID: <20250423142624.622323835@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 0866ee8e50f017731b80891294c0edd0f5fcd0a9 upstream.

Starting with Rust 1.86.0, Clippy's `needless_continue` lint complains
about the last statement of a loop [1], including cases like:

    while ... {
        match ... {
            ... if ... => {
                ...
                return ...;
            }
            _ => continue,
        }
    }

as well as nested `match`es in a loop.

One solution is changing `continue` for `()` [2], but arguably using
`continue` shows the intent better when it is alone in an arm like that.

Moreover, I am not sure we want to force people to try to find other
ways to write the code either, in cases when that applies.

In addition, the help text does not really apply in the new cases the
lint has introduced, e.g. here one cannot simply "drop" the expression:

    warning: this `continue` expression is redundant
      --> rust/macros/helpers.rs:85:18
       |
    85 |             _ => continue,
       |                  ^^^^^^^^
       |
       = help: consider dropping the `continue` expression
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_continue
       = note: requested on the command line with `-W clippy::needless-continue`

The examples in the documentation do not show a case like this, either,
so the second "help" line does not help.

In addition, locally disabling the lint is not possible with `expect`,
since the behavior differs across versions. Using `allow` would be
possible, but, even then, an extra line just for this is a bit too much,
especially if there are other ways to satisfy the lint.

Finally, the lint is still in the "pedantic" category and disabled by
default by Clippy.

Thus disable the lint, at least for the time being.

Feedback was submitted to upstream Clippy, in case this can be improved
or perhaps the lint split into several [3].

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://github.com/rust-lang/rust-clippy/pull/13891 [1]
Link: https://lore.kernel.org/rust-for-linux/20250401221205.52381-1-ojeda@kernel.org/ [2]
Link: https://github.com/rust-lang/rust-clippy/issues/14536 [3]
Link: https://lore.kernel.org/r/20250403163805.67770-1-ojeda@kernel.org
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 -
 1 file changed, 1 deletion(-)

--- a/Makefile
+++ b/Makefile
@@ -480,7 +480,6 @@ export rust_common_flags := --edition=20
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
-			    -Wclippy::needless_continue \
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \


