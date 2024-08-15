Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 776BF18D630;
	Thu, 15 Aug 2024 13:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730260; cv=none; b=UfgfofUPXrzcBAw8JI+jxiixTB/U0RX6Htl5hUalTn6SepJONLmsYr5Zy2tcZvVvWg8b7xnVHIlquNfbLfIiYjeu7XdHOsNQkuwv5tvhtk0tgZ2Fkf6G0jWsLYyIZGn8mWOa0iJukkrAVPFpo3Zkz/DJeivoguDJ9fpUorhd2Ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730260; c=relaxed/simple;
	bh=fdtS5lPN43zZxR4/Oit+mruBUYQVxv1zKQ4/HK46Z+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hsiRlKIbyy97sfC39W6nx5fpiPWl3fDIl+qxQWB7HtfEXuSeICSpNnNXFYI2iAAQntEEJY2E/1bME+KmyAHom3H3e1YPb9XZ/Kfq0vIVYsObw2SeBu8kVF5jLMIC6mg3HpiwDDUQTqUselO+oST3+XlhdfaF5WrH5GT8u/zpsPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eijFRNNe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eijFRNNe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40D2C32786;
	Thu, 15 Aug 2024 13:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730260;
	bh=fdtS5lPN43zZxR4/Oit+mruBUYQVxv1zKQ4/HK46Z+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eijFRNNeNAqEPdBYEBQcg9/tCv5ze1/vatz2TJMJGmwbP6f8yv8oUuciz0nqQHVhk
	 f/GO5rzJHosogRowVp2HjRsJcitK+St/M2m8THwvUvWXGC2hY9AMonf2pwBeuu/wou
	 X5WCDZa9m3J31/BnoY55AiIFdSTnWJRRlaB/QoHs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Maltsev <keltar.gw@gmail.com>,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/484] netfilter: ipset: Add list flush to cancel_gc
Date: Thu, 15 Aug 2024 15:23:31 +0200
Message-ID: <20240815131955.062612388@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e839c356bcb56..902ff2f3bc72b 100644
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



