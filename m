Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B554BEE54;
	Sat, 12 Sep 2026 07:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198366; cv=none; b=gjgUjlwVGi9EymckzBUfEz9d2CzQqPLlGY0aWmrWOrLCdb3IhMu+lqlZyBB41/qdLtPoSRwluQSSSF205z+Fz4+UCT+xhSHgeL/oQ9aFMz7aFaV2VwTBmy0+qlNLwVUwDObaUqcY5/3DQd+8jKLcfgpyazDXz2Eh3M0puI5w6tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198366; c=relaxed/simple;
	bh=usQUDHDPC5iE84Zrqp95Gl7VHpBa3gEM7ZUESp2lygg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClFIOZjFdgS2X6Zwz6KGqkJXRh5QCAPXHzRqFK+YsrpnvSD7MZuZ6uSA4MI5I+Khfj6wVF6BF9bIW9Ihwy6bhp/JmBXEyD+k+k2AtncBrHrpi7yA2kMFrKLB0wEy5vk1V1/YCKP1LoPAVoJOUU0qo7V4hvQaKn7RhLlch8rkbqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1wxWDeaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1wxWDeaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFBAE1F000FF;
	Sat, 12 Sep 2026 07:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198364;
	bh=+5ZuC2sxmV2kEIFuYXSwneFNmiPzn3GJf8pXbV3c+tM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1wxWDeaHR61gKwD9JmL+Xdn98QkHyAw21j1p5qkszQlMghkvnExp3NBOyD+NbYD3D
	 ZlN0GgjrcTMptSYDDHEbOaSMOmIlTg5wyY91Fr1aEe0CQyeDVhv6LvSO5Ga8Sd3LNp
	 BgWcVXDueOvMb1iA7sOOVUz0QqFSBq4IDFsE5Gxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0322/1815] usb: gadget: configfs: fix out-of-bounds read of qw_sign
Date: Sat, 12 Sep 2026 08:34:32 +0200
Message-ID: <20260912065656.494459094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 183a25f65ac89..dd6d6b11199e0 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1177,7 +1177,7 @@ static ssize_t os_desc_qw_sign_show(struct config_item *item, char *page)
 	struct gadget_info *gi = os_desc_item_to_gadget_info(item);
 	int res;
 
-	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN,
+	res = utf16s_to_utf8s((wchar_t *) gi->qw_sign, OS_STRING_QW_SIGN_LEN / 2,
 			      UTF16_LITTLE_ENDIAN, page, PAGE_SIZE - 1);
 	page[res++] = '\n';
 
@@ -1199,7 +1199,7 @@ static ssize_t os_desc_qw_sign_store(struct config_item *item, const char *page,
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



