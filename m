Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CA44189BB1;
	Tue, 30 Jul 2024 17:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359191; cv=none; b=IAZ+vEybzCOG8f9Og8qedKgD7dFgkI/4WU3NhmgZ6BU6Bxw9Pba878sirzA5hoM63rHW4iu3k4sxAclI0DdAEADpkBvfC35sg7wr7lzicOKrGaYmqYPDuHaG7Zh5IobtAuFanzwUeFyD483pnicbvAxOv6Q4+TWhYmHX5tSbXnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359191; c=relaxed/simple;
	bh=UslgiwE6+vRNT3kRGgHUolgIyM2qRrEv4kaWc7t+r3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y81bUbwOecc2d0td/DpT5kqt2b5PJtH4OHthRMmgZEzlqMB0gphuXSvEQVgQ6C/NO2OMHfw84U/CUwSnN0dnRpR2AVFm3X6wdX4bDmETYaYId2F/7a6Br7AWGVEbNH9svA7gqBq90XzY2mJguxlea7vSN5/GTGQTwn6/dF0ELmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jSQ2kdh2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSQ2kdh2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9ED3DC4AF0E;
	Tue, 30 Jul 2024 17:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359191;
	bh=UslgiwE6+vRNT3kRGgHUolgIyM2qRrEv4kaWc7t+r3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSQ2kdh2UdY08Pw6/Y4Pwqgd3Rhsb8ITU/UOrQUUPSUbkKiLYd7bO3J94TvqRCT1v
	 0iPZ2CeEHTowIYPRyx+XIvtKnNSBX4X0CMlFgG/o+l2umshmaBzi0qL2qS8NsWoP0w
	 MaQH08bLaodJUA93QwLEGgWPEbocaRaIT/D3Wrd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 445/568] decompress_bunzip2: fix rare decompression failure
Date: Tue, 30 Jul 2024 17:49:12 +0200
Message-ID: <20240730151657.264040515@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


