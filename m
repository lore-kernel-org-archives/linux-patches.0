Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CDA329CE6;
	Thu, 15 Aug 2024 14:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731385; cv=none; b=KaNo5EAcy8J4LEDAYa/6F1/3liCzveapMVs1X9qDTjkoq66eIX9nuUvg4D2i9iaeBckrec29SAmM0WowydOjwCNtoDKuBnnfKyk2bOp1Bb+wc+MFNGMSA6MUJBDiBMo2oXfq4GUqxESLLw3Cn7UK6mlYqiduKtj8SkbdpbvboHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731385; c=relaxed/simple;
	bh=5Fmckj8cS0tJ8Vkb4T2QJ9lyK6KRQQwU3DObVyEptuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PVaN0gsj0rePvy2Bfbr69+Ck/do2R0rLmc4Mj8tbcRX4z1zNcUxnfg0r32ybbythdTEQOSf2FpbVb8b0myLh96uEvvmWg/vArggipIAfRxQ7Pu34f9gLQCG7HXB653tvMapk6xrQ+Fs90kGOPhSNP4c4FdQ04sAn9MJdnMxGdPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aapxsAB6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aapxsAB6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE877C32786;
	Thu, 15 Aug 2024 14:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731385;
	bh=5Fmckj8cS0tJ8Vkb4T2QJ9lyK6KRQQwU3DObVyEptuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aapxsAB62lRIRMgKM0wc/X8xuypSlI87+wkzItOCGABAoGjXDRIAAGv+8r0nmVu8S
	 3v60LJWmwU+fLLoNcp9Env76C3CCxMz2Ilnu2eLdcbHFuhFEUCmk7Ljv9irbeWc9Hq
	 mhQzrSBdX9CXdte1BySwJYiae6rNACPlcJJpuSzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.4 113/259] decompress_bunzip2: fix rare decompression failure
Date: Thu, 15 Aug 2024 15:24:06 +0200
Message-ID: <20240815131907.164524576@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit bf6acd5d16057d7accbbb1bf7dc6d8c56eeb4ecc upstream.

The decompression code parses a huffman tree and counts the number of
symbols for a given bit length.  In rare cases, there may be >= 256
symbols with a given bit length, causing the unsigned char to overflow.
This causes a decompression failure later when the code tries and fails to
find the bit length for a given symbol.

Since the maximum number of symbols is 258, use unsigned short instead.

Link: https://lkml.kernel.org/r/20240717162016.1514077-1-ross.lagerwall@citrix.com
Fixes: bc22c17e12c1 ("bzip2/lzma: library support for gzip, bzip2 and lzma decompression")
Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Cc: Alain Knaff <alain@knaff.lu>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/decompress_bunzip2.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/lib/decompress_bunzip2.c
+++ b/lib/decompress_bunzip2.c
@@ -232,7 +232,8 @@ static int INIT get_next_block(struct bu
 	   RUNB) */
 	symCount = symTotal+2;
 	for (j = 0; j < groupCount; j++) {
-		unsigned char length[MAX_SYMBOLS], temp[MAX_HUFCODE_BITS+1];
+		unsigned char length[MAX_SYMBOLS];
+		unsigned short temp[MAX_HUFCODE_BITS+1];
 		int	minLen,	maxLen, pp;
 		/* Read Huffman code lengths for each symbol.  They're
 		   stored in a way similar to mtf; record a starting


