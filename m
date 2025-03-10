Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43FFC226D0B;
	Mon, 10 Mar 2025 17:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627243; cv=none; b=STGq6yTIVuUyEg0jYETNzxv1Q9xISuFDOjFSoDnI08Cnuk1UvC4Q7h8RRobj6Yin9nu/ssJOhfB5gVxbmz7R+wS1nGRC6o+HjRhJvsHZnGL39lMx7jjDFhgTkX0dNML1NpU3a8WH51T+l/RZ8gJM9qO9yYtp1wz1iwkG4IwrQ4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627243; c=relaxed/simple;
	bh=vLURNjiyCLtxcV/XrfP/ruGIYNmRiE9D2of8WBb2KNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PrKrx+YzkRV2TkRDFbO/5OzeTqHCwM4Wj6aH6BO239rR+L7xDZ8YExLBDzzBTiX50hSBzvfUDwn1kGotW8E+/+51AzzjPY2xVfqtrIOgyHjLMjjGfAneie6enO1jbr/Ow2rl7U0mAWv7JexXLv59nhMZbvkMW/zs1LU5exQw2Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRtRrtAY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRtRrtAY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C275EC4CEE5;
	Mon, 10 Mar 2025 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627243;
	bh=vLURNjiyCLtxcV/XrfP/ruGIYNmRiE9D2of8WBb2KNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zRtRrtAYX65B2C7887ryZx8Yv6LO2iU8GLoz3zSId3+ugSXiTU+AmZoJoYsts12WX
	 9yW2Dmts+CatpIdIetISY0gF6g7XJbVXuQdvQOsCmYtcAIxgw/kG0CGTmNygQhjQHN
	 vVOxzc7is1NNc5J/yG3Nk12xRcKMepw9ys3ih5Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	=?UTF-8?q?Thomas=20B=C3=B6hler?= <witcher@wiredspace.de>,
	Jocelyn Falempe <jfalempe@redhat.com>
Subject: [PATCH 6.12 062/269] drm/panic: prefer eliding lifetimes
Date: Mon, 10 Mar 2025 18:03:35 +0100
Message-ID: <20250310170500.200378177@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Böhler <witcher@wiredspace.de>

commit ae75c40117b53ae3d91dfc9d0bf06984a079f044 upstream.

Eliding lifetimes when possible instead of specifying them directly is
both shorter and easier to read. Clippy notes this in the
`needless_lifetimes` lint:

    error: the following explicit lifetimes could be elided: 'b
       --> drivers/gpu/drm/drm_panic_qr.rs:479:16
        |
    479 |     fn new<'a, 'b>(segments: &[&Segment<'b>], data: &'a mut [u8]) -> Option<EncodedMsg<'a>> {
        |                ^^                       ^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_lifetimes
        = note: `-D clippy::needless-lifetimes` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::needless_lifetimes)]`
    help: elide the lifetimes
        |
    479 -     fn new<'a, 'b>(segments: &[&Segment<'b>], data: &'a mut [u8]) -> Option<EncodedMsg<'a>> {
    479 +     fn new<'a>(segments: &[&Segment<'_>], data: &'a mut [u8]) -> Option<EncodedMsg<'a>> {
        |

Remove the explicit lifetime annotation in favour of an elided lifetime.

Fixes: cb5164ac43d0 ("drm/panic: Add a QR code panic screen")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1123
Signed-off-by: Thomas Böhler <witcher@wiredspace.de>
Reviewed-by: Jocelyn Falempe <jfalempe@redhat.com>
Link: https://lore.kernel.org/r/20241019084048.22336-4-witcher@wiredspace.de
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_panic_qr.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/drm_panic_qr.rs
+++ b/drivers/gpu/drm/drm_panic_qr.rs
@@ -476,7 +476,7 @@ struct EncodedMsg<'a> {
 /// Data to be put in the QR code, with correct segment encoding, padding, and
 /// Error Code Correction.
 impl EncodedMsg<'_> {
-    fn new<'a, 'b>(segments: &[&Segment<'b>], data: &'a mut [u8]) -> Option<EncodedMsg<'a>> {
+    fn new<'a>(segments: &[&Segment<'_>], data: &'a mut [u8]) -> Option<EncodedMsg<'a>> {
         let version = Version::from_segments(segments)?;
         let ec_size = version.ec_size();
         let g1_blocks = version.g1_blocks();


