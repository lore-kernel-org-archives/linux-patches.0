Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2E75757FC;
	Tue, 30 Jul 2024 16:44:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357875; cv=none; b=KUvSq4Egvl7osbDXUVPy7u7iQ/WrvOpsx2sF6OTPQhGekgrF1mt3HKdNl5XUxC6TTwmOt7yN8Fiysfscc9p9uUCh5NcWepe0+NQTfAdDsgA5jXRD8DIBg8kkVRjI7+cODqCkeuSjFnG93UjZVNkFwPKafvyvEk0gKPbOLr6WH3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357875; c=relaxed/simple;
	bh=xzlPXF8+KFW2Yi5Damgp5TCLmND3xA3cE9PW2W1fnss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HoAunHuaBC/Skn0EBjt8LCZRqCQR5+AEpH1glTNbiR1s/DTmTloQEj4iM+XCrBucL2okA0rCXSHLIu877AYZQ/2gQ/AYLUy3iKntZoFOUeC9HRyzhy3zDz7PNv1yz3tfHKvJfLvUXyBHrAeFDC/b5c9I3XJbF793R66uxZxY1jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsY3mxx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsY3mxx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7731FC32782;
	Tue, 30 Jul 2024 16:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357874;
	bh=xzlPXF8+KFW2Yi5Damgp5TCLmND3xA3cE9PW2W1fnss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsY3mxx26PyQkS+2EhbtUGwkaZ3WwbckES9SCcybdb9/VVVp1lQUGhqlKGtAUfFRc
	 cml/C+POvi1FyZudhlEbqZWNeLij8ooV2QfLBCDTdDP49+Ccul71O2qgJDtZKOX/5R
	 8+Jdth5hOfUGRsaaL2iUWhq7c7luCTtTLeAqg5SY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ross Lagerwall <ross.lagerwall@citrix.com>,
	Alain Knaff <alain@knaff.lu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 335/440] decompress_bunzip2: fix rare decompression failure
Date: Tue, 30 Jul 2024 17:49:28 +0200
Message-ID: <20240730151628.905244543@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


