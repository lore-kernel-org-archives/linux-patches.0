Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 083642D592D;
	Fri,  9 Oct 2026 14:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555801; cv=none; b=r4Vy+tTqPc0uhiUUgP/iQPIkB3+sXYyIh3zGCMyfzid689vBeibQPjY0mgMTIZybkKli18S6TQ5ptnJmwuwIPRL8M5skip8/DLUCjerE+P15n6Je+GkasnRbW/tJ2LITCW35chkunaQxed3HjIwnynVNzt8b+KeECKozyQzmGSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555801; c=relaxed/simple;
	bh=Yzg9w9wB4pwYr6uQygz0Y7yMtt1/m9r7oJqB7NUjLgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrHI76o0T2D3dlXbTZ1D77Dv+u626+4y5olJ/FIt2ez9gixaAK7tv24bhf9LfwYWUO802qYtXPxDM6IFMGQUMvePJ1qWwsCw/mQRTSRKHyJPEgLrj/Vz3K4FOw1pXNoI3E+vAn7HdboNf3uy6qO5+xdqStGEj4cLmHZ/RI8fbZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKt4hIlU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKt4hIlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F31C1F000FF;
	Fri,  9 Oct 2026 14:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555799;
	bh=aPlT5N/o7M/rvnTQZ5RiXdfIjDVkG/HByelBAvcR+l4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKt4hIlU6E5NosBNQy5GIYODU7HMkOK9oHqQZKFouzq8P4+MjxlWcczMw7Z2sv9qr
	 EqVkKxNyz9n8DM7UfWpQDsROq68rJOV6wBQb6LcpZPEbeALIaD660X0NsHHVqvv+MB
	 ewfL2vKH56tgosvsk1xmEYS8223GFlqg2dMi30oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Anastasov <ja@ssi.bg>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 120/403] ipvs: fix missing counter decrement in lblc
Date: Fri,  9 Oct 2026 16:08:01 +0200
Message-ID: <20261009140954.885757361@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julian Anastasov <ja@ssi.bg>

[ Upstream commit bdac17779f46817f60103baf09f0370546c3f023 ]

LBLC may delete cache entries for destinations that are
removed or overloaded and replace them with available ones.
But ip_vs_lblc_new() forgets to decrement the tbl->entries
counter after calling ip_vs_lblc_del(). This can lead to
increased shrinking of the cache with every new garbage
collection.

Fixes: 2f3d771a35fe ("ipvs: do not use dest after ip_vs_dest_put in LBLC")
Link: https://sashiko.dev/#/patchset/0bdd5abe9968ded7ca2b9cb6844ba83d94cc8d53.1787318053.git.zhilinz%40nebusec.ai
Signed-off-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipvs/ip_vs_lblc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/ipvs/ip_vs_lblc.c b/net/netfilter/ipvs/ip_vs_lblc.c
index 9bb1e05063dc4..765825b51af01 100644
--- a/net/netfilter/ipvs/ip_vs_lblc.c
+++ b/net/netfilter/ipvs/ip_vs_lblc.c
@@ -204,6 +204,7 @@ ip_vs_lblc_new(struct ip_vs_lblc_table *tbl, const union nf_inet_addr *daddr,
 		if (en->dest == dest)
 			return en;
 		ip_vs_lblc_del(en);
+		atomic_dec(&tbl->entries);
 	}
 	en = kmalloc(sizeof(*en), GFP_ATOMIC);
 	if (!en)
-- 
2.53.0



