Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD344502F;
	Tue, 16 Jun 2026 17:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630481; cv=none; b=QWPqO9rS+ws+4lZ0kQVh7ykK/7KVZn8O0J+w+yBS5dugnrPU9WOzpx8W/eGAz8bS3uRZs5+XciImxAux8QypNTWhfZSTGUJoaqoj/6xiNhaQ1GTPRR6cb4xE0VZLbByzeJn3bhjQwGuiksphiicOAD/9hAkAzY19lxK97/9iOKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630481; c=relaxed/simple;
	bh=R8vlusCmrM6OQxTIHpMrQ9uxLth9bfr/dZDzKhBSQOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UzXj5jdXj3IyT8iH446aVec1vpeNRCbwLPscH5KRBAbDaZ2cbLrDr0hrV5oaLXGE8YEf5/dgsCGZMGGu56NVdrGw+/uGMhpDf05S4fol8xhpLqJlLaHQpjx0bBFyamUYDg2O6GaKk1YZzkJDtqIDEVzSZg30P5p0pupMRMUg8+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NDJps+qX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NDJps+qX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DBF1F000E9;
	Tue, 16 Jun 2026 17:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630480;
	bh=NFU3bEeTGWs0lV7XSuI1XFkytEiCSdsUCRzygzU1TSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NDJps+qXvBp/gdUQmP9q/TDo0i6UUDjIDWbJ1o5E9+UKbvvTpV3M0dCo55aU3PgnY
	 6nBLYHkwL0cGJh8lzgGjWHgAWDCkCZKHtXoFvwrGrLZpYxeSVtFlvYrvPo6A8eHkIS
	 RuyXaq83KGNyBoHtgycUceIibs/6ZlDFeSy6KbVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 038/522] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Tue, 16 Jun 2026 20:23:05 +0530
Message-ID: <20260616145127.470027110@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b544f403f7ca8f..867a426867a7d1 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9364,6 +9364,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



