Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7771E493C;
	Thu, 30 Jan 2025 14:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246873; cv=none; b=FaKsHlckx3yafsdGU8YQ+fkgEAU5VnmFyx6UcDsljUj6JsoTuQav8JJQLrS123BNzURjPhO9Z5ncuFNlkKqGakF7TT6n4r4YrFbf7pVceEFHKpW2iL5OoBKfHLEwaHYrPp8W5Lg5yGbEVmIXsrLjWeXEtY4SDoZ5tA2V8C42+dI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246873; c=relaxed/simple;
	bh=dAgC29DAgvJMTBRhu9qoAnaiGzfMmxVDEBrSpjsjmTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvZVHCSRqN97Vl6CmV1skBTwLCxsJJMBWP64YA1Mb0WkZ6hYByaUjqiIn6l4UtLayaARsPTtpa0G5ug9hP6QjF6aTs8PtxfrbSlDqLZ+svAfQiYdtNdxwCnxMdsY442szMG+PHrNMpEpDSQoDRSyyQHQXpVo4ayYWUSpoWrFM0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Px2ci4S0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Px2ci4S0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AE0C4CED2;
	Thu, 30 Jan 2025 14:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246873;
	bh=dAgC29DAgvJMTBRhu9qoAnaiGzfMmxVDEBrSpjsjmTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Px2ci4S0qF+q/uXNzmL/Y/lLftyAdAahEpDfYkbMBZT/Z736xmI7jZ1IqrDiHJhsn
	 bDsmAMVMS4xq6NAzMEFlTU9BR6YXozou7Mns4v6dcyrh2fbQh+JhlXyEBIBxwfmZeD
	 LOuZjp5LeInYwPtHgll2PzkBK5klfiumtkSnwe/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
	Wei Liu <wei.liu@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Hagar Hemdan <hagarhem@amazon.com>
Subject: [PATCH 5.4 82/91] net: xen-netback: hash.c: Use built-in RCU list checking
Date: Thu, 30 Jan 2025 15:01:41 +0100
Message-ID: <20250130140136.977938402@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

From: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>

commit f3265971ded98a069ad699b51b8a5ab95e9e5be1 upstream.

list_for_each_entry_rcu has built-in RCU and lock checking.
Pass cond argument to list_for_each_entry_rcu.

Signed-off-by: Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>
Acked-by: Wei Liu <wei.liu@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 0fa5e94a1811 ("net/xen-netback: prevent UAF in xenvif_flush_hash()")
Signed-off-by: Hagar Hemdan <hagarhem@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netback/hash.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/xen-netback/hash.c
+++ b/drivers/net/xen-netback/hash.c
@@ -51,7 +51,8 @@ static void xenvif_add_hash(struct xenvi
 
 	found = false;
 	oldest = NULL;
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
+	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
+				lockdep_is_held(&vif->hash.cache.lock)) {
 		/* Make sure we don't add duplicate entries */
 		if (entry->len == len &&
 		    memcmp(entry->tag, tag, len) == 0)
@@ -102,7 +103,8 @@ static void xenvif_flush_hash(struct xen
 
 	spin_lock_irqsave(&vif->hash.cache.lock, flags);
 
-	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link) {
+	list_for_each_entry_rcu(entry, &vif->hash.cache.list, link,
+				lockdep_is_held(&vif->hash.cache.lock)) {
 		list_del_rcu(&entry->link);
 		vif->hash.cache.count--;
 		kfree_rcu(entry, rcu);


