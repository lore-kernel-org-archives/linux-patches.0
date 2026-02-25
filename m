Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 498CB19FA93;
	Wed, 25 Feb 2026 01:42:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983743; cv=none; b=jJFFErns44RZKJj0twFRHIE/xkKCSXwmpco+ugPupRgLvY4RYakKVvKVhi97C2hmUZnqn7eK8SzfQm4QV+OEjzZt6wpS6Q/6nquvGSXPXQ8T+JCbTNw+mI6D04p7hgJv+7jc8a1LcN4CgXx/IM3PFuDcnm83G5j8jtxueVyWx6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983743; c=relaxed/simple;
	bh=Y8N5gHuJGtKMgwaCu1IS8UKmo6+B8LN6W4vGTN4ewGs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm7v3Rbhtgio9mh261Lw3DyOhdLIpi960IB4ZhdLdR7DT0xe8VuSkkFnsB6/c0+5y683U3StgFt4M90LLxLsOiJ3YITqg4lC2etrOBYKz78XfdRPVQR+eEN8KYoTXJg+xFx4CZJM0eHNyb0PWFyqx7lw4v4plR9ozyXwIeDSgmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YMiMaAjy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YMiMaAjy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0F5C116D0;
	Wed, 25 Feb 2026 01:42:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983743;
	bh=Y8N5gHuJGtKMgwaCu1IS8UKmo6+B8LN6W4vGTN4ewGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YMiMaAjytD5fWcEXnqEh+SQUm1nbhecDNt+W6CKLfomC1ojRZWJJ3HgqQLbXcsUoX
	 7d7jh+/GKY/TGCFw9MtJlrYdNju2xQXMgQvWlxLXUnNwQK+g4NP/dbBfwwuzTc/9tD
	 tWndctQvsI0Nus/z7CWCGsNT1hVPQoE04bT3W5V8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teddy Astie <teddy.astie@vates.tech>,
	Juergen Gross <jgross@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 036/641] xen/virtio: Dont use grant-dma-ops when running as Dom0
Date: Tue, 24 Feb 2026 17:16:02 -0800
Message-ID: <20260225012349.874591875@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 29257d2639dbf..43a918c498c6c 100644
--- a/drivers/xen/grant-dma-ops.c
+++ b/drivers/xen/grant-dma-ops.c
@@ -362,7 +362,8 @@ static int xen_grant_init_backend_domid(struct device *dev,
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



