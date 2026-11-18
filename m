Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038344;
	b=z75pMBlSCJau+qBPlSzUMNHhwH2glELHcU79QppXSIUMFBaxEbgXkQhB2/Dxv+dkWcXo
	 ljZFIkLod9emJVkUQsdaIJ+p0F55YfqSkJsqKgLoy6m65xf8WDARRMq4dvw5X8zzSF56/
	 eCTAqr5PHUFRgc1IMJxRw6cdEXPJCyq7oRGBcNgdcOyJa4BIqeJy5OOwUXAGOpNKEwveJ
	 dzi/Xyl6CFu8W0CH9iIUAh7uFzzcv24lim0Ni2RMTILm5uALf9zFanYBz/HQ3/l1E42bg
	 XzIuGr+udPIlTHa3qbJL1+lKHUUjqD6kSA0eR4+11peFDGpEpbo6L6u1Vb1svP/xvGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038344;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eimOHcDdvFCEQ1qF0BC9nzFcb4aOvpTKs6rUK9QB4Uc=;
	b=mNmC2+C2tNm4CK76z3qdnGpQQo2N1LJvNMqCKfEycgxpioIiGx55/wEwyonhGtovq+h6
	 kgFYmLwCKMzX3HuFX7Ul5QLXXTDKEl/5+8dMnTvVeGxQwZ2Yxl5zncqY73BYpYVcXJaIF
	 09PQkimfhlfOeNgpAGoDUSz5XflA74sBMwj5reE0jXF/jiVVYujAQMX3JodzA8VllEIAD
	 uWn+cYeVk33QF1/nmnYXbisOsC+GW2cFVSjBLIzZRNZweZSVpNBITgbZXpxseyc1Ckt/L
	 0Tlc6VYNbGBLVc6MuSBrnxAvFKHaFffEAEwRPpekNA+kDWPgCHEsj5uzsAATJpG3elA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvE6ijtv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6509D606A32A;
	Wed, 18 Nov 2026 21:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dvE6ijtv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91F01F000C4;
	Wed, 18 Nov 2026 21:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038344;
	bh=eimOHcDdvFCEQ1qF0BC9nzFcb4aOvpTKs6rUK9QB4Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dvE6ijtv4S2yMIRFtmUmu7W3hZ9HeP7ggV9SCeMkoMlWu02zY8SGm2bo6PlsZm3ht
	 3bsDD8IPZBf63sOoVTZEljQVVvGbjjvdVJO6mDIJ2elFwcM925dqgD6fX5fyapeEoR
	 dFQqhRmXoRGtdSfwBR8UfAjA9JJnaVPLQxsYlcog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dan Moulding <dmoulding@me.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1694/3318] init: fix early boot crash with bare hostname parameter
Date: Wed, 18 Nov 2026 15:38:36 +0100
Message-ID: <20261118150412.650945022@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit b6bec5b63a5b812145e53aaad1e63661c7214f93 ]

When a bare hostname parameter is specified on the kernel command line
without the '=' separator, early parameter parsing passes NULL to
early_hostname(), which dereferences it in strscpy() and can crash the
system during early boot.

Reject NULL values in early_hostname() and return -EINVAL instead.

Link: https://lore.kernel.org/20260826100904.296151-2-blum@kernel.org
Fixes: 5a704629f2c1 ("init: add "hostname" kernel parameter")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Moulding <dmoulding@me.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/version.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6a..0bd5c45aabc46 100644
--- a/init/version.c
+++ b/init/version.c
@@ -23,6 +23,9 @@ static int __init early_hostname(char *arg)
 	size_t maxlen  = bufsize - 1;
 	ssize_t arglen;
 
+	if (!arg)
+		return -EINVAL;
+
 	arglen = strscpy(init_uts_ns.name.nodename, arg, bufsize);
 	if (arglen < 0) {
 		pr_warn("hostname parameter exceeds %zd characters and will be truncated",
-- 
2.53.0



