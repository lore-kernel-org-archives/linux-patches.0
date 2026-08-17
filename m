Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F00843F8C9;
	Mon, 17 Aug 2026 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979549; cv=none; b=jyylRQTAzz7halYasdd1Umwv+cPIJsSBRaESXs86VJ6SESCcNI67JyHALXlpTjZ4mwNHopXDQlBPSlAtFzKKj5WhgJK7dgoD4fNdNLY+jOjbZdxn5oYpA0wpsKL3KchAqvTB+caSJ09CyRG3L4E/zPPJDHvLJCibcGTNJ2k/788=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979549; c=relaxed/simple;
	bh=KLil+ZK+Q1w4jVQcryOqIduiQSvsgXgNL6JVR415yzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxSXOFKddkqVQv1fmvPyJJq7DHNivTT/aRBJAse3DNKtlwK9PveoAc9JfZZ4CeAb3zSqvu9fxBV4Kh4HEsPfEEtG9cCRj7nV6phugTHIR0Mn4JJm9U+iQpkI/UMBuRBUYbjGTJYYe7BNNDF2uDxT9TdHJfzGre5jr5xrBcu+HVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdOeHKco; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdOeHKco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8BF21F00A3A;
	Mon, 17 Aug 2026 15:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979548;
	bh=ES765zBinlsaQeuGwoa+9L385PsJ4LOvCH8ugG+TxCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdOeHKcoEKTGqf36YfAhSUJ04eL7gYSIvrkTRgSoQLOkzDwi9bIAFhssnzIBR0yQZ
	 e/lmhXSczrZmwVCel4ZgJTSdQ2++/xb9ICSoVe3psBdsJ6cOZZ06T4lqk60HPfa+/m
	 UtZwegb3jrWm6msxrT6M95oLBfuP1zBq9qVSJX8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungmin Kang <726ksm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 263/609] net: slip: serialize receive against buffer reallocation
Date: Mon, 17 Aug 2026 15:29:19 +0200
Message-ID: <20260817132552.913152486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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


