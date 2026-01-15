Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2BC33993;
	Thu, 15 Jan 2026 17:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497046; cv=none; b=JtnDf+ifW3PMsZc2rewvJ+2uhU0FRlJjasILiDx5vCpx+vP8Vo5Zz2G+jUL0S6kf89YQ3Vy7LYr+0pbLVRPfCdzywDFDmtLc6UnUZcNdZvIy580/oMyI5HWztxSlnnk4OY+3cX/b8V1wXzf/OsIALr/qm8dUKo61lCV7eJQnyqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497046; c=relaxed/simple;
	bh=t8M0B4vdnfep4V8bdxVMviH1d7aCyKFWFNr1oB/f4II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2lmP+Mtf38w1IhoNBAC1gON4cUyzp1srQOks1RS4UVw3V6zPcMvFfWNyhZpODQB8QDPGRznN5RvptpE1Udn+hurBw7r4UcjaG9axHZB1notNVC/pMCpy3h3ECM0n84CamNasQZHQ77Q1l+9KGMDyGa5PeybmRNtQiQXY4wnPz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8vLAbVz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8vLAbVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E72B7C116D0;
	Thu, 15 Jan 2026 17:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497046;
	bh=t8M0B4vdnfep4V8bdxVMviH1d7aCyKFWFNr1oB/f4II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8vLAbVziHVuXcops4bjw59Z0RYO9ZwsL7ISfCfhzfH50qP8u4XrnMbgmAQGDPFv1
	 iE0FOud7FAeraq45EGTRknjHZS6+5L1KrdO90b9lg3rhfOsz2jOqmkrhYflbELokhR
	 ghSp1ltgS7PAc+mGbJA8PIp+CgW2mRE2qAOj8lx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.1 05/72] lib/crypto: aes: Fix missing MMU protection for AES S-box
Date: Thu, 15 Jan 2026 17:48:15 +0100
Message-ID: <20260115164143.685907173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


