Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B8B524AA;
	Mon,  8 Jan 2024 15:39:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gr5UvSVK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C74BCC433C7;
	Mon,  8 Jan 2024 15:39:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728394;
	bh=DyEPa5vZKEpUtxJXzGFjh1NJEjkIgPboBvU77t3koZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gr5UvSVKaaUv5CtnoCDfk8pvHdq6lUCfHDB51Cxds82CufSq9JvbIod0grNPyx8LW
	 XMsYKWRRH2zeSk5bzg45o8+wNkds91rBdv39X8+lR06lLsao6QGY1pxuVlhIlQTvh1
	 EbVHF8v6ZkZvoqotFlZI78TVmHEBWExjXgYIEK4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Lange <thomas@corelatus.se>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 055/150] net: Implement missing SO_TIMESTAMPING_NEW cmsg support
Date: Mon,  8 Jan 2024 16:35:06 +0100
Message-ID: <20240108153513.759383966@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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
index 0d8754ec837dc..c50a14a02edd4 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2771,6 +2771,7 @@ int __sock_cmsg_send(struct sock *sk, struct msghdr *msg, struct cmsghdr *cmsg,
 		sockc->mark = *(u32 *)CMSG_DATA(cmsg);
 		break;
 	case SO_TIMESTAMPING_OLD:
+	case SO_TIMESTAMPING_NEW:
 		if (cmsg->cmsg_len != CMSG_LEN(sizeof(u32)))
 			return -EINVAL;
 
-- 
2.43.0



