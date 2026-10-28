Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211149;
	b=4dKvQ9aoXNJdhBcFYAEylpdcMquhtJVD398BECZBwLqMbuxvm1mylJk9a32pIMcqHd2P
	 ltLaYjGbbKoq509nZijZEQpdx/iBbgJGGgceVGhq7shu6vRYrJQ1AgSNTCJ3T3T1ljO4z
	 4EyfnRGp+LuOOK0TP+142/C8QpAPgF/6Q818QaifnyTDW82x7d3kCbjpkSWkN2LIB2EMB
	 QLOFV/AELnZuEM3xGNYE3Xwr1KaenW5tDn7elvyMASHjbXC1uJ6Q1PK3P2wvpQWx0CqFZ
	 HypSZC6vLB+w40aryUjL1X68N5PR8s/jyynIoG01JKulFaTeetu2lGqsR8aekGSHGbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JFFgjTuJnmSNWoatZgaUbTCfnFBow3azuM/iv1dAJb4=;
	b=NERnUKOpiMt8w9v3NdjpEpyXpPlPPq5iRWkGWnRJrHmQcruaDiKJd/jihrHZUR4SrK1o
	 5surLfhdj8iWbsoWPnl3+OTKmKN+2n2ZSQZVoMmdfix0KpksnhiLDvboRGCOoRF/jqme0
	 XbgUHe4q+o4mvLYijv3AFysfNx+3vHB4jcn9USjImhKlWQSZBaU2GM62l6yO8DonGIIBm
	 mXM/kd4PQTzGmCz0t9mQep5MOYmcOeq4doJ9MZt02sVks1/81y6VIMKk1GWQ+mjUwDsnV
	 YDqLYVtg2PU1Bhu0Nnb9/F/MxXitwOcQJvNDp8FUvRkB/lysfcgjyozRkP7uY47A8OA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmlwYgsb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4E8606B46D;
	Wed, 28 Oct 2026 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BmlwYgsb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C1F1F01828;
	Wed, 28 Oct 2026 18:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211148;
	bh=JFFgjTuJnmSNWoatZgaUbTCfnFBow3azuM/iv1dAJb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BmlwYgsb2WyBuWj4YYm3OV06q1zmk9mTKxiKuYvp6QJn1uFgRwHFQz32x0AQZ7B/3
	 miw/nFKOYszLpJMA98BaizjsNhlNGi53jffJxCYKlui3p/DU8OGgvG/fhXsLiLUCbm
	 9iRsyzRnmXUsOw7ZejwGGrsXZd9ChkiMf0l81zPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wentao Liang <vulab@iscas.ac.cn>
Subject: [PATCH 5.15 222/571] serial: vt8500: Fix clock reference leak in vt8500_serial_probe()
Date: Wed, 28 Oct 2026 17:56:09 +0100
Message-ID: <20261028170013.268464930@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

commit 9d8955281d9229a899e2041659a59b389027b711 upstream.

of_clk_get() returns a clock with a reference that has to be released
with clk_put(). If clk_prepare_enable() fails the function returns
without doing so, leaking the reference.

Add the missing clk_put() on that error path.

Fixes: 12faa35ae5cb ("serial: vt8500: UART uses gated clock rather than 24Mhz reference")
Cc: stable@kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917155834.2161361-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/vt8500_serial.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -677,6 +677,7 @@ static int vt8500_serial_probe(struct pl
 	ret = clk_prepare_enable(vt8500_port->clk);
 	if (ret) {
 		dev_err(&pdev->dev, "failed to enable clock\n");
+		clk_put(vt8500_port->clk);
 		return ret;
 	}
 


