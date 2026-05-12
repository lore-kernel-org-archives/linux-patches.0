Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464863955F9;
	Tue, 12 May 2026 17:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608564; cv=none; b=rX3UTQSAWQhUv7e2ucxKSOn6V69Chp+382TAgrOkSNORqG+otPcz17WDdqCRysG9fo7mpcjpp33IjwSO/Jzk4v+3e5QVdZEuld5Zt481YMZM2ufBwc/FopZ7iS2uGg2bmEHEHf7vR8mn4ITE/E5ugn3tuOZZEYTGyJUO7dtrC/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608564; c=relaxed/simple;
	bh=hW9PU1ujQt7fMMgCZ9uFPWB4iVE3Pz/zuYCg60T5cgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QBEgZzjx2I5qOa+JuKcJwEXwFt3laWJLr07z0WowgPUAaRcqgR+2Y406gzltJ7CYqfdbRRaKj2pdNw0vjsrg8t7/FaHNzOGiheVYX35Ay0+6kDAMTRLAGzYcUm8gnwGVg7RUQLzTOMqWsz9P4owbrj8U5C0GkdC+8OkDcHuMqfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2GmXwNF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2GmXwNF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F16C2BCB0;
	Tue, 12 May 2026 17:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608564;
	bh=hW9PU1ujQt7fMMgCZ9uFPWB4iVE3Pz/zuYCg60T5cgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2GmXwNFhu9enu2eRkxndi260PI9gayzesaobdzSRjcusT5QpZuI15Opq9I1IsNRH
	 +ReUQ5jFSoJMfrgiR+qWij4RsJnGnNlHJ0C9iJ2SqHqRMBnaBaX4cbjalzdJpjbXxp
	 DqByVC81UJY94SwwCnMBHc/VjyfXb5g0DluqdFcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.18 076/270] rust: allow `clippy::collapsible_match` globally
Date: Tue, 12 May 2026 19:37:57 +0200
Message-ID: <20260512173940.052376832@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -483,6 +483,7 @@ export rust_common_flags := --edition=20
 			    -Wclippy::as_ptr_cast_mut \
 			    -Wclippy::as_underscore \
 			    -Wclippy::cast_lossless \
+			    -Aclippy::collapsible_match \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \


