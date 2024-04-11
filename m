Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53CEF1474B9;
	Thu, 11 Apr 2024 10:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831744; cv=none; b=RiBZ9KRz++o/Vr/wUbNj/b18pQzGjgtdNHD/VvdLHH9se7t5fPmuf2kSl4yIvlTfDQ6yf/J0+zlT9vDcY21pVPfrcX1B5CSkoYHzaaa+HSN5QJ269k/D1sKIx68vevxZZobwtOytuDk8BTRKFE5EOk4Gmg0w9VreqkyVZiDynp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831744; c=relaxed/simple;
	bh=+e8XLNvELddZonv6ny2jdM0bWUiA6dIO5dswj54CizM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQYW+iIjc4EHfB1vIYwYAQbXieRF/0kPmNl5iYP1OtFJD68/CxRP1YpJcuC+7k3UivbN9XbYBwQqCgH1CrwNghsSguBj7ZXA7Hre48COOLplqHnHW/Z2erkxOrmjehlkpcq+KALpI1c3a4nRNTjpPWlnIIKaWmK4KgXPkAiDjlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gJIxyJPq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gJIxyJPq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD226C433C7;
	Thu, 11 Apr 2024 10:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831744;
	bh=+e8XLNvELddZonv6ny2jdM0bWUiA6dIO5dswj54CizM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJIxyJPqpGwHCRfG73k/ijU+28i66hDFptrG8S2VO3cbn69S85usViweXI3FDEYh1
	 +DJmisC78HK3kR5rN3599Dnh+FdKiRylIFXpgmjjYqIgcCjtxufP5tHmH2vFlIWcyC
	 /QaikQtFQN/OFU/PDpHq26MHUaGvXl4IRQjqbmQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Pittman <jpittman@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/294] dm snapshot: fix lockup in dm_exception_table_exit
Date: Thu, 11 Apr 2024 11:54:35 +0200
Message-ID: <20240411095439.041700662@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit 6e7132ed3c07bd8a6ce3db4bb307ef2852b322dc ]

There was reported lockup when we exit a snapshot with many exceptions.
Fix this by adding "cond_resched" to the loop that frees the exceptions.

Reported-by: John Pittman <jpittman@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-snap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 41735a25d50aa..de73fe79640fd 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -685,8 +685,10 @@ static void dm_exception_table_exit(struct dm_exception_table *et,
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
-		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list)
+		hlist_bl_for_each_entry_safe(ex, pos, n, slot, hash_list) {
 			kmem_cache_free(mem, ex);
+			cond_resched();
+		}
 	}
 
 	vfree(et->table);
-- 
2.43.0



