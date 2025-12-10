Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3999221F2F;
	Wed, 10 Dec 2025 07:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351962; cv=none; b=h756XQR8s4/iOGTOD2iQ3VRMglF7qaK0P8gHbacrfG7DN2t6++1eJpYRaKr3ooDrGVrbjZ0MNW7cFKsKCS/f0slzvdUAZYn/YwQvNrOobTKmvRhLLi3VGcU+agLlj8ZXtOPLHLpWvCuWpHVTwb+eRwxe2x4bC2PwB2zGUVmd+ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351962; c=relaxed/simple;
	bh=To7u7B92qt5SosqUisV3ywjVpPSNB+/6AP+JAx11P3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDLhz8w1EfLk74+vBRe69Tz+c+Bk/u3wlE/q17FEKz4R/4dgQmIbMUsnrrgubzxf0R8WO6myfJpdWl5EGvY/lpr6q7slVl1qkmNr87+k7CAZkwvHHArwMJZ2MjIWjbChdgKNrEV7fkfcHYsmiP0ck4SubCIE0vAi6tDbMloYhK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eZwzYU7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eZwzYU7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1E7CC4CEF1;
	Wed, 10 Dec 2025 07:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351962;
	bh=To7u7B92qt5SosqUisV3ywjVpPSNB+/6AP+JAx11P3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZwzYU7oH3VJ1ocpGZjj3khYJqcEjfugSy6nvxFEbbeHSNolTyHWA5P7ucRRTm/6Q
	 j9wBuUxJHvphRwEhcr9kljJmMOymSa3IjscWfdIRwls+imES71Ha1U3uU6BVyf8jo+
	 9Q0meHEbYiC5cAeRwUGtu3ULXO+xXhqTHF19A16Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.12 45/49] staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser
Date: Wed, 10 Dec 2025 16:30:15 +0900
Message-ID: <20251210072949.284753464@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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


