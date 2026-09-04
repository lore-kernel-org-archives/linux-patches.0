Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA30D3B95FA;
	Fri,  4 Sep 2026 05:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500034; cv=none; b=bBY4GLBCFjH2gBaxc7y2+ysCxpv0oO932mZmXtagh/NZxvO5guYOdq5v9AoXSxrvRF3vEXcGzD+l9IFEkgT3t5IpaCg3zb019QTzfimQVu3Ugl4cnMe4O2CNCbzMdqrBrs+/+jXpRwYFBMZ6RVDsU+/SunfOy6HM7rRwYD44ljs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500034; c=relaxed/simple;
	bh=ujKpelvGaBmXg7ipCYBfhRcu9bYpzuQD3LJFnDOjxOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y7um/rbxzPQ6joxTj3sdIp+9WRPD5s0dBMmbRtEGfgikx1p/VUc00XtISaPKg+axyRf0dvbtY3nkRKMS/nQRNtvD3+TVQpHI4JeKtGe/g8ZTiCLctxBFcbZWgwm4s23ztXPQnAw2JyurfVUAHDk3kbCWRt1NDf+i3VvqDv8jddQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q4E+5czW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q4E+5czW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390371F00A3D;
	Fri,  4 Sep 2026 05:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500032;
	bh=NwqhDW1PvkHx4WVbFl/HNXOs+iRudJf/TKwV7tcwCZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q4E+5czWoJYXlkL+nNMHX+1J/OL2c9paDMrd9nfi4bkhf8gEnCnYgtL4TEAxyWMJ/
	 1d4wLCg2HEAID24IhO4RoIVS9Y6arfISWAboG/iLNkI4JUslQO0el/7PyHMe84VaoO
	 aihurX8TIosd+uqfBc3nQh7ltb/T713qfZfNQ5IM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 7.2 590/713] ipmi: ipmb: validate write message length
Date: Fri,  4 Sep 2026 06:59:18 +0200
Message-ID: <20260904045817.042862884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Yousef Alhouseen <alhouseenyousef@gmail.com>

commit 53637506884dbd5c91a89b1a3547d99d80f8ed2c upstream.

ipmb_write() read message fields before validating the length byte.

A zero or short write can read uninitialized stack bytes.

A length smaller than the SMBus header underflows the block write length.

Require a non-empty buffer and the minimum IPMB request length.

Also require the length byte plus payload before parsing the message.

Fixes: 51bd6f291583 ("Add support for IPMB driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
Message-ID: <20260624175353.8592-1-alhouseenyousef@gmail.com>
Signed-off-by: Corey Minyard <corey@minyard.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/ipmi/ipmb_dev_int.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/char/ipmi/ipmb_dev_int.c
+++ b/drivers/char/ipmi/ipmb_dev_int.c
@@ -141,13 +141,14 @@ static ssize_t ipmb_write(struct file *f
 	u8 msg[MAX_MSG_LEN];
 	ssize_t ret;
 
-	if (count > sizeof(msg))
+	if (!count || count > sizeof(msg))
 		return -EINVAL;
 
 	if (copy_from_user(&msg, buf, count))
 		return -EFAULT;
 
-	if (count < msg[0])
+	if (msg[IPMB_MSG_LEN_IDX] < IPMB_REQUEST_LEN_MIN ||
+	    count < (size_t)msg[IPMB_MSG_LEN_IDX] + 1)
 		return -EINVAL;
 
 	rq_sa = GET_7BIT_ADDR(msg[RQ_SA_8BIT_IDX]);


