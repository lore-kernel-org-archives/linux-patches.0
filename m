Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52B7C19E7FA;
	Thu, 15 Aug 2024 13:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728805; cv=none; b=eHeKYYAuveao8MIsFxGzV45qddDnVa+v7s/u5v2BVWFRPnSc0h/hggrjJ0Y4/Yvnu308EC3USXY8p+jdvKXITWq7gJWoiikTHesz3rj8+5iiLonybeQ1wi+lbCT40xqpZ6FIojQl0JDVPYen5HbwHtb0k4PkrxYXg++wiRvG+BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728805; c=relaxed/simple;
	bh=CMPSsIbh7fH7HXS4bvasSm9d2LN+XMhqgvtOBRiPP0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bKwjq4Q3gE74T+a8ZvHMtmUOgB3wFzqWIgiD9VrvRiXpAZHmCkIrUAtdJdVSV/u1Bec8e6IU7bm2Zcb59Vw4lNMiAaXHRRNkqZg+U4qtZkV1p0HcSCuNEh3br4Td3O4rJRPmrVlAQyAAL1iC0iKjTEkHamtYtUU5Rg1dELbQS0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYarmvsH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYarmvsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0612C32786;
	Thu, 15 Aug 2024 13:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728805;
	bh=CMPSsIbh7fH7HXS4bvasSm9d2LN+XMhqgvtOBRiPP0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYarmvsHK3LavPRPo9WNCAh5bN1tYXOEgdZPcdU6Hbi2inGIIXBt4pSvjLlJk974w
	 zpVcOs1r1u9J4FzoH2soZcWhF7lTDwAInwIN2RlTvZUddTit9D0FtNqyIddYMEJzt8
	 b5ZD2Aab/Hd41RTznzAXZapKG8czyA1LdVAjhL+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.19 084/196] decompress_bunzip2: fix rare decompression failure
Date: Thu, 15 Aug 2024 15:23:21 +0200
Message-ID: <20240815131855.295105292@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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


