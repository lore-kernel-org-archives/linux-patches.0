Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E62212DC321;
	Sat, 12 Sep 2026 14:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223010; cv=none; b=FnDqAAytN1KtCy4vRp8AUrUg2AvO2XF8HhljCFMFUUmf1guWN2JKK2TItDqqJPebUNz1QvXONHDoBb6fe2f3h542H2EqHjmtevRfSEziig6YvcRI1ZYe3Nr1Jrmw0MAkEwiw9szpLZJkSrhBONQarZQbpdJKwXa2oTtRulb16lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223010; c=relaxed/simple;
	bh=wrF5p0sXRvDgP1+7mxS53edxEXZXirSk9gy5UHayyv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I7bLAXAvCeKoOTVCcqYtZGyl2sr/FQ+UB/HzmwbzEqFdKP1HY/t1kestMCAlMM5vHfWBpH4/7qs7bj9JcuojQwtZbxonW6x5tOZ6xn1VEcLp6gWangG09X1GsWKrLE2vy1KyjJGd38/ZEAq3PHfqHkcwJeMPdtGgBwrjgNolJQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAv1qbjF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAv1qbjF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8E661F000FF;
	Sat, 12 Sep 2026 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223008;
	bh=VutXDD758evjmFn/nea2U8GSYXK9gySAShs1Gj9caWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAv1qbjFj/izf61HV9fb0cCJgCLkbhSL0wpenwAPEqyu2oowF11privCqs5bCRFye
	 AFtZNuZltvyjlzKeC8a8Zs6d8GUBKlWrbkrMNxNm5UbK+K8YYU8rL+esylE+pErtwY
	 pELDr+xOSkK3zlSKgXSUeC2ox0lJrhbwcVbl+mTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0702/1424] usb: gadget: configfs: fix out-of-bounds read of qw_sign
Date: Sat, 12 Sep 2026 08:52:14 +0200
Message-ID: <20260912065623.019004840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit f63edb54d8f738f9c21e2068c777ae1c097df6b7 ]

os_desc_qw_sign_show() passes OS_STRING_QW_SIGN_LEN as the input
length to utf16s_to_utf8s(), but that argument counts UTF-16 code
units while OS_STRING_QW_SIGN_LEN (14) is the byte size of qw_sign[].
The array holds only OS_STRING_QW_SIGN_LEN / 2 (7) code units, so the
conversion reads up to 7 units (14 bytes) past the end of qw_sign[]
into the following members of struct gadget_info when the stored
signature fills the array without a NUL terminator, exposing those
bytes through the configfs attribute.

The store path halves the count for its input bound but passes the
full byte count as the utf8s_to_utf16s() output limit; use the
destination code-unit count in both directions.

Fixes: 76180d716f91 ("usb: gadget: configfs: make qw_sign attribute symmetric")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Link: https://patch.msgid.link/20260618005043.1581707-1-michael.bommarito@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 9e8af571448bf..75392bf7bd34c 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1174,7 +1174,7 @@ static ssize_t os_desc_qw_sign_show(struct config_item *item, char *page)
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res;
 
-	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN,
+	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN / 2,
 			      UTF16_LITTLE_ENDIAN, page, PAGE_SIZE - 1);
 	page[res++] = '\n';
 
@@ -1196,7 +1196,7 @@ static ssize_t os_desc_qw_sign_store(struct config_item *item, const char *page,
 	mutex_lock(&gi->lock);
 	res = utf8s_to_utf16s(page, l,
 			      UTF16_LITTLE_ENDIAN, (wchar_t *) gi->qw_sign,
-			      OS_STRING_QW_SIGN_LEN);
+			      OS_STRING_QW_SIGN_LEN / 2);
 	if (res > 0)
 		res = len;
 	mutex_unlock(&gi->lock);
-- 
2.53.0



