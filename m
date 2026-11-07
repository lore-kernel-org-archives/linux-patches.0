Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063047;
	b=ncWdOyydFl3BUtdzlL+iMmmBVrzErg8wpOoDMxSdxY+Q+S6Uw4mabKi9QDW8MiXpyQGl
	 WHnNr7b5e7TKjvUke+RzaPsya6HgW8szKyHwL7dGiWgJcMRwOQKHbGaC+I7yWnoSTpizp
	 vM0Zf1yLXNWIWcRbU0zktOTDzCDVHyQgxAtNJqkTKE6V8gfoPPuTaLXCYYvoNlzIjUmb1
	 TkTS8nBCe8ilFcFBVGK64jkO1tTRmrOCL8GKMia9Ly9t1hYd2rtZDo5KMvhVRNO3NUem1
	 Dm89aePGEwPqfP6Pej657C55BAODXETDItpn3vwEj9phs+mkDdJQGDyQcGOf9mSxJqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063047;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tpcx33y0PS0mIUGK39PVPys4GHI+9YDIWqAQeJNp7Lc=;
	b=zBXlx72dSdYjeuD6tz7e5Z3LickDxrMpuREBTlxKBJ42/hym0ntqOUPBMZEUkroWqy/5
	 c1yAp3gUQ11x8v3Ox0YG+mjaG28u8u+mgkxrp/hsvn9mOgWm87Ne52udR/Xy2ZAP8WdSk
	 xqzrrHDKGnjTxKmwJ4DJ7Nyla4OiB61bvouIPI9XdLFhDN0jiVBXqSnDXzIZt8P1yWrdM
	 jY07U9/glEVLRnF6Fw5ugre9vaJcpAwNNX6IINRbDuD3a13mYP9Tmo9r4mJ2SOnJDrzc5
	 B8gkz4p8lQsMnQHrNwdDs5Ced9jJSXyIWx4z6hVopujzepvx6k2KlI6Emb931VK+TWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wid/ZFKG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5251606D801;
	Sat,  7 Nov 2026 14:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wid/ZFKG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 707951F0089F;
	Sat,  7 Nov 2026 14:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063046;
	bh=tpcx33y0PS0mIUGK39PVPys4GHI+9YDIWqAQeJNp7Lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wid/ZFKGzb7gXnEOmDa21D935mmUupbKCZy69zKgRwIuLEvViNZmVPjO0Y7/LHNrX
	 99/8+N72vwupaspdFnU59IasHQXEyu4ajFrF2ib9NcCFA/70jZPjKp9/ii4MorhhoE
	 CKAhVkevjySlSi1UnWPmNqSusRf3+ESvnh+JDnWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Hal Feng <hal.feng@starfivetech.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 292/869] clk: starfive: jh7110-isp: fix refcount leak in jh7110_ispcrg_probe()
Date: Sat,  7 Nov 2026 08:49:34 -0500
Message-ID: <20261107134901.822895461@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f3fa069db193e..c02c8b29a1230 100644
--- a/drivers/clk/starfive/clk-starfive-jh7110-isp.c
+++ b/drivers/clk/starfive/clk-starfive-jh7110-isp.c
@@ -130,7 +130,7 @@ static int jh7110_ispcrg_probe(struct platform_device *pdev)
 
 	/* enable power domain and clocks */
 	pm_runtime_enable(priv->dev);
-	ret = pm_runtime_get_sync(priv->dev);
+	ret = pm_runtime_resume_and_get(priv->dev);
 	if (ret < 0)
 		return dev_err_probe(priv->dev, ret, "failed to turn on power\n");
 
-- 
2.53.0



