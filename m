Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7512325A64C;
	Tue, 11 Nov 2025 01:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824823; cv=none; b=CSULlb32iYYW+O0xD/TnDkwfA7f5PJKTWHBNdQCHzmnV+V4t+bv3A8BasAs40JugDnRy+k8OTe1MaWBOLojkufy/Nsyn8hEjv7Y5v2i+enFwfk9Imx4zuyH/WwCcsj3vTxa9p7cQAJkKiTGipqP879k2cT9s7iAd6v1DogPwRvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824823; c=relaxed/simple;
	bh=8BqeE5KFvSJa+7Q1AtBU3w1YW6hbmyysRSBaEzzPIHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIaNbsW/kGiPacgYd8435I7k9LQDrnSs7bZ1iLu27To48iZIxCgM6Pe/aBzahoneM6rDnsutgFI1ad+U0UTC79KAaSHc/jdQHIU+HJS/cJOFQ65udy0iBFJb1fEwTv51yJqWWkEFNtCEsNAZ1KBVR+Ku3n3KhvkxwP4tTQQYDP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v3T+mYGQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v3T+mYGQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1564AC116B1;
	Tue, 11 Nov 2025 01:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824823;
	bh=8BqeE5KFvSJa+7Q1AtBU3w1YW6hbmyysRSBaEzzPIHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v3T+mYGQTtNuZTxn3vW56MLQ0D+LBcTWk/q8/BHpkCI1HJnqAZFylxx6S1Yphqxri
	 aGF0p220i1CyBojHrK7TINxXI+F+Mlo/EYHm4KJU6hqI+QopJMoz7MSVI5QtYOxPOH
	 uFjqMeznhUEaUCsUB7HJlUniGyVdwE+x68zEibxg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Stefan Wiehler <stefan.wiehler@nokia.com>,
	Xin Long <lucien.xin@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 524/565] sctp: Prevent TOCTOU out-of-bounds write
Date: Tue, 11 Nov 2025 09:46:20 +0900
Message-ID: <20251111004538.752125999@linuxfoundation.org>
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

From: Stefan Wiehler <stefan.wiehler@nokia.com>

[ Upstream commit 95aef86ab231f047bb8085c70666059b58f53c09 ]

For the following path not holding the sock lock,

  sctp_diag_dump() -> sctp_for_each_endpoint() -> sctp_ep_dump()

make sure not to exceed bounds in case the address list has grown
between buffer allocation (time-of-check) and write (time-of-use).

Suggested-by: Kuniyuki Iwashima <kuniyu@google.com>
Fixes: 8f840e47f190 ("sctp: add the sctp_diag.c file")
Signed-off-by: Stefan Wiehler <stefan.wiehler@nokia.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Acked-by: Xin Long <lucien.xin@gmail.com>
Link: https://patch.msgid.link/20251028161506.3294376-3-stefan.wiehler@nokia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/diag.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/sctp/diag.c b/net/sctp/diag.c
index dadf8254b30fd..95e65b9d623b3 100644
--- a/net/sctp/diag.c
+++ b/net/sctp/diag.c
@@ -88,6 +88,9 @@ static int inet_diag_msg_sctpladdrs_fill(struct sk_buff *skb,
 		memcpy(info, &laddr->a, sizeof(laddr->a));
 		memset(info + sizeof(laddr->a), 0, addrlen - sizeof(laddr->a));
 		info += addrlen;
+
+		if (!--addrcnt)
+			break;
 	}
 	rcu_read_unlock();
 
-- 
2.51.0



