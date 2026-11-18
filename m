Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036176;
	b=aEeBphbI8rLconDNIhwAlCDHNYdqewFkbYhRvYCIyRTttIFEBKTXV+9AMlyK2GjeZc8a
	 8aGRFP8qZAwxTldsoleJbHFh3p8ZQIZK6MS4pgc4/odnvQSDLMXQJMWHW0cBzmZUPYLIh
	 SMy59G+4/asUKcuTwngHWyfTbxl2SGR5VCZMoeNDQunaQjS1KoXIb/aHCig/rfhwyhmxn
	 v3CHjwTA1/109qsWAHWLovocokhr9v/E5ASYosNiRxAuk7Ml20WdWHILwTrx6y2NBK5o8
	 B2E8+ZDdxhw16KAB72Je2JQ4sZiJH0suwC21+kFWZlktVL8fXNNToHlV/U/SDRtsr/w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036176;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dzqyTFC4FTbMfwykbKNThdcej2huSHCfv75kuNDLjxc=;
	b=Q82OWtHABnezI7bRund6oM2LiMo5tyH6j1P/X6BoZ6TU3zk5PbUV1w/ox3KC0RmYCgLX
	 9ySJ2hKfKMyyHsbCKGVBzIDH+UG6CTJJOYVQ86fQJfHFzw2xNHqXIvs1QU9OIo36qfnAZ
	 xDa4PWOsqIXg43vfHAjRjJobPcLY+ZPtlEWmF21jbguuO8Yi+7z96fXR21fYQSReTEmWk
	 +EYMbx/HkImnE5+JfPi9514+4EIdhHlH3BirUgOeLtr6a3Z1Y3DaHKE+prlF5szi3nORX
	 eLEy5lgTmWKBB6H4SpIvLJhh89mD4fIDacl4Z9pKehVBdsTZo4FE5v48NPln4WZkLiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQWeAz68;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A953606A31C;
	Wed, 18 Nov 2026 21:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQWeAz68
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EBB21F000C4;
	Wed, 18 Nov 2026 21:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036176;
	bh=dzqyTFC4FTbMfwykbKNThdcej2huSHCfv75kuNDLjxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQWeAz68dfz4XfFndmBkhU0/S5OKO67DL5qM0gGuB49aBe4qRgNkmP3Bd0EMadj39
	 KhphWZewAtC1mPoUMo77bNjbNfTU+Ptn9I9MeHebIXywy0pJPPD35tS8OqPEnOJaS2
	 vJU1wGFMPiK0lAA8Bv9QY615WsA964Q40FUT5rvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hal Feng <hal.feng@starfivetech.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0964/3318] clk: starfive: jh7110-isp: fix refcount leak in jh7110_ispcrg_probe()
Date: Wed, 18 Nov 2026 15:26:26 +0100
Message-ID: <20261118150348.580982588@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 1c4f9480473917558908c083d1293b4ebb3d50c5 ]

In jh7110_ispcrg_probe(), the error path for pm_runtime_get_sync()
failure directly returns without releasing the runtime PM reference
count. The call to __pm_runtime_resume() increments the usage count
unconditionally before attempting to resume, and does not decrement it
on failure. Thus the leaked reference makes it impossible to suspend
the device later.

All other error paths correctly jump to err_exit and call
pm_runtime_put_sync(). Fix this by replacing pm_runtime_get_sync()
with pm_runtime_resume_and_get(), which properly balances the
reference count on error.

Cc: stable@vger.kernel.org
Fixes: 81279f5d0812 ("clk: starfive: Add StarFive JH7110 Image-Signal-Process clock driver")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Hal Feng <hal.feng@starfivetech.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/starfive/clk-starfive-jh7110-isp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/starfive/clk-starfive-jh7110-isp.c b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
index ce034ed285321..582f91f835156 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-isp.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
@@ -140,7 +140,7 @@ static int jh7110_ispcrg_probe(struct platform_device *pdev)
 
 	/* enable power domain and clocks */
 	pm_runtime_enable(priv->dev);
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0)
 		return dev_err_probe(priv->dev, ret, "failed to turn on power\n");
 
-- 
2.53.0



