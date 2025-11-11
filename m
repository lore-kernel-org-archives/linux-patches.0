Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1238726E158;
	Tue, 11 Nov 2025 01:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824767; cv=none; b=WHSoiREHPOvd9F8CnX0Br4Ci/mEnJSSJHTPmANOinGSqTDr0cQ2vkcI87vRC8Mwn1/FL+ZRU7nNZIIgwDPnv0MMljtF/kzp3oMMnW3AEFxE3dphjj3PoXulL9f5MSsF2K/2/JA7QqQZgxnl/YFvq2KbGLi/QFvp3lB+763TI0lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824767; c=relaxed/simple;
	bh=LwWxk4xDVVOFmXgMLwrth+LnM0oOG4s5HnICl9YKefE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vovg4jpOWJaEG2zMLHEHTuV66Z+uu6vffsa8vfhV6b0ZRd1jPKaCP3C0PsC8b6qya9LS2oROU25/9Og16HSN8XlLyoTd3IUThFas8SoG25FMW3oB44xjyRlSH9bYIPmNvUFEdler1u268DZZ8MR5uEq1o/agiW3n4b3dmILUGik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wQeGy7/4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wQeGy7/4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D2F1C4CEFB;
	Tue, 11 Nov 2025 01:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824766;
	bh=LwWxk4xDVVOFmXgMLwrth+LnM0oOG4s5HnICl9YKefE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wQeGy7/459OJyhbcd5yq1Tgdqs1NoorBpD4Wyt4zOlprpXl+oYUwcD1LEZyRXjmTn
	 1xg2cRgATKf1QNLSJlIiXpZNPrWzL1QUnpw/RKsw5DKkV/1MT48bpdzhfmH4hEnK6f
	 XB6ZkdOLxIsXcyLb3lXQRVYFyWsJmAkjVmLOkDGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Willem de Bruijn <willemb@google.com>,
	Anubhav Singh <anubhavsinggh@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 513/565] selftests/net: fix out-of-order delivery of FIN in gro:tcp test
Date: Tue, 11 Nov 2025 09:46:09 +0900
Message-ID: <20251111004538.495495002@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b2184847e3881..d8a7906a9df98 100644
--- a/tools/testing/selftests/net/gro.c
+++ b/tools/testing/selftests/net/gro.c
@@ -969,6 +969,7 @@ static void check_recv_pkts(int fd, int *correct_payload,
 
 static void gro_sender(void)
 {
+	const int fin_delay_us = 100 * 1000;
 	static char fin_pkt[MAX_HDR_LEN];
 	struct sockaddr_ll daddr = {};
 	int txfd = -1;
@@ -1012,15 +1013,22 @@ static void gro_sender(void)
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



