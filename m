Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040073;
	b=cd4oWgSdR00NRFeCN4L/pLlo1pRSGlnvfnIdSZy1QKSHaGePguyZaCguU0LmnuLyCMVk
	 S16tSNnJeIU4TpTWEXo/Yk8AwucmOy3tzpBo4KRyF8X412fRfVOVB+h1xqvdu4LEn/0kC
	 cB3Ab4kZNveGVQB+Hyg9QpYw0Avw+zGORJpUaoYjSj6cTCOBxeSsWVUhM1u5GFiwijJr+
	 Vv+WVFNLixuZOvo39K7srNZfbXt73hvjE8B1F9un5T2k8mD3qqNMhiamq2OCaFVAA+xob
	 fA3aJOAdOAgVwiyR6UVtWckxB6FBBz1NvQ/8/zSjIuFpZXGXGmAhjrVsWK8q3xw1EVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040073;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fzzipzNCpMdB8iv5i6FgUy8x18BcD3QzsFgTPqLih/8=;
	b=NiD6upEueIX5VNeCg8TP82JSO3FeVQL1eGPPkCclltpbol7qnsPn7NBO7oFYwZg5fcwW
	 FLQTCgTV+CcbfROPmuzIvGlNnWoixSvRgxP18DOuumTQOps46ItDXuh0foO+qM/Boder9
	 B0uLFN0fRUIlr8QQkWn1nBFU3VoA7Ao17g/zT3wIUvBbE1l9GWs+9Ip+rRvknYtjjsLaz
	 W1i3bwxJg3JerH0a6sNjyJHy3o6HOK0ZI/CLRoqdHiB/HgzGI6KbEWqlb/WXNPkCoeFhm
	 9pCmZczTS6jdYxIc4Eh6VJU3RhOZeUDjZ/w3Od5hMHvDiPygCH+8QsXdC9BG703Gqtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCHzvhWy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98528606A31C;
	Wed, 18 Nov 2026 22:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vCHzvhWy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8B791F000C4;
	Wed, 18 Nov 2026 22:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040073;
	bh=fzzipzNCpMdB8iv5i6FgUy8x18BcD3QzsFgTPqLih/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vCHzvhWypZv+GyteoI6m14B0UXSSz4b3fWfoMYsK6uyqt0R3XVajGDoBRyxrKLpYT
	 UYVMNj+UjP5xPcACmTkc1+jm4vQ0ed0Ww9KveIlM2O2VBmJgBFYBw2Z7ML8NweKhME
	 VDH3g9oOA+pGvM227hKHchviL1OQ0uQ21+EgRQzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zongmin Zhou <zhouzongmin@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2328/3318] serial: sifive: fix off-by-one in console port bounds check
Date: Wed, 18 Nov 2026 15:49:10 +0100
Message-ID: <20261118150431.497537706@linuxfoundation.org>
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

From: Zongmin Zhou <zhouzongmin@kylinos.cn>

[ Upstream commit bf961847813d9edcb5a9c089714069428d141fa9 ]

sifive_serial_console_ports[] is sized SIFIVE_SERIAL_MAX_PORTS (8), so
valid indices are 0..7. The bounds check in sifive_serial_probe() uses
"id > SIFIVE_SERIAL_MAX_PORTS", which lets id == 8 pass and causes an
out-of-bounds write in __ssp_add_console_port() through
sifive_serial_console_ports[ssp->port.line].

Fix the check to use >= instead, matching the check already used in
sifive_serial_console_setup().

Fixes: 45c054d0815b ("tty: serial: add driver for the SiFive UART")
Signed-off-by: Zongmin Zhou <zhouzongmin@kylinos.cn>
Link: https://patch.msgid.link/20260827014524.19375-1-min_halo@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/sifive.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/serial/sifive.c b/drivers/tty/serial/sifive.c
index e86b00873d0ea..1b2477347ec06 100644
--- a/drivers/tty/serial/sifive.c
+++ b/drivers/tty/serial/sifive.c
@@ -940,7 +940,7 @@ static int sifive_serial_probe(struct platform_device *pdev)
 	}
 
 #ifdef CONFIG_SERIAL_SIFIVE_CONSOLE
-	if (id > SIFIVE_SERIAL_MAX_PORTS) {
+	if (id >= SIFIVE_SERIAL_MAX_PORTS) {
 		dev_err(&pdev->dev, "too many UARTs (%d)\n", id);
 		return -EINVAL;
 	}
-- 
2.53.0



