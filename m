Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE80E37883C;
	Thu, 30 Jul 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423197; cv=none; b=NyMxJOSeDpi1ggvLTOLjid1GfmtGvcjeNrfBFCgGjlm6WazX72ord15Od/XwE+IO/MSoEKxbhTXReA0WJle6IL5UMjjyxjsv07gtL4nyL7DxNOWhBXyY7i+54MtMwSvPfg1b592rOMu3t/xe6Ew2+W/96u2Zhp7YC9O9SjAMaQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423197; c=relaxed/simple;
	bh=hPb2+uYQqa/GmUBprUHOU61GEulkBS2jEPtprk97QTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qC6QMFAWEjzHZ0b3KuqpIYRJT0syjDJ8+K9e6evDXBWrv6GfV2XxavXFOlMVKoTJRQCtc8tmC3KEYcYwlV4uaVoXamg9pCMvQOXVwgCmqcYefcWvBiLmWf67+O8PXydnbc/OL0DqZEcQJ6QnSX25yiYvOWOH1avCsNxwQqDcyIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DM6XRCuF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DM6XRCuF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402C01F000E9;
	Thu, 30 Jul 2026 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423196;
	bh=8Bd+qIYS/vvMvrGkmPzoILCj2V1ele/LQeMP2ji2+j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DM6XRCuFsOAj131oBpqVfSBw4pvVP+PggZ0acUKMhuS2zeCcC2QE2n/CYP4XzzVJJ
	 lYAkxntymhc9CdaM3u8JPTa86U8ZPNyEhZlpIXOn5ws7q60vQ/Y3ZBqC/sUjvbG0d2
	 Bm/MSchYCPteYSCIM/gD6lU01KlYeS56iYaCPwkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungmin Kang <726ksm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.1 655/744] net: slip: serialize receive against buffer reallocation
Date: Thu, 30 Jul 2026 16:15:28 +0200
Message-ID: <20260730141458.190644761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


