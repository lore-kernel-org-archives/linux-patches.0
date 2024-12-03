Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11A51DAC9F;
	Tue,  3 Dec 2024 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241155; cv=none; b=IkvVImkYRBrSba4V/KJXf/tnZe+K0Ul5CdiI+FnLSHlO4Kf1lpXU57+5bcFYZcFhtxW59s36IksTdAG4x29kPF98XWSfwBwTLM69XeKTwos7zXzRK7qJwhewS8sOqZ0TS78r/ul2rgSCIdrC36z+dbC12d6aYu51RuUtNR/P89I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241155; c=relaxed/simple;
	bh=V7xsSRXk+ym1ejSRJ86HgqfTTwgm4wXyvvA4QMHp4Lk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eG3rgCcEfI8PBVcamBXM1XvU6wKR5AjAvuEdIY9xOI3DN8+XOd7WRAkuIkRlC6Uwip+Oj5vKFfSfj6T+WPInWogckXmLfjMUWtdqTD9GiTkMHdcwXWuNBoNNf5DkXZh2T3QJw2FnDiKcQdz9uXPWpfadr3eH6ReM9RDsBHchQhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wZ9HaGzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wZ9HaGzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E41AC4CED6;
	Tue,  3 Dec 2024 15:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241154;
	bh=V7xsSRXk+ym1ejSRJ86HgqfTTwgm4wXyvvA4QMHp4Lk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wZ9HaGzs1Ojdo11ajPeANN3zLr4WHeDzTMIhmmX3N7skMnXpWeyRlqLExLJ2ew6ul
	 segHNPXiYD1J1ZjoCYhlfWSBU72Ie7Z+XERavHgWUz7+aF4IsuiNJ6JXCPme7CHmNc
	 fOlFhdzPmvBuw96xKG9zPkVW2hk1ir3TSTNMPeWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 310/826] selftests/bpf: Fix total_bytes in msg_loop_rx in test_sockmap
Date: Tue,  3 Dec 2024 15:40:37 +0100
Message-ID: <20241203144755.853722653@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 523dffccbadea0cfd65f1ff04944b864c558c4a8 ]

total_bytes in msg_loop_rx should also take push into account, otherwise
total_bytes will be a smaller value, which makes the msg_loop_rx end early.

Besides, total_bytes has already taken pop into account, so we don't need
to subtract some bytes from iov_buf in sendmsg_test. The additional
subtraction may make total_bytes a negative number, and msg_loop_rx will
just end without checking anything.

Fixes: 18d4e900a450 ("bpf: Selftests, improve test_sockmap total bytes counter")
Fixes: d69672147faa ("selftests, bpf: Add one test for sockmap with strparser")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20241106222520.527076-4-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_sockmap.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_sockmap.c b/tools/testing/selftests/bpf/test_sockmap.c
index 1d59bed90d80b..5f4558f1f0049 100644
--- a/tools/testing/selftests/bpf/test_sockmap.c
+++ b/tools/testing/selftests/bpf/test_sockmap.c
@@ -606,8 +606,8 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		}
 		clock_gettime(CLOCK_MONOTONIC, &s->end);
 	} else {
+		float total_bytes, txmsg_pop_total, txmsg_push_total;
 		int slct, recvp = 0, recv, max_fd = fd;
-		float total_bytes, txmsg_pop_total;
 		int fd_flags = O_NONBLOCK;
 		struct timeval timeout;
 		unsigned char k = 0;
@@ -628,10 +628,14 @@ static int msg_loop(int fd, int iov_count, int iov_length, int cnt,
 		total_bytes = (float)iov_length * (float)cnt;
 		if (!opt->sendpage)
 			total_bytes *= (float)iov_count;
-		if (txmsg_apply)
+		if (txmsg_apply) {
+			txmsg_push_total = txmsg_end_push * (total_bytes / txmsg_apply);
 			txmsg_pop_total = txmsg_pop * (total_bytes / txmsg_apply);
-		else
+		} else {
+			txmsg_push_total = txmsg_end_push * cnt;
 			txmsg_pop_total = txmsg_pop * cnt;
+		}
+		total_bytes += txmsg_push_total;
 		total_bytes -= txmsg_pop_total;
 		err = clock_gettime(CLOCK_MONOTONIC, &s->start);
 		if (err < 0)
@@ -800,8 +804,6 @@ static int sendmsg_test(struct sockmap_options *opt)
 
 	rxpid = fork();
 	if (rxpid == 0) {
-		if (txmsg_pop || txmsg_start_pop)
-			iov_buf -= (txmsg_pop - txmsg_start_pop + 1);
 		if (opt->drop_expected || txmsg_ktls_skb_drop)
 			_exit(0);
 
-- 
2.43.0



