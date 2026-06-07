Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C60323392F;
	Sun,  7 Jun 2026 10:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827652; cv=none; b=XSL8lXEMxyi2IzgesvvIiDliVJb/vYESJFlTAS9rJoHm5CS4ImQHClSkBxu1fmaE+0dEdudVTdO255mnB1HQ5fcnc7iqvKd/CY6h4NrN7VSdQMAap3VlwJAntCW7xrgDbf9l52GgrCQba7TqLBxQ3zr9VKzpeqrOVU/wj0STsSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827652; c=relaxed/simple;
	bh=L4XEuaVr4buyO5WShRF03ZGq0/N1pSwJ8CPB57F8bEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZQgjJh3XmloMx9RXznj1UUIORaU+F3mt9j4FN8zW5oD3xzmfo0HvYuU3R5xhYyYY0w9lt0ZUn71fZ7I66Lbv3BK3o+ED/ATokwoULB+A6KbE9/XnakJ1J1YzBVTKNa1yaAOZEtkZT3JfPkMvkoGNv8wAhSz7Zs++R9Jrr6aTjkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H13NLXlb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H13NLXlb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AAB1F00893;
	Sun,  7 Jun 2026 10:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827651;
	bh=UAVg3Iq5hnTYyRD0Q4hjIL4hYI6gPMl1dwL0mLtbjWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H13NLXlbF3zln4r0NGJvzE3H0tqTWMiLv4xI5e3bLj59p81QMS009k0iy+oWsFFd7
	 +I2xmZuHhVmGTKOenA6K/jWHkn0iBuxRmjPTZL5KDVehsFCn5XpLbTb4shM1T3/sfk
	 NR/P7kduo31Prbs8mAlMVEsbPPza0ngZ1jP14q4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 090/315] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Sun,  7 Jun 2026 11:57:57 +0200
Message-ID: <20260607095730.931617884@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit f14fe6395a8b3d961a61e138ad7b36ba3626dd4e ]

sctp_wait_for_connect() drops and re-acquires the socket lock while
waiting for the association to reach ESTABLISHED state. During this
window, another thread can peeloff the association to a new socket via
getsockopt(SCTP_SOCKOPT_PEELOFF), changing asoc->base.sk. After
re-acquiring the old socket lock, sctp_wait_for_connect() returns
success without noticing the migration — the caller then accesses
the association under the wrong lock in sctp_datamsg_from_user().

Add the same sk != asoc->base.sk check that sctp_wait_for_sndbuf()
already has, returning an error if the association was migrated while
we slept.

Fixes: 668c9beb9020 ("sctp: implement assign_number for sctp_stream_interleave")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20260527032411.60959-1-kipreyyy@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sctp/socket.c b/net/sctp/socket.c
index 2c5ad53984906c..c763eb3296b3ee 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9350,6 +9350,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



