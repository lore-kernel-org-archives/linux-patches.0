Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FCD251793;
	Wed, 25 Feb 2026 01:27:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982849; cv=none; b=k5PUEi4mi73N8npHbWQ6aPWJPWYTa8/WZkh6VSPStd4lh6egjAfzdcXPCuBK865l0CqPLasCpKvhP6TgYqChGH82b/5o04oWMteip/IiQV6cHSk8tL060zSXIfaWUXWLWjWaR1VPqUJVySjcCUV6C09f6ABnsaMU9kXTy779Bro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982849; c=relaxed/simple;
	bh=pWEGjLClUhLH8zoaZzeA8oaucri2913pZzn2uY3+RxY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PChoxDVxSV6/p1vpsEuRD42DonDKha+Y9q71tzmsaU9IW6DlK7CnHvatiCcFUF+2YrEKoEWKz8qkHqfD5aroMd9VJiDxJCLJvqWDZxLYBQbrPbhhhe9thNxR/rYUC+qvT5reTmeiDCBOugMb0ScewlNz6+MKoNY9+gZd3CGm/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXnxC7VY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXnxC7VY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7EAC116D0;
	Wed, 25 Feb 2026 01:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982849;
	bh=pWEGjLClUhLH8zoaZzeA8oaucri2913pZzn2uY3+RxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXnxC7VYHdrDYF55o7l+REJgbTtex7nPvBFtCqeQCIFUUQJG4RyircyUjsxSkQZTm
	 kTdpZEWphpgAlBEi72FDdx61ki7WHdNYf8NNv4uz62kkwV3PTP3+J/q2PQ/DYotD8k
	 m23HFo4Y/hLSPxczU7JgjMOhR4Kp1mI42qVyrT58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teddy Astie <teddy.astie@vates.tech>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 039/781] xen/virtio: Dont use grant-dma-ops when running as Dom0
Date: Tue, 24 Feb 2026 17:12:28 -0800
Message-ID: <20260225012400.661107953@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Teddy Astie <teddy.astie@vates.tech>

[ Upstream commit dc8ea8714311e549ee93a2b0bdd5487d20bfadbf ]

Dom0 inherit devices from the machine and is usually in PV mode.
If we are running in a virtual that has virtio devices, these devices
would be considered as using grants with Dom0 as backend, while being
the said Dom0 itself, while we want to use these devices like regular
PCI devices.

Fix this by preventing grant-dma-ops from being used when running as Dom0
(initial domain). We still keep the device-tree logic as-is.

Signed-off-by: Teddy Astie <teddy.astie@vates.tech>
Fixes: 61367688f1fb0 ("xen/virtio: enable grant based virtio on x86")
Reviewed-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Juergen Gross <jgross@suse.com>
Message-ID: <6698564dd2270a9f7377b78ebfb20cb425cabbe8.1767720955.git.teddy.astie@vates.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/xen/grant-dma-ops.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/grant-dma-ops.c b/drivers/xen/grant-dma-ops.c
index 14077d23f2a19..c2603e7001786 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -366,7 +366,8 @@ static int xen_grant_init_backend_domid(struct device *dev,
 	if (np) {
 		ret = xen_dt_grant_init_backend_domid(dev, np, backend_domid);
 		of_node_put(np);
-	} else if (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain()) {
+	} else if (!xen_initial_domain() &&
+		   (IS_ENABLED(CONFIG_XEN_VIRTIO_FORCE_GRANT) || xen_pv_domain())) {
 		dev_info(dev, "Using dom0 as backend\n");
 		*backend_domid = 0;
 		ret = 0;
-- 
2.51.0



