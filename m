Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1427E1465A8;
	Tue, 25 Jun 2024 09:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308945; cv=none; b=lUXaCSQiLpNxbfHaSG8c7JHEY30rTiymrm4/iXggG8Jxf4dNugQg45MqTk8A3mhp5WrBuk+yD3GRYNREkNrZuBUQlT4cY2Sj7LAP2WRgLBh+5Oc9MDMr9fD2A8kFj7Zk4feWASZnmiX4fBPLQs0JGPzx6/etoS4Yb1ZxEM2Sjxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308945; c=relaxed/simple;
	bh=EXymjJcvKQXkAaLLPMo3aR48cs2IjmQf5rKJpEpJSSA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QdsIEdBknw8riGt88xVXxEQK0QpF5gA/PoOI+l/Khfsu15RmgeRN8uDHOSDPyCfhFhxrPWl6XJPu0a+RrDo+7RUVPL3W3NQMBwDKvc50lZtA2Opcbw/S4BMVR2YqBD3l4RXEk+vvbIiWiWhbtMYY3OB8Qifmzcry2ZtMcjwJU6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lPeuq4eB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lPeuq4eB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F321C32781;
	Tue, 25 Jun 2024 09:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308945;
	bh=EXymjJcvKQXkAaLLPMo3aR48cs2IjmQf5rKJpEpJSSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPeuq4eBRD1CQ/WBcGPQt9hyxrMFEGM941SWx+kIDrizNrezqjob0VFNTx57EL5sk
	 5LYrV8snGzl8hzxECvbveyad5hEmDuHQdENsLXgxFgBFeCY58beouQLqxdq9OI1aAW
	 wTYtPGtPk/suTjcyrrRACU13lhR88uvV0bUhCzuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	Kees Cook <keescook@chromium.org>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 015/192] af_packet: avoid a false positive warning in packet_setsockopt()
Date: Tue, 25 Jun 2024 11:31:27 +0200
Message-ID: <20240625085537.742907093@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 86d43e2bf93ccac88ef71cee36a23282ebd9e427 ]

Although the code is correct, the following line

	copy_from_sockptr(&req_u.req, optval, len));

triggers this warning :

memcpy: detected field-spanning write (size 28) of single field "dst" at include/linux/sockptr.h:49 (size 16)

Refactor the code to be more explicit.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index ff1ddf544e179..10a6ec43efb9f 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -3805,28 +3805,30 @@ packet_setsockopt(struct socket *sock, int level, int optname, sockptr_t optval,
 	case PACKET_TX_RING:
 	{
 		union tpacket_req_u req_u;
-		int len;
 
+		ret = -EINVAL;
 		lock_sock(sk);
 		switch (po->tp_version) {
 		case TPACKET_V1:
 		case TPACKET_V2:
-			len = sizeof(req_u.req);
+			if (optlen < sizeof(req_u.req))
+				break;
+			ret = copy_from_sockptr(&req_u.req, optval,
+						sizeof(req_u.req)) ?
+						-EINVAL : 0;
 			break;
 		case TPACKET_V3:
 		default:
-			len = sizeof(req_u.req3);
+			if (optlen < sizeof(req_u.req3))
+				break;
+			ret = copy_from_sockptr(&req_u.req3, optval,
+						sizeof(req_u.req3)) ?
+						-EINVAL : 0;
 			break;
 		}
-		if (optlen < len) {
-			ret = -EINVAL;
-		} else {
-			if (copy_from_sockptr(&req_u.req, optval, len))
-				ret = -EFAULT;
-			else
-				ret = packet_set_ring(sk, &req_u, 0,
-						    optname == PACKET_TX_RING);
-		}
+		if (!ret)
+			ret = packet_set_ring(sk, &req_u, 0,
+					      optname == PACKET_TX_RING);
 		release_sock(sk);
 		return ret;
 	}
-- 
2.43.0



