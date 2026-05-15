Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6AD3B4EAF;
	Fri, 15 May 2026 16:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862322; cv=none; b=mTmi5v5zPQVvgVGuKykrvduFvE83BBYLsdfi/D7QnoaOgs+dLwjmHHG3WfcXkLPgp1VDBIClHVsEeWJcqZDoBycVAcg7HbrG0K3P3B+w/ku3pxZ3rlJlZsZVpDVq6KHIzgNAp8uQ+PTcgB74poPfjyplMLeNkRWFzsqxKVl/tms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862322; c=relaxed/simple;
	bh=d26o/+I1KDz971hPXYSjw5flPHqZ+HytB8LP5wN382I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OhH61iLRpVl7xPBZWVF0xemWxmu6OUALtS09l777j7BtqLfmmHoPv+xVW6YFM5DgCeStzZgeb+jpSSfIXf/3vtDPw6NWhr9PKQhJazgTr1hoe77G6sg5nOagND1DNV4IV1QshWKCYXOjs56owk1yav5bJKzNEZvIqhs+i6HnLDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YcBNChSV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YcBNChSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C891EC2BCB0;
	Fri, 15 May 2026 16:25:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862322;
	bh=d26o/+I1KDz971hPXYSjw5flPHqZ+HytB8LP5wN382I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YcBNChSV2U45D1YHNr6y3bswmmAEWkxXX8lOdbhdOOiaG7li3VLZeR5ot7nKccsRJ
	 5HW87Ze/lR2GmaIjib9FBcYvQ+sWg4CK80lkw5fO6HztwfoUJ4iTi37RsBm12rZR3Q
	 c6GHxRKDN20/OHA8rCZefOEnf4/sUP2p0BBSEgT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prasanna Kumar T S M <ptsm@linux.microsoft.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 159/188] EDAC/versalnet: Fix device name memory leak
Date: Fri, 15 May 2026 17:49:36 +0200
Message-ID: <20260515154700.775737342@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

From: Prasanna Kumar T S M <ptsm@linux.microsoft.com>

[ Upstream commit 8cf5dd235eff6008cb04c3d8064d2acfa90616f1 ]

The device name allocated via kzalloc() in init_one_mc() is assigned to
dev->init_name but never freed on the normal removal path.  device_register()
copies init_name and then sets dev->init_name to NULL, so the name pointer
becomes unreachable from the device. Thus leaking memory.

Use a stack-local char array instead of using kzalloc() for name.

Fixes: d5fe2fec6c40 ("EDAC: Add a driver for the AMD Versal NET DDR controller")
Signed-off-by: Prasanna Kumar T S M <ptsm@linux.microsoft.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260401111856.2342975-1-ptsm@linux.microsoft.com
[ adapted fix from `init_one_mc()` helper to the equivalent loop in `init_versalnet()` using literal `32` instead of `MC_NAME_LEN` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -765,9 +765,9 @@ static int init_versalnet(struct mc_priv
 	u32 num_chans, rank, dwidth, config;
 	struct edac_mc_layer layers[2];
 	struct mem_ctl_info *mci;
+	char name[32];
 	struct device *dev;
 	enum dev_type dt;
-	char *name;
 	int rc, i;
 
 	for (i = 0; i < NUM_CONTROLLERS; i++) {
@@ -814,7 +814,6 @@ static int init_versalnet(struct mc_priv
 
 		dev = kzalloc(sizeof(*dev), GFP_KERNEL);
 		dev->release = versal_edac_release;
-		name = kmalloc(32, GFP_KERNEL);
 		sprintf(name, "versal-net-ddrmc5-edac-%d", i);
 		dev->init_name = name;
 		rc = device_register(dev);


