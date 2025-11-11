Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7817F27FD4A;
	Tue, 11 Nov 2025 01:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823949; cv=none; b=LXxNFjD+0MXCT0SrlHfcdh2pc9aqyjE+Y7CntFSnVUZ6y6AGFkBhEmt0EUlMCE7WJcnBrSZpG6Mj4xwmROPinVWVs7Zo4hKcv8+NipxDkuFEGAVDAZrbf3VXsQ9i/DrXYAm96ttL4Gt8ycwjt1577Brn1/v/CkmFoU7SJmJztf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823949; c=relaxed/simple;
	bh=ABnkS29oGZ1Of76JlllobGcJwllOE9dCTfmbdPp64Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KuJj9FuxG57B6Hbes1eb7JWRwSwIt6Zy6pIqFAs+GPULYQOKWjcVYytcaO/uY+yVOnuvA/HqvtJh7+6Ku9rDiWR0avLIw0yQ7HFLa0R+Bt4hMR07w1kAYaGdtasgkkgQencw8TSSIC0a0oIjXHLgXHssE5WWi+2cJjsT+uUq8Q0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOH06Trz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOH06Trz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17A15C4CEF5;
	Tue, 11 Nov 2025 01:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823949;
	bh=ABnkS29oGZ1Of76JlllobGcJwllOE9dCTfmbdPp64Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOH06TrzAMR7lQyIGqPfE0nbs5UeKyl08Rzed+zk1kE/PkXQe+uErDlSWW8CgaOh5
	 LEK88tdtk/M9Wz56PeboAKjQ3eMxw/G0L5xJJFWvUHnt4/eguj5G/rBiIRddYjaP/V
	 W9b3GF+zDPDDWOi7j2cwImg91YWjhqA3WfC/0QTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 403/849] tcp: use dst_dev_rcu() in tcp_fastopen_active_disable_ofo_check()
Date: Tue, 11 Nov 2025 09:39:33 +0900
Message-ID: <20251111004546.182165484@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit b62a59c18b692f892dcb8109c1c2e653b2abc95c ]

Use RCU to avoid a pair of atomic operations and a potential
UAF on dst_dev()->flags.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_fastopen.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/tcp_fastopen.c b/net/ipv4/tcp_fastopen.c
index f1884f0c9e523..7d945a527daf0 100644
--- a/net/ipv4/tcp_fastopen.c
+++ b/net/ipv4/tcp_fastopen.c
@@ -576,11 +576,12 @@ void tcp_fastopen_active_disable_ofo_check(struct sock *sk)
 		}
 	} else if (tp->syn_fastopen_ch &&
 		   atomic_read(&sock_net(sk)->ipv4.tfo_active_disable_times)) {
-		dst = sk_dst_get(sk);
-		dev = dst ? dst_dev(dst) : NULL;
+		rcu_read_lock();
+		dst = __sk_dst_get(sk);
+		dev = dst ? dst_dev_rcu(dst) : NULL;
 		if (!(dev && (dev->flags & IFF_LOOPBACK)))
 			atomic_set(&sock_net(sk)->ipv4.tfo_active_disable_times, 0);
-		dst_release(dst);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.51.0



