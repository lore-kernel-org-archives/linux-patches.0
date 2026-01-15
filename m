Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4958E39B4BF;
	Thu, 15 Jan 2026 17:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496434; cv=none; b=UKo6315ctgJQP6baBPui9eywOqwHw/9tVifZ6Y1GAali3D6aGZmyjkxUDvkpvP3CEOxgctqm/LGqhOczJBO85hlIUvv/nUIcBGv/3tu4DoZBxxza3WE5ZGBkGXsOtbhNWe5J96gk9i8cK8QNGxGuGfFXWBtnm6vbupReQdF5Zlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496434; c=relaxed/simple;
	bh=5v+u0HwowQngyscIZtRmCNMhKWhdsts3kPYcG+WR2d4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hRs3RGDV+B1Refy7s0MZ2dVH5/ZMZ/uTbi3Jk4Ax74nS2XdvArR6oOIs02nQYoq0Cg6L6338+mgLgjQNYMIK6SzdVFdsT++LMlQiRpkHnrpr1du8HhXXn81plyNed9dWbTtL0bu/MxTo05b9ip6cUo/t7GaZNn6NXhfJJgUN0qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WtggF2Ms; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WtggF2Ms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C213CC116D0;
	Thu, 15 Jan 2026 17:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496434;
	bh=5v+u0HwowQngyscIZtRmCNMhKWhdsts3kPYcG+WR2d4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WtggF2MsbdgIxqBhgaRGbQOBKm1vo9vhiUzWldDEJPOQoafoaKzBqxtt5LyTFeEZA
	 GDkoeaawSDO3HTio5RZyAwNxbzhxxyWOTMjgFyXU8mwQw3hr4PxvQV8D7YdByGkxGS
	 yis/Df1IJFOMzNL8wzRfDw9AK/OAKH5XX12PTlCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.12 012/119] lib/crypto: aes: Fix missing MMU protection for AES S-box
Date: Thu, 15 Jan 2026 17:47:07 +0100
Message-ID: <20260115164152.405364208@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

commit 74d74bb78aeccc9edc10db216d6be121cf7ec176 upstream.

__cacheline_aligned puts the data in the ".data..cacheline_aligned"
section, which isn't marked read-only i.e. it doesn't receive MMU
protection.  Replace it with ____cacheline_aligned which does the right
thing and just aligns the data while keeping it in ".rodata".

Fixes: b5e0b032b6c3 ("crypto: aes - add generic time invariant AES cipher")
Cc: stable@vger.kernel.org
Reported-by: Qingfang Deng <dqfext@gmail.com>
Closes: https://lore.kernel.org/r/20260105074712.498-1-dqfext@gmail.com/
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Link: https://lore.kernel.org/r/20260107052023.174620-1-ebiggers@kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/crypto/aes.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/lib/crypto/aes.c
+++ b/lib/crypto/aes.c
@@ -12,7 +12,7 @@
  * Emit the sbox as volatile const to prevent the compiler from doing
  * constant folding on sbox references involving fixed indexes.
  */
-static volatile const u8 __cacheline_aligned aes_sbox[] = {
+static volatile const u8 ____cacheline_aligned aes_sbox[] = {
 	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
 	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
 	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
@@ -47,7 +47,7 @@ static volatile const u8 __cacheline_ali
 	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
 };
 
-static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
+static volatile const u8 ____cacheline_aligned aes_inv_sbox[] = {
 	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
 	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
 	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,


