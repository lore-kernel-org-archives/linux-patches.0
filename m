Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FB072116E9;
	Wed,  7 May 2025 18:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644024; cv=none; b=OG3u04r7fbHRdu0NTtook1P1Pwh8y4Vx7xp0ckE6RWZsVqNrKq4gmgPM9kBd3XtSryD4UycNhUwfFTs3/ZX31OKH30o5so1qbItVhNVnOG9Hcs9EWPGsPsB0Gr8yPI37r/UV4QWF0lUgqIAOPWDjw5JKn4BLLAiXX/YsTNSTd7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644024; c=relaxed/simple;
	bh=pXTH2jlUg6H9yMX73ONz8/FLSJ8gopop/RTEzA9WLEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkHWnALo+Gj+1wI4kX7DM+UUq9p50anDW2AvQW0dphWmD8zfggntsrFj1e5JdIGDTGT+/p+cjMsxfP0P71N/wfpX2nqKuYsp79XlXQMgrtyFJSB5xbd0UABdzfak++AqL6VwqLhov3KT9i8ekqq96bwwVT3cEG0KiW7HzgaoqGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eud+Kk/K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eud+Kk/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B806C4CEE2;
	Wed,  7 May 2025 18:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644022;
	bh=pXTH2jlUg6H9yMX73ONz8/FLSJ8gopop/RTEzA9WLEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eud+Kk/KkFscz5V4cIWxqk98HNMbI68O0ols1tY/3SAwA18PEBiTlvWupNdAo2U7T
	 t5XHIhgDjdtwRHUg4JoBZUXoTmh51VvQWCzLKdkakqRpkNGKXIXzahpPxs+ELJqqER
	 2NZEUFg4nPmuUJFP7vAkb+k1soshEXJLpPWteNHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shannon Nelson <shannon.nelson@amd.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 095/183] pds_core: remove write-after-free of client_id
Date: Wed,  7 May 2025 20:39:00 +0200
Message-ID: <20250507183828.672830749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shannon Nelson <shannon.nelson@amd.com>

[ Upstream commit dfd76010f8e821b66116dec3c7d90dd2403d1396 ]

A use-after-free error popped up in stress testing:

[Mon Apr 21 21:21:33 2025] BUG: KFENCE: use-after-free write in pdsc_auxbus_dev_del+0xef/0x160 [pds_core]
[Mon Apr 21 21:21:33 2025] Use-after-free write at 0x000000007013ecd1 (in kfence-#47):
[Mon Apr 21 21:21:33 2025]  pdsc_auxbus_dev_del+0xef/0x160 [pds_core]
[Mon Apr 21 21:21:33 2025]  pdsc_remove+0xc0/0x1b0 [pds_core]
[Mon Apr 21 21:21:33 2025]  pci_device_remove+0x24/0x70
[Mon Apr 21 21:21:33 2025]  device_release_driver_internal+0x11f/0x180
[Mon Apr 21 21:21:33 2025]  driver_detach+0x45/0x80
[Mon Apr 21 21:21:33 2025]  bus_remove_driver+0x83/0xe0
[Mon Apr 21 21:21:33 2025]  pci_unregister_driver+0x1a/0x80

The actual device uninit usually happens on a separate thread
scheduled after this code runs, but there is no guarantee of order
of thread execution, so this could be a problem.  There's no
actual need to clear the client_id at this point, so simply
remove the offending code.

Fixes: 10659034c622 ("pds_core: add the aux client API")
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250425203857.71547-1-shannon.nelson@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/auxbus.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
index 4d3387bebe6a4..889a18962270a 100644
--- a/drivers/net/ethernet/amd/pds_core/auxbus.c
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -186,7 +186,6 @@ void pdsc_auxbus_dev_del(struct pdsc *cf, struct pdsc *pf,
 	pds_client_unregister(pf, padev->client_id);
 	auxiliary_device_delete(&padev->aux_dev);
 	auxiliary_device_uninit(&padev->aux_dev);
-	padev->client_id = 0;
 	*pd_ptr = NULL;
 
 	mutex_unlock(&pf->config_lock);
-- 
2.39.5



