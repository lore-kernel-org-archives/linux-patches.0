Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622600;
	b=Ra/C1V5IaJWTvEM2tTud3MCT1z0SBSAE0iXhs5VbRPVj0W/k33reCARERjH4nwWEP6Dc
	 UfneSm40QCOFaXDzjHCq1jJYEpHLIMNYNqp+p/pMzZpTY0yziRoZJ5KcNxR9U/98WmY/0
	 AicW51mu9a09GJDX8f1VY6Cb2AvaRpvzCIHLm+d6uFQFahygSymz7Kz9BhtiaqqmzzEu5
	 zdT5as99A2bsn8UB5Il7VVL5/rGwihBQjD+mFIRGwgLL3TuTA7ltYaB72WGpBgIqP8JGQ
	 OURjNr+lMs40E6Yb6EhpjsbkRkf8ZsDvHb1XumnpOLtKAuWDUnOKTLRWU4bvk6cm+rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622600;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=m9spgZZkLuiCc6/mr3x66TC2R9PDUrNXHUthwqBgzKg=;
	b=nnr6wnJX6k3v4J7pc/vPL7gZebDl/1yQ9vH1cI/SDEy34wUt673hy2CuG6M68qY7lJtj
	 SqiyvWDg5PuEz+uqi/rb3eoeKI6faQkV04HbiSloDVQGFW52n3A7QSKB/JoMRQUi+dLA4
	 2V7L9h5U9yEjmLTqswjt5H3clJAzAv0opLrVQUYr75KKtj0kucDhyanEOGhRLi1PeIWmF
	 uFhq+oHgD/CZdjOf7AoGU0eQ5zyHCNH158pWm9Nmk2RsMyq9VtW095Ukz0ZT9STTxWAL/
	 uTnacH/sf3LJoBpCtR+evOOSoUrXCBvwdE6t0kqEZ7+UtsLZHBv/Rsgm5N+/sJXx/RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6RJMFyi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F64C606A31E;
	Wed, 25 Nov 2026 16:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F6RJMFyi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696BE1F000CF;
	Wed, 25 Nov 2026 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622600;
	bh=m9spgZZkLuiCc6/mr3x66TC2R9PDUrNXHUthwqBgzKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6RJMFyi1eWnqi7F56RJCs1iSjII5GBKMd5ms8G1q9ifzrhzepVkSXQdZgDPh+wk9
	 vjh8mH0dx0Q2I1BGbKl8v+gUmfCbl2ymkCZLCqb16ASxKY/hEQGbNEryAN6pSr8aGf
	 eIdC9oEhyaC6ZKsZ+RBsEpHwBbeT8sS2Kk0hWE3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 587/990] drm/panfrost: Fix PM refcnt and autosuspend issues at device probe/remove
Date: Wed, 25 Nov 2026 15:32:34 +0100
Message-ID: <20261125143835.840180938@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit e9672bf9382ff80be21d586f88e50339b85f5766 ]

During device probe(), failure to do a PM get() will leave the usage_count
set to 0, which is the value assigned at device creation time. That means
when the autosuspend delay expires, runtime suspend callback won't be
invoked, so the device will remain powered on forever.

On top of that, failure to call PM put() during device unplug means
Panfrost device's PM usage_count increases monotonically for every new
module reload.

The outcome of both of the above meant that:

- Devfreq OPP transition notifications would be printed all the time,
  even when no jobs are being submitted. This quickly fills the kernel
  ring buffer with junk.
- Because MMU interrupts are only enabled when the device is reset,
  the very first job targeting the tiler heap BO after device probe()
  would always time out, since the driver's PM runtime resume callback
  would not be invoked.

To fix the above:
- Manually adjust the PM refcnt at device probe and removal time.
- Ensure pm_runtime_dont_use_autosuspend is called in the wind-down path.
- Call pm_runtime_put_autosuspend() when device is ready to accept jobs

Fixes: 635430797d3f ("drm/panfrost: Rework runtime PM initialization")
Fixes: 876b15d2c88d ("drm/panfrost: Fix module unload")
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20261012-claude-fixes-v15-6-bc0a6c498553@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
[ sashal: Replaced pfdev->base.dev with pfdev->dev, and placed pm_runtime_put_autosuspend() after panfrost_gem_shrinker_init() since this tree's probe has that extra step and error label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_drv.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/panfrost/panfrost_drv.c b/drivers/gpu/drm/panfrost/panfrost_drv.c
index a31c5395de18c..2d49edaa9467d 100644
--- a/drivers/gpu/drm/panfrost/panfrost_drv.c
+++ b/drivers/gpu/drm/panfrost/panfrost_drv.c
@@ -761,6 +761,11 @@ static int panfrost_probe(struct platform_device *pdev)
 		goto err_out0;
 	}
 
+	/* The reason we must manually set the PM status and usage counter is
+	 * we have just powered the device up but did not go through the PM
+	 * runtime resume callback, so we need to update these ourselves.
+	 */
+	pm_runtime_get_noresume(pfdev->dev);
 	pm_runtime_set_active(pfdev->dev);
 	pm_runtime_mark_last_busy(pfdev->dev);
 	pm_runtime_enable(pfdev->dev);
@@ -779,14 +784,18 @@ static int panfrost_probe(struct platform_device *pdev)
 	if (err)
 		goto err_out2;
 
+	pm_runtime_put_autosuspend(pfdev->dev);
+
 	return 0;
 
 err_out2:
 	drm_dev_unregister(ddev);
 err_out1:
+	pm_runtime_dont_use_autosuspend(pfdev->dev);
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_set_suspended(pfdev->dev);
+	pm_runtime_put_noidle(pfdev->dev);
 err_out0:
 	drm_dev_put(ddev);
 	return err;
@@ -801,9 +810,11 @@ static void panfrost_remove(struct platform_device *pdev)
 	panfrost_gem_shrinker_cleanup(ddev);
 
 	pm_runtime_get_sync(pfdev->dev);
+	pm_runtime_dont_use_autosuspend(pfdev->dev);
 	pm_runtime_disable(pfdev->dev);
 	panfrost_device_fini(pfdev);
 	pm_runtime_set_suspended(pfdev->dev);
+	pm_runtime_put_noidle(pfdev->dev);
 
 	drm_dev_put(ddev);
 }
-- 
2.53.0



