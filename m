Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C05F5C613;
	Wed, 10 Dec 2025 07:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352120; cv=none; b=gOLHLKiEA80vShWRrTvDKtHFMhxzsffqPAHT/LI4cYDm4YDU1HPAKUvF43k+8pzjZE4OrCS8XZDbYMUn5uMiLLh/xu1tgLGEDGDlZFc/oJIxsaF54JhEfjJKqDISy5tsgsJmenpJxhKi83CY0zAFYTfOO/nWyP4yCdupvhVrLww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352120; c=relaxed/simple;
	bh=PZxr3vIxMybNEYdA5Fp3jUXh4Nxjz6nSlJVQyqDLeM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OB2uNM3y+7gdOW/72BrmpEvthFTBF68Bfqzu97y4x+1fJaT0pbYJFSIhQZioFehssC760JNY0LTJxnzhBMh50a8Gty3tDE1zsyQLGh5niCNfqLFQfbS3QSzA2a5ul73+u/1yimiFozZm8yqCv1HqVhwF987Ami4pRYkoqZeqGy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QKBSVKg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QKBSVKg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF8BFC4CEF1;
	Wed, 10 Dec 2025 07:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352120;
	bh=PZxr3vIxMybNEYdA5Fp3jUXh4Nxjz6nSlJVQyqDLeM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QKBSVKg1fo7M3NaqAwwUeWoa3nXWOIjd63m5a8tATXwLRqxeWmXH/r1mWNw+FaNhA
	 8Kq1OazmRruETB7jkHHt8z1boIH7cZp2AgZmIaVDMVRaq+UeknkzoU8T7IVytFTkr/
	 At2RFOA0y2X2TUOThSl8RVTaKQ7q4B0atyWWbR8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.17 58/60] staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser
Date: Wed, 10 Dec 2025 16:30:28 +0900
Message-ID: <20251210072949.310348149@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
References: <20251210072947.850479903@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navaneeth K <knavaneeth786@gmail.com>

commit 154828bf9559b9c8421fc2f0d7f7f76b3683aaed upstream.

The Information Element (IE) parser rtw_get_ie() trusted the length
byte of each IE without validating that the IE body (len bytes after
the 2-byte header) fits inside the remaining frame buffer. A malformed
frame can advertise an IE length larger than the available data, causing
the parser to increment its pointer beyond the buffer end. This results
in out-of-bounds reads or, depending on the pattern, an infinite loop.

Fix by validating that (offset + 2 + len) does not exceed the limit
before accepting the IE or advancing to the next element.

This prevents OOB reads and ensures the parser terminates safely on
malformed frames.

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -140,22 +140,24 @@ u8 *rtw_get_ie(u8 *pbuf, signed int inde
 	signed int tmp, i;
 	u8 *p;
 
-	if (limit < 1)
+	if (limit < 2)
 		return NULL;
 
 	p = pbuf;
 	i = 0;
 	*len = 0;
-	while (1) {
+	while (i + 2 <= limit) {
+		tmp = *(p + 1);
+		if (i + 2 + tmp > limit)
+			break;
+
 		if (*p == index) {
-			*len = *(p + 1);
+			*len = tmp;
 			return p;
 		}
-		tmp = *(p + 1);
+
 		p += (tmp + 2);
 		i += (tmp + 2);
-		if (i >= limit)
-			break;
 	}
 	return NULL;
 }


