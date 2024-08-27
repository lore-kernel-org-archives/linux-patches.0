Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87651C9ECD;
	Tue, 27 Aug 2024 15:33:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772819; cv=none; b=ODugv6cg3tzTBN0/LuRuTqwmeDIj/AcOMQhRmDKmDnrI6/aP/egwT9QJz1KWCwiFfvQLQxxaSs+O6CipOjm1Gq7+cQi5Gj6B/pjUmoqDib1HVVlzzxgXX3UdqIOLnKWkyMfSktvpIEU6bXvNU+VujUytDKxDZHGz+ByGlhWLRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772819; c=relaxed/simple;
	bh=wXeZDr/BRrZ31QfDLBKaiYD0D+vsxaY0+pxclWQIdh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgXEGexEYeFCgGW3OO2ZjjJ9fV8MrVx6UozPvtmwzlXKrG68Fb+VzoWB34+lyKZpFtVFo6LIHDx5fp+6BpoWF3rzCVKKNBokfz+szlwCck/nXJTkTLmza0VyzbMLZpIu/q6JxxotJbkANFyUC7X5OXtSp8pfZ5ioi7FYl6dtdr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jqsWroF0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jqsWroF0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32648C61052;
	Tue, 27 Aug 2024 15:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772819;
	bh=wXeZDr/BRrZ31QfDLBKaiYD0D+vsxaY0+pxclWQIdh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqsWroF0lHIxi+r5nhx7RvbtPMxIFYGrzr/puZ8WzxZe5QXooMe9Y62wiX7kfJi5X
	 qcIN1GgWx+GYeHP72vI4S3ynZOuVTsyfry+SzCUHuPYEG0dUJaPogscEuYNQhy4VAe
	 N1FkONni7oAn7ir3pBfZbHn0qFEklhL2UjWshp04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Jakub Kicinski <kuba@kernel.org>,
	Nicolas Escande <nico.escande@gmail.com>
Subject: [PATCH 6.1 311/321] wifi: cfg80211: fix receiving mesh packets without RFC1042 header
Date: Tue, 27 Aug 2024 16:40:19 +0200
Message-ID: <20240827143850.095453959@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 net/wireless/util.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -580,6 +580,8 @@ int ieee80211_strip_8023_mesh_hdr(struct
 		hdrlen += ETH_ALEN + 2;
 	else if (!pskb_may_pull(skb, hdrlen))
 		return -EINVAL;
+	else
+		payload.eth.h_proto = htons(skb->len - hdrlen);
 
 	mesh_addr = skb->data + sizeof(payload.eth) + ETH_ALEN;
 	switch (payload.flags & MESH_FLAGS_AE) {


