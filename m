Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036780;
	b=wB2Nevm0jppJt0S1N5eX2y7ob2tiijSumn7goQ9gBaGev//VJTJa4lx8IbVoT01T12m9
	 5sWjKj2BgmEEhkl0LzK4gtZ1W5SMpGCbqRaLkB1tjVrfypUBM0hHQ+zHq2qOFpIJTBLai
	 f30f2lB/RjdE8LEgKGhzCj0u428i9MDR0NsDC9W1CnG8hVrUjxu6sxDtp02gqAX6t9ljx
	 QGKumi5+mp75sn75Wa9CyBQ7NNmASU07/Kbpieb01uxDZufGJhMfC169Clu8CisEl6fAm
	 rGxKb7YMPqYVdiMcDgQENhBDZP9eo2OTsojoSs0M5M+SrMYmlvEF/d725N/ENX+JPWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VKW0xN11rhpj0SNox5NDtpJ6iq8JPLMCgo951TDKOzc=;
	b=LZllffDiK7sKWf66XvzPqFKx/8KZIgmfGF3Gly01MR55FRuksVsksfc5VoA0Er/20eua
	 c+os9KmWBxyLucrJ9jJjhQfeXjZ7eAzmFW9YHZ18NRcqSwbm/0XvWZjjvz5CVoPCkGirE
	 S4YsBniWFSDi/pS2udN7R5ai29DzYSVKyFXwhEF5NB4GFdx/T8w95zAYvRE7T258lsuzT
	 z66XQm7/GPL5AfYBkIW15AWlAkMnQFwm2M5qiwG1nyVfQhdSmsjR2JwdKN2UgTA5nRl1J
	 nmWwmZxpuTJ5h3flYCS7qUoVNJeutmO8/LkUthJtxKRHVkgrcYAOfwqgLDCl/m/Ms7A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFZegZlL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D4F6606A32A;
	Wed, 18 Nov 2026 21:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xFZegZlL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A3431F000C4;
	Wed, 18 Nov 2026 21:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036780;
	bh=VKW0xN11rhpj0SNox5NDtpJ6iq8JPLMCgo951TDKOzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xFZegZlLubcESRjMwWXnLN0JNQ6mUIrB++qx5PJxWFK5pnIv7HourJj5UpW2M7Tvs
	 lyLJ+ZnJss3Vqof6PUtxh/A/+g81Bg9po/AeLel7EFpsi4GzmflJWHDLu8K8sqPGis
	 Lmw/xDFzZURyFqNiIqvoDONQizNHwSj5sczbRmG4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yingjie Wang <1075151112@qq.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1181/3318] net: unix: reject negative max_dgram_qlen values
Date: Wed, 18 Nov 2026 15:30:03 +0100
Message-ID: <20261118150355.575881208@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yingjie Wang <1075151112@qq.com>

[ Upstream commit 1a4e7bc6e3457ad95515a9d2c042452c3161bb2c ]

net.unix.max_dgram_qlen is parsed as a signed int and copied to the u32
sock::sk_max_ack_backlog when an AF_UNIX socket is created.  Consequently,
a negative value such as -1 is accepted and converted to UINT_MAX.  Since
the receive queue length is also u32, its fullness check cannot become true
for that limit.

max_dgram_qlen has no documented negative sentinel.  Its existing signed
interface represents nonnegative values only through INT_MAX; negative bit
patterns are not a supported encoding for the upper half of the u32
consumer range.

Switch to proc_dointvec_minmax and make the established 0..INT_MAX input
range explicit.  This rejects negative values without adding new accepted
values or changing the default and zero-value behavior.  Very large valid
values can still make the queue limit impractical to reach; this change
corrects the input domain rather than imposing a new resource ceiling.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Signed-off-by: Yingjie Wang <1075151112@qq.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/tencent_A643419B56079E9A448D97922763FF069F08@qq.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 3 ++-
 net/unix/sysctl_net_unix.c             | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index e21743445e4cc..64fb384dc197e 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -3226,5 +3226,6 @@ l3mdev_accept - BOOLEAN
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
-	Default: 10
+	Possible values: 0 - INT_MAX
 
+	Default: 10
diff --git a/net/unix/sysctl_net_unix.c b/net/unix/sysctl_net_unix.c
index 44996af61999b..91b6448fb290a 100644
--- a/net/unix/sysctl_net_unix.c
+++ b/net/unix/sysctl_net_unix.c
@@ -17,7 +17,9 @@ static struct ctl_table unix_table[] = {
 		.data		= &init_net.unx.sysctl_max_dgram_qlen,
 		.maxlen		= sizeof(int),
 		.mode		= 0644,
-		.proc_handler	= proc_dointvec
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_INT_MAX,
 	},
 	{ }
 };
-- 
2.53.0



