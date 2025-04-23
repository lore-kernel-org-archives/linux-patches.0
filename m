Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD48280A3C;
	Wed, 23 Apr 2025 14:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419976; cv=none; b=HcTtYx9WDVpwRfxUHIOVN0EL4jLmm2d43vLooFb/hIn5XKUYIQEdp2fBCOqsB4mU5oMTWLZGO8WZ+iSlyQIKwZUAFnV2NRM/m/5fbGBv1YJGJe1aiyN0bVWQXXvo1zwYelHg6AO1U15U2VKdLhtOZ45TN9kGnsWkdDSZz2rSZ3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419976; c=relaxed/simple;
	bh=gzp+a6IgUrcdlS1qy9uwdJyeY1Eipp4OVBMgo8wukmo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxb5SqpOawVuTe9iMS9d+kse0/jAYm7S4SlbnbS4sp/gZkT5a09rnJE1Wb/u+fmXtoWdnkcT7l1CZk6hhavsF21F86QDRoIbbmxGs1by5AsC0Tb6PnPcGCyvGKFCALoe3b90G6ogLbx9qkSB+QG4DrWolPXGmrT2l31aOeMnIEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veX2mCp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veX2mCp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E948C4CEE3;
	Wed, 23 Apr 2025 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419976;
	bh=gzp+a6IgUrcdlS1qy9uwdJyeY1Eipp4OVBMgo8wukmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=veX2mCp3w/+Z1er9zwLX+OweFgBrm8/TVulX6c/dK19y+1IsGv6bLPPbD90pdX0bq
	 mUX8UMzd0OqCmZzlaE1D4v1XGEvYSGdckmcXzcOO4lnpYuq2WTX5cq8Q+N/x2mIoK2
	 fCBdH6slJLjWpeP4VJ1kAfC17Mmkdm7YdwTms3xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 085/223] rust: disable `clippy::needless_continue`
Date: Wed, 23 Apr 2025 16:42:37 +0200
Message-ID: <20250423142620.586407794@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -455,7 +455,6 @@ export rust_common_flags := --edition=20
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
-			    -Wclippy::needless_continue \
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \


