Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277D0348477;
	Fri, 21 Nov 2025 13:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733253; cv=none; b=k572OQN10wEaiGHXoqLJ35Lvn1B5dmM0u0DV8QFPmgypNSevyzEbpEXm+a1IJ9Jvj/XSHj4cKnanZBdL7fc4jZCi8CnBzRXwNilpt8Jh84XjlwDMll2xUhjsqzbD1So+zuZV45E5eu+SCGanxktIIqt3x5kxc0yIaaJkOshVGe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733253; c=relaxed/simple;
	bh=gmQ0HIP9Sw6Rb9v1+hQTwW3YMMr9zEyg4TUPfklAKVE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bmHNU/f75wGKj7JDS/JJQOy+pIJhwYLBZmpSuU8gcNCM0xAX8NqRmD2++CgddDR3DWBtn4TQ4dKQgf09KhqSUE94PYsAYx2ySJteoY0grb9Fhy0plzOyPpHdqEfJST6qNTvoRfbfVqiC1EkF3pVpFDSGV5McpiFIYw1neV6/PiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CLquLMsF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CLquLMsF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CA78C4CEF1;
	Fri, 21 Nov 2025 13:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733252;
	bh=gmQ0HIP9Sw6Rb9v1+hQTwW3YMMr9zEyg4TUPfklAKVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CLquLMsFkyrYNktGK1fpF4Gu+3kFrPJix1w3YExZo5v3Q9cUjxyccyr5ueX9+8HQI
	 mvxvYffdpSJ6dLSKdRbV5FMJURya9K8E7oLKqTfdtkns/h9U42GJjhKoSzud0tow3e
	 AgvZMI+O+RU7nXBG+UZhob78kmZDmHfqCf5ikIzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 404/529] net/handshake: Fix memory leak in tls_handshake_accept()
Date: Fri, 21 Nov 2025 14:11:43 +0100
Message-ID: <20251121130245.395840118@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit 3072f00bba764082fa41b3c3a2a7b013335353d2 ]

In tls_handshake_accept(), a netlink message is allocated using
genlmsg_new(). In the error handling path, genlmsg_cancel() is called
to cancel the message construction, but the message itself is not freed.
This leads to a memory leak.

Fix this by calling nlmsg_free() in the error path after genlmsg_cancel()
to release the allocated memory.

Fixes: 2fd5532044a89 ("net/handshake: Add a kernel API for requesting a TLSv1.3 handshake")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Link: https://patch.msgid.link/20251106144511.3859535-1-zilin@seu.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/handshake/tlshd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/handshake/tlshd.c b/net/handshake/tlshd.c
index bbfb4095ddd6b..06916a80cc130 100644
--- a/net/handshake/tlshd.c
+++ b/net/handshake/tlshd.c
@@ -254,6 +254,7 @@ static int tls_handshake_accept(struct handshake_req *req,
 
 out_cancel:
 	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
 out:
 	return ret;
 }
-- 
2.51.0



