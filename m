Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4238E198853;
	Thu,  6 Jun 2024 14:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683045; cv=none; b=iQFsGyEzkBAAp0R1vuh6lg7y2zZhQCaO7BZaKmv5qXr/tVrdcglNvq44WH/ZIvUJhtLE4cpBqAyFQ4eSQyABhc4lL/+SDEz0wqTj7ypfMvY0AVRKhjoG48P2YPkGH+LUZtqeHgGrBbRu9TwCOpPJCGqHbEeBpez8FmdokU9LhHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683045; c=relaxed/simple;
	bh=UG9uks6kv4RZYpBSDzS+7aKEFgozlQEd9cj/53fvf/Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfwxbKFSdNz1XaoJM8oH8Y8A4SMC7XfMIZpMlYX9hEILzpBvo1LX1Li8gjcNMZQEgxtOxHwPhgazWKJQFeSRNNeMXcsyvXnuGxfqCvKy90OVg45WcHvP384LQirofzFIpvMEfRtOhmrc6Frb7R4ERUfMUJxhhXjJHMTr5J/YpWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vFOP1Bqk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vFOP1Bqk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 206E0C2BD10;
	Thu,  6 Jun 2024 14:10:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683045;
	bh=UG9uks6kv4RZYpBSDzS+7aKEFgozlQEd9cj/53fvf/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vFOP1BqkVB8+8I0kmnSuyN5Z9akhd5ihtDbfTpdOC9vNfFSx3X+jzuIN2+4eUQ2dA
	 +vOVDO8X+s1IkELJOPd3hM8z/dz3gq6LJZIkY8+mnOW7amiSeesFmGlfJzoDsuztNE
	 kSORnO1DKRolVVqqwUiLtJMqCRRrVyDcDVINtBmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Maltsev <keltar.gw@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 284/374] netfilter: ipset: Add list flush to cancel_gc
Date: Thu,  6 Jun 2024 16:04:23 +0200
Message-ID: <20240606131701.408692158@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 6c3f28bc59b32..54e2a1dd7f5f5 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -549,6 +549,9 @@ list_set_cancel_gc(struct ip_set *set)
 
 	if (SET_WITH_TIMEOUT(set))
 		timer_shutdown_sync(&map->gc);
+
+	/* Flush list to drop references to other ipsets */
+	list_set_flush(set);
 }
 
 static const struct ip_set_type_variant set_variant = {
-- 
2.43.0



