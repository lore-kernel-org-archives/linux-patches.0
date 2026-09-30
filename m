Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F6E36A033;
	Wed, 30 Sep 2026 18:37:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793422; cv=none; b=IDKskO9iDb1O+YMZNY6AuJ+dcQ6XaYXRMBPHi1Til+dT0bGheiSfMLZPjAHrAOR2OrjXiFK1tKa9KYTpUacgPEp0IwrbBPAAzxDU5IWEUgWHoDgAyV3/N1gL66gjcg8Mrna19669wFhK6EH5ZVVlx+tIW0mc1CKs6WOFuxpLIks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793422; c=relaxed/simple;
	bh=Kcn3kYHgy5rY6SBXXmC/yFMcr4BphHXigrg/tNTvttU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ha8bFCwqEVeZ/6bJ9uGZeX8zmFxyYIKD4cxSQxIn4qMFX7Moq6/d0sn4TecF3K9bAubPAWMe1TImvrwdo78qTLHTRD9OOK941TbzCus+/Dqsu26n2sAtIYRGl0M9E4zkA4mj5Bvs3HRqfryFvJDogmpsGl6dbLHSoCgKBo0iLSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vB1m0elh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vB1m0elh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D84D1F00898;
	Wed, 30 Sep 2026 18:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793421;
	bh=UZudoVlhfbMSebPSBiEkn/w1ism84XJ0jsZjWcvPG3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vB1m0elhhzV5wd3Q/TbhCx6iRQSZNRRenJ1A1NUPvHGiAU+Fapb1w6mFBnKc9NSr6
	 JQwhObwVXnduNLcnLPqWHotTTYAs9vu3OY2lpX998R7gscNsE5eDT/xMi/+bLKe5mf
	 P5UWXfuiQTKQEaATn4m4weM40CWHuKIvkQpE+UPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Lyude Paul <lyude@redhat.com>
Subject: [PATCH 6.18 248/395] drm/nouveau: Fix bridge reference leak in nv1a_ram_new()
Date: Wed, 30 Sep 2026 17:28:30 +0200
Message-ID: <20260930152346.033067289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

commit 67b4411538c8341692548429d43256f25be99f7a upstream.

pci_get_domain_bus_and_slot() takes a reference to the PCI device,
which is never released once the memory size has been read from its
config space.  Drop the reference before returning.

Fixes: 2fa6d6cdaf283c05 ("drm/nouveau: deprecate pci_get_bus_and_slot()")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patch.msgid.link/20260916180036.2090118-1-vulab@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/fb/ramnv1a.c
@@ -51,6 +51,8 @@ nv1a_ram_new(struct nvkm_fb *fb, struct
 		mib = ((mem >> 4) & 127) + 1;
 	}
 
+	pci_dev_put(bridge);
+
 	return nvkm_ram_new_(&nv04_ram_func, fb, NVKM_RAM_TYPE_STOLEN,
 			     mib * 1024 * 1024, pram);
 }


