Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C9587DA9E;
	Thu, 15 Aug 2024 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729756; cv=none; b=s0RXJ9S85GyitxeHkHxtcmPO4PKCKIFKPWJNc7aco+OjAV0m5PDVvXy7CRJfNjv9HMkI7ta1m044Yo4hdSLUEw/+e2oQqOzTSkctk+ISQvfsRABcKz2paNs68FSgEn+voJrf5L7fQDBmOc9jhmn/4uF/VRCkLbNpImls9Kvh68E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729756; c=relaxed/simple;
	bh=2HUVJxsqBGTPTGhQUCXFnGezRoSvuLk3C1xWbRIguT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UPOwFDUI0+cROJe9iuEE5zTwNSkW17RZF6ljVHh/kOsqVylIkVg71fhKzJ4yMT1v0n1Q8ouapvWagzxOuhUxio6LJEiUPtEQegOAizgVafrcY0yKB6UIG5oGserFoNNvkRbG/9OYQ5niaK2007AmCYQU+gKYbzHM80j3ru3BQ+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k9JqQCo2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k9JqQCo2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4E8C32786;
	Thu, 15 Aug 2024 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729756;
	bh=2HUVJxsqBGTPTGhQUCXFnGezRoSvuLk3C1xWbRIguT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k9JqQCo2FKMhrZcrKULPjE6tAx0L4/2BGeeqxKI6tAx+1fbxjCisUiGV57YdAPiI+
	 xaIKZ/k8MYEq4kl3hPzKEURNYReBLgINDRAT96QA01wjrbZch28HXjJQXW3GDrLXC/
	 JQUCsObJbmMRon+uys6qxlCqqCSSzlpYIFCH3s4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Carlos=20L=C3=B3pez?= <clopez@suse.de>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 166/484] s390/dasd: fix error checks in dasd_copy_pair_store()
Date: Thu, 15 Aug 2024 15:20:24 +0200
Message-ID: <20240815131947.824230420@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carlos López <clopez@suse.de>

[ Upstream commit 8e64d2356cbc800b4cd0e3e614797f76bcf0cdb8 ]

dasd_add_busid() can return an error via ERR_PTR() if an allocation
fails. However, two callsites in dasd_copy_pair_store() do not check
the result, potentially resulting in a NULL pointer dereference. Fix
this by checking the result with IS_ERR() and returning the error up
the stack.

Fixes: a91ff09d39f9b ("s390/dasd: add copy pair setup")
Signed-off-by: Carlos López <clopez@suse.de>
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Link: https://lore.kernel.org/r/20240715112434.2111291-3-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/block/dasd_devmap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index 6f9f7a0723128..7447dec5ce221 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -2141,13 +2141,19 @@ static ssize_t dasd_copy_pair_store(struct device *dev,
 
 	/* allocate primary devmap if needed */
 	prim_devmap = dasd_find_busid(prim_busid);
-	if (IS_ERR(prim_devmap))
+	if (IS_ERR(prim_devmap)) {
 		prim_devmap = dasd_add_busid(prim_busid, DASD_FEATURE_DEFAULT);
+		if (IS_ERR(prim_devmap))
+			return PTR_ERR(prim_devmap);
+	}
 
 	/* allocate secondary devmap if needed */
 	sec_devmap = dasd_find_busid(sec_busid);
-	if (IS_ERR(sec_devmap))
+	if (IS_ERR(sec_devmap)) {
 		sec_devmap = dasd_add_busid(sec_busid, DASD_FEATURE_DEFAULT);
+		if (IS_ERR(sec_devmap))
+			return PTR_ERR(sec_devmap);
+	}
 
 	/* setting copy relation is only allowed for offline secondary */
 	if (sec_devmap->device)
-- 
2.43.0



