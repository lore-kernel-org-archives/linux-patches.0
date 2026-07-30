Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31735449995;
	Thu, 30 Jul 2026 16:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427864; cv=none; b=NUpf5WFL5g2ProJZqQ7wKwcZnPBtdc7TdmZsvgot2Qzjx6OjFZsCSaxusROZ1hRQ6fF7pCj7besmctKGM4hjH6p+++112Zz6S6AFVBSn3xYXDtblnyhF3+xp8jRvre+X04lal1z+n/2ywIA1DP+s/FvZKx2AaxYT/umZOadYIMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427864; c=relaxed/simple;
	bh=ZTsjQJCyy4lyXbSSVxX88p3dKnqQ7CIX2/JQJM/aUWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SnalYkNK0Pl1PcTr9tb7oZ3sablXaUCjMwbDpxyBJqpbe0I2XbItSzC/0JMNlBfEi+xlgvpXZCvPG/EoHz0KXUTX1U4Gpl4upwv1oZ4QK6cMJJJoeeJw3vSfS3YCrdKtRIS8HG7WtXsmEBo2sKGnOgCg4guleWQ2SNML1Kds5C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdsrpBaW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdsrpBaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FEC1F000E9;
	Thu, 30 Jul 2026 16:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427863;
	bh=5bxeki+JZKfPdCBsh6UrlxfA0QzfUhOvGDyl/Kl9P/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdsrpBaW8DWHe12N9NCkH5+eIVYiqEIeqNbfuVNuY7WAMJhbF1LvcM1YLzNGhI7yQ
	 9xZL9dBTKMViuKpNO7sNPobX2UWk6AEdwOqIDlNY+AHeNDuLOFiwgZa5J9USJb+MBy
	 vJbbJjyHwUONv+bfafLcWmP8RozL0bYiEqXG10LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungmin Kang <726ksm@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 318/484] net: slip: serialize receive against buffer reallocation
Date: Thu, 30 Jul 2026 16:13:35 +0200
Message-ID: <20260730141430.394883268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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


