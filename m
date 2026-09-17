Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B907D344DA2;
	Thu, 17 Sep 2026 15:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660108; cv=none; b=tOUMkF3XUcazRxNgF89hi8z4HV6XPRexL1g9z3ObxVZynfshZjpvM78nOnUl/yBYjyUc6NTvdya4iHsxd7s6/kBeG3vF8u+BDdsSs1sc4pDqBIxZbUBqyLn2z980vfom+533Kb/JD03Nmi0k05ioVwiO/aP/W2Hs842QBwHh5PA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660108; c=relaxed/simple;
	bh=0cJzacsb8r3iA9wtm01qzKfAJTzARHCqhWz0KdBrGPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qAyUavcIGsJu+NszhpljxlO3U0ZtdJTWoxpWrbNPhqKTsbtx3XQDtaxWiy6aSsVSPnJeWDeD34xIaTi1Dg+1zpwV4TfGgoxWPaL10N3obJmic+2fmx4KR9eYjAua2rbB2rAgaenAY3uvlpfSHu/uegkYE0j2L0mEkPrMZxJ1qGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfrpxH2n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfrpxH2n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067571F00893;
	Thu, 17 Sep 2026 15:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660100;
	bh=t+GVpjaZRNHOF89SQdy1m63z2bquQpGbprILhC81mXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JfrpxH2nC56rAfwFQ18jev/Kql2LWHdmo7gQYz1epFEaSBMP3teJzEEOxTp+HdYmP
	 1FqpGGi8YNwHOkF1ieQ2ukQz9UuQOkKij4HHj7hspN0Bg0LsvZ61OEjtti0Oemfta5
	 atTZkqKbIwMrp46sUj+kEUctLNgUpcwtcVLrpIzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Courbot <acourbot@nvidia.com>,
	Jocelyn Falempe <jfalempe@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.2 479/733] drm/panic: clean new `clippy::needless_range_loop` lint for Rust 1.100.0
Date: Thu, 17 Sep 2026 16:13:07 +0100
Message-ID: <20260917151403.948684741@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit 97f8cb91a8c5658fe2ae6f5c2ff6e95474a5eb2f upstream.

Starting with Rust 1.100.0 (expected 2026-11-12), Clippy warns:

    warning: the loop variable `i` is only used to index `self.decimals`
       --> drivers/gpu/drm/drm_panic_qr.rs:410:18
        |
    410 |         for i in 0..len {
        |                  ^^^^^^
        |
    note: for this index operation
       --> drivers/gpu/drm/drm_panic_qr.rs:411:13
        |
    411 |             self.decimals[i] = (chunk % 10) as u8;
        |             ^^^^^^^^^^^^^^^^
        = help: for further information visit https://rust-lang.github.io/rust-clippy/main/index.html#needless_range_loop
        = note: `-W clippy::needless-range-loop` implied by `-W clippy::all`
        = help: to override `-W clippy::all` add `#[allow(clippy::needless_range_loop)]`
    help: consider using an iterator
        |
    410 -         for i in 0..len {
    410 +         for <item> in self.decimals.iter_mut().take(len) {
        |

The lint did not trigger here before because it could not handle arrays
behind a field access such as `self.decimals` -- Clippy was improved to
catch those cases [1][2].

Thus clean the warning by iterating over a slice rather than using
`take()` so that an out-of-range `len` still triggers the same bounds
check as the indexed loop.

Cc: stable@vger.kernel.org # Needed in 6.18.y and later.
Link: https://github.com/rust-lang/rust-clippy/issues/16631 [1]
Link: https://github.com/rust-lang/rust-clippy/pull/16634 [2]
Assisted-by: LLM
Reviewed-by: Alexandre Courbot <acourbot@nvidia.com>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://patch.msgid.link/20260826145642.43807-1-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -407,8 +407,8 @@ impl DecFifo {
         for i in (0..self.len).rev() {
             self.decimals[i + len] = self.decimals[i];
         }
-        for i in 0..len {
-            self.decimals[i] = (chunk % 10) as u8;
+        for decimal in &mut self.decimals[..len] {
+            *decimal = (chunk % 10) as u8;
             chunk = div10(chunk);
         }
         self.len += len;


