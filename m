Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2525C32FA3D;
	Fri,  9 Jan 2026 11:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959414; cv=none; b=kv7i7BH3DE4o732TFwz5eR5OEQxbWQUe74jCT4mc+EM6UFrpHZ2CxsmmxEjdehj74JvFiEjyXDy0kFnjje4i5e7/c1jlyjrDAhqiGzfOGcpZBR98B0CAq7cGorpFcW+qRueItXXIQUKXWJD9LhTH+wxtiSNcrM/iZrDb2GaZcwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959414; c=relaxed/simple;
	bh=zOpN+vQIZXeOLPe2Rk+wIGGxBmkfImZiaaf9hKRbR7A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ka8vtRu6NwFHHVbF2W/VCqVoRHVsnUzpPtDlqJdmKVOkcnsYkE+OtZHjzywsh6LsqBxgxuG5oi6pOcZc04czM7HVwGJr3B2w8GuDMUxSVjzYT08dmYawwNXwfI+sy3pnVZRytuQKaX3jmn3MT1IOXoiKHlBnofeCtYOno75CsV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l4Oldjw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l4Oldjw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6259FC4CEF1;
	Fri,  9 Jan 2026 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959413;
	bh=zOpN+vQIZXeOLPe2Rk+wIGGxBmkfImZiaaf9hKRbR7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l4Oldjw6dEqVwceHcYU3AlwN/fU5tgv0AKAVER09w8+A4cjOFulXOsROnxES4gxbK
	 UJzHqfCNKJVR0jwwgQq/3Bku8eSAolV/BUX3yW3/bNO5lKYhLCz8rtPhnEsBy3QS9g
	 LIQ8bc5snWFW5y1xvfS8vgCEj4Qb222NbaQg4N6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 044/737] staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser
Date: Fri,  9 Jan 2026 12:33:03 +0100
Message-ID: <20260109112135.652942233@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -139,22 +139,24 @@ u8 *rtw_get_ie(u8 *pbuf, signed int inde
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


