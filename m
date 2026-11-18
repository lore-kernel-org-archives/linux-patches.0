Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050462;
	b=5kuS+oqxxz2OvP91Wa6j5XETJ3xQubC1fI6LTaEa7lQe92At42tJj/JOf6s9zRA/xMub
	 PMOPN+o1wQZGTE3/ZSgvQHYmJdNCrOksQ5LeNOEpCyxgVyLQXnyGk549lGlBehihX+0ro
	 PijsFkd93L7+Y9q9JXuK92TSJnSFQAWT/uHlFeT33ixjHixlaoWer5Lwg0G9vahXH3yzg
	 6juv2Hz0PVYJFGQCxtmz0NDJ7MdIFrfTtmh7mtutEGa6kOBJsr2U2lUf5trLTtHKdv998
	 pF+7KP4BT0zZVpkLPeRmJ6/LLfbXUVL0uQX5AEkFvtUP/Cqzqwye4qlPzKLpwXnTl9Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GKCHFMmb7kTH//Rg1SdJ7s9cAueCAxyAgTkDhZjrTlM=;
	b=e7LGnddVdRLqu/8bb1rOO83Pz9ExpgSCU2wbqIH7w2AvHdCIQFTJjhWgRW/26ziO/nUu
	 QJMNSMqMpfqUguOKSiRsVRU2hsd77fnhxDXS2Auw2ZUGRtAVAjESbkYNZXL+mijwsMLfO
	 oX0UVOOjAam36kJVB3P+ahLEdApSQwsosUA7FEMIvOHHYp+OJuHYAc2t43dC6IxeowoYC
	 be30kCh4Enlelcex/qAUEkS6Pd1h2pauJpVRgSMRWUw5jpTpq8HMFArqU6uTxrXv9mvGQ
	 SaWKe6l4qCm7JhhXTaSdSj7KQd90fiZjrfcWSorTjjEtfHpq/owFziBUDk4WlyHwfmw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YR6baQNG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CAC9606A31C;
	Thu, 19 Nov 2026 01:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YR6baQNG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA0F1F000C4;
	Thu, 19 Nov 2026 01:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050462;
	bh=GKCHFMmb7kTH//Rg1SdJ7s9cAueCAxyAgTkDhZjrTlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YR6baQNGmhAXNj7JmOPdYBo2T2S3hh4W1UJttvjSPFwMO5djitHen2EmI5nkrQJ1K
	 482one/jdKlzMD+revYkZpKQyWkXFd+VPjSepY57SoTyoslx1GVDqrwN3OnOGZzJ59
	 KqYsc7SA8TA8LFsFuhvQJ9h/Lmv4eedgZ9/VeFcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <f.fainelli@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2666/2857] net: skbuff: move alloc_cpu into a potential hole
Date: Wed, 18 Nov 2026 16:01:40 +0100
Message-ID: <20261118150337.572046321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4398f3f6d1380d9f71a484e1e5d869ba0eaf23d5 ]

alloc_cpu is currently between 4 byte fields, so it's almost
guaranteed to create a 2B hole. It has a knock on effect of
creating a 4B hole after @end (and @end and @tail being in
different cachelines).

None of this matters hugely, but for kernel configs which
don't enable all the features there may well be a 2B hole
after the bitfield. Move alloc_cpu there.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 78d4bd22ec9d ("net: skbuff: don't copy alloc_cpu in skb header copies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index f4c5411eae275..3c4a8e1345654 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -993,6 +993,8 @@ struct sk_buff {
 	__u16			tc_index;	/* traffic control index */
 #endif
 
+	u16			alloc_cpu;
+
 	union {
 		__wsum		csum;
 		struct {
@@ -1011,7 +1013,6 @@ struct sk_buff {
 		unsigned int	sender_cpu;
 	};
 #endif
-	u16			alloc_cpu;
 #ifdef CONFIG_NETWORK_SECMARK
 	__u32		secmark;
 #endif
-- 
2.53.0



