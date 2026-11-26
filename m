Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704124;
	b=WhU9xntE9lU1QG7J+Z2I4UhJZ8sz4CjjKNEnxtME/2fC0STlUQJqcYQDQ+IQSZjkgZGX
	 KoPmzumkwHL4O3NPrn0+3hDFWVyADhuc/Ue0+M5Zgkwov1kwlH/9vMqxjpi0PGCg3O148
	 99Q8Da71IRoHi6tsDZ+1El5d3v8TeM3M6ABgxsfZruW2WMT970kkfVoE8u5mOCIR0M+va
	 Xau6IjKDc1wHvwdU+VgKbsXjcxANPYFM1KfnGAvfbG8rI2qo+P2c6L0rzvPUgJB9vwKty
	 ufMiC5iYHio7LnXLl+2ptrbyFxwdgZ0eoSTMlkoiQ5efjeRpUO/liehOCleAqTLOlZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704124;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jkwMWHeZ6a+idRACinLUV5t914P6cBksXZ7zU+HI9/c=;
	b=X5ysKAH1q/DOfGP0IFmvlu8IRZKbOwWdNz0lgWaewoyIyDWxI4FXi3Ap/EYnhrUBLHuf
	 4pHj5wmmS/iwN/TU5CJgblv2ZOjxR2skqdZCANIbHFT4l4MsgAo7n+srhkKsKJvcxKgEK
	 uvla5UJ4vJbaMhHq93NapjfBBtzp7ZEUzqawadz77iicTK7Bj2M+F/rL+WBtjkvtYm8cm
	 T/owsviKaUGUyWa0wbMOwfDWRoefco1rq7oQR//0WyhsHUbIWYlGTTUzdbpevMWHRG3aJ
	 0/1NM4+DBsS9hiHwuZ78NsKQfmgKl/DQZ9+ygBLM36xKJ+jUrpOYhDbzlHudFsS6fLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wu+Y17Lt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C293606A326;
	Thu, 26 Nov 2026 14:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wu+Y17Lt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99EEB1F000C4;
	Thu, 26 Nov 2026 14:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704124;
	bh=jkwMWHeZ6a+idRACinLUV5t914P6cBksXZ7zU+HI9/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wu+Y17Ltd5gtH2SwRZcMFuAv6lLDmW+LKyKkQ9KvpSoB72GqfjsUPVUeGKjVk4cCQ
	 JE6XWJOHbbBtyCbkuU9d3FbrKK5EGscbIRhfOn35yPy8QZaoQJJUX9CeGOnFwtZDFb
	 fhOiFynmBg8H9ADb+rYrhRz1xhwUgd9rjenqedBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	"Nobuhiro Iwamatsu (CIP)" <nobuhiro.iwamatsu.x90@mail.toshiba>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/265] remoteproc: imx_rproc: Fix refcount leak in imx_rproc_addr_init
Date: Thu, 26 Nov 2026 15:35:45 +0100
Message-ID: <20261126143606.145215230@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 61afafe8b938bc74841cf4b1a73dd08b9d287c5a upstream.

of_parse_phandle() returns a node pointer with refcount
incremented, we should use of_node_put() on it when not needed anymore.
This function has two paths missing of_node_put().

Fixes: 6e962bfe56b9 ("remoteproc: imx_rproc: add missing of_node_put")
Fixes: a0ff4aa6f010 ("remoteproc: imx_rproc: add a NXP/Freescale imx_rproc driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220512045558.7142-1-linmq006@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro.iwamatsu.x90@mail.toshiba>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/remoteproc/imx_rproc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/remoteproc/imx_rproc.c b/drivers/remoteproc/imx_rproc.c
index 373fce8b91064..95b17eaa216e4 100644
--- a/drivers/remoteproc/imx_rproc.c
+++ b/drivers/remoteproc/imx_rproc.c
@@ -290,9 +290,12 @@ static int imx_rproc_addr_init(struct imx_rproc *priv,
 		if (!node)
 			continue;
 		/* Not map vdevbuffer, vdevring region */
-		if (!strncmp(node->name, "vdev", strlen("vdev")))
+		if (!strncmp(node->name, "vdev", strlen("vdev"))) {
+			of_node_put(node);
 			continue;
+		}
 		err = of_address_to_resource(node, 0, &res);
+		of_node_put(node);
 		if (err) {
 			dev_err(dev, "unable to resolve memory region\n");
 			return err;
-- 
2.53.0



