Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1066214A088;
	Wed,  5 Feb 2025 14:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765571; cv=none; b=Vs6DDxav2ouRi9tJteyv+idHldapjUbfGsHWtYBR2MEgNz0XyjIBM24cdG6Mo3JIN9e4hGsIN0wuzkNOell8fmReQnK0ofvOmiRoNbkhC1NqH/XF4QhWexOYPisQUeMoVZTMH4fZotlVSydBBVafE9lYwJHsM2FQ9MFBQHQosuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765571; c=relaxed/simple;
	bh=PcWiF1XxYcFA1mh/pDCL/twUSLKFmLhknxU1Zizxi48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XcJh3VFKwJzRVFzxLOvjkkuI6gnrLvIPHmsY0K4vvx5933cmloeWqxdDZEcqMWHqTQ/O+mC3WnDnDGabMQXnybem/rJ4Phv1GlAsEqd70ZU31r1dsI54UrRmokdcJ812xJfQee3Te4MGZMqjCu5QIVPSpZeD89aooTBzeYkPSlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b6qxpZIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b6qxpZIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EC78C4CED6;
	Wed,  5 Feb 2025 14:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765570;
	bh=PcWiF1XxYcFA1mh/pDCL/twUSLKFmLhknxU1Zizxi48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b6qxpZIrsdQIRCm3/Od1KWzQsf+jaolLluSMaLUMymMkjCmZpa2MNHJ5Qt/Ne9Cs0
	 7hRtdoHlTcCVbt/ljtGlu+abdhU5mveSeYRz0JdJAWG7tVyEnwGfcH7a+sSL7IsZSn
	 1mPcJ3iArgptNpLNb+bUF7nzT2+E5Ki8iyaRR5Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+85992ace37d5b7b51635@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 279/393] iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to_index()
Date: Wed,  5 Feb 2025 14:43:18 +0100
Message-ID: <20250205134430.983226376@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qasim Ijaz <qasdev00@gmail.com>

[ Upstream commit e24c1551059268b37f6f40639883eafb281b8b9c ]

Resolve a UBSAN shift-out-of-bounds issue in iova_bitmap_offset_to_index()
where shifting the constant "1" (of type int) by bitmap->mapped.pgshift
(an unsigned long value) could result in undefined behavior.

The constant "1" defaults to a 32-bit "int", and when "pgshift" exceeds
31 (e.g., pgshift = 63) the shift operation overflows, as the result
cannot be represented in a 32-bit type.

To resolve this, the constant is updated to "1UL", promoting it to an
unsigned long type to match the operand's type.

Fixes: 58ccf0190d19 ("vfio: Add an IOVA bitmap support")
Link: https://patch.msgid.link/r/20250113223820.10713-1-qasdev00@gmail.com
Reported-by: syzbot <syzbot+85992ace37d5b7b51635@syzkaller.appspotmail.com>
Closes: https://syzkaller.appspot.com/bug?extid=85992ace37d5b7b51635
Signed-off-by: Qasim Ijaz <qasdev00@gmail.com>
Reviewed-by: Joao Martins <joao.m.martins@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/iova_bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vfio/iova_bitmap.c b/drivers/vfio/iova_bitmap.c
index 7af5b204990bb..38b51613ecca9 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -127,7 +127,7 @@ struct iova_bitmap {
 static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
 						 unsigned long iova)
 {
-	unsigned long pgsize = 1 << bitmap->mapped.pgshift;
+	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
 
 	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
 }
-- 
2.39.5



