Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDFC315785;
	Sat, 12 Sep 2026 13:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789220809; cv=none; b=U0NYcPiNTVE0sBMdgKgvtuRhOOUhk9dXNwr+u7Ep0ChF5ExiLJc08f0MDYFkhLto0fQYqS5sg5AMh412euiVDNOgJHoM9fYwdIjOGd+G/3wcSJrDVcxKA9QGNjX+49lBi8KWH9H9x5h+gBtfRVVksRUYknBv0RlfTK2S7EEsfl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789220809; c=relaxed/simple;
	bh=aZur4STV+0Sakhbx5tTE3+m4otcgBrUhQvDRzt7BhyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGun6dn9vezVIZVz+pdcyFB9Y1Z3xTmLmiSWhENMZj4p0KqILVyvudY/J/cMq9mGf/u/1P6tJKQZ7OIPElgRmmgYuRH83wUiIrMhkDIwhaTLPdRUh6CzDaqWASPlon4BeuVk1BkpcTLggMgtI8Eaz32QgRLwONo/9CgzfsCozfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AMR8ykjP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AMR8ykjP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69E231F000FF;
	Sat, 12 Sep 2026 13:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789220806;
	bh=puaV6d83zrDC1zX9eAOLQV8uAqx2yEKVvb9VJQr7HE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMR8ykjPucczq3yam4FIw/5GzYFaGggxdqjUG6iZEY2/4InWErSt6DHt7etdPA4R3
	 X1wrCIeJ+UmmphPiPSGPxwFMGEyoqtn8JwJTDAcfTHO5ylWKymaOHr/ItELIkGV3hY
	 ZDA1iekg5PrJq1g2MrV5vsCfnxW9fzFW6zOaWGMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yousef Alhouseen <alhouseenyousef@gmail.com>,
	Corey Minyard <corey@minyard.net>
Subject: [PATCH 6.6 0251/1424] ipmi: ipmb: validate write message length
Date: Sat, 12 Sep 2026 08:44:43 +0200
Message-ID: <20260912065612.900015140@linuxfoundation.org>
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


