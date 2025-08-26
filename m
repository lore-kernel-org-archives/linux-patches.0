Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E41405F7;
	Tue, 26 Aug 2025 14:32:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218720; cv=none; b=LfSQMQTBWVc8tCe6J+KqLjocHUzvx5/GI2SYqOT/kZANkNn9tnqjR57cW9jyKlzY/wP4DQkBkUBrtBsqlI41pDOyz4bDjol2rRs8vySqpplxdxvXogeUMUhMnfHQg2+eHZ5Lir6KPmsIG19tQZXsBCH9tP27qqdHl8H1yFGJS6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218720; c=relaxed/simple;
	bh=gN+a1ya02CHna6gNJTRo8iCiycI5BJ+/aizhcyBzoHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5in/DOgH+IoDg2Jw42r8p8YDtmM9Lykb69/L9SCX97+lwB1NhGIk5IajZNkSxoHt4VBjhl9gb+oVBw1C4hzAwK1X3tBK2PgnopRuYgMmPhYfJT0595Ya8B8uwVT5Smmpg3kE3HErC0lk5+V3/ibNnb+i6sj/0hvr/Eme1Bfy/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TMvW2kyU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TMvW2kyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA3BC4CEF1;
	Tue, 26 Aug 2025 14:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218720;
	bh=gN+a1ya02CHna6gNJTRo8iCiycI5BJ+/aizhcyBzoHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TMvW2kyUjF7cPNxQ/3sXmsGbv1pNHM2i555DEQkT0IgQ643ePTl8VbYHHkJFTO5ev
	 EgZJXf8hKhTbs36vorfei6jCmPFg4NUCs26tybD+g65IryFwmu7OsBU24ruj8YkwxW
	 sWxlhQMvrYFX372Lf1ZHB0aljBkGFZoRH/JdRiFg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Stepchenko <sid@itb.spb.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 107/403] mtd: fix possible integer overflow in erase_xfer()
Date: Tue, 26 Aug 2025 13:07:13 +0200
Message-ID: <20250826110909.641822453@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ivan Stepchenko <sid@itb.spb.ru>

[ Upstream commit 9358bdb9f9f54d94ceafc650deffefd737d19fdd ]

The expression '1 << EraseUnitSize' is evaluated in int, which causes
a negative result when shifting by 31 - the upper bound of the valid
range [10, 31], enforced by scan_header(). This leads to incorrect
extension when storing the result in 'erase->len' (uint64_t), producing
a large unexpected value.

Found by Linux Verification Center (linuxtesting.org) with Svace.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Ivan Stepchenko <sid@itb.spb.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/ftl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ftl.c b/drivers/mtd/ftl.c
index 2578f27914ef..ffe89209cf4b 100644
--- a/drivers/mtd/ftl.c
+++ b/drivers/mtd/ftl.c
@@ -344,7 +344,7 @@ static int erase_xfer(partition_t *part,
             return -ENOMEM;
 
     erase->addr = xfer->Offset;
-    erase->len = 1 << part->header.EraseUnitSize;
+    erase->len = 1ULL << part->header.EraseUnitSize;
 
     ret = mtd_erase(part->mbd.mtd, erase);
     if (!ret) {
-- 
2.39.5



