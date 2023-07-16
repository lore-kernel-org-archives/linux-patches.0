Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1498F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B08BC433C8;
	Sun, 16 Jul 2023 20:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539223;
	bh=pFjYJL5R6I/nl8gISCr1UMH8nPD+e6rYKspmxpAEkZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UoK6+rqRLNJ+RVHD8esMXHVFffmcvj1H39zO3Yo6n6EV2peaHQvSkgGR629m94t5b
	 L1OdHC5SIKndJzGCsiaY4aUrv7xmh7ibJ8tpXtuSWatPgEXGsol+j88pUOxajEaju6
	 h+f/s2KXjvhXWT2rl7V8yK92M4PA0YKkIH6Bf6lA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Nicolas Escande <nico.escande@gmail.com>
Subject: [PATCH 6.4 732/800] wifi: cfg80211: fix receiving mesh packets without RFC1042 header
Date: Sun, 16 Jul 2023 21:49:45 +0200
Message-ID: <20230716195006.119938165@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Felix Fietkau <nbd@nbd.name>

commit fec3ebb5ed299ac3a998f011c380f2ded47f4866 upstream.

Fix ethernet header length field after stripping the mesh header

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/CT5GNZSK28AI.2K6M69OXM9RW5@syracuse/
Fixes: 986e43b19ae9 ("wifi: mac80211: fix receiving A-MSDU frames on mesh interfaces")
Reported-and-tested-by: Nicolas Escande <nico.escande@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20230711115052.68430-1-nbd@nbd.name
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 89c9ad6c886e..1783ab9d57a3 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -580,6 +580,8 @@ int ieee80211_strip_8023_mesh_hdr(struct sk_buff *skb)
 		hdrlen += ETH_ALEN + 2;
 	else if (!pskb_may_pull(skb, hdrlen))
 		return -EINVAL;
+	else
+		payload.eth.h_proto = htons(skb->len - hdrlen);
 
 	mesh_addr = skb->data + sizeof(payload.eth) + ETH_ALEN;
 	switch (payload.flags & MESH_FLAGS_AE) {
-- 
2.41.0



