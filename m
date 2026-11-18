Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055163;
	b=djUzDJONHO0LSY7ShjR5W0LCUsNMRNYvLQLMTe2CVpVP+ldr0GeZQwE1911gAuc48FE7
	 NRiWL16Vj2ZyzGrL4ySMSA3eVWIyOBi6/VMOR7O2eOpKb8haTOmTsmbGZjELvg9NE+MZj
	 FdQ91vGAOCbyjMftC+SNy410r4xf1NYVvdYKdgnflOUNaianQsmUrb0okrLMB29VGkK1M
	 1jzJR8s+mSkwOjRHY4GXNmmZhYk5pH/Vv6yX+rhzPcuJhQ5I55Zks3jkVly6ol5jv8O8y
	 nVAUfH+4kCgcGaB6RYX2qnqWbvSpxCcLNoavdSKrWxnKoZgB3FRvgh6W23kuCMuDgtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055163;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=uBzGXt7ohgXmkAyYl5GdkZHe8o6pwy0LF1Ae+1AoUTY=;
	b=V4xJef+MVcXcr4K4RqDV8tJf/9j4QlL95CaZpCsGdpvJ3xixwpAl63znlGp2QiUyOcej
	 YXXf78PYXGnWDEbtOWjsSNDKnKVjBiRAovQ03JNovbMce9bVVtF3lBx3IzqYekVrMXDiu
	 bJLj2QT7xMrJTMu406PyPX6pnndUUOrVgZhLRrCxD0pRX5F7uiz1VA1wZvYyrZcDCduaz
	 iKpA4fp0QEpMOxSPlblaJkVkQmfA6GDEaasfRJrnK3Gnexmby8McEVomfrgTaHq9ZHrlr
	 Bisu9XlUPbKUXirqEwXdx0m30D0ZIC3Q/AKv8/N2pGp9kmlZKQECMcVEfDKBgruYDVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSkXysKd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDF9606A320;
	Thu, 19 Nov 2026 02:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KSkXysKd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3681F000C4;
	Thu, 19 Nov 2026 02:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055162;
	bh=uBzGXt7ohgXmkAyYl5GdkZHe8o6pwy0LF1Ae+1AoUTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KSkXysKd9jITJHlsmjbSclNIiwNI2nslhdTe5ISTnLYu7l6X72xtv/5zCZ//KEkFG
	 2i6mWenReVRSSvCOengvkL4AAkxYOIsFRvAxFcxtvOzlIlsVOj0hTkCgaS4NNTsyWM
	 IcirEWPWZ3rZSdKUvh4mlBNieJbhWpDULFN+RQoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1533/2214] spi: mxic: fix ps_clk leak in runtime resume
Date: Wed, 18 Nov 2026 15:53:29 +0100
Message-ID: <20261118150113.501937436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index 03fce4493aa79..99015d0ae1ebb 100644
--- a/drivers/spi/spi-mxic.c
+++ b/drivers/spi/spi-mxic.c
@@ -529,7 +529,13 @@ static int __maybe_unused mxic_spi_runtime_resume(struct device *dev)
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



