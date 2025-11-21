Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2620034DB7C;
	Fri, 21 Nov 2025 13:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733067; cv=none; b=HaKTJsj7XoyUHPA1B9jJwy7YsPmr3e5pbh8kdOcrznhNAvHqOuwiVz+Uznm9DKOsYz8H2N+PmQ8ri0bdIzwFGjzsINLYEUk8H0KmNwZB3mG02H8Hul0zTgVt4XQ+WWzicrS5iO4UNCp/CbagI5XJJT+4xVc2QyJfb1jSFhyblwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733067; c=relaxed/simple;
	bh=Rs+l+lBp3B6VG3t3I8wygA5Urhm+AIkVmDcdc2835H4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z7N5WpBUP6rYlhFaSdoRYD7qAv03raFc2K9ZtO377+vf4eEYpk8nBViRNCLmU/n0yeg5kQXM5Hlrv3sd0uJyfYJ+N9uQDaOeTT0lF7lAZmpGMvdWxHZ64a5mgzWu0auk8MsBINn117efnT9PIVpr8+DwXwl7nyvCmVs8/WGrP3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ddekT+wH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddekT+wH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E22FC4CEF1;
	Fri, 21 Nov 2025 13:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733067;
	bh=Rs+l+lBp3B6VG3t3I8wygA5Urhm+AIkVmDcdc2835H4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddekT+wHoJKVCcGkKEPQ65WgSIrktpvzsjbKt5P7qb23jNAyMTGCXgXj8xBg8hiaA
	 Bou3Uff5EogtrG6dSL35K7XAhcFVYzza4ZOSI80TH8UIKLD3rYW0ACAD0niP4ZOQCJ
	 DlA4xcXXMOl6m2LJP8AYOQMFQsozXhDAeRB4Lri8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Anubhav Singh <anubhavsinggh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 339/529] selftests/net: fix out-of-order delivery of FIN in gro:tcp test
Date: Fri, 21 Nov 2025 14:10:38 +0100
Message-ID: <20251121130243.093623455@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 30024d0ed3739..ad7b07084ca24 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -802,6 +802,7 @@ static void check_recv_pkts(int fd, int *correct_payload,
 
 static void gro_sender(void)
 {
+	const int fin_delay_us = 100 * 1000;
 	static char fin_pkt[MAX_HDR_LEN];
 	struct sockaddr_ll daddr = {};
 	int txfd = -1;
@@ -845,15 +846,22 @@ static void gro_sender(void)
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



