Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1DC3624C4;
	Thu, 15 Jan 2026 16:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495921; cv=none; b=Rzwl6VFAhIN+bwTQyId4ukofxG7Ww7rslg8EADw40dHj5cwyEmcRtL/48zzT0Q05oLZLbBOVflVTNMDWFBRNBgrQiLH49uKMJUKSPpR48n7duP/BnDXQ5rWmuxb00z1tjC2Y+Jaac2qfd4dIxhdrjlxOIfyIi4BWM3N/3yeaKmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495921; c=relaxed/simple;
	bh=v5d8kCVXLHGdtF8eUs4WvU0IkjQXkRE1ckWkOZmzEKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orHfXnxX7DXSZUQFhWxzFjXIoTH9ajdajcSCtP9LjLKQzUPOd9xZ4XXtr30CllWHLxKn+osiZZnnjL/bV+l4iJ45WPxdt98vSo41XR3IPSQO9ZMSXE8mCbSbtN8LVbFE9MBSw/16FIHe44uYgy/+gzw8ez0ft2lVU8VDrXytTWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5jaLHUW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5jaLHUW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EBB6C116D0;
	Thu, 15 Jan 2026 16:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495920;
	bh=v5d8kCVXLHGdtF8eUs4WvU0IkjQXkRE1ckWkOZmzEKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5jaLHUWPp/vCvX7LrTc6gKV4AI8O7UYccapzNah6QVqgdLexyKlaNolBJdSc63TE
	 mLMcy2sH5la8rh9R8xh026kkRIw3jVrzpVXMi7Ze95ObD3tiHuCyfHs5rUNan2Yhg1
	 HcySWGkt7vwzT7Gw3HhxEGkX7RWXzAQeZ41MYwJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingfang Deng <dqfext@gmail.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 6.18 015/181] lib/crypto: aes: Fix missing MMU protection for AES S-box
Date: Thu, 15 Jan 2026 17:45:52 +0100
Message-ID: <20260115164202.871887326@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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
@@ -13,7 +13,7 @@
  * Emit the sbox as volatile const to prevent the compiler from doing
  * constant folding on sbox references involving fixed indexes.
  */
-static volatile const u8 __cacheline_aligned aes_sbox[] = {
+static volatile const u8 ____cacheline_aligned aes_sbox[] = {
 	0x63, 0x7c, 0x77, 0x7b, 0xf2, 0x6b, 0x6f, 0xc5,
 	0x30, 0x01, 0x67, 0x2b, 0xfe, 0xd7, 0xab, 0x76,
 	0xca, 0x82, 0xc9, 0x7d, 0xfa, 0x59, 0x47, 0xf0,
@@ -48,7 +48,7 @@ static volatile const u8 __cacheline_ali
 	0x41, 0x99, 0x2d, 0x0f, 0xb0, 0x54, 0xbb, 0x16,
 };
 
-static volatile const u8 __cacheline_aligned aes_inv_sbox[] = {
+static volatile const u8 ____cacheline_aligned aes_inv_sbox[] = {
 	0x52, 0x09, 0x6a, 0xd5, 0x30, 0x36, 0xa5, 0x38,
 	0xbf, 0x40, 0xa3, 0x9e, 0x81, 0xf3, 0xd7, 0xfb,
 	0x7c, 0xe3, 0x39, 0x82, 0x9b, 0x2f, 0xff, 0x87,


