Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F072594BD;
	Sat, 12 Sep 2026 16:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229366; cv=none; b=QC91CGwT+0G9jakT70xQxHRDGEbug6UsGkGgLgxgRUrYnfQX5T/cv/DSFFCCg0PvAgSEc7fKQGy1v5+Ok/eAE5GV2siS4CBS5Mwr9O3NblpLtFpAFFl7AtZdclAoT4sfsGdiXRMqnOQ1V/CbD6axMLOlfxnocG+M457ixjatkbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229366; c=relaxed/simple;
	bh=9ZE3y6MmUQ9uXhKgH/I6f9DY5AH6N8y1Ws+3I2bpg2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwA9WJPn5eltBLiz7rn+Cz2hhlhCOI9iuKpUKJaZF+XOLeijOzLnrhsc8l/8r5Az5stXg5V4sWOiR0n+EWz1Twqf27+9aMM8tdv/GZkY1s1B+VIGQ15I+PgNONPPUQhib9XPYMKB49MAHXFdzA6QK3ZNVWwYZD3WbF3VL2374QQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHztCFSw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHztCFSw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 109BD1F000FF;
	Sat, 12 Sep 2026 16:09:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229365;
	bh=QQm8wmHzS3oF/23L2VlIOmRSXKQ9uwoy3/9hd714MCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHztCFSwhDrvGB092D3ueOsik1+ZAsVLa8OJ/ybHoGm40nTH43Jk1Jg8jIBHpFl17
	 GfwM4K/L0b9tn1py1Es9d++Hdc25hrbzTrr2EPNAk6Ib+5Zk7i07vQpe73eF9ZMNnO
	 GSje+sy2n7r+hm3MIh0ciB1MaXeqW3bS8Tca5b84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0575/1191] usb: gadget: configfs: fix out-of-bounds read of qw_sign
Date: Sat, 12 Sep 2026 08:55:03 +0200
Message-ID: <20260912065601.160583826@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index f55dcc3a40184..723454292b734 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -849,7 +849,7 @@ static ssize_t os_desc_qw_sign_show(struct config_item *item, char *page)
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res;
 
-	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN,
+	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN / 2,
 			      UTF16_LITTLE_ENDIAN, page, PAGE_SIZE - 1);
 	page[res++] = '\n';
 
@@ -871,7 +871,7 @@ static ssize_t os_desc_qw_sign_store(struct config_item *item, const char *page,
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



