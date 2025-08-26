Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8205C3376BE;
	Tue, 26 Aug 2025 13:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214469; cv=none; b=OQhxWjyFxf9yVkp3bxoyRwQcL+T9aQMOKakRQ1LhmkrWTlvd/2flAJDyryJ+EIxr/9r69qVQaRaKHF90mo+jdPOdf2IhwMhsI7PfHYV6MpWlwygXW3HbDo80cjRlankr2N4hy7aR+0mHskXrMVl25noNLPzorxfwamHvGaUYo60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214469; c=relaxed/simple;
	bh=Oo7LW0JB3UdPdGTY3ZUzB/uZZGFNbri3dmCCh6X3Zg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ci/giLXv00X3eyUDnY7dsPtAiANBpHk1dO2ZocTeLaSR9Mx0kQM8nahZoPJqNdr6vmcnBhrLDDLmypx8BBP8y0lIRrt6EtVb6zrkUovMJLQgzeb847F8Ukea3NWYYdAhrCsJL1ja+msIapgL47SUokaSMHVGcsT01A//XdVnA38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2dBeGUze; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2dBeGUze"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12937C4CEF1;
	Tue, 26 Aug 2025 13:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214469;
	bh=Oo7LW0JB3UdPdGTY3ZUzB/uZZGFNbri3dmCCh6X3Zg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2dBeGUzegw9IPCWKWAdXTb349JjmFctDZvxanXJ0r0q9YXK0Iaxe+j9uN3PO3cxOi
	 h7Z5wOAGG+Ion9UpJS01nJMaj+Sex+URhEPMi/8BbHv82lWCbejIEBqCXIFNZLacd1
	 GFbrqxxwvYCp7wkB2ZNJ7CCiVETlKIuX3gxVOnP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/482] be2net: Use correct byte order and format string for TCP seq and ack_seq
Date: Tue, 26 Aug 2025 13:06:11 +0200
Message-ID: <20250826110933.741211783@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit 4701ee5044fb3992f1c910630a9673c2dc600ce5 ]

The TCP header fields seq and ack_seq are 32-bit values in network
byte order as (__be32). these fields were earlier printed using
ntohs(), which converts only 16-bit values and produces incorrect
results for 32-bit fields. This patch is changeing the conversion
to ntohl(), ensuring correct interpretation of these sequence numbers.

Notably, the format specifier is updated from %d to %u to reflect the
unsigned nature of these fields.

improves the accuracy of debug log messages for TCP sequence and
acknowledgment numbers during TX timeouts.

Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250717193552.3648791-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 173625a10886..7a3f7b4b859e 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1466,10 +1466,10 @@ static void be_tx_timeout(struct net_device *netdev, unsigned int txqueue)
 						 ntohs(tcphdr->source));
 					dev_info(dev, "TCP dest port %d\n",
 						 ntohs(tcphdr->dest));
-					dev_info(dev, "TCP sequence num %d\n",
-						 ntohs(tcphdr->seq));
-					dev_info(dev, "TCP ack_seq %d\n",
-						 ntohs(tcphdr->ack_seq));
+					dev_info(dev, "TCP sequence num %u\n",
+						 ntohl(tcphdr->seq));
+					dev_info(dev, "TCP ack_seq %u\n",
+						 ntohl(tcphdr->ack_seq));
 				} else if (ip_hdr(skb)->protocol ==
 					   IPPROTO_UDP) {
 					udphdr = udp_hdr(skb);
-- 
2.39.5



