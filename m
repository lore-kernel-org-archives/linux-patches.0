Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C3BC26ED4F;
	Wed, 28 Jan 2026 15:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614250; cv=none; b=QMA2pPJeu+ppIsPovap8+Cg14M4Z7/0tkYtefvrwsBWioUu4LV7FE+XDLt/lfk9Aq+QIwg6pBJkh7xaDFHmgi4Idz+UsWGkGtc77l4NCDOvClL3782xbmhDxgqF0e+qlHydrvaZvCRyMEAG5zYfWl1ZwXotPsWOiWHu/JrOTUgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614250; c=relaxed/simple;
	bh=5OjwkeYH1XQ5VIzKd08iIfyKLqDr0LDv7lG7UTyPJs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPdWBH96gk7GaZ6fo6NZcnSyWkxU5GPDU6wNN4AJkolmNExhCgID7ouMakfcRBj6V0ttLSeqNsBD8Mvdl2ez+mtsqmbrSiGMiia87CXufPyWxSeRaJhotxZk0780fpFX77VTwwrGeTN/hSabRVNoQoS2vUr3ZsrBxtXHxDDQp6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JXjp6tCx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JXjp6tCx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76D1EC116C6;
	Wed, 28 Jan 2026 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614250;
	bh=5OjwkeYH1XQ5VIzKd08iIfyKLqDr0LDv7lG7UTyPJs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXjp6tCxLk9u1e48BA1H8+0gFREKcfMVeSi8hO4eHXBSBqv6xg2nSJQa8nDfyZ9Ry
	 /c+vRmiOgIJ/+WlYwVKLfO4on9cX6mb6mZVkEk9/IKhryS/W6xcR3VhA5ZjZWPwzLp
	 Zn0NO8dMnKH9FRaKJG47QM6iZanItHNAYCSWSqJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 080/254] dmaengine: bcm-sba-raid: fix device leak on probe
Date: Wed, 28 Jan 2026 16:20:56 +0100
Message-ID: <20260128145347.572733216@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 7c3a46ebf15a9796b763a54272407fdbf945bed8 upstream.

Make sure to drop the reference taken when looking up the mailbox device
during probe on probe failures and on driver unbind.

Fixes: 743e1c8ffe4e ("dmaengine: Add Broadcom SBA RAID driver")
Cc: stable@vger.kernel.org	# 4.13
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-4-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/bcm-sba-raid.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/dma/bcm-sba-raid.c
+++ b/drivers/dma/bcm-sba-raid.c
@@ -1699,7 +1699,7 @@ static int sba_probe(struct platform_dev
 	/* Prealloc channel resource */
 	ret = sba_prealloc_channel_resources(sba);
 	if (ret)
-		goto fail_free_mchan;
+		goto fail_put_mbox;
 
 	/* Check availability of debugfs */
 	if (!debugfs_initialized())
@@ -1729,6 +1729,8 @@ skip_debugfs:
 fail_free_resources:
 	debugfs_remove_recursive(sba->root);
 	sba_freeup_channel_resources(sba);
+fail_put_mbox:
+	put_device(sba->mbox_dev);
 fail_free_mchan:
 	mbox_free_channel(sba->mchan);
 	return ret;
@@ -1744,6 +1746,8 @@ static int sba_remove(struct platform_de
 
 	sba_freeup_channel_resources(sba);
 
+	put_device(sba->mbox_dev);
+
 	mbox_free_channel(sba->mchan);
 
 	return 0;


