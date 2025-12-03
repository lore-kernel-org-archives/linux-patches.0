Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906BD34FF62;
	Wed,  3 Dec 2025 16:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778097; cv=none; b=kQ8xmFwG5jjzQA9/XUcF65vgq6t4TxQyPz1aOZHzzxkQzGHBkfsSBZGTH5BaFAD606iOOm0V3k/zctpCuIEwstQbFHU7NCz1qWxKhtj3sYQlQVlSqo+OZkcO3219sCXllSIPTUUYN5PB0hTMmM+yKJvE1N3h4KQqnhzJE5X4Bzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778097; c=relaxed/simple;
	bh=vgpXBf5giiDLnhyPFU7DcnYlte+zXwVWcSX3RnEOMpU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgsAxcKNPKl5t7iZAdGaYNQkH1bw/FEtAAISRRCDh8lMhRbicq8FuOeJMNQmTDAKf2Z5SKq/p/aoSCXm3isE+cVFC7LkzfSZ5d2xSJhi/QupoURivajH437rKGs0gqDWTXOa4iWigBGTP5gR4W6yErGYZ6NnKFMvrWL0X7aweo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxXq/Rny; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxXq/Rny"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E649C116B1;
	Wed,  3 Dec 2025 16:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778097;
	bh=vgpXBf5giiDLnhyPFU7DcnYlte+zXwVWcSX3RnEOMpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxXq/RnyjjFdIhQEtWkReOVSAkShryq1k1YF+EcKQOvRtZ8V2WQU9Usxm/Afpab2d
	 PexpvDMe5jxdPZT+0IpY/UqqccZsHCuidPLYpaU8kRb6ReSweHzL2xBh+3nsMF8pUR
	 02gzu6+P7GmKrW7+F/9Behl3QPjg1vXqF46o6Q/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Anubhav Singh <anubhavsinggh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 210/392] selftests/net: fix out-of-order delivery of FIN in gro:tcp test
Date: Wed,  3 Dec 2025 16:26:00 +0100
Message-ID: <20251203152421.800207540@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anubhav Singh <anubhavsinggh@google.com>

[ Upstream commit 02d064de05b1fcca769391fa82d205bed8bb9bf0 ]

Due to the gro_sender sending data packets and FIN packets
in very quick succession, these are received almost simultaneously
by the gro_receiver. FIN packets are sometimes processed before the
data packets leading to intermittent (~1/100) test failures.

This change adds a delay of 100ms before sending FIN packets
in gro:tcp test to avoid the out-of-order delivery. The same
mitigation already exists for the gro:ip test.

Fixes: 7d1575014a63 ("selftests/net: GRO coalesce test")
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: Anubhav Singh <anubhavsinggh@google.com>
Link: https://patch.msgid.link/20251030062818.1562228-1-anubhavsinggh@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/gro.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/testing/selftests/net/gro.c b/tools/testing/selftests/net/gro.c
index cf37ce86b0fd0..687ab5e7cecf1 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -801,6 +801,7 @@ static void check_recv_pkts(int fd, int *correct_payload,
 
 static void gro_sender(void)
 {
+	const int fin_delay_us = 100 * 1000;
 	static char fin_pkt[MAX_HDR_LEN];
 	struct sockaddr_ll daddr = {};
 	int txfd = -1;
@@ -844,15 +845,22 @@ static void gro_sender(void)
 		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 	} else if (strcmp(testname, "tcp") == 0) {
 		send_changed_checksum(txfd, &daddr);
+		/* Adding sleep before sending FIN so that it is not
+		 * received prior to other packets.
+		 */
+		usleep(fin_delay_us);
 		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 
 		send_changed_seq(txfd, &daddr);
+		usleep(fin_delay_us);
 		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 
 		send_changed_ts(txfd, &daddr);
+		usleep(fin_delay_us);
 		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 
 		send_diff_opt(txfd, &daddr);
+		usleep(fin_delay_us);
 		write_packet(txfd, fin_pkt, total_hdr_len, &daddr);
 	} else if (strcmp(testname, "ip") == 0) {
 		send_changed_ECN(txfd, &daddr);
-- 
2.51.0



