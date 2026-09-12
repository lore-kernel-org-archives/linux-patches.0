Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A900726ED46;
	Sat, 12 Sep 2026 19:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242465; cv=none; b=pMuKXUTHyD3smglH0Zg1luWi/E2YXFKhIdnXZhHJ4KEJXIA/D5YtrW+vlIMC47rca+Yo089SVi7X6vOBN5Kfih62TG4uXs3ogBMZ/B7lkjgXdhVD7FCxnq9GThqq6WA0/oTX8nWVvIaZNWlePkF0NObCckoE9Tq7hN0oKoD72OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242465; c=relaxed/simple;
	bh=qudaCTJpHwdOgWW3e7YuQxhMZxqJR+aK+Ol41t0sx8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3IC81nUNR4vornpeyLu4pwh6QcvqQEWqOriRMTHyD6LmgxMiGhPuRhLcVZZkD352+yvT8ZyU4HSfXeZv1gHzhQLgnUuk04aYih2MTUg4sPvS3fxy9OpdR8aCxVlY81lAuny5q0usVeYAN6HFV489KlyUAasxSogW0yHxkEfqvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mT1prLCY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mT1prLCY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040731F000FF;
	Sat, 12 Sep 2026 19:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242464;
	bh=c0zNXSl2pUGbe16IQ/VonAAjJUkhKAgH/JVyprXlkFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mT1prLCYTLxWN94ZM2R3uMTcycy6Af4CPJYj2HZmNhJtmpTXcuw72PU/+sw7Ha0S7
	 4KmmwY0C54PDvTfTEtnQnWdvFUMI6UGezxLUdUPLZEh9kRVwpxjwvv0j1bwyulMBWn
	 hhzMUxGs1LQS1u9ZoHou6tH2kTuuPRs6hvYPO1Ps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 412/798] usb: gadget: configfs: fix out-of-bounds read of qw_sign
Date: Sat, 12 Sep 2026 09:00:40 +0200
Message-ID: <20260912065526.594891360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 4256b1d09380f..e00762efd6da2 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -842,7 +842,7 @@ static ssize_t os_desc_qw_sign_show(struct config_item *item, char *page)
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res;
 
-	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN,
+	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN / 2,
 			      UTF16_LITTLE_ENDIAN, page, PAGE_SIZE - 1);
 	page[res++] = '\n';
 
@@ -864,7 +864,7 @@ static ssize_t os_desc_qw_sign_store(struct config_item *item, const char *page,
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



