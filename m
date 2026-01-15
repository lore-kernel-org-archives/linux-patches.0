Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9866F2C0285;
	Thu, 15 Jan 2026 17:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496705; cv=none; b=ohXtj/86fwAKFch+KSFnNzN8eN9GLLn6oS1xUYHNYRwJsOan1rqw7++FSyVPFOJHpvVIxm2jsI+bx8hPjUtj50GUWDVPZNZKgmo79VZbTnpSwR80sME6jHvddsu5ZlUoTHXJO8RWGrew0Az2i2BdP0nGxW9VErD5acD0uFaZEbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496705; c=relaxed/simple;
	bh=AegRlaPLFMs2sUxJ+s08+DOKN1gXj9O9auVa3G+7Wz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRDPjAgdtv4bgWSU4k20MWwfGBE7H//y+EVBjOBA2cLacAsIRzMg398THNlQ04tI6OMHUX9p7NShI5C6AGG61xLbWOnhiIvJ0DTEQYnx7dRKUJhQpsS7a0fFyxm6s/bvZqeKDV2clBCH2ZYFlpLWAREoMKBX3KzpJgSvwYfyFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsLZkK6D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsLZkK6D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE698C19422;
	Thu, 15 Jan 2026 17:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496705;
	bh=AegRlaPLFMs2sUxJ+s08+DOKN1gXj9O9auVa3G+7Wz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsLZkK6DaAFhrAftNSG7om638CSzOJ5TyFIEfxk7kbF7PS9ldWIEjZ/srlTwNZgB9
	 lfiSj7ix2kzip5jsqWZgMRpNdU9JSoQKoZcf1/FU8Q275mVoQJpvusf+BA4WOGcen9
	 iiy5OjzzT+co6RMVIsNjDcPzAu/5dFVujGjVb6bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 073/119] vsock: Make accept()ed sockets use custom setsockopt()
Date: Thu, 15 Jan 2026 17:48:08 +0100
Message-ID: <20260115164154.587497536@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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
index 621be9be64f67..282d973233245 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1742,6 +1742,10 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
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



