Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621961;
	b=UjTCwPlpXwQZbgbAnJBPz2sr+TpRFo5XdG3CMgX3YQu/lAWuESlI9to0Tn17LzuUQddI
	 /8Ot+T1pGgZdc5frW63squGxFO8e69ZrLMj9C5mk6YiGoZ6N2385Wk7jtm/BhcDOn88va
	 WdxoFEV4VFVk52qC9gnU06Ls5bYw4rL5M8qpgvP1SoqHz+v0clLgaxRTK/r40VjpAiCP5
	 mfPn1/SyFlSVz30p2ympTmsjWwpPS2TjZ6+lQdR/84QgxluueoqdQxT1y00oZIQg2Nr05
	 1omUvWM/wP7D9mfn+p0p3s57J786ybZ4Fj4WVh5Czs2KZhANhs80WQERVeijfHl7fpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y6uv9h1uowMblus6qnRPEU6XgCWgA0G95SC28k04Fas=;
	b=FHWJYt/XUbgzHE7X+co2kXl3MVOxHKuUck4Wmuxt2PBU7klBiRh8yt2CcsMAZfS14EDD
	 7dWD7hnEa4ccI2XMqWKMhtWZTUsUQfpCjcE5+kR4vJsivntcHNEvRASRJ+3zTyad/tnxV
	 QqTR0ybyqbMEGqjCfaH9rhNJyRIyRg5VM5PjcV9xC4lfC8dUT8memfTMpF42Ao5FQtrUB
	 bqO4hZPjd/LFnJQR0XDE5RqPnb8y2Mf2PMzx15PDM+BE9h9wwe1NnrPIyfzSUMvoln970
	 G3gFHHqKMMKZJzhcUoDdbhPM/r2q9NwIsT5d2QDFObE+dOqbKB8uef9OQaKtgFP37Eg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEebLvy8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6B2606A31E;
	Wed, 25 Nov 2026 15:52:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NEebLvy8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13D51F000D0;
	Wed, 25 Nov 2026 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621960;
	bh=y6uv9h1uowMblus6qnRPEU6XgCWgA0G95SC28k04Fas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NEebLvy8zYNwHjX/mH7g6FAZtj6aB3R9qk3LcBGK4NtXevfI0VdJizRftDD3sJb+L
	 SKU9HP1BLkpVoItgssMrrH6bvIf59qpIRoyZ/5Fgc49V8yq2w3o2NdrPhJzB6Lu6EB
	 s12lKAxncdS5+slYJKilMqTfPevdNjzpi2JPidso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/990] SUNRPC: preserve fatal network errors during RPC binding
Date: Wed, 25 Nov 2026 15:29:12 +0100
Message-ID: <20261125143831.109454459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit 30150b94c70eff4bf916d7d367ecf75de25d5337 ]

call_bind_status() initializes status to -EIO. When an unbound
transport's port lookup fails with -ENETDOWN or -ENETUNREACH
and RPC_TASK_NETUNREACH_FATAL is set, the function exits the
switch without updating status. The RPC task then reports -EIO
instead of the network error.

This can occur during NFSv3 port discovery with nconnect,
when an additional transport has not yet bound.

Preserve task->tk_status in the fatal branch. Leave the nonfatal
retry handling unchanged.

Fixes: 9827144bfb2b ("NFS: Treat ENETUNREACH errors as fatal in containers")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/clnt.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
index 07de0efaf37db..bb96cbaf02208 100644
--- a/net/sunrpc/clnt.c
+++ b/net/sunrpc/clnt.c
@@ -2125,8 +2125,10 @@ call_bind_status(struct rpc_task *task)
 		goto retry_timeout;
 	case -ENETDOWN:
 	case -ENETUNREACH:
-		if (task->tk_flags & RPC_TASK_NETUNREACH_FATAL)
+		if (task->tk_flags & RPC_TASK_NETUNREACH_FATAL) {
+			status = task->tk_status;
 			break;
+		}
 		fallthrough;
 	case -ECONNREFUSED:		/* connection problems */
 	case -ECONNRESET:
-- 
2.53.0



