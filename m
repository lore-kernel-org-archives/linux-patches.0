Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 598DB15E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seUMdL5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C61A3C433C7;
	Mon, 23 Oct 2023 11:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061109;
	bh=Smf/1YDRMQtiyZVixiidGV1lAz4Ng/k4PSPS2Ln4Vsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=seUMdL5VDitnD9tyGemJXPi+Mh9K8yCUxDGTXtfrP7VBp5gPZRE949Cay1tDMnc0E
	 CmqJmyw1qItr34ieyBmn4lcrmZtUSShoSGtmOG8XaWShlEphK3ayyMtGeQk2z4n1Up
	 Y9gpuG4j66YlKSey3nvHax/hE9b0CmYTdWu6tylc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 048/137] net: pktgen: Fix interface flags printing
Date: Mon, 23 Oct 2023 12:56:45 +0200
Message-ID: <20231023104822.632968114@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

From: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>

commit 1d30162f35c7a73fc2f8cdcdcdbd690bedb99d1a upstream.

Device flags are displayed incorrectly:
1) The comparison (i == F_FLOW_SEQ) is always false, because F_FLOW_SEQ
is equal to (1 << FLOW_SEQ_SHIFT) == 2048, and the maximum value
of the 'i' variable is (NR_PKT_FLAG - 1) == 17. It should be compared
with FLOW_SEQ_SHIFT.

2) Similarly to the F_IPSEC flag.

3) Also add spaces to the print end of the string literal "spi:%u"
to prevent the output from merging with the flag that follows.

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with SVACE.

Fixes: 99c6d3d20d62 ("pktgen: Remove brute-force printing of flags")
Signed-off-by: Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/pktgen.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -668,19 +668,19 @@ static int pktgen_if_show(struct seq_fil
 	seq_puts(seq, "     Flags: ");
 
 	for (i = 0; i < NR_PKT_FLAGS; i++) {
-		if (i == F_FLOW_SEQ)
+		if (i == FLOW_SEQ_SHIFT)
 			if (!pkt_dev->cflows)
 				continue;
 
-		if (pkt_dev->flags & (1 << i))
+		if (pkt_dev->flags & (1 << i)) {
 			seq_printf(seq, "%s  ", pkt_flag_names[i]);
-		else if (i == F_FLOW_SEQ)
-			seq_puts(seq, "FLOW_RND  ");
-
 #ifdef CONFIG_XFRM
-		if (i == F_IPSEC && pkt_dev->spi)
-			seq_printf(seq, "spi:%u", pkt_dev->spi);
+			if (i == IPSEC_SHIFT && pkt_dev->spi)
+				seq_printf(seq, "spi:%u  ", pkt_dev->spi);
 #endif
+		} else if (i == FLOW_SEQ_SHIFT) {
+			seq_puts(seq, "FLOW_RND  ");
+		}
 	}
 
 	seq_puts(seq, "\n");


