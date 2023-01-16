Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5998346B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:05:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5865C433F2;
	Mon, 16 Jan 2023 16:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673885155;
	bh=ni5T7fZfYL2N8Hz9PTTrAC2eRAsAWVEB9Ghv0+wdLE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPBH64R5msA9se0YZ/GesXGJ0JVPfqnq5meSEUFgozDtDiiJODRdf4Uplr3mGGShy
	 S5Ymsi7vghv/K4LNctwlWcgphuZfHm8L5Hvrlga+PwIZYUPR+PVaI7Zd3H+5Gu1Rmv
	 wNNRaZov0vypVnBgsuJdkUkXN+4KDopjprdyzPLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Davide Ornaghi <d.ornaghi97@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 01/64] netfilter: nft_payload: incorrect arithmetics when fetching VLAN header bits
Date: Mon, 16 Jan 2023 16:51:08 +0100
Message-Id: <20230116154743.642295197@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
References: <20230116154743.577276578@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 696e1a48b1a1b01edad542a1ef293665864a4dd0 upstream.

If the offset + length goes over the ethernet + vlan header, then the
length is adjusted to copy the bytes that are within the boundaries of
the vlan_ethhdr scratchpad area. The remaining bytes beyond ethernet +
vlan header are copied directly from the skbuff data area.

Fix incorrect arithmetic operator: subtract, not add, the size of the
vlan header in case of double-tagged packets to adjust the length
accordingly to address CVE-2023-0179.

Reported-by: Davide Ornaghi <d.ornaghi97@gmail.com>
Fixes: f6ae9f120dad ("netfilter: nft_payload: add C-VLAN support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_payload.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -62,7 +62,7 @@ nft_payload_copy_vlan(u32 *d, const stru
 			return false;
 
 		if (offset + len > VLAN_ETH_HLEN + vlan_hlen)
-			ethlen -= offset + len - VLAN_ETH_HLEN + vlan_hlen;
+			ethlen -= offset + len - VLAN_ETH_HLEN - vlan_hlen;
 
 		memcpy(dst_u8, vlanh + offset - vlan_hlen, ethlen);
 


