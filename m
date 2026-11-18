Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048381;
	b=GJ9/0aS7/VdM8FzAUM5g0cUHdsRKP3tJ4x9KPzKszvnzjy0qfkewzDi0y/f3hWGc51lM
	 KFrLqLpt7r5ahzcRtmKvfCj0leRvBw1VGQGfBfIDEyXxczWKNkxkNu4qDABv8hkP44mrZ
	 jNnpRR0Bj6zKMqzcyx7KiiJTuM5CytB+NefySKghOz7ght/HaYDvRx3V3qw2W91m2avds
	 vccn8NsvzIh+3rkP1HzSRk+3YL8MxUhAhNkpvT813v46FTLmIPDa1p3heu6mrRBMpYTKA
	 V9lCKM5jwdR2+0xkkx2nvfssK+S7U/hntQ14kBkPrX8rmEtIHdV24hVEW2lqnrvF0RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048381;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v+eu1U5PO786nUyBv5p3Y2QjnWc2/P2qx2iTCTYdA5M=;
	b=AIliDECEx9VM7w5DEfyUiBMl+9Vvgpn22cyA6LycEoRdA3dh+/JxlYaV/wXpLZHdGDBm
	 N49URGmTkXAYJ/NMJz3cwHL+PqoyjU1apzkI7iafTrg6422DVSNtBCM4QtSJ5EqZIPjwB
	 qaR3uZo3IbAufwkZWEmPXdxq11eKublfkjRhdyT+ZwB85SJHblTxnNic8FEj8QA0Pf4Fx
	 D+oASjuEesCLzKhFZCnVVb7KdFmabFumsY2jetlET1hVvAyPxPlK5lw/rG8l/xwYyi/Cw
	 19R4ZaVzLJvgNzu6n5uty+UgT4QpeiyFfcfOaBt0cX81hgQ4oaBvwNWjFUt/sHjn9Ag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdwLouGl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AAF60A3825;
	Thu, 19 Nov 2026 00:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tdwLouGl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB65C1F000CF;
	Thu, 19 Nov 2026 00:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048381;
	bh=v+eu1U5PO786nUyBv5p3Y2QjnWc2/P2qx2iTCTYdA5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tdwLouGlAs/UFxVjJq2DL8z4SyKOKWbN0mzZCreOadJG82F5aWwWRtvh9Uaf1ostH
	 aFyLjlfvbVktd+ZW+j3B2DR3yH+MsaWKWaX2/eO7ikno0nGrO0qskRrqIDFenueg1G
	 PbJLZ2xMA5peJuUxTHTk10fJZT+7kewVl/pvpuio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1973/2857] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:50:07 +0100
Message-ID: <20261118150312.433380002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 648e3c436032b675b339662ea9c0edd9221add76 ]

mxic_spi_runtime_resume() enables ps_clk before calling
mxic_spi_clk_enable(). If the latter fails, ps_clk was not
disabled.

Unwind ps_clk with clk_disable_unprepare() before returning
the error.

Fixes: b942d80b0a39 ("spi: Add MXIC controller driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Link: https://patch.msgid.link/20260902-mxic-v1-1-76806325826d@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-mxic.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/spi/spi-mxic.c b/drivers/spi/spi-mxic.c
index 65be8e085ab83..d0fff4a681f6b 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -734,7 +734,13 @@ static int __maybe_unused mxic_spi_runtime_resume(struct device *dev)
 		return ret;
 	}
 
-	return mxic_spi_clk_enable(mxic);
+	ret = mxic_spi_clk_enable(mxic);
+	if (ret) {
+		clk_disable_unprepare(mxic->ps_clk);
+		return ret;
+	}
+
+	return 0;
 }
 
 static const struct dev_pm_ops mxic_spi_dev_pm_ops = {
-- 
2.53.0



