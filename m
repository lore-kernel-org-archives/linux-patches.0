Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C872EAB82;
	Fri, 15 May 2026 15:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860537; cv=none; b=pm6NxLakKbW8ArZHtrM0NejJyPgzgc3b7puU4FZnn9xtrfC+qUxK0G4jJhTdu5iZJ46Ua3fs9//xhq19cmAg07dchAST8oavuMNwOR7oB8OpQusIc6jbi3AK9FST2X0GC+4iZV4rP5qe0jkSX41n16+i1+ewOt6OChYeg4uZIew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860537; c=relaxed/simple;
	bh=xUWqlAn5Uf22kKcDB5pPVdcQJAO54Fm8IaJ4jiN93Rc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V2Kt5GiHfoS50pccpLlp3MpG0cPpb9lLfXKdNmfqQbgGePOOo2ta8c13LAdk9G+459GpQefjLkj8BC2l6GWCghkL4RlqrKjFt2UGzj0G4g4D3YGRGVgMTv6meot22fKgdl9EHslQrLs10IKSApLYbRKojDnhFOMPy1zr1ZITZI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIXLlp8q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIXLlp8q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69C1BC2BCB0;
	Fri, 15 May 2026 15:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860536;
	bh=xUWqlAn5Uf22kKcDB5pPVdcQJAO54Fm8IaJ4jiN93Rc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIXLlp8q7ymHdbQnydJu2LDuyLRAov4+5g9QNCisPZvlTUQdLnPcCNLRoz/DMKW2w
	 5ZCTgdSLNxs++N8dX8KR4tRFwyrR8tSiMgNna5/SGdtxdeWrhGCJMT8dn7XN/GUol7
	 J7HnFxQ6bdeUWjBHX0l4+igMUU3+Y77kXfU2tfTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 127/144] rust: allow `clippy::collapsible_match` globally
Date: Fri, 15 May 2026 17:49:13 +0200
Message-ID: <20260515154656.455109117@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

commit 838d852da8503372f3a1779bfbd1ccb93153ab4e upstream.

The `clippy::collapsible_match` lint [1] can make code harder to read
in certain cases [2], e.g.

      CLIPPY P rust/libmacros.so - due to command line change
    warning: this `if` can be collapsed into the outer `match`
      --> rust/pin-init/internal/src/helpers.rs:91:17
       |
    91 | /                 if nesting == 1 {
    92 | |                     impl_generics.push(tt.clone());
    93 | |                     impl_generics.push(tt);
    94 | |                     skip_until_comma = false;
    95 | |                 }
       | |_________________^
       |
       = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#collapsible_match
       = note: `-W clippy::collapsible-match` implied by `-W clippy::all`
       = help: to override `-W clippy::all` add `#[allow(clippy::collapsible_match)]`
    help: collapse nested if block
       |
    90 ~             TokenTree::Punct(p) if skip_until_comma && p.as_char() == ','
    91 ~                 && nesting == 1 => {
    92 |                     impl_generics.push(tt.clone());
    93 |                     impl_generics.push(tt);
    94 |                     skip_until_comma = false;
    95 ~                 }
       |

The lint does not have much upside -- when the suggestion may be a good
one, it would still read fine when nested anyway. And it is the kind of
lint that may easily bias people to just apply the suggestion instead
of allowing it.

[ In addition, as Gary points out [3], the suggestion is also wrong [4] and
  in the process of being fixed [5], possibly for Rust 1.97.0:

  Link: https://lore.kernel.org/rust-for-linux/DI3YV94TH9I3.1SOHW51552497@garyguo.net/ [3]
  Link: https://github.com/rust-lang/rust-clippy/issues/16875 [4]
  Link: https://github.com/rust-lang/rust-clippy/pull/16878 [5]

    - Miguel ]

Thus just let developers decide on their own.

Cc: stable@vger.kernel.org # Needed in 6.12.y and later (Rust is pinned in older LTSs).
Link: https://rust-lang.github.io/rust-clippy/master/index.html#collapsible_match [1]
Link: https://lore.kernel.org/rust-for-linux/CANiq72nWYJna_hdFxjQCQZK6yJBrr1Mb86iKavivV0U0BgufeA@mail.gmail.com/ [2]
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260426144201.227108-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    1 +
 1 file changed, 1 insertion(+)

--- a/Makefile
+++ b/Makefile
@@ -453,6 +453,7 @@ export rust_common_flags := --edition=20
 			    -Wrust_2018_idioms \
 			    -Wunreachable_pub \
 			    -Wclippy::all \
+			    -Aclippy::collapsible_match \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \


