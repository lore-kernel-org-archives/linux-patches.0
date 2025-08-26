Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E44CB1662E7;
	Tue, 26 Aug 2025 14:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217756; cv=none; b=XOcfJkFsVS2HiERuUHKSOobkEK2oABuYpNLr39Lx/njQ3AI94Eg9lb8H6OZag242c4x7RNANtHo0z9h4szhtJX8GpWWgI2gku3rOvDU3pjK43FD81LEaGd33EaQVUgFpQgsioAInMTtmhzB4ZDR8DBeA0PHBAFFgdz4c1StYhkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217756; c=relaxed/simple;
	bh=3FBKxPpoOhetmYgNRvcyu8LsG/GLnIfu8AVfS57lchE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPteGDMgIimgbTBCOZ2+hHoHMaPWAtfoVhuiuW02a9EehvYUrWmdATJsFyO0ydll6QjXMFz6nmyJqAeF8kHylDzi6UHVNlj8QRtKI3j4bYFk1KsRBqY8kRexJjsJQwPbAv9UblQPz3qQMFq1OolC95Cwmi4nMuzMA6KyRS99Bwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ikHsARUR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ikHsARUR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771D5C4CEF1;
	Tue, 26 Aug 2025 14:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217755;
	bh=3FBKxPpoOhetmYgNRvcyu8LsG/GLnIfu8AVfS57lchE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikHsARURvf7AtkoEUTAlwDeqwtkLVhEpBkvtpRjfBLINLuKebXdZXsvOOltFygGlu
	 EqzkOidkefGKGAbPbHzS+ocuKv7fpuUMcAGEp413wZTYrYe4/uqG5EV/4ErvDUjPh2
	 6eaBa6cizvvhdpwnOQt3hx3IhZKeQ5CVFParRYvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 262/523] be2net: Use correct byte order and format string for TCP seq and ack_seq
Date: Tue, 26 Aug 2025 13:07:52 +0200
Message-ID: <20250826110930.888410603@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ff3ea24d2e3f..97cbe7737eb4 100644
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



