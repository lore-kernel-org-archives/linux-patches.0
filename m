Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0762325FA29;
	Tue, 12 May 2026 18:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609131; cv=none; b=FJekyw+XinJvC/ajwK+quzTLwZEBcDsisKuKemMmZlX8tVkA4v6sPTehVqI0SWSyiE0Csj5mV/DpZh1C43Id6x4T8GWPd9t2PD43PzoDwVFSCMrx4Beckjd7Rr7kEADeq1NCtlpGdnKGj4WEa0w07LBly5ef3gpq/iGpeU9xOrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609131; c=relaxed/simple;
	bh=8q0Rh3BxTPuIlvgKr084CTxcnbgMRAUcN5Eigf0UH9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MyrIid143nAlfrbdWs2xg+ApqXqQdNDjxAjRWUcuiOoDxd9kpQEgjeXf2+PK/JuCerjK+7QErMLNq7+gzVGFd6cP4xFB7PsZh9PDpnz4F9w21EAcDR2lxP0rNasKODkNEZVxNLOzu9hKbh92AZSMz9A1Cl4UnPa1mriB6G5cUWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qfVgiaKp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qfVgiaKp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A16DC2BCB0;
	Tue, 12 May 2026 18:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609130;
	bh=8q0Rh3BxTPuIlvgKr084CTxcnbgMRAUcN5Eigf0UH9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qfVgiaKpTWLANVFFzs2wZmPSubLpYKHMf7zlZE2aVCuHduEWAqzX+vQtS23JeBwMD
	 Q7oMUSKQLmNUnFepuDz5oDFSuI8kix08dVTVVa1GM2RjWcdccc1RD7QLAN6GQjssHy
	 vGgKkr0v2D8Tqu7g9n0+7vpJTpfXGV2qjWEjRi34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.0 078/307] rust: allow `clippy::collapsible_match` globally
Date: Tue, 12 May 2026 19:37:53 +0200
Message-ID: <20260512173941.766198623@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -486,6 +486,7 @@ export rust_common_flags := --edition=20
 			    -Wclippy::as_ptr_cast_mut \
 			    -Wclippy::as_underscore \
 			    -Wclippy::cast_lossless \
+			    -Aclippy::collapsible_match \
 			    -Wclippy::ignored_unit_patterns \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \


