Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213665;
	b=sDKlFaY8NlmHkzNOCDt3x+pZ5z6a4xO8M/uL90ABD5c1kiTRiuK3zOX3aHmg/8FKVBaZ
	 OB6WCpL77NliwQGFhm7aeKLsbUzsoYswLgwYqcT4keYPgen60bz7sPMwz3u36ohiuWdmI
	 7R2yyS+jjp3osYMN/Fr3WeLotENtVTwzC9TYxB0qauX1oB3wBQBvs5NyoAfFE8B5Zgeu8
	 nHpzJV4fElurrXYeFx8dN9Wcdl/YpJDuIDLDi+viRrEdqpTRri6xKablQxI3eiockhiBw
	 p/snKEeLHuxHZHjfxZ71qt8jDyFlyZFfR7jF9uEVb1UOwab3x/3QQZb7c5P1D9BFJlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213665;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+05xJc1VPVNHN/61Y3Wn76OcYXYsINqD5lvxgNIjAfM=;
	b=dyciK9oadJDgOpmvr6DwDu8vOYGfHmCn1ApgLo2N4AHIK+NmBsQk8MenoAuM+WPfcB2S
	 Tk62G3YkLdSMzWu47CoVleZJ/hTNHjE777iH6AYpl1K+EafNTFqwNO6UBFrnugYsq6x60
	 8CbcUbaZd0cUMIeqTGQaWMkISt3EXWAEITtuAxK21HpYN7HTWwSPGqe7AcRWPkSpbpEp6
	 nb4Ozvswvcrlsy1bs0YHufuewtega66G7lUQ+lx+nXjjE9nnop/7odwmuFkx3IVxBGyg8
	 yFGiYk7WCzKJPxt7y8V/NZzGI2gTPVvjCvxnClOF+daAQAu6f++a+5VxEIZE43/wUhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAV2vYYD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8321C606A31A;
	Wed, 28 Oct 2026 18:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AAV2vYYD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83DD41F01825;
	Wed, 28 Oct 2026 18:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213665;
	bh=+05xJc1VPVNHN/61Y3Wn76OcYXYsINqD5lvxgNIjAfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AAV2vYYDY6OYpDnJud1byOucaZIpRcOqQuaZbE23A6Qe7MBDTySSrcyoq8RZJECHJ
	 YJsuzZlJg2PjcFfObHWRYWm1NVFXcYXIv7GI9/XBrdqllkW3JxqoCIF6qnxU9A9GA0
	 EBIYgGfWo3L0+xEtMASLk+djJExxkVYP+AuvAkak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Sverdlin <alexander.sverdlin@siemens.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0587/1887] spi: lpspi: Avoid potential use-after-free in probe()
Date: Wed, 28 Oct 2026 17:44:43 +0100
Message-ID: <20261028170512.780132836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Alexander Sverdlin <alexander.sverdlin@siemens.com>

[ Upstream commit 2ae0ab0143fcc06190713ed81a6486ed0ad3c861 ]

fsl_lpspi_probe() is allocating/disposing memory manually with
spi_alloc_host()/spi_alloc_target(), but uses
devm_spi_register_controller(). In case of error after the latter call the
memory will be explicitly freed in the probe function by
spi_controller_put() call, but used afterwards by "devm" management outside
probe() (spi_unregister_controller() <- devm_spi_unregister() below).

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000070
...
Call trace:
 kernfs_find_ns
 kernfs_find_and_get_ns
 sysfs_remove_group
 sysfs_remove_groups
 device_remove_attrs
 device_del
 spi_unregister_controller
 devm_spi_unregister
 release_nodes
 devres_release_all
 really_probe
 driver_probe_device
 __device_attach_driver
 bus_for_each_drv
 __device_attach
 device_initial_probe
 bus_probe_device
 deferred_probe_work_func
 process_one_work
 worker_thread
 kthread
 ret_from_fork

Fixes: 5314987de5e5 ("spi: imx: add lpspi bus driver")
Signed-off-by: Alexander Sverdlin <alexander.sverdlin@siemens.com>
Link: https://msgid.link/r/20240312112050.2503643-1-alexander.sverdlin@siemens.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 0daba232f4744..df49b52df7c2a 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -827,11 +827,11 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 
 	is_slave = of_property_read_bool((&pdev->dev)->of_node, "spi-slave");
 	if (is_slave)
-		controller = spi_alloc_slave(&pdev->dev,
-					sizeof(struct fsl_lpspi_data));
+		controller = devm_spi_alloc_target(&pdev->dev,
+						   sizeof(struct fsl_lpspi_data));
 	else
-		controller = spi_alloc_master(&pdev->dev,
-					sizeof(struct fsl_lpspi_data));
+		controller = devm_spi_alloc_host(&pdev->dev,
+						 sizeof(struct fsl_lpspi_data));
 
 	if (!controller)
 		return -ENOMEM;
@@ -931,7 +931,6 @@ static int fsl_lpspi_probe(struct platform_device *pdev)
 	pm_runtime_put_sync(fsl_lpspi->dev);
 	pm_runtime_disable(fsl_lpspi->dev);
 out_controller_put:
-	spi_controller_put(controller);
 
 	return ret;
 }
-- 
2.53.0



