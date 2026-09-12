Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64B7347AF65;
	Sat, 12 Sep 2026 16:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229195; cv=none; b=ObmOwpgzeKQz06IIPKMlFbAVPylQiThDvNnDQ9bTd7iWCqP6rlWKjsf0w4XdQ1j42CWIflGEq61YQQtjO5oGpaGrl1LQVXj/r/GLV0ByrUssuuHd8TDtK4LrcYmyCfBv0rw+N1SNejYFuTEnIZNuA3+rDs28mxp6nL7KrkxckGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229195; c=relaxed/simple;
	bh=pdw8PYlH5tW8GVPPzZdEqmTUpsXi7uw96PlyTBmCeV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltEdGN8Ej73X7tcgXp/k3FHJ7ubNYzOLNjNmz9VvteX1m7BZk+Z7NWTD1O66XPKM1q9StDk6BnC7xoKVr9bNcR0bzVUqxXucLm0nxpI07ayoN9wg7PzQl4unTV+AExYr9hww8XEtfpWX2Ih1A4MkFV/h8cykD3aq+poNqbW+KZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/A3RluQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/A3RluQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BA631F000FF;
	Sat, 12 Sep 2026 16:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229191;
	bh=tBWyhaHIXuC75WZITg/5q2y6xZOJt4t9Nhv7YCswmGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N/A3RluQTX5yr5yXeEGzE9C8GH1WOe7k2RQkRPFgoiVeFxsPO5tOBsDH/4KWnXJC8
	 Hef9Tlhpf94aa9s4/K7W+mJfvbvvE4DW/1MnMThqqfcUMFhZvHbI8RbaAJHjgBnW/+
	 a1xyvrBaHpnZfjCu4i2O86J27HyowMq9e0kKKaAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuvraj Singh Chauhan <ysinghcin@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0539/1191] staging: octeon: fix free_irq dev_id mismatch in cvm_oct_rx_shutdown
Date: Sat, 12 Sep 2026 08:54:27 +0200
Message-ID: <20260912065600.355865580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuvraj Singh Chauhan <ysinghcin@gmail.com>

[ Upstream commit 41db5b76eeb4cc11a1097384caba7cfc659f7293 ]

In cvm_oct_rx_initialize(), request_irq() is called with
&oct_rx_group[i].napi as the dev_id:

	request_irq(oct_rx_group[i].irq, cvm_oct_do_interrupt, 0, "Ethernet",
							&oct_rx_group[i].napi);

However, cvm_oct_rx_shutdown() passes cvm_oct_device (an array of
struct net_device pointers) as the dev_id to free_irq():

  free_irq(oct_rx_group[i].irq, cvm_oct_device);

Since __free_irq() matches the action to remove by comparing
dev_id pointers, the mismatched cookie means the IRQ handler is
never found, triggering a WARN and leaving the IRQ line permanently
allocated. This prevents proper driver cleanup on module removal.

Fix the mismatch by passing &oct_rx_group[i].napi as the dev_id
to free_irq(), matching what was used during request_irq().

Signed-off-by: Yuvraj Singh Chauhan <ysinghcin@gmail.com>
Link: https://patch.msgid.link/20260212171903.1417804-1-ysinghcin@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: c0a9a8586a63 ("staging: octeon: add missing napi_disable in cvm_oct_rx_shutdown")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/octeon/ethernet-rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
index 965330eec80a8..d0b43d50b83ce 100644
--- a/drivers/staging/octeon/ethernet-rx.c
+++ b/drivers/staging/octeon/ethernet-rx.c
@@ -535,7 +535,7 @@ void cvm_oct_rx_shutdown(void)
 			cvmx_write_csr(CVMX_POW_WQ_INT_THRX(i), 0);
 
 		/* Free the interrupt handler */
-		free_irq(oct_rx_group[i].irq, cvm_oct_device);
+		free_irq(oct_rx_group[i].irq, &oct_rx_group[i].napi);
 
 		netif_napi_del(&oct_rx_group[i].napi);
 	}
-- 
2.53.0



