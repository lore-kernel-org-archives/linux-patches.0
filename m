Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40134223304;
	Thu, 12 Dec 2024 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019352; cv=none; b=Qp+3dvGlm0t47n37N5ShmnaZQgh0lWRrRVWEayVEelzquJk1Q7Ath10PPlJiDw5mjBc/x5g9grSy1v0H4DMhS+mpda6QiSJaohm3q0dvbOWSVjAdQthqNLsEQrSk/EWEojF7+vKu7hnZJ2xf/Lc3J0Szx4W3fweKG/8bNpR0tP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019352; c=relaxed/simple;
	bh=bALHUrVMLKZqVIKs3RVkz/d9181ffgGNATJvKa+fWk0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rze+U6DuKYp+x0N5AZQrop2DbIuHMbu6dbqC6J405h9AAv4kkAj4M5gLmmE7ZBYSAtPfjJmA4UNiusIJvGQE3KJsqc9xpSOJRREfw/7ghHmAunF7SgD9AS8i1193ttUo2weYMLxieNTqQ9eTHv8H6W/zowWOm2SudEKKioMOlJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSKmUq37; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSKmUq37"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99A6C4CECE;
	Thu, 12 Dec 2024 16:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019352;
	bh=bALHUrVMLKZqVIKs3RVkz/d9181ffgGNATJvKa+fWk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSKmUq37A58/C7v5ReGkSxnnG7Kgd2JvFJL2NUheZ7Zu8dR1M/MwFFxiymV9j9Y+l
	 y6ITCzfgLmMxCHG5idIQCLG2AwaEM7HiFGcF5t0KaMStzNVc2gN3p3/cOyNv27MGx0
	 DfRs0Ym9M99Swl1BlpcbFbFI7Wzy2uYwNoBLfPWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zijian Zhang <zijianzhang@bytedance.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 184/772] bpf, sockmap: Fix sk_msg_reset_curr
Date: Thu, 12 Dec 2024 15:52:09 +0100
Message-ID: <20241212144357.549460242@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijian Zhang <zijianzhang@bytedance.com>

[ Upstream commit 955afd57dc4bf7e8c620a0a9e3af3c881c2c6dff ]

Found in the test_txmsg_pull in test_sockmap,
```
txmsg_cork = 512; // corking is importrant here
opt->iov_length = 3;
opt->iov_count = 1;
opt->rate = 512; // sendmsg will be invoked 512 times
```
The first sendmsg will send an sk_msg with size 3, and bpf_msg_pull_data
will be invoked the first time. sk_msg_reset_curr will reset the copybreak
from 3 to 0. In the second sendmsg, since we are in the stage of corking,
psock->cork will be reused in func sk_msg_alloc. msg->sg.copybreak is 0
now, the second msg will overwrite the first msg. As a result, we could
not pass the data integrity test.

The same problem happens in push and pop test. Thus, fix sk_msg_reset_curr
to restore the correct copybreak.

Fixes: bb9aefde5bba ("bpf: sockmap, updating the sg structure should also update curr")
Signed-off-by: Zijian Zhang <zijianzhang@bytedance.com>
Link: https://lore.kernel.org/r/20241106222520.527076-9-zijianzhang@bytedance.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 5174f4d48647f..4a97c89c9da9a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2594,18 +2594,16 @@ BPF_CALL_2(bpf_msg_cork_bytes, struct sk_msg *, msg, u32, bytes)
 
 static void sk_msg_reset_curr(struct sk_msg *msg)
 {
-	u32 i = msg->sg.start;
-	u32 len = 0;
-
-	do {
-		len += sk_msg_elem(msg, i)->length;
-		sk_msg_iter_var_next(i);
-		if (len >= msg->sg.size)
-			break;
-	} while (i != msg->sg.end);
+	if (!msg->sg.size) {
+		msg->sg.curr = msg->sg.start;
+		msg->sg.copybreak = 0;
+	} else {
+		u32 i = msg->sg.end;
 
-	msg->sg.curr = i;
-	msg->sg.copybreak = 0;
+		sk_msg_iter_var_prev(i);
+		msg->sg.curr = i;
+		msg->sg.copybreak = msg->sg.data[i].length;
+	}
 }
 
 static const struct bpf_func_proto bpf_msg_cork_bytes_proto = {
-- 
2.43.0



