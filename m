Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026334;
	b=oOofmJEikWlbeyx5f3dUn5AA4oSIvCFrhcJQ8zdWf8KLNOj1j7COfY6IhLWXFa/O+dTp
	 5QRpZq0Kc+pL3q0ebBn6fkutnLj1hESD4iR2dicK9IQSTnJDJYBYfl0reJ3xzQcqqnbXx
	 nIMcgMekBr2tkaomGlfUZyXqs8SupPaybnVWqFAmH3nr3CyQAyWxRdabCkwwy+UD8M3Fv
	 xEmIQbNG7W/kGXDAqTAMYYslgnL2L8V6e0uF4Ldugjzjc1wyWpbhyVCYo4oR72NSFctex
	 RWufoYscGPVPgPP9dI9pI9RMP7gZ2dhCQz0mMUN0qnOUu2j7HGOvewLruvCdHbo78yw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9A2uhExaKSHw+0HilPBvaiSibM6Wil9OOB/GuvrtM/M=;
	b=IHNONaCjALJIfa2AzCLTP86Tcp4qERlEIvUnR/Z/jaCPkrxM2xt2cP5kcevMFkvXSmX8
	 y7+cM61PZssRFaHAmvBXCbLKc3CVFw1LIkAts0X/0BkuhyOQU6lIij+DZmmwQ3cwSphE3
	 4hdO4QxSUGvOBJvQ4sUF/6azV2I990+tuMOF0lgnLFOyR1msH26Sblx9sY/hoSYMfhfHr
	 ynCB1x92xaAB6LT/yvnmeo3+W8uVIntzMu1oN1lRWBpjZ90qTkVxXG3nwXc3Fy5kgHYUC
	 BSQ8/S02bzrQUW8xEavgrN2FbcO/l4HrsVCFYfUn+Oq8vGqXlkLnBXXZ5skYmAT3wXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1kFUh7V;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C431E606A320;
	Wed, 18 Nov 2026 18:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v1kFUh7V
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 273BD1F000C5;
	Wed, 18 Nov 2026 18:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026334;
	bh=9A2uhExaKSHw+0HilPBvaiSibM6Wil9OOB/GuvrtM/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v1kFUh7VrOxczClOycFsqcUelqQ3jq1N5q8dMfI5CZMwJxebdbE4sgh4mM65rmd4n
	 3VFa+8xadu2qbWhr1Es1gzxZCXHOTjWBfbx1A4fJrLIchO2og7xmCGy5RTW11C3XHT
	 ods68jegRs6JFvx62s/n3bMLRkNGxFAaPrf9jWUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1398/2151] tcp_bic: fix divide by zero on max_increment == 0
Date: Wed, 18 Nov 2026 15:52:13 +0100
Message-ID: <20261118150212.919455588@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 8edbf6c23363563e508a61f3f26f4e4b6eec9dd5 ]

max_increment is how many packets cwnd can grow per RTT, so 0 makes
no sense, and bictcp_update() divides by it.

Reject values below 1 when the parameter is written.

Fixes: 83803034f423 ("[TCP]: Add TCP BIC congestion control module.")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@kernel.org>
Link: https://patch.msgid.link/20261008092641.140777-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_bic.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_bic.c b/net/ipv4/tcp_bic.c
index 65444ff142413..27d2e38ff7932 100644
--- a/net/ipv4/tcp_bic.c
+++ b/net/ipv4/tcp_bic.c
@@ -27,15 +27,25 @@
 					  */
 
 static int fast_convergence = 1;
-static int max_increment = 16;
+static unsigned int max_increment = 16;
 static int low_window = 14;
 static int beta = 819;		/* = 819/1024 (BICTCP_BETA_SCALE) */
 static int initial_ssthresh;
 static int smooth_part = 20;
 
+static int max_increment_set(const char *val, const struct kernel_param *kp)
+{
+	return param_set_uint_minmax(val, kp, 1, INT_MAX);
+}
+
+static const struct kernel_param_ops max_increment_ops = {
+	.set = max_increment_set,
+	.get = param_get_uint,
+};
+
 module_param(fast_convergence, int, 0644);
 MODULE_PARM_DESC(fast_convergence, "turn on/off fast convergence");
-module_param(max_increment, int, 0644);
+module_param_cb(max_increment, &max_increment_ops, &max_increment, 0644);
 MODULE_PARM_DESC(max_increment, "Limit on increment allowed during binary search");
 module_param(low_window, int, 0644);
 MODULE_PARM_DESC(low_window, "lower bound on congestion window (for TCP friendliness)");
-- 
2.53.0



