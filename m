Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591631;
	b=gODahXPD++4tlc06Il1RPmXPZL1TU6OH8YCQ8c3+yRUaqc0WukqoMYom7KtzuFKZ3QFp
	 QebRYZVOxfWM5eXxQ3EbyUl2rEQuyU+0BI4SyX0njAcDlg2Xaf82ulykYF4ih1Q3Z6gb7
	 P6vlBBxgC3PD3Uu+H3SQub+gzvK59UlLjLagTlNwVPpH9HVsu6CEDp9E6WW09z9JUtlSf
	 S1oq7Tls5QdrajhVib/Rf+LZFnrYEMAnxBbw4mwVOdUJbLzg8DWY9BKwHzxDdGEWIqRUb
	 kGvrRbtYk1+TpBTqYRP5uXq2n4N06XzNv1/9f+4mO/sQeiwO20ZIx+pi2dwLTln4dAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591631;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BHKLfDUtK72kdGzGcdtQaGw6ClgAfYjPyDRXxc3vJ/8=;
	b=k2etySP3KK7uLfs4Twpz4+O2lvBxD8KCbC4eQI23SPQi3FIPsGLTrxKmO6Tqt+yhZO79
	 yQPSj8CZi0srHq0w4sJcfqQJqH7r2bfHZ7Hi+F+/4d9Z3rk50XczZjsoJjmH8fnu8n7mt
	 fUEkEj2+97uO7FUWhEJy48pqroQOkFNmJShO7PSCJkGISMD8MExCfA08z+I9UsTfx8e/K
	 cf7NhQp/I+ZYb3K/jlJceQgVsL2dhBOEj6GMPuPIXB+hM8+WBHghblSqiDy8EbeMhyc6O
	 /ph8zfOpvX0JbxJkZdNvuCzumrYG0C3YU4mB2Izeu+cG5n4plJsotoM1t+irmCGgXrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z3/WEOwV";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B69DE606A331;
	Fri, 13 Nov 2026 17:40:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z3/WEOwV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D23E1F000C4;
	Fri, 13 Nov 2026 17:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591631;
	bh=BHKLfDUtK72kdGzGcdtQaGw6ClgAfYjPyDRXxc3vJ/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3/WEOwV+86hGdmiMbFKsFzudUTgzTfixp9sBl+uNBIi3KbPqPl2UgYJ/eY3PBeja
	 gv6aTfhmi1TuaGcyYnW330WphMGJpW9lI0WlDKstycSwF4VkHWr6ofvWRPEZbt3K7/
	 eGJcB0fgrVHc0YRgz47EnOVZDekGO8Nf5LiblYA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 652/670] crypto: omap-sham - fix crypto engine cleanup
Date: Fri, 13 Nov 2026 10:53:36 -0500
Message-ID: <20261113153833.975875510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit be51ea091c6563158531e8c74e040552fdb1e28c ]

omap_sham_probe() allocates and starts a crypto engine, but the remove
path does not call the matching crypto_engine_exit(). The probe failure
path already performs this cleanup.

crypto_engine_alloc_init() creates a kthread worker for processing
requests. Without crypto_engine_exit() during driver removal, the
worker is left running after the device is removed.

Call crypto_engine_exit() after unregistering the algorithms and before
tearing down the remaining request handling resources. This stops the
engine and destroys its worker.

This issue was found by manual code inspection.

Fixes: 133c3d434d91 ("crypto: omap-sham - convert to use crypto engine")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/omap-sham.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/omap-sham.c b/drivers/crypto/omap-sham.c
index 51842cf61995a..4f5e36197d3d7 100644
--- a/drivers/crypto/omap-sham.c
+++ b/drivers/crypto/omap-sham.c
@@ -2210,6 +2210,7 @@ static void omap_sham_remove(struct platform_device *pdev)
 	list_del(&dd->list);
 	spin_unlock_bh(&sham.lock);
 	omap_sham_unregister_algs(dd->pdata);
+	crypto_engine_exit(dd->engine);
 	cancel_work_sync(&dd->done_task);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.53.0



