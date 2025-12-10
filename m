Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B70119CD06;
	Wed, 10 Dec 2025 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765352196; cv=none; b=YLyv99yuvJBlycAecealeQvG+weONd4QZN2vR/hUqyA0ZUmS8OITzKvhxxt7AhsujWHh7PJ49G5swURJIVMwqFFpSrgfpzopTvYKecKbErsXWZBV85tLhF7FBL6Z2McRQKJGyikY2gYxDdqoTGxcUsWv5v4R9OzLgBMevOdwI5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765352196; c=relaxed/simple;
	bh=x2Q6PGyRYAoNlsgkRbjGZ7ju1O5TzTRO7TjX4D8/mOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFSbSIMvuRnJussZ7KCZJyFVlfzzpoqEznCb1Y4YzZH9bSrTFYijcyG1dVeFLpMXUd2brt3FEywV+7Ag64a9Cooe5lBfBWtc0NnGHaVWziwbA/xeQQWD/6Q8wCVHktemMdm29zKqr+zMVIogZP2QRtyLBRJbcGvjHS7XtSSCSVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nmhkVdLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nmhkVdLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C789FC4CEF1;
	Wed, 10 Dec 2025 07:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765352196;
	bh=x2Q6PGyRYAoNlsgkRbjGZ7ju1O5TzTRO7TjX4D8/mOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nmhkVdLCFk5IsxtpPxW5HO5u/mNj5bbL+BM+hEaaw3Q+iadV8hH+mcMppQgH45PAt
	 DfVMSgeBdtUVINfg6x2EEJdY1LvzWcGmPBBnqXLvh+Ytm/0yok+jWG0L/vonSxvzKl
	 P8l7FOCyY0i2AN8JhMpWRnCL1ZTPLqSWpF7GLgsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.18 27/29] staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser
Date: Wed, 10 Dec 2025 16:30:37 +0900
Message-ID: <20251210072945.102463004@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
References: <20251210072944.363788552@linuxfoundation.org>
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


