Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAC02108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21B8EC433EF;
	Mon, 24 Apr 2023 13:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343080;
	bh=JNwwZ8erFC9UapkXT18tqn01jY1Hhw1A08NlEQTQ3sQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2fCa/SLyaJxDAI4hbotSq6Lq7KxniIJZKdCQPNOTBZz74i7865sutJY9ZKJKKH2FH
	 lDECITIYEznh7yOpeUvFBBmV0zfoIMHo1nQTuF/7nlwHWYQfl1JrV5c2+z6/D/XnCS
	 NTd5ruNrDlRDlukpREyn8twEcUTBq69Vw4EBgHYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	maxpl0it <maxpl0it@protonmail.com>,
	David Ahern <dsahern@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 030/110] net: rpl: fix rpl header size calculation
Date: Mon, 24 Apr 2023 15:16:52 +0200
Message-Id: <20230424131137.257042528@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 4e006c7a6dac0ead4c1bf606000aa90a372fc253 ]

This patch fixes a missing 8 byte for the header size calculation. The
ipv6_rpl_srh_size() is used to check a skb_pull() on skb->data which
points to skb_transport_header(). Currently we only check on the
calculated addresses fields using CmprI and CmprE fields, see:

https://www.rfc-editor.org/rfc/rfc6554#section-3

there is however a missing 8 byte inside the calculation which stands
for the fields before the addresses field. Those 8 bytes are represented
by sizeof(struct ipv6_rpl_sr_hdr) expression.

Fixes: 8610c7c6e3bd ("net: ipv6: add support for rpl sr exthdr")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Reported-by: maxpl0it <maxpl0it@protonmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/rpl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/rpl.c b/net/ipv6/rpl.c
index 488aec9e1a74f..d1876f1922255 100644
--- a/net/ipv6/rpl.c
+++ b/net/ipv6/rpl.c
@@ -32,7 +32,8 @@ static void *ipv6_rpl_segdata_pos(const struct ipv6_rpl_sr_hdr *hdr, int i)
 size_t ipv6_rpl_srh_size(unsigned char n, unsigned char cmpri,
 			 unsigned char cmpre)
 {
-	return (n * IPV6_PFXTAIL_LEN(cmpri)) + IPV6_PFXTAIL_LEN(cmpre);
+	return sizeof(struct ipv6_rpl_sr_hdr) + (n * IPV6_PFXTAIL_LEN(cmpri)) +
+		IPV6_PFXTAIL_LEN(cmpre);
 }
 
 void ipv6_rpl_srh_decompress(struct ipv6_rpl_sr_hdr *outhdr,
-- 
2.39.2



