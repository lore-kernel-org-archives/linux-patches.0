Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE1B256C80;
	Fri,  7 Mar 2025 22:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387975; cv=none; b=Qyhsi85f+fAUyDD6txZTE4vY8b7r1bkwe54hTEqjB9FVALoNjZrxG6FtoY482APnpTo0RuqXDrtAIgscGwkGUDbLKPsCiScL80JkuVwrcwkLSayTdeDYmAOCc+Mffgah3GGQ1FFHEeuuw+4WajPgufY0iyRcLLUcdncFJ2d4iPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387975; c=relaxed/simple;
	bh=Sr9EAV2SOn5LxA4DnpC/+Fk/oDJ3B89Q8uapuVNmxbw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YDa/DFjr4DbeOL+O8/MEhcVtfn8PrWDUlIEuJXH/Iv9xTw6N9pnwV7HCqruRzj+Z0GDhqW1PKrVisYrlGvJXirCP2aZXt4RvZADKVbECwvui3g1HjN/fbUyRa3CXw4Qj4dUI66ji/ecdcYzs75wV24BAm9OcVHGIsFfESOWZlDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGHRghgM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGHRghgM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6533DC4CED1;
	Fri,  7 Mar 2025 22:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387974;
	bh=Sr9EAV2SOn5LxA4DnpC/+Fk/oDJ3B89Q8uapuVNmxbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGHRghgMaaqhvQBv9FOQiWbExmrhDXCQF0rv884M1OEosKFCF457X9smLNJIMytCe
	 8fh2Jo0t7kn52qOo96iUJgRwvGp0LXRo+3upIXqa7Wu7BNxvQPEz0pxIGlTONRdj7Y
	 1z5GNmNq2HEHce9DBaqM79RNQJjiapLwz0o1c75tKRZt16+w1Kzh5KbjzTtLcGN8BI
	 5cGvsUoKZgrqpUeZj1g5O0FVhVTx/E3aPPbggpP8yoNZYiBuC6+0vaIQSPCZt3pYhu
	 8TY1KhRKaCHH/SBkx7VjRXG5tzUH4cyDROt55CL2qXNeJpoK9fVEJSvid/ulVvpIQk
	 UWSAwBTEz1SMw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 51/60] drm/panic: prefer eliding lifetimes
Date: Fri,  7 Mar 2025 23:49:58 +0100
Message-ID: <20250307225008.779961-52-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
---
 drivers/gpu/drm/drm_panic_qr.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_panic_qr.rs b/drivers/gpu/drm/drm_panic_qr.rs
index ce245d6b9b91..f7e224ad340d 100644
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
-- 
2.48.1

