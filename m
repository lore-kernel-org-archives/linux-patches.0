Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60DBC30567C;
	Thu, 30 Jul 2026 15:20:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424844; cv=none; b=AnRbeJtGESIEBxCX3z8OzqRSJwhdi0vsCDYgYpMf1PmXtbGdnJ3TdKO81p/j3mdTPOIefN3kKBTgtGahNI2u+xWiotNtLSwWSoDlRuJyEbmU/hTRMncz551jFD1+wzcsJnf5Yo4Ov/liYuktq4eZ00li9n8I9KORb0h/XqNjUKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424844; c=relaxed/simple;
	bh=xjAh5yuqgdnq5170o7JRDo6cvhVxMoei++4Hf3cRim0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QuWtl1E9ECRy9GWqhBTmnDpWfECDiZevmd7FNMY96orsXveha3infr//QlDM5puIXizndMfH3ND3m55ksSwrEYPJExDDBYl0FGNyQYiwmEZgePKFDC3h6Kh1EBT97lSS+bOQ6DCic4cF5Zd+GgW3VoLnFTOtW5svSZxfna4APGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kkzPTI3P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kkzPTI3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5A0A1F000E9;
	Thu, 30 Jul 2026 15:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424843;
	bh=amBCMxFEBoZMM6H738Y1aHRbleyIoK3KsL4aNEs2F1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkzPTI3POQqeMiRi1UIUG/ICBUW/PU2jS4JTqXZLGmzH5miLd1FZ5BfM/3vZkWTJA
	 8qLUHDXmN88QrxNeSqy1RHGYhNUQGd8iYgxnXc8CHlu01UEwqw0QvlQ3Gn+AokIgRX
	 6c3Uir6SQoM/D+7Mw9IYwHD0VlIUASYpgGj7ESJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungmin Kang <726ksm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 535/675] net: slip: serialize receive against buffer reallocation
Date: Thu, 30 Jul 2026 16:14:25 +0200
Message-ID: <20260730141456.512909491@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Sungmin Kang <726ksm@gmail.com>

commit ee7f9bb9320add61f7b367d7e6cd55e3a3a4d65d upstream.

sl_realloc_bufs() replaces rbuff and updates buffsize while holding
sl->lock. slip_receive_buf() reads those fields and writes through rbuff
without holding the lock.

An MTU change can therefore race with receive processing. An MTU shrink
can expose the new smaller rbuff with the old larger bound, causing an
out-of-bounds write. A receive callback which already loaded the old
rbuff can instead continue writing after that buffer has been freed.

Serialize receive processing with sl_realloc_bufs() by holding sl->lock
while consuming each receive batch.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Sungmin Kang <726ksm@gmail.com>
Link: https://patch.msgid.link/20260718073631.1674-1-726ksm@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/slip/slip.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/slip/slip.c
+++ b/drivers/net/slip/slip.c
@@ -693,6 +693,8 @@ static void slip_receive_buf(struct tty_
 	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
 		return;
 
+	spin_lock_bh(&sl->lock);
+
 	/* Read the characters out of the buffer */
 	while (count--) {
 		if (fp && *fp++) {
@@ -708,6 +710,8 @@ static void slip_receive_buf(struct tty_
 #endif
 			slip_unesc(sl, *cp++);
 	}
+
+	spin_unlock_bh(&sl->lock);
 }
 
 /************************************


