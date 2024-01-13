Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 982B61846;
	Sat, 13 Jan 2024 09:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lt+EJMS4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179F2C433F1;
	Sat, 13 Jan 2024 09:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139891;
	bh=6Wtv63WM5HwCju8Qlwa9MvBk1vQpSD0crBdvpzdJV4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lt+EJMS4HAAX7lQwtyZT/I3k+qA4P5rMotoLHknoq2PmHAXpzOCyetkmvm6rjLO0U
	 bwGOV5fhCDONUbbkSVQM97ef3vYOPrwRrZj5+GYip3+Aeo8tzCiEKejKTdXx8MZMjk
	 2Bza/0C0QYsLRTBkAVsVf4CASkltFFbh3+IHXNqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Lange <thomas@corelatus.se>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 26/43] net: Implement missing SO_TIMESTAMPING_NEW cmsg support
Date: Sat, 13 Jan 2024 10:50:05 +0100
Message-ID: <20240113094207.754508628@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.930684111@linuxfoundation.org>
References: <20240113094206.930684111@linuxfoundation.org>
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

From: Thomas Lange <thomas@corelatus.se>

[ Upstream commit 382a32018b74f407008615e0e831d05ed28e81cd ]

Commit 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW") added the new
socket option SO_TIMESTAMPING_NEW. However, it was never implemented in
__sock_cmsg_send thus breaking SO_TIMESTAMPING cmsg for platforms using
SO_TIMESTAMPING_NEW.

Fixes: 9718475e6908 ("socket: Add SO_TIMESTAMPING_NEW")
Link: https://lore.kernel.org/netdev/6a7281bf-bc4a-4f75-bb88-7011908ae471@app.fastmail.com/
Signed-off-by: Thomas Lange <thomas@corelatus.se>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20240104085744.49164-1-thomas@corelatus.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/sock.c b/net/core/sock.c
index 9c3bc24bfdd1f..aa5237a6116e1 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2402,6 +2402,7 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 		sockc->mark = *(u32 *)CMSG_DATA(cmsg);
 		break;
 	case SO_TIMESTAMPING_OLD:
+	case SO_TIMESTAMPING_NEW:
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
 			return -EINVAL;
 
-- 
2.43.0



