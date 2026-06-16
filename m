Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952EE3D810C;
	Tue, 16 Jun 2026 18:06:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633196; cv=none; b=NCvhs4LmYFp6G0LZxAWc4dT9baCDzX7sE8t2O5MSkn7rGUFu73bDw2Vt3F5cZY/hG7DkpA1mhrTMIk6cPBjlBOzL6hRcRWUkFiLc65bKtOYk/OWfVYY7lUUdLiJuu7CLCDtYRTsdJvAzvp4alFgXDN9nDP7QQQnwa9m5i+8ZlKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633196; c=relaxed/simple;
	bh=JMlA9M7QDVclwxYc1qKVEBMJ0PKbW7h3InK2WCsKh4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Pfejav20NCJl0xF2zLI0PX+l/RFXcZ/0toKFc2PqiowPrfQSzZQltfbIi1+xRCjVP2argr1RGYzCnNCr3CEvLrC00kHvRA+AHi40J1N6AGPTkNAo4+lGAuTRV4EQlmhBgvBwEQhiVrPclUS7xSlstSoc3UUZNwvaBE0JIzmpmeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vrts3+7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vrts3+7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3871F000E9;
	Tue, 16 Jun 2026 18:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633193;
	bh=BsiGnypnl63BjY+yYYKTx1aoPm8jYw5XKCI1YBu+B7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vrts3+7YzV2+UbU4ozg1hOOPwq4ATidhny58BU2pA6MuCdTa32D87B912AVLNhwxP
	 I4m8yt0WiVV3kGv+fO81wwKUn/2qyUhzQ3nqBovbyD2HYidMsnD/HKiHLUUJM99eq0
	 poQ+3ZCQzkxWWnxKb3HRYgMb/y92k3oEuo4okHlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/411] sctp: fix race between sctp_wait_for_connect and peeloff
Date: Tue, 16 Jun 2026 20:24:32 +0530
Message-ID: <20260616145102.147205777@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 11040232ee937b..136b122d87c5a6 100644
--- a/net/sctp/socket.c
+++ b/net/sctp/socket.c
@@ -9369,6 +9369,8 @@ static int sctp_wait_for_connect(struct sctp_association *asoc, long *timeo_p)
 		release_sock(sk);
 		current_timeo = schedule_timeout(current_timeo);
 		lock_sock(sk);
+		if (sk != asoc->base.sk)
+			goto do_error;
 
 		*timeo_p = current_timeo;
 	}
-- 
2.53.0



