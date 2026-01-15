Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235FA349B0A;
	Thu, 15 Jan 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496299; cv=none; b=SOtGo+xtQVftepNtwp8D3Dq1JwoKAebR9zlM3PqwqI1wMz6aJBZ1ANkkgY6LzCg2aOrQXu9Xq/qJuQ4nRZmWzBCgebmGmuqgF5rL9Zi1XD8C7ygCQqXuza28+prjkvztcxaUUz4kfSTwaKlLULj50ZP7kXi71KVD7K2C650LqeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496299; c=relaxed/simple;
	bh=Qyhb7a13K5vr/yyJtZbWaeSsfp8n8diWBVB2ypq6a+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sd4cHkEdUyA10vtfWDOyG0x4DlLh3+UQnP87q8K3hWuTXluVd6nXxjkiHeIL8dK0dh8aZcEvRz+0Q1EnHDRQ7WK38j5xFfrgPXweRPcMtYIkuaR742Li0QDombPEsQj+vBVX2P84ippmYszf9hIpUxNTBamn6Q5z1b1aM+2mXj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+73qllV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+73qllV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5961C116D0;
	Thu, 15 Jan 2026 16:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496299;
	bh=Qyhb7a13K5vr/yyJtZbWaeSsfp8n8diWBVB2ypq6a+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j+73qllVLZzHheJR+TQZp385BI+PDyLALEnftVrkI+o/E7Q5zbs4Nl6QKgsR7VXBv
	 NwzNjed3SjIu0pdD+aS+8ZqYvRs2tSySwpEcaRUt0gTfyxrw2NFryAl51/Y+nWVB36
	 Ve0jlFLbsHR2RUFmd1uiY2AdfJUtAustPQmKE1Hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 114/181] vsock: Make accept()ed sockets use custom setsockopt()
Date: Thu, 15 Jan 2026 17:47:31 +0100
Message-ID: <20260115164206.431205386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

[ Upstream commit ce5e612dd411de096aa041b9e9325ba1bec5f9f4 ]

SO_ZEROCOPY handling in vsock_connectible_setsockopt() does not get called
on accept()ed sockets due to a missing flag. Flip it.

Fixes: e0718bd82e27 ("vsock: enable setting SO_ZEROCOPY")
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20251229-vsock-child-sock-custom-sockopt-v2-1-64778d6c4f88@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index a9ca9c3b87b31..cbd649bf01459 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1787,6 +1787,10 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
 		} else {
 			newsock->state = SS_CONNECTED;
 			sock_graft(connected, newsock);
+
+			set_bit(SOCK_CUSTOM_SOCKOPT,
+				&connected->sk_socket->flags);
+
 			if (vsock_msgzerocopy_allow(vconnected->transport))
 				set_bit(SOCK_SUPPORT_ZC,
 					&connected->sk_socket->flags);
-- 
2.51.0



