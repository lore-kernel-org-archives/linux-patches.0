Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BB41C5F0C;
	Wed, 19 Feb 2025 09:14:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956463; cv=none; b=Wr25tbTM9E5qAo9UaZ5uGeFNNDs69ch0pCbmJzVc2AgcjN+fPwaNlJlAVCLe3ko7HCuEaXzfSD7qts7vxJHPtwSh5byMj+5WR9vBz7z79vYUnSpOwbPyvSXhFBT5a/rTr5dy6QI5yNBMH6WqQ1kVeYPAba8Oi5TfAugYKnIa1Yo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956463; c=relaxed/simple;
	bh=7ThH0RcmO5Ltuvr3Hc26hAi8gGZmvDyMV5Hh/4K0yfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZU9HeTs5YWQIdxWnReZezgNqEtdAQaRcmkOJ9nyPpFwtZUwgV5enQfFrDgjReZ3QgiPayanlAxVIDJAEJjxwlc+N+fYVaqJ8Z6uQbKsj48InZ32wotpE8w3tjRvwVlVHGcFH19W+yyNHte71bMOuJ4d7/S87DF5qbs9HdZFPmi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAM+5w3X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAM+5w3X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7889FC4CED1;
	Wed, 19 Feb 2025 09:14:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956462;
	bh=7ThH0RcmO5Ltuvr3Hc26hAi8gGZmvDyMV5Hh/4K0yfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAM+5w3XeJwGHgHC9F7Sdz4dHhGdvxCxzG9ZIaZJhDXbKBpbGFS/zL/jVEpk2M7/s
	 7zbpiu5Z9+UMXS/ckNENgqmXweY71mLT91xmdWpaOQy9JkBlY9JVDk4y1brbkniV9U
	 oqPXWGyfLZ2kUziq6Q1mGNS3dPCEy2+iefsbCSp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+85992ace37d5b7b51635@syzkaller.appspotmail.com>,
	Qasim Ijaz <qasdev00@gmail.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 187/578] iommufd/iova_bitmap: Fix shift-out-of-bounds in iova_bitmap_offset_to_index()
Date: Wed, 19 Feb 2025 09:23:11 +0100
Message-ID: <20250219082700.319667752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dfab5b742191a..76ef63b940d96 100644
--- a/drivers/vfio/iova_bitmap.c
+++ b/drivers/vfio/iova_bitmap.c
@@ -126,7 +126,7 @@ struct iova_bitmap {
 static unsigned long iova_bitmap_offset_to_index(struct iova_bitmap *bitmap,
 						 unsigned long iova)
 {
-	unsigned long pgsize = 1 << bitmap->mapped.pgshift;
+	unsigned long pgsize = 1UL << bitmap->mapped.pgshift;
 
 	return iova / (BITS_PER_TYPE(*bitmap->bitmap) * pgsize);
 }
-- 
2.39.5



