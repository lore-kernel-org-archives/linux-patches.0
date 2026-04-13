Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1804724E4A1;
	Mon, 13 Apr 2026 16:39:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098370; cv=none; b=gHqKoTYhf6z4QC4ewx/nuwo3bJ4wxpoaNe+GFAevaWSlZEEqozKAkl1oZPIWqvXF5/WDpy3z9tAdTwPKott83XWon/3beFl2keP142ni8pjNwTGMxOWNKyN00UUw1oyhrrvfKcnntrhqGvySQB8gtLB+sddEkdUCD2v8V1B1lCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098370; c=relaxed/simple;
	bh=vqSABUnmZpBrJ5KENaDpwHszqTSN1hCnFCTRON2MAmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CYnddNripL6SvDQbS+8QIlhLqY2B6JQWjm9K0vckPJAj+elAv4+QQvT0xUdt8Sn9k/ANbGLDwf1CvRA3GWnygZ0vc0+1Ozx6Y/GTk1bAr4HnBdVvNpTvief3tRr3PilU7l9jmeN1Rka06WgV3Wu9FpEUWnwK/dnWX7grI1FfLjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOvLpeyF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOvLpeyF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F87EC2BCAF;
	Mon, 13 Apr 2026 16:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098370;
	bh=vqSABUnmZpBrJ5KENaDpwHszqTSN1hCnFCTRON2MAmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOvLpeyFQJfpaet0NKRQ9doeVYfFjarcUhWJj88+DR11Ji/X58PT6w9S/RgVmp4At
	 xyePBfARKyFx1EFc7uFov/rj8qvp5i7BB805lcupLgCd2ZzSNC8dBBv6Fgt6DDEpKw
	 cNjwd+oYDl8ECRfsQqUZt5iC3DZCmifatkAnBKEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Navaneeth K <knavaneeth786@gmail.com>,
	stable <stable@kernel.org>,
	Johnny Hao <johnny_haocn@sina.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/570] staging: rtl8723bs: fix out-of-bounds read in rtw_get_ie() parser
Date: Mon, 13 Apr 2026 18:00:29 +0200
Message-ID: <20260413155849.111618916@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Navaneeth K <knavaneeth786@gmail.com>

[ Upstream commit 154828bf9559b9c8421fc2f0d7f7f76b3683aaed ]

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

[ The context change is due to the commit 4610e57a7d2e
("staging: rtl8723bs: Remove redundant else branches.") in v5.19
which is irrelevant to the logic of this patch. ]

Signed-off-by: Navaneeth K <knavaneeth786@gmail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Johnny Hao <johnny_haocn@sina.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_ieee80211.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
index c01f7da9d025c..666ce2f9c5270 100644
--- a/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ieee80211.c
@@ -141,23 +141,24 @@ u8 *rtw_get_ie(u8 *pbuf, signed int index, signed int *len, signed int limit)
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
 		} else {
-			tmp = *(p + 1);
 			p += (tmp + 2);
 			i += (tmp + 2);
 		}
-		if (i >= limit)
-			break;
 	}
 	return NULL;
 }
-- 
2.53.0



