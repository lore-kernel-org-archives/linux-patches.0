Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064785;
	b=r9ZXFVf6Nv8+yKYrfbD2voshqeLhO9f0FpjMpmr6eNZuva0BvmW6eB6RP4ig6I41ACzv
	 m7QEROiRnXWXNhgn7AmuXtR8N0y1a0uaIWqpJA2zJU6boNJagklFLpxtF30bIOiQTshDt
	 p8cZy9/ObcjEmCSP9UuithUJGl13Z8qzWzRRvay6TFydenziG6/XK/Hl3Ew8QKHarNoY0
	 0Lx7Be+Dvs41Mhz8KNcfjxZU74B5VNfaUE0cEJCsTcEWSkUnAj9pUsf2BGFZgpKa7ad0o
	 QC8sePs4DnufwAQoB9rml0DTd5TFS7BAwkiW9sloMMaY7cgz9yVdne6LvM/XPNr/orA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064785;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NL9lkRo/Q5LGZcGFJ/LCV7nfWY+uNpi4e+HXBopJUMU=;
	b=ZN3I8X0dgw1z5kjEp3Jlxr6lZDDJwUwHAB+Lvg1Ym5Az22uXeC8QVEBwA8lmA5S5vjrv
	 Dh/jR8p/+zasiO8oNPCVZeObdbCXgkyKpME0WupLGeLtBAQA06tMaAlQPbgjJrhTQJSze
	 iROQ+hqEAMpqMIshpcN2Wf1QQyQ2kDOzaa3nCI2+our1cyditBrIJ6xG9mL+4Xx86CNn+
	 zCB4LmCSJMgblsB7BlXWu2zxRGF0j/aSpckBCBoFj2z79neJ/FfAIZyB/6MosA7Rnsx76
	 JyRWOSqDsGCzIZ0/7zzpMsyrFe16A1rtS5IZIYaPZXk8yStI856tf2Hqb5E/FQMT0PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mYx9Xie4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65BC606A9FA;
	Sat,  7 Nov 2026 15:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mYx9Xie4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B1151F0089F;
	Sat,  7 Nov 2026 15:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064784;
	bh=NL9lkRo/Q5LGZcGFJ/LCV7nfWY+uNpi4e+HXBopJUMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mYx9Xie4IYdEeuuj/f9Ma7owNPi9ZpIv9pBvmcSBPFfZJmq10JxIMwBtOxRo311jp
	 St7X7myjtxBavj7xow51dQNG9aPHIj2xrUvc5BAfPZZBDm7AVVkQ15oHoHEtwz0tIu
	 NN6ezsgEJUKdqcgYScMkvnvF/VO/fs2d9Ij/q0lQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bradley Morgan <brads@mainlining.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>,
	Guenetr Roeck <linux@roeck-us.net>,
	Sashiko <sashiko-bot@kernel.org>,
	Wang Jinchao <wangjinchao600@gmail.com>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0733/1257] panic: fix va_list reuse in panic_try_force_cpu()
Date: Sat,  7 Nov 2026 08:50:29 -0500
Message-ID: <20261107134959.520521612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bradley Morgan <brads@mainlining.org>

[ Upstream commit 245001a347f1effc09c233d1712e1efeedab59ee ]

vsnprintf() consumes the caller's va_list.  When the redirect fails,
vpanic() reuses it for the panic message, which is undefined behavior.
Use va_copy().

Link: https://lore.kernel.org/20260916182957.7788-4-brads@mainlining.org
Fixes: 2e171ab29f91 ("panic: add panic_force_cpu= parameter to redirect panic to a specific CPU")
Signed-off-by: Bradley Morgan <brads@mainlining.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Petr Mladek <pmladek@suse.com>
Cc: Guenetr Roeck <linux@roeck-us.net>
Cc: Sashiko <sashiko-bot@kernel.org>
Cc: Wang Jinchao <wangjinchao600@gmail.com>
Cc: Wim Van Sebroeck <wim@linux-watchdog.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/panic.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/panic.c b/kernel/panic.c
index e1b443150ba0b..6b5728c3c9ce2 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -417,7 +417,12 @@ static bool panic_try_force_cpu(const char *fmt, va_list args)
 	 * fall back to static message for early boot panics or allocation failure.
 	 */
 	if (panic_force_buf) {
-		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, args);
+		va_list ap;
+
+		/* Do not consume args, the caller reuses it if we fail */
+		va_copy(ap, args);
+		vsnprintf(panic_force_buf, PANIC_MSG_BUFSZ, fmt, ap);
+		va_end(ap);
 		msg = panic_force_buf;
 	} else {
 		msg = "Redirected panic (buffer unavailable)";
-- 
2.53.0



