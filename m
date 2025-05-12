Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BAF31A08CA;
	Mon, 12 May 2025 17:52:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072336; cv=none; b=E1NQOIp0a6Jk2VbYgSZbykvX5hX50M39pupRHSYQhVYDlRdhp0d2tItdXDPGB2KYi48g0/jVK2xAzW9mXFn2q2ykVXnnU8LNfMhI8HaNFamWoa0IMIu9GPHjd3EeYj8cZtnZbDAFYfV+4FWlN4k0fjaivvA1YoxLdP5HCxML4DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072336; c=relaxed/simple;
	bh=oAx7Bmrl7dgKS3DeGJo7LkBoOXKHxeD0+ayZb7Hnfxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQ13Uk2Or67i+CXs0tdaN87yUt5/7lMVAgTBAcUNhsqMhd6FHTz/9Sha5jZLnH7pT4Qge+vSmm0+h2u2RhZgfh4IK8/rAIHGb8OajeO9Idd5R1t81Jf95P24snonuBBzmnQ5P89TuN1uzdz6UA+CV9sEGv4wxtzwSDBUL1XP6z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2xZ7b4+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2xZ7b4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A497C4CEE7;
	Mon, 12 May 2025 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072336;
	bh=oAx7Bmrl7dgKS3DeGJo7LkBoOXKHxeD0+ayZb7Hnfxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2xZ7b4+sM/+Ymgw/6EXzfGL1LS2XO0JrvsPF+qFmvoZUAOWOa1luuObv4w/pX6jK
	 5HDZeabWbwf8FaoUbaV+vYP56KRRavP/eyguDEeiGXe5p1QjD9jjNRwZjmEEAXs9rv
	 md+1wu4JHapruB/8xJYn4M+oqPpgHDBn9I8jGyaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 01/92] dm: add missing unlock on in dm_keyslot_evict()
Date: Mon, 12 May 2025 19:44:36 +0200
Message-ID: <20250512172023.196146259@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
References: <20250512172023.126467649@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

commit 650266ac4c7230c89bcd1307acf5c9c92cfa85e2 upstream.

We need to call dm_put_live_table() even if dm_get_live_table() returns
NULL.

Fixes: 9355a9eb21a5 ("dm: support key eviction from keyslot managers of underlying devices")
Cc: stable@vger.kernel.org	# v5.12+
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-table.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1243,7 +1243,7 @@ static int dm_keyslot_evict(struct blk_c
 
 	t = dm_get_live_table(md, &srcu_idx);
 	if (!t)
-		return 0;
+		goto put_live_table;
 
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
@@ -1254,6 +1254,7 @@ static int dm_keyslot_evict(struct blk_c
 					  (void *)key);
 	}
 
+put_live_table:
 	dm_put_live_table(md, srcu_idx);
 	return 0;
 }


