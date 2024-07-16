Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8C1F9E8;
	Tue, 16 Jul 2024 15:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144613; cv=none; b=tBQRJ7unK61/DU3byfGBEWf3l70Bv2duPGCbbRNctZeRuEpYdoxB9OLr9/uzxIZAJoQteTnHCWpLvkQ8t+s6PBcxjom/FDdYzl1Ytr6j7rpTtJFnkEkDGCVy1e41lnLyZILZdSYAvmM4Epmthf5yZ9bUo9sDlrAKkLqgCqRAZh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144613; c=relaxed/simple;
	bh=FrXu0Rmp/1jat9pqsOiWV5pk5r3ZQtZj5t1ko2+dk1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fo6hWH6MmXDTXgFdEMdIiPaHi+nF7RoS+/ktP8IWV877NScxOqaBPo4nN+rw7GJA7elE4iTpLM/UMs4mJAwH2+Lig6sJzhACYAJ2O1cVVHNka7Bh0G3hkSOkyMbW/HY8d37dhbcxCFK5vSgE+yJtceC4gpt19/7hidl9JeHvKko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uqGA7K2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uqGA7K2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4D95C116B1;
	Tue, 16 Jul 2024 15:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144613;
	bh=FrXu0Rmp/1jat9pqsOiWV5pk5r3ZQtZj5t1ko2+dk1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uqGA7K2mJYIWYFXP8V/vcDlZY4WwCVLHwfBBgYgEpgOOUlPl0iaIQb2MwRDF+Syb
	 0Z9W/c2ei27LzUkOyWNg/1sAvy9dDufWP2PvwViuJ29sXWItlvPBK90LcTRSyWI6bJ
	 Rn5ZID8MpWZFfh+zJody17pYrbEEWZTcBUT0y//k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Xiaochun Lu <xiaochun.lu@bytedance.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 031/108] selftests: fix OOM in msg_zerocopy selftest
Date: Tue, 16 Jul 2024 17:30:46 +0200
Message-ID: <20240716152747.193640710@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit af2b7e5b741aaae9ffbba2c660def434e07aa241 ]

In selftests/net/msg_zerocopy.c, it has a while loop keeps calling sendmsg
on a socket with MSG_ZEROCOPY flag, and it will recv the notifications
until the socket is not writable. Typically, it will start the receiving
process after around 30+ sendmsgs. However, as the introduction of commit
dfa2f0483360 ("tcp: get rid of sysctl_tcp_adv_win_scale"), the sender is
always writable and does not get any chance to run recv notifications.
The selftest always exits with OUT_OF_MEMORY because the memory used by
opt_skb exceeds the net.core.optmem_max. Meanwhile, it could be set to a
different value to trigger OOM on older kernels too.

Thus, we introduce "cfg_notification_limit" to force sender to receive
notifications after some number of sendmsgs.

Fixes: 07b65c5b31ce ("test: add msg_zerocopy test")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Signed-off-by: Xiaochun Lu <xiaochun.lu@bytedance.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20240701225349.3395580-2-zijianzhang@bytedance.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/msg_zerocopy.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/msg_zerocopy.c b/tools/testing/selftests/net/msg_zerocopy.c
index bdc03a2097e85..926556febc83c 100644
--- a/tools/testing/selftests/net/msg_zerocopy.c
+++ b/tools/testing/selftests/net/msg_zerocopy.c
@@ -85,6 +85,7 @@ static bool cfg_rx;
 static int  cfg_runtime_ms	= 4200;
 static int  cfg_verbose;
 static int  cfg_waittime_ms	= 500;
+static int  cfg_notification_limit = 32;
 static bool cfg_zerocopy;
 
 static socklen_t cfg_alen;
@@ -95,6 +96,7 @@ static char payload[IP_MAXPACKET];
 static long packets, bytes, completions, expected_completions;
 static int  zerocopied = -1;
 static uint32_t next_completion;
+static uint32_t sends_since_notify;
 
 static unsigned long gettimeofday_ms(void)
 {
@@ -208,6 +210,7 @@ static bool do_sendmsg(int fd, struct msghdr *msg, bool do_zerocopy, int domain)
 		error(1, errno, "send");
 	if (cfg_verbose && ret != len)
 		fprintf(stderr, "send: ret=%u != %u\n", ret, len);
+	sends_since_notify++;
 
 	if (len) {
 		packets++;
@@ -460,6 +463,7 @@ static bool do_recv_completion(int fd, int domain)
 static void do_recv_completions(int fd, int domain)
 {
 	while (do_recv_completion(fd, domain)) {}
+	sends_since_notify = 0;
 }
 
 /* Wait for all remaining completions on the errqueue */
@@ -549,6 +553,9 @@ static void do_tx(int domain, int type, int protocol)
 		else
 			do_sendmsg(fd, &msg, cfg_zerocopy, domain);
 
+		if (cfg_zerocopy && sends_since_notify >= cfg_notification_limit)
+			do_recv_completions(fd, domain);
+
 		while (!do_poll(fd, POLLOUT)) {
 			if (cfg_zerocopy)
 				do_recv_completions(fd, domain);
@@ -708,7 +715,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46c:C:D:i:mp:rs:S:t:vz")) != -1) {
+	while ((c = getopt(argc, argv, "46c:C:D:i:l:mp:rs:S:t:vz")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -736,6 +743,9 @@ static void parse_opts(int argc, char **argv)
 			if (cfg_ifindex == 0)
 				error(1, errno, "invalid iface: %s", optarg);
 			break;
+		case 'l':
+			cfg_notification_limit = strtoul(optarg, NULL, 0);
+			break;
 		case 'm':
 			cfg_cork_mixed = true;
 			break;
-- 
2.43.0



