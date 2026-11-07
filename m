Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062261;
	b=xhTLNyM477dJdsliNY5IrUe3YrqzapDvo+jduwhWuh/b+DKgT4rvFGEz7TUrbwNWcUV9
	 6YJqOVsxgbENOsNRMAUiySoMrEMdeCaoQhSs9W0Ni0vOug18Mz//KzLmi96X1ElRwBi70
	 M9jMEzg9sHuxLz++d95ye0UhMB9vBHlWzQKGzu3ZW53zrAVZd9HjjjxG/bCEQwynlgGgF
	 sBsP+axEKe1pb6++y0VVsn8RzDFdohwYTv6ZjSrOoJNQKS+YJ5RSj5tiwK0y3JRA/lleI
	 maPlni9EeUnqVipftMqygGy1n2PaCpYe1WQJigiOqXb4eIWnpyIgd1kcXPbopuAYzDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062261;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t2dSpaopuMJsdGv18G9eXi0HynTpnOuvd1qbNXMIo1E=;
	b=18AQTCIUbtNUzadjEZobQ2lTLXaRKLOYrUuhOUbbsmkgSb8zLFnYWtmGlXLyIGxpbh1j
	 ClBs5OmNi1R3DaxhxKP46VpRbYQRlGEyTJ9JRxBnkSXnJh1SUc8lIHS0UerKIcZvffnn/
	 CnirAtW+C/ejAZjPoxYGVU1ceq3PgYgvsZTlXUhw8zH7zpRaDDGC46aXgZG7PZJ7Vp2rF
	 xEV6CCSQPJq1q/Hy6bIpRx7+CjmU8X6ulR0edtW3HWTQ9Zui8ihNs4rPnnpT+Hwf8FzcG
	 AeT4Ckcpkjj502qKmxc6dEwTSxaNDbBglKUMTq3VJiqhg8ueWJkh6NYNNLcLapeRy+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whEYkn+n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57BA1606A334;
	Sat,  7 Nov 2026 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=whEYkn+n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059DB1F0089F;
	Sat,  7 Nov 2026 14:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062261;
	bh=t2dSpaopuMJsdGv18G9eXi0HynTpnOuvd1qbNXMIo1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=whEYkn+ntIRo8Je5WSjl2vt29CAXCad6H8P24XyfE8+3NzkutNGEWHqV4pAzN1r++
	 OFvxUGNFd7roOuBhmo/ZiYNLLFMqjo9By3EcXWFDUgK7jEwEqbe/QoXF9ioA4+0m2l
	 Qmw78OKDxZGyUmRoyspFv49BEIAR0hE/MqLzkO/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Herve Codina <herve.codina@bootlin.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1205/1536] soc: fsl: cpm1: tsa: Fix clock leak in tsa_of_parse_tdms()
Date: Sat,  7 Nov 2026 08:53:41 -0500
Message-ID: <20261107135031.593228268@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 46201d760c48e771fa2febfcb0787f22c3b71387 ]

The error cleanup loop puts l1rsync_clk and l1rclk_clk a second time
and never puts l1tsync_clk or l1tclk_clk, because the branches that
guard the transmit clocks use the receive clock field names.

Use the matching field in each branch so every clock acquired by
tsa_of_parse_tdms() is released exactly once.

Fixes: 1d4ba0b81c1c ("soc: fsl: cpm1: Add support for TSA")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20260917152719.2160395-1-vulab@iscas.ac.cn
[chleroy: Fixed the same in tsa_remove()]
Signed-off-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/fsl/qe/tsa.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/soc/fsl/qe/tsa.c b/drivers/soc/fsl/qe/tsa.c
index 515da9b45c2c3..38e9f02cffe48 100644
--- a/drivers/soc/fsl/qe/tsa.c
+++ b/drivers/soc/fsl/qe/tsa.c
@@ -885,12 +885,12 @@ static int tsa_of_parse_tdms(struct tsa *tsa, struct device_node *np)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 	return ret;
@@ -1059,12 +1059,12 @@ static void tsa_remove(struct platform_device *pdev)
 			clk_put(tsa->tdm[i].l1rclk_clk);
 		}
 		if (tsa->tdm[i].l1tsync_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rsync_clk);
-			clk_put(tsa->tdm[i].l1rsync_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tsync_clk);
+			clk_put(tsa->tdm[i].l1tsync_clk);
 		}
 		if (tsa->tdm[i].l1tclk_clk) {
-			clk_disable_unprepare(tsa->tdm[i].l1rclk_clk);
-			clk_put(tsa->tdm[i].l1rclk_clk);
+			clk_disable_unprepare(tsa->tdm[i].l1tclk_clk);
+			clk_put(tsa->tdm[i].l1tclk_clk);
 		}
 	}
 }
-- 
2.53.0



