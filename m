Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAD32673B7;
	Tue,  8 Apr 2025 11:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110687; cv=none; b=pIm4DejG/+6n/2uc2h3VfI03bQWdF4GAn+g1NINkbnE4LgP7GL0g/04KnRKH385GivlJ4B4oeLyqj09XwetDyCRN908UW5yNWk/Ja1ve6EFWxG8tJeMeRk3APa2l1rOKLDnD/G3MMflr/rEJu9ELNmGogUKF6O39PM5/XmWbD14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110687; c=relaxed/simple;
	bh=0lGJDF5YWg9YwNtkr8v8Sq7JdntUfi3iUDOsU9WduAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BPYyJ3e4DBgLiTLqLrjUUsJH+lZ5lGRJdkNTL3zZIob9SwZ21eaZQwWmnkd/IHWdMWUGvup18GMaZBt2JCu5KSKq+ctSuwY+mcAPvAUmSZC6+NIufDpcw63+2C3t6iQ9fdiT+krj2+26e/VcTd6RdpIl9XM7P5pDR9jdsHSeMZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQrZTNKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQrZTNKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B5A8C4CEE5;
	Tue,  8 Apr 2025 11:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110687;
	bh=0lGJDF5YWg9YwNtkr8v8Sq7JdntUfi3iUDOsU9WduAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQrZTNKQLFw4tk5jEoRSZ7SzkS+7fje7roZeEQdxIDWQVPd5K7h0Ll96VuG4hOQ2l
	 m8gnWNHL80LQVnXOSAkoaUbjS9VlcheINwVoZ0jmWr38sYQAotd//AcMuz/2M4FGDD
	 9aK2cTnlwHA72hu2Qc4tRG2l8eMTZWEkJyD/E0QQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Nan <linan122@huawei.com>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 155/731] badblocks: fix merge issue when new badblocks align with pre+1
Date: Tue,  8 Apr 2025 12:40:52 +0200
Message-ID: <20250408104917.881847553@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Nan <linan122@huawei.com>

[ Upstream commit 9ec65dec634a752ab0a1203510ee190356e4cf1a ]

There is a merge issue when adding badblocks as follow:
  echo 0 10 > bad_blocks
  echo 30 10 > bad_blocks
  echo 20 10 > bad_blocks
  cat bad_blocks
  0 10
  20 10    //should be merged with (30 10)
  30 10

In this case, if new badblocks does not intersect with prev, it is added
by insert_at(). If there is an intersection with prev+1, the merge will
be processed in the next re_insert loop.

However, when the end of the new badblocks is exactly equal to the offset
of prev+1, no further re_insert loop occurs, and the two badblocks are not
merge.

Fix it by inc prev, badblocks can be merged during the subsequent code.

Fixes: aa511ff8218b ("badblocks: switch to the improved badblock handling code")
Signed-off-by: Li Nan <linan122@huawei.com>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250227075507.151331-9-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/badblocks.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/badblocks.c b/block/badblocks.c
index 43430bd3efa7d..52206a42191da 100644
--- a/block/badblocks.c
+++ b/block/badblocks.c
@@ -892,7 +892,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 		len = insert_at(bb, 0, &bad);
 		bb->count++;
 		added++;
-		hint = 0;
+		hint = ++prev;
 		goto update_sectors;
 	}
 
@@ -951,7 +951,7 @@ static int _badblocks_set(struct badblocks *bb, sector_t s, int sectors,
 	len = insert_at(bb, prev + 1, &bad);
 	bb->count++;
 	added++;
-	hint = prev + 1;
+	hint = ++prev;
 
 update_sectors:
 	s += len;
-- 
2.39.5



