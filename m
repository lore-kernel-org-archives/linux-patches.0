Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA1DD19DF85;
	Thu, 15 Aug 2024 14:20:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731607; cv=none; b=DrZNhmpFgvSso8Ly0eqOc0n9+06qarqhH7JdBYqsZq7QNJPi8udhR+lDgAGiyl0n7RF7dgimZYfdoDYyt7oEJWqO+JC8Xk1L1PhOsAPxldUozFbj/kBzB6pF0oLQJhLVGnjYc+FQGw8UYsaowk4JSQTOx6x5yfsrJOhbMmwysmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731607; c=relaxed/simple;
	bh=W8tRTT5ASs5wWs+MKL2K3IfQNk7C6672FxaBgK0r7Oo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GmigbGt2kZ/3ThqtLQRBhzSlXPpT72LFs0SLO/b4yfqX0czw451Lv4qla20ZLSJWAX924j9zbXgH3ltrcuzOAgdYbnffcTUSKq8YlZydFbM4SPNWeKqiODl3VStB/yGkVRglngun0rP3ArLJBAD/vQJWVsEPcszGx2GU0NlSALI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzA389Ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzA389Ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E593C32786;
	Thu, 15 Aug 2024 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731607;
	bh=W8tRTT5ASs5wWs+MKL2K3IfQNk7C6672FxaBgK0r7Oo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AzA389KibfBWy3VwNZ+z1JHEieLjemUhWySUOQvEhu4VzjxuVqNs1nAxq5ndoRLSM
	 3Ar+eTEotZ9+f/fqzuAj5lakUs7/WqS5VhKv3lqfUYzt8UIx3E/082Om4bmdUzPWUQ
	 Q2zntzgIeAeqTvnvXNKsW2e3uhWF69EvOjiFsl6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Maltsev <keltar.gw@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 182/259] netfilter: ipset: Add list flush to cancel_gc
Date: Thu, 15 Aug 2024 15:25:15 +0200
Message-ID: <20240815131909.807678099@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Maltsev <keltar.gw@gmail.com>

[ Upstream commit c1193d9bbbd379defe9be3c6de566de684de8a6f ]

Flushing list in cancel_gc drops references to other lists right away,
without waiting for RCU to destroy list. Fixes race when referenced
ipsets can't be destroyed while referring list is scheduled for destroy.

Fixes: 97f7cf1cd80e ("netfilter: ipset: fix performance regression in swap operation")
Signed-off-by: Alexander Maltsev <keltar.gw@gmail.com>
Acked-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_list_set.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 9f4f0126d6ed5..c4aae8c586acf 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -547,6 +547,9 @@ list_set_cancel_gc(struct ip_set *set)
 
 	if (SET_WITH_TIMEOUT(set))
 		del_timer_sync(&map->gc);
+
+	/* Flush list to drop references to other ipsets */
+	list_set_flush(set);
 }
 
 static const struct ip_set_type_variant set_variant = {
-- 
2.43.0



